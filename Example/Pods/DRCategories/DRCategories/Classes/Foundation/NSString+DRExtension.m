//
//  NSString+DRExtension.m
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/7.
//

#import "NSString+DRExtension.h"
#import "sys/utsname.h"
#import <AdSupport/AdSupport.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <mach/mach.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CommonCrypto/CommonDigest.h>
#import "NSDictionary+DRExtension.h"
#import <DRMacroDefines/DRMacroDefines.h>
#import "NSNumber+DRExtension.h"

@implementation NSString (DRExtension)

/**
 获取时间间隔中文描述
 
 @param duration 时间间隔，单位秒
 @return 20分钟，1小时20分钟，1天1小时20分钟
 */
+ (NSString *)descForTimeDuration:(int64_t)duration {
    NSMutableString *timeString = [NSMutableString string];
    if (duration > 0) {
        if (duration >= 86400) {
            [timeString appendFormat:@"%lli天", duration / 86400];
            duration %= 86400;
        }
        if (duration >= 3600) {
            [timeString appendFormat:@"%lli小时", duration / 3600];
            duration %= 3600;
        }
        if (duration > 59) {
            [timeString appendFormat:@"%lli分钟", duration / 60];
        }
    }
    return timeString;
}

/**
 获取时间间隔中文描述
 
 @param duration 时间间隔，单位秒
 @return 如：20分钟，1小时，15.5小时
 */
+ (NSString *)hourDescForTimeDuration:(int64_t)duration {
    NSString *timeString;
    if (duration > 0) {
        if (duration >= 3600) {
            CGFloat hour = duration / 3600.0;
            NSString *hourStr = [@(hour) stringValueWithDigit:1 isForce:NO block:nil];
            timeString = [NSString stringWithFormat:@"%@小时", hourStr];
        } else {
            timeString = [NSString stringWithFormat:@"%lli分钟", duration / 60];
        }
    }
    return timeString;
}

// 取出指定range的字符，字母，汉字，表情都算一个字符
- (NSString *)subCharStringWithRange:(NSRange)range {
    NSRange aRange;
    NSInteger index = 0;
    NSMutableString *subStr = [NSMutableString string];
    for (int i=0; i<self.length; i+=aRange.length){
        aRange = [self rangeOfComposedCharacterSequenceAtIndex:i];
        if (index >= range.location && index < range.location + range.length) {
            [subStr appendString:[self substringWithRange:aRange]];
        }
        index++;
    }
    return subStr;
}

// 获取字符串中的字符数量，字母，汉字，表情都算一个字符
- (NSInteger)charCount {
    NSInteger count = 0;
    NSRange aRange;
    for (int i=0; i<self.length; i+=aRange.length){
        aRange = [self rangeOfComposedCharacterSequenceAtIndex:i];
        count++;
    }
    return count;
}

@end


@implementation NSString (DRIDFA)

+ (NSString *)deviceIdentifier {
    if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
        return self.idfa;
    } else {
        return self.idfv;
    }
}

+ (NSString *)idfa {
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return adId;
}

