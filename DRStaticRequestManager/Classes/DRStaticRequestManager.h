//
//  DRStaticRequestManager.h
//  Records
//
//  Created by 冯生伟 on 2018/12/5.
//  Copyright © 2018 DuoRong Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DRStaticRequestProtocol.h"

@interface DRStaticRequestTaskModel : NSObject

@property (nonatomic, strong) Class<DRStaticRequestProtocol> requestClass; // 接口请求类名
@property (nonatomic, strong) id params;        // 接口请求参数
@property (nonatomic, assign) BOOL needLogin;   // 需要登录
@property (nonatomic, assign) BOOL launchOnly;  // 仅启动时执行

+ (instancetype)taskWithRequestClass:(Class)requestClass
                              params:(id)params
                           needLogin:(BOOL)needLogin
                          launchOnly:(BOOL)launchOnly;

@end

@interface DRStaticRequestManager : NSObject

/**
 注册所有静态接口请求任务，并执行一遍请求
 并在将来每次APP进入前台时请求一次
 ************注意：需要经常更新缓存的接口才需要注册，普通接口直接实现协议就能用**********

 @param allRequstTasks 所有需要执行的请求任务
 @param isLogined 当前是否已登录
 @param loginMessageName 登录成功的消息名，用于在登录后，执行一遍需要登录才能获取的请求任务
 @param logoutMessageName 退出登录成功的消息名
 */
+ (void)registerStaticRequestsWithAllTask:(NSArray<DRStaticRequestTaskModel *> *)allRequstTasks
                                isLogined:(BOOL)isLogined
                         loginMessageName:(NSString *)loginMessageName
                        logoutMessageName:(NSString *)logoutMessageName;

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
                                                   doneBlock:(void(^)(id staticData))doneBlock;

/**
 获取指定静态接口的数据
 优先走网络，失败时读缓存，成功则更新缓存

 @param requestClass 接口请求类
 @param params 请求参数
 @param doneBlock 获取完成回调
 */
+ (id<DRStaticRequestProtocol>)getStaticDataIgnoreCacheWithRequestClass:(Class<DRStaticRequestProtocol>)requestClass
                                                                 params:(id)params
                                                              doneBlock:(void(^)(id staticData))doneBlock;

/**
 直接拿缓存数据

 @param requestClass 请求类
 @param params 请求参数
 @return 当前缓存数据
 */
+ (id)getStaticCacheDataWithClass:(Class<DRStaticRequestProtocol>)requestClass
                           params:(id)params;

/**
 取消一个请求
 需要requestTask实现DRStaticRequestProtocol协议的cancel方法

 @param requestTask 要取消的请求
 */
+ (void)cancelRequestTask:(id<DRStaticRequestProtocol>)requestTask;

@end
