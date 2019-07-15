//
//  DRStaticRequestManager.m
//  Records
//
//  Created by 冯生伟 on 2018/12/5.
//  Copyright © 2018 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "DRStaticRequestManager.h"
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/NSDictionary+DRExtension.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <YYModel/YYModel.h>
#import "DRStaticRequestCache.h"

@implementation DRStaticRequestTaskModel

+ (instancetype)taskWithRequestClass:(Class)requestClass
                              params:(id)params
                           needLogin:(BOOL)needLogin
                          launchOnly:(BOOL)launchOnly {
    DRStaticRequestTaskModel *task = [DRStaticRequestTaskModel new];
    task.requestClass = requestClass;
    task.params = params;
    task.needLogin = needLogin;
    task.launchOnly = launchOnly;
    return task;
}

@end

@interface DRStaticRequestManager ()

@property (nonatomic, strong) NSMutableArray<DRStaticRequestTaskModel *> *needLoginTasks;
@property (nonatomic, strong) NSMutableArray<DRStaticRequestTaskModel *> *allTask;
@property (nonatomic, strong) NSMutableDictionary *failedTasks; // 失败了的请求任务，恢复网络时重试
@property (nonatomic, strong) NSCache *staticDataCache; // 请求后模型化的缓存数据
@property (nonatomic, assign) BOOL isLogined; // 标记已登录

@property (nonatomic, assign) BOOL isReachableLastTime; // 标记网络由不畅通到畅通的变更

@end

@implementation DRStaticRequestManager

#pragma mark - init
+ (instancetype)sharedInstance {
    static DRStaticRequestManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DRStaticRequestManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _staticDataCache = [[NSCache alloc] init];
        _failedTasks = [NSMutableDictionary dictionary];
        _allTask = [NSMutableArray array];
        _needLoginTasks = [NSMutableArray array];
        _isReachableLastTime = YES;
        
        KDR_ADD_OBSERVER(UIApplicationWillEnterForegroundNotification, @selector(onApplicationWillEnterForeground))
        KDR_ADD_OBSERVER(AFNetworkingReachabilityDidChangeNotification, @selector(appNetworkChangedNotification:))
    }
    return self;
}

- (void)dealloc {
    kDR_REMOVE_OBSERVER
}

#pragma mark - notice
- (void)onApplicationWillEnterForeground {
    [self doBatchRequests:self.allTask];
}

- (void)whenUserLogin {
    self.isLogined = YES;
    [self doBatchRequests:self.needLoginTasks];
}

- (void)whenUserLogout {
    self.isLogined = NO;
    // 避免失败接口中有需要登录的接口
    [self.failedTasks removeAllObjects];
}

// 网络发生变化，接入网络时，重试失败的接口
- (void)appNetworkChangedNotification:(NSNotification *)notification {
    if (!self.isReachableLastTime && [AFNetworkReachabilityManager sharedManager].isReachable) {
        // 网络畅通时
        [self doBatchRequests:self.failedTasks.allValues];
    }
    AFNetworkReachabilityStatus status = [notification.userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue];
    self.isReachableLastTime = (status > 0);
}

