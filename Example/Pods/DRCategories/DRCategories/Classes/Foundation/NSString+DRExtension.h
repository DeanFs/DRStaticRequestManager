//
//  NSString+DRExtension.h
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/7.
//

#import <Foundation/Foundation.h>
#import <AdSupport/AdSupport.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (DRExtension)

/**
 获取时间间隔中文描述

 @param duration 时间间隔，单位秒
 @return 20分钟，1小时20分钟，1天1小时20分钟
 */
+ (NSString *)descForTimeDuration:(int64_t)duration;

/**
 获取时间间隔中文描述

 @param duration 时间间隔，单位秒
 @return 如：20分钟，1小时，15.5小时
 */
+ (NSString *)hourDescForTimeDuration:(int64_t)duration;

// 取出指定range的字符，字母，汉字，表情都算一个字符
- (NSString *)subCharStringWithRange:(NSRange)range;

// 获取字符串中的字符数量，字母，汉字，表情都算一个字符
- (NSInteger)charCount;

@end

@interface NSString (DRIDFA)

+ (NSString *)deviceIdentifier;
+ (NSString *)idfa;
+ (NSString *)idfv;

@end


@interface NSString (DRDeviceInfo)

//总内存大小
+ (NSString *)totalMemorySize;

//当前可用内存大小
+ (NSString *)availableMemorySize;

//获取像素
+ (NSString *)PPI;

//电池电量
+ (NSString *)batteryLevel;

//电池状态
+ (NSString *)getBatteryInfo;

//MAC
+ (NSString *)macString;

//WiFi MAC地址
+ (NSString *)wifiMacAddress;

//SSID
+ (NSString *)SSID;

//当前WiFi名称
+ (NSString *)currentWifiName;

//屏幕分辨率
+ (NSString *)screenPixels;

//当前时间
+ (NSString *)currentDate;

//当前语言
+ (NSString *)currentLanguage;

//系统版本
+ (NSString *)deviceOS;

@end


@interface NSString (DRIPAddress)

+ (NSString *)ipAddress;
+ (NSString *)macAddress;

@end


@interface NSString (DRDateUtility)

- (NSString *)solarMonthTitle;
- (NSString *)solarDayTitle;
- (NSString *)lunarMonthTitle;
- (NSString *)lunarDayTitle;

@end

NS_ASSUME_NONNULL_END