+ (NSString *)idfv {
    if([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        return [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    return @"";
}

@end

#define MB (1024*1024)
#define GB (MB*1024)

@implementation NSString (DRDeviceInfo)

// 获得总内存大小
+ (NSString *)totalMemorySize {
    long long memory = [NSProcessInfo processInfo].physicalMemory;
    return [self formatMemory:memory];
}

// 获得当前可用内存大小
+ (NSString *)availableMemorySize {
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if (kernReturn != KERN_SUCCESS) {
        //        return NSNotFound;
        return @"";
    }
    long long memory = ((vm_page_size * vmStats.free_count + vm_page_size * vmStats.inactive_count));
    return [self formatMemory:memory];
}

+ (NSString *)formatMemory:(long long)Space {
    // Format the long long disk space
    @try {
        // Set up the string
        NSString *FormattedBytes = nil;
        
        // Get the bytes, megabytes, and gigabytes
        double NumberBytes = 1.0 * Space;
        double TotalGB = NumberBytes / GB;
        double TotalMB = NumberBytes / MB;
        
        // Display them appropriately
        if (TotalGB >= 1.0) {
            FormattedBytes = [NSString stringWithFormat:@"%.2f GB", TotalGB];
        } else if (TotalMB >= 1)
            FormattedBytes = [NSString stringWithFormat:@"%.2f MB", TotalMB];
        else {
            FormattedBytes = [self formattedMemory:Space];
            FormattedBytes = [FormattedBytes stringByAppendingString:@" bytes"];
        }
        
        // Check for errors
        if (FormattedBytes == nil || FormattedBytes.length <= 0) {
            // Error, invalid string
            return nil;
        }
        
        // Completed Successfully
        return FormattedBytes;
    }
    @catch (NSException *exception) {
        // Error
        return nil;
    }
}

//bytes 转 string
+ (NSString *)formattedMemory:(unsigned long long)Space {
    // Format for bytes
    @try {
        // Set up the string variable
        NSString *FormattedBytes = nil;
        
        // Set up the format variable
        NSNumberFormatter *Formatter = [[NSNumberFormatter alloc] init];
        
        // Format the bytes
        [Formatter setPositiveFormat:@"###,###,###,###"];
        
        // Get the bytes
        NSNumber * theNumber = [NSNumber numberWithLongLong:Space];
        
        // Format the bytes appropriately
        FormattedBytes = [Formatter stringFromNumber:theNumber];
        
        // Check for errors
        if (FormattedBytes == nil || FormattedBytes.length <= 0) {
            // Error, invalid value
            return nil;
        }
        
        // Completed Successfully
        return FormattedBytes;
    }
    @catch (NSException *exception) {
        // Error
        return nil;
    }
}

// 获取像素
+ (NSString *)PPI {
    if (kDRScreenWidth > 375) {
        return @"401PPI";
    } else  {
        return @"326PPI";
    }
}

//电池电量
+ (NSString *)batteryLevel {
    // Find the battery level
    @try {
        // Get the device
        UIDevice *Device = [UIDevice currentDevice];
        // Set battery monitoring on
        Device.batteryMonitoringEnabled = YES;
        
        // Set up the battery level float
        float BatteryLevel = 0.0;
        // Get the battery level
        float BatteryCharge = [Device batteryLevel];
        
        // Check to make sure the battery level is more than zero
        if (BatteryCharge > 0.0f) {
            // Make the battery level float equal to the charge * 100
            BatteryLevel = BatteryCharge * 100;
        } else {
            // Unable to find the battery level
            return @"uidevicebatterystateunknown";
        }
        // Output the battery level
        return [NSString stringWithFormat:@"%0.lf%%",BatteryLevel];
    }
    @catch (NSException *exception) {
        // Error out
        return @"uidevicebatterystateunknown";
    }
}

//电池状态
+ (NSString *)getBatteryInfo {
    //电池的状态是可监听的
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    //huoqu电池的状态
    switch ([UIDevice currentDevice].batteryState) {
        case UIDeviceBatteryStateUnknown:
            return (@"电池的状态未知");
        case UIDeviceBatteryStateCharging:
            return(@"电池正在充电");
        case UIDeviceBatteryStateUnplugged:
            return(@"电池未充电");
        case UIDeviceBatteryStateFull:
            return(@"电池电量充满");
    }
}

//MAC
+ (NSString *)macString {
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *macString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return macString;
}

//WiFi MAC地址
+ (NSString *)wifiMacAddress {
    // Get the WiFi MAC Address
    @try {
        // Start by setting the variables to get the WiFi Mac Address
        int                 mgmtInfoBase[6];
        char                *msgBuffer = NULL;
        size_t              length;
        unsigned char       macAddress[6];
        struct if_msghdr    *interfaceMsgStruct;
        struct sockaddr_dl  *socketStruct;
        
        // Setup the management Information Base (mib)
        mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
        mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
        mgmtInfoBase[2] = 0;
        mgmtInfoBase[3] = AF_LINK;        // Request link layer information
        mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
        
        // With all configured interfaces requested, get handle index
        if ((mgmtInfoBase[5] = if_nametoindex([@"en0" UTF8String])) == 0)
            // Error, Name to index failure
            return nil;
        else
        {
            // Get the size of the data available (store in len)
            if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
                // Error, Sysctl MgmtInfoBase Failure
                return nil;
            else
            {
                // Alloc memory based on above call
                if ((msgBuffer = malloc(length)) == NULL)
                    // Error, Buffer allocation failure
                    return nil;
                else
                {
                    // Get system information, store in buffer
                    if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                        // Error, Sysctl MsgBuffer Failure
                        return nil;
                }
            }
        }
        
        // Map msgbuffer to interface message structure
        interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
        
        // Map to link-level socket structure
        socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
        
        // Copy link layer address data in socket structure to an array
        memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
        
        // Read from char array into a string object, into traditional Mac address format
        NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                      macAddress[0], macAddress[1], macAddress[2],
                                      macAddress[3], macAddress[4], macAddress[5]];
        
        // Release the buffer memory
        free(msgBuffer);
        
        // Make a new string from the macAddressString
        NSString *deviceID = macAddressString;
        
        // If the device ID comes back empty
        if (deviceID == (id)[NSNull null] || deviceID.length <= 0) {
            // Return that the MAC address was not found
            return nil;
        }
        
        // Return Successful
        return deviceID;
    }
    @catch (NSException *exception) {
        // Error, return nil
        return nil;
    }
}

//SSID
+ (NSString *)SSID {
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    // kDR_LOG(@"%s: Supported interfaces: %@", __func__, interfaceNames);
    
    NSDictionary *SSIDInfo;
    for (NSString *interfaceName in interfaceNames) {
        SSIDInfo = CFBridgingRelease(
                                     CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
        // DLog(@"%s: %@ => %@", __func__, interfaceName, SSIDInfo);
    }
    
    return [NSString stringWithFormat:@"{\"BSSID\":\"%@\",\"SSID\":\"%@\"}", [SSIDInfo objectForKey:@"BSSID"], [SSIDInfo objectForKey:@"SSID"]];
}

//当前WiFi名称
+ (NSString *)currentWifiName {
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    //  kDR_LOG(@"%s: Supported interfaces: %@", __func__, interfaceNames);
    NSDictionary *SSIDInfo;
    for (NSString *interfaceName in interfaceNames) {
        SSIDInfo = CFBridgingRelease(
                                     CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
        // kDR_LOG(@"%s: %@ => %@", __func__, interfaceName, SSIDInfo);
        
        BOOL isNotEmpty = (SSIDInfo.count > 0);
        if (isNotEmpty) {
            break;
        }
    }
    NSString *SSID = SSIDInfo[@"SSID"];
    return SSID;
}

//屏幕分辨率
+ (NSString *)screenPixels {
    CGFloat scale = [UIScreen mainScreen].scale;
    int withPixel = scale *kDRScreenWidth;
    int  heightPiexl = scale *kDRScreenHeight;
    return [NSString stringWithFormat:@"%d*%d",withPixel,heightPiexl];
}

//当前时间
+ (NSString *)currentDate {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}

//当前语言
+ (NSString *)currentLanguage {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = [languages objectAtIndex:0];
    return currentLanguage;
}

//系统版本
+ (NSString *)deviceOS {
    NSString* sys = [[UIDevice currentDevice] systemVersion];
    return [NSString stringWithFormat:@"%@",sys];
}

@end


@implementation NSString (DRIPAddress)

+ (NSString *)ipAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}


+ (NSString *)macAddress {
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *macString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return macString;
}

@end


@implementation NSString (DRDateUtility)

- (NSString *)solarMonthTitle {
    NSInteger idx = [self integerValue] - 1;
    
    if(idx < 12 && idx >= 0) {
        return @[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月"][idx];
    }
    
    return nil;
}

- (NSString *)solarDayTitle {
    NSInteger idx = [self integerValue] - 1;
    
    if(idx < 31 && idx >= 0) {
        return @[@"1日", @"2日",@"3日",@"4日",@"5日",@"6日",@"7日",@"8日",@"9日",@"10日",
                 @"11日", @"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",
                 @"21日", @"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日",@"29日",@"30日",@"31日"][idx];
    }
    
    return nil;
}

- (NSString *)lunarMonthTitle {
    NSInteger idx = [self integerValue] - 1;
    
    if(idx < 12 && idx >= 0) {
        return @[@"正月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"十二月"][idx];
    }
    
    return nil;
}

- (NSString *)lunarDayTitle {
    NSInteger idx = [self integerValue] - 1;
    
    if(idx < 30 && idx >= 0) {
        return @[@"初一", @"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",@"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十"][idx];
    }
    
    return nil;
}

@end