#pragma mark - private
// 请求数据并缓存
- (id<DRStaticRequestProtocol>)doRequestWithRequestTask:(DRStaticRequestTaskModel *)task
                                              doneBlock:(dispatch_block_t)doneBlock {
    kDRWeakSelf
    NSString *cachePath = [DRStaticRequestManager makeCachePathWithRequestTask:task];
    
    id<DRStaticRequestProtocol> staticRequest = [(Class)task.requestClass new];
    if (![staticRequest respondsToSelector:@selector(getDataWithParams:successBlock:failureBlock:)]) {
        return nil;
    }
    [staticRequest getDataWithParams:task.params successBlock:^(id  _Nonnull requestResult, id<DRStaticRequestProtocol>  _Nonnull request) {
        @try {
            // 实例化请求结果
            if ([request respondsToSelector:@selector(packageToModel:)]) {
                id modelData = [request packageToModel:requestResult];
                if (modelData && ![modelData isKindOfClass:[NSNull class]]) {
                    [weakSelf.staticDataCache setObject:modelData forKey:cachePath];
                } else {
                    NSString *message = [NSString stringWithFormat:@"接【口%@】请求异常，没有返回数据", cachePath];
                    NSAssert(NO, message);
                }
            }
            // 缓存请求结果
            [DRStaticRequestCache cacheStaticRequestData:[requestResult yy_modelToJSONData] forKey:cachePath];
        } @catch (NSException *exception) {
            kDR_LOG(@"%@", exception);
        }
        [weakSelf.failedTasks removeObjectForKey:cachePath];
        kDR_SAFE_BLOCK(doneBlock);
    } failureBlock:^(id<DRStaticRequestProtocol>  _Nonnull request) {
        // 先读缓存
        NSData *jsonData = [DRStaticRequestCache getStaticRequestDataCacheForKey:cachePath];
        id result = [self jsonResultFromJsonData:jsonData withStaticRequest:staticRequest];
        if (!result) {
            // 没有缓存则读本地json
            if ([staticRequest respondsToSelector:@selector(localJsonDataFromParams:)]) {
                jsonData = [staticRequest localJsonDataFromParams:task.params];
            } else {
                // 默认json文件，于请求类同名
                NSString *jsonPath = [[NSBundle mainBundle] pathForResource:NSStringFromClass(task.requestClass) ofType:@"json"];
                jsonData = [NSData dataWithContentsOfFile:jsonPath];
            }
            if (jsonData) {
                result = [self jsonResultFromJsonData:jsonData withStaticRequest:staticRequest];
            }
        }
        
        if (result && [request respondsToSelector:@selector(packageToModel:)]) {
            id modelData = [request packageToModel:result];
            if (!modelData) {
                NSString *message = [NSString stringWithFormat:@"接【口%@】请求异常，没有返回数据，请添加本地json文件", cachePath];
                NSAssert(NO, message);
            }
        }
        kDR_SAFE_BLOCK(doneBlock);
        [weakSelf.failedTasks safeSetObject:task forKey:cachePath];
    }];
    return staticRequest;
}

- (id)jsonResultFromJsonData:(NSData *)jsonData
           withStaticRequest:(id<DRStaticRequestProtocol>)staticRequest {
    id result;
    if (jsonData) {
        result = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if ([staticRequest respondsToSelector:@selector(checkDataFomat:)]) {
            if (![staticRequest checkDataFomat:result]) {
                result = nil;
            }
        }
    }
    return result;
}

- (void)doBatchRequests:(NSArray<DRStaticRequestTaskModel *> *)tasks {
    for (DRStaticRequestTaskModel *task in tasks) {
        if (task.needLogin && !self.isLogined) {
            continue;
        }
        [self doRequestWithRequestTask:task doneBlock:nil];
    }
}

+ (NSString *)makeCachePathWithRequestTask:(DRStaticRequestTaskModel *)task {
    id<DRStaticRequestProtocol> staticRequest = [(Class)task.requestClass new];
    if ([staticRequest respondsToSelector:@selector(cacheKeyFromParams:)]) {
        return [staticRequest cacheKeyFromParams:task.params];
    }
    NSString *cachePath = NSStringFromClass(task.requestClass);
    if (task.params) {
        if ([task.params isKindOfClass:[NSString class]] ||
            [task.params isKindOfClass:[NSNumber class]]) {
            cachePath = [NSString stringWithFormat:@"%@_%@", cachePath, task.params];
        } else {
            NSString *paramString = [task.params yy_modelToJSONString];
            cachePath = [NSString stringWithFormat:@"%@_%@", cachePath, paramString];
        }
    }
    return cachePath;
}

// 登录，退出登录消息监听
- (void)addLoginObserver:(NSString *)loginMessageName logoutObserver:(NSString *)logoutMessageName {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (loginMessageName) {
            KDR_ADD_OBSERVER(loginMessageName, @selector(whenUserLogin))
        }
        if (logoutMessageName) {
            KDR_ADD_OBSERVER(logoutMessageName, @selector(whenUserLogout))
        }
    });
}

#pragma mark - API
/**
 注册所有静态接口请求任务，并执行一遍请求
 并在将来每次APP进入前台时请求一次
 
 @param allRequstTasks 所有需要执行的请求任务
 @param isLogined 当前是否已登录
 @param loginMessageName 登录成功的消息名，用于在登录后，执行一遍需要登录才能获取的请求任务
 @param logoutMessageName 退出登录成功的消息名
 */
+ (void)registerStaticRequestsWithAllTask:(NSArray<DRStaticRequestTaskModel *> *)allRequstTasks
                                isLogined:(BOOL)isLogined
                         loginMessageName:(NSString *)loginMessageName
                        logoutMessageName:(NSString *)logoutMessageName {
    DRStaticRequestManager *manager = [DRStaticRequestManager sharedInstance];
    manager.isLogined = isLogined;
    
    for (DRStaticRequestTaskModel *task in allRequstTasks) {
        if (task.needLogin) {
            [manager.needLoginTasks addObject:task];
        }
        if (!task.launchOnly) {
            [manager.allTask addObject:task];
        }
    }
    
    [manager addLoginObserver:loginMessageName
               logoutObserver:logoutMessageName];
    
    // 执行全部请求
    [manager doBatchRequests:allRequstTasks];
}

