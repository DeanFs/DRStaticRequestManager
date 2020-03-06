//
//  NSUserDefaults+DRExtension.h
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSUserDefaults (DRExtension)

+ (nullable id)objectForKey:(NSString *)defaultName;
+ (void)setObject:(nullable id)value forKey:(NSString *)defaultName;
+ (void)removeObjectForKey:(NSString *)defaultName;

+ (nullable NSString *)stringForKey:(NSString *)defaultName;
+ (nullable NSArray *)arrayForKey:(NSString *)defaultName;
+ (nullable NSDictionary<NSString *, id> *)dictionaryForKey:(NSString *)defaultName;
+ (nullable NSData *)dataForKey:(NSString *)defaultName;
+ (nullable NSArray<NSString *> *)stringArrayForKey:(NSString *)defaultName;
+ (NSInteger)integerForKey:(NSString *)defaultName;
+ (float)floatForKey:(NSString *)defaultName;
+ (double)doubleForKey:(NSString *)defaultName;
+ (BOOL)boolForKey:(NSString *)defaultName;

+ (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName;
+ (void)setFloat:(float)value forKey:(NSString *)defaultName;
+ (void)setDouble:(double)value forKey:(NSString *)defaultName;
+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName;

@end

NS_ASSUME_NONNULL_END
