//
//  DRStaticRequestProtocol.h
//  Records
//
//  Created by 冯生伟 on 2019/2/18.
//  Copyright © 2019 DuoRong Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DRStaticRequestProtocol <NSObject>

/**
 走网络请求获取数据并在成功回到中返回请求数据
 适合有请求参数接口
 
 @param params 请求参数
 @param doneBlock 获取完成回调
 @param failureBlock 获取失败回调
 */
- (void)getDataWithParams:(id)params
             successBlock:(void(^)(id requestResult, id<DRStaticRequestProtocol> request))doneBlock
             failureBlock:(void(^)(id<DRStaticRequestProtocol> request))failureBlock;

/**
 将请求数据打包成对应的数据模型
 
 @param resulet 网络请求的或者缓存的有效数据
 @param params 请求参数，可能根据参数的不同，打包成不同的数据模型
 @return 打包后的模型数据
 */
+ (id)packageToModel:(id)resulet params:(id)params;

#pragma mark - 非必须实现的方法
@optional
/**
 校验数据个数
 使用场景：同一个接口，参数不变的情况下，后台返回的数据结构发生了变更
 需要通过该方法过滤掉本地返回的老的数据结构数据
 
 @param result 请求结果或者本地缓存
 @return YES: 没有变更  NO: 有变更
 */
+ (BOOL)checkDataFomat:(id)result params:(id)params;

/**
 本地json二进制文件内容
 如果没有实现该方法，会尝试用类名读取mainBundle内 className.json
 使用场景：一个接口，根据参数不同返回完全不一样的数据结构
         需要根据参数，读取不同的本地json文件，通过该方法实现

 @param params 请求参数
 @return 二进制json数据
 */
+ (NSData *)localJsonDataFromParams:(id)params;

/**
 设置缓存相对路径
 默认根据类名和参数缓存

 @param params 请求参数
 @return 缓存key
 */
+ (NSString *)cacheKeyFromParams:(id)params;

/**
 取消请求
 */
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