/**
 获取指定静态接口的数据
 优先读缓存，并执行一次更新
 
 @param requestClass 接口请求类
 @param params 请求参数
 @param doneBlock 获取完成回调
 @return 当前执行请求的类，当读取的是缓存时，返回空
 */
+ (id<DRStaticRequestProtocol>)getStaticDataWithRequestClass:(Class<DRStaticRequestProtocol>)requestClass
                                                      params:(id)params
                                                   doneBlock:(void(^)(id staticData))doneBlock {
    DRStaticRequestTaskModel *task = [DRStaticRequestTaskModel new];
    task.requestClass = requestClass;
    task.params = params;
    
    NSString *cachePath = [DRStaticRequestManager makeCachePathWithRequestTask:task];
    DRStaticRequestManager *manager = [DRStaticRequestManager sharedInstance];
    
    id data = [manager.staticDataCache objectForKey:cachePath];
    if (data) {
        kDR_SAFE_BLOCK(doneBlock, data);
        [manager doRequestWithRequestTask:task doneBlock:nil];
        return nil;
    }
    return [manager doRequestWithRequestTask:task doneBlock:^{
        kDR_SAFE_BLOCK(doneBlock, [manager.staticDataCache objectForKey:cachePath]);
    }];
}

/**
 获取指定静态接口的数据
 优先走网络，失败时读缓存，成功则更新缓存
 
 @param requestClass 接口请求类
 @param params 请求参数
 @param doneBlock 获取完成回调
 */
+ (id<DRStaticRequestProtocol>)getStaticDataIgnoreCacheWithRequestClass:(Class<DRStaticRequestProtocol>)requestClass
                                                                 params:(id)params
                                                              doneBlock:(void(^)(id staticData))doneBlock {
    DRStaticRequestTaskModel *task = [DRStaticRequestTaskModel new];
    task.requestClass = requestClass;
    task.params = params;
    
    NSString *cachePath = [DRStaticRequestManager makeCachePathWithRequestTask:task];
    DRStaticRequestManager *manager = [DRStaticRequestManager sharedInstance];
    return [manager doRequestWithRequestTask:task doneBlock:^{
        kDR_SAFE_BLOCK(doneBlock, [manager.staticDataCache objectForKey:cachePath]);
    }];
}

/**
 直接拿缓存数据
 
 @param requestClass 请求类
 @param params 请求参数
 @return 当前缓存数据
 */
+ (id)getStaticCacheDataWithClass:(Class<DRStaticRequestProtocol>)requestClass
                           params:(id)params {
    DRStaticRequestTaskModel *task = [DRStaticRequestTaskModel new];
    task.requestClass = requestClass;
    task.params = params;
    
    NSString *cachePath = [DRStaticRequestManager makeCachePathWithRequestTask:task];
    DRStaticRequestManager *manager = [DRStaticRequestManager sharedInstance];
    id cacheData = [manager.staticDataCache objectForKey:cachePath];
    if (!cacheData) {
        id<DRStaticRequestProtocol> staticRequest = [(Class)task.requestClass new];
        // 先读缓存
        NSData *jsonData = [DRStaticRequestCache getStaticRequestDataCacheForKey:cachePath];
        id result = [manager jsonResultFromJsonData:jsonData withStaticRequest:staticRequest];
        if (!result) {
            // 没有缓存则读本地json
            if ([staticRequest respondsToSelector:@selector(localJsonDataFromParams:)]) {
                jsonData = [staticRequest localJsonDataFromParams:task.params];
            } else {
                // 默认json文件，于请求类同名
                NSString *jsonPath = [[NSBundle mainBundle] pathForResource:NSStringFromClass(task.requestClass) ofType:@"json"];
                jsonData = [NSData dataWithContentsOfFile:jsonPath];
            }
            if (jsonData) {
                result = [manager jsonResultFromJsonData:jsonData withStaticRequest:staticRequest];
            }
        }
        
        if (result && [staticRequest respondsToSelector:@selector(packageToModel:)]) {
            cacheData = [staticRequest packageToModel:result];
        }
    }
    return cacheData;
}

/**
 取消一个请求
 
 @param requestTask 要取消的请求
 */
+ (void)cancelRequestTask:(id<DRStaticRequestProtocol>)requestTask {
    if ([requestTask respondsToSelector:@selector(cancel)]) {
        [requestTask cancel];
    }
}

@end
