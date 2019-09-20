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
    NSString *cacheKey = [DRStaticRequestCache makeCacheKeyWithRequestClass:task.requestClass
                                                                     params:task.params];
    id<DRStaticRequestProtocol> staticRequest = [(Class)task.requestClass new];
    if (![staticRequest respondsToSelector:@selector(getDataWithParams:successBlock:failureBlock:)]) {
        NSString *message = [NSString stringWithFormat:@"%@请求类未遵循DRStaticRequestProtocol协议，实现getDataWithParams:successBlock:failureBlock:方法", NSStringFromClass(task.requestClass)];
        NSAssert(NO, message);
        return nil;
    }
    [staticRequest getDataWithParams:task.params successBlock:^(id  _Nonnull requestResult, id<DRStaticRequestProtocol>  _Nonnull request) {
        // 更新缓存
        [DRStaticRequestCache cacheStaticRequestResult:requestResult withRequestClass:task.requestClass params:task.params];
        // 移除请求任务失败记录
        [self.failedTasks removeObjectForKey:cacheKey];
        // 执行完成回调
        kDR_SAFE_BLOCK(doneBlock);
    } failureBlock:^(id<DRStaticRequestProtocol>  _Nonnull request) {
        // 添加请求任务失败记录
        [self.failedTasks safeSetObject:task forKey:cacheKey];
        // 执行完成回调
        kDR_SAFE_BLOCK(doneBlock);
    }];
    return staticRequest;
}

- (void)doBatchRequests:(NSArray<DRStaticRequestTaskModel *> *)tasks {
    for (DRStaticRequestTaskModel *task in tasks) {
        if (task.needLogin && !self.isLogined) {
            continue;
        }
        [self doRequestWithRequestTask:task doneBlock:nil];
    }
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
 优先读缓存，并执行一次更新，若更新后发现与缓存不一致，会再次掉回调
 
 @param requestClass 接口请求类
 @param params 请求参数
 @param doneBlock 获取完成回调
 @return 当前执行请求的类，当读取的是缓存时，返回空
 */
+ (id<DRStaticRequestProtocol>)getStaticDataWithRequestClass:(Class<DRStaticRequestProtocol>)requestClass
                                                      params:(id)params
                                                   doneBlock:(void(^)(id staticData))doneBlock {
    id cacheData = [DRStaticRequestCache getStaticRequestDataCacheWithRequestClass:requestClass
                                                                             params:params];
    if (cacheData != nil) {
        kDR_SAFE_BLOCK(doneBlock, cacheData);
    }
    
    DRStaticRequestTaskModel *task = [DRStaticRequestTaskModel new];
    task.requestClass = requestClass;
    task.params = params;
    
    DRStaticRequestManager *manager = [DRStaticRequestManager sharedInstance];
    return [manager doRequestWithRequestTask:task doneBlock:^{
        id resaultData = [DRStaticRequestCache getStaticRequestDataCacheWithRequestClass:requestClass
                                                                                  params:params];
        if (![DRStaticRequestCache isResultDate:resaultData equalToCacheData:cacheData]) {
            // 请求后缓存有变更，则再次调用完成回调
            kDR_SAFE_BLOCK(doneBlock, resaultData);
        }
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
    
    DRStaticRequestManager *manager = [DRStaticRequestManager sharedInstance];
    return [manager doRequestWithRequestTask:task doneBlock:^{
        kDR_SAFE_BLOCK(doneBlock, [DRStaticRequestCache getStaticRequestDataCacheWithRequestClass:requestClass
                                                                                           params:params]);
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
    return [DRStaticRequestCache getStaticRequestDataCacheWithRequestClass:requestClass params:params];
}

/**
 取消一个请求
 需要requestTask实现DRStaticRequestProtocol协议的cancel方法
 
 @param requestTask 要取消的请求
 */
+ (void)cancelRequestTask:(id<DRStaticRequestProtocol>)requestTask {
    if ([requestTask respondsToSelector:@selector(cancel)]) {
        [requestTask cancel];
    }
}

@end
