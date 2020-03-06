//
//  NSDate+DRExtension.m
//  Records
//

//  Created by admin on 2017/11/3.
//  Copyright © 2017年 DR. All rights reserved.
//

#import "NSDate+DRExtension.h"
#import "NSObject+DRExtension.h"
#import <DRMacroDefines/DRMacroDefines.h>
#include <mutex>

using namespace std;
static mutex _mutex;

#define DRExtensionLock lock_guard<mutex> lock_g(_mutex);

@interface NSDateFormatter (DRExtension)

+ (instancetype)dr_dateFormatter;

@end

@implementation NSDateFormatter (DRExtension)

+ (instancetype)dr_dateFormatter {
    static NSDateFormatter* dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_cn"]];
    });    
    [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    [dateFormatter setCalendar:nil];
    return dateFormatter;
}

@end



@implementation NSDate (DRExtension)

+(NSString *)timeWithTimeIntervalInt:(int64_t)timeInt formatterString:(NSString *)formatterStr
{
    DRExtensionLock
    // 格式化时间
    NSDateFormatter* formatter = [NSDateFormatter dr_dateFormatter];
    [formatter setAMSymbol:@"上午"];
    [formatter setPMSymbol:@"下午"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formatterStr];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeInt/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    
    return dateString;
}

//+ (NSDate *)getYMDDateWithTimeIntervalInt:(int64_t)timeInt {
//    // 格式化时间
//    NSDateFormatter* formatter = [NSDateFormatter dr_dateFormatter];
//    formatter.timeZone = [NSTimeZone timeZoneWithName:kTimeZone];
//    [formatter setAMSymbol:@"上午"];
//    [formatter setPMSymbol:@"下午"];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    // 毫秒值转化为秒
//    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeInt/ 1000.0];
//    return date;
//}

+ (NSString *)stringFromeDate:(NSDate *)date {
    DRExtensionLock
    // 格式化时间
    NSDateFormatter* formatter = [NSDateFormatter dr_dateFormatter];
    
    [formatter setAMSymbol:@"上午"];
    [formatter setPMSymbol:@"下午"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    
    return dateString;
}

+ (NSString *)timeIntervalFromeTimeString:(NSString *)timeString {
    if (![timeString containsString:@"月"]) {
        return timeString;
    }
    
    DRExtensionLock
    // 格式化时间
    NSDateFormatter* formatter = [NSDateFormatter dr_dateFormatter];
    
    [formatter setAMSymbol:@"上午"];
    [formatter setPMSymbol:@"下午"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    if ([timeString componentsSeparatedByString:@":"].count > 2) {
        if (![timeString containsString:@"年"]) {
            timeString = [NSString stringWithFormat:@"%ld年%@",[NSDate date].year, timeString];
        }
        [formatter setDateFormat:@"yyyy年MM月dd日 E HH:mm:ss"];
    } else if ([timeString componentsSeparatedByString:@":"].count > 1) {
        if (![timeString containsString:@"年"]) {
            timeString = [NSString stringWithFormat:@"%ld年%@",[NSDate date].year, timeString];
        }
        [formatter setDateFormat:@"yyyy年MM月dd日 E HH:mm"];
    } else {
        [formatter setDateFormat:@"yyyy年MM月dd日"];
    }
    NSDate *date = [formatter dateFromString:timeString];
    
    NSInteger timeInterval = [date timeIntervalSince1970] *1000.0;
    return @(timeInterval).stringValue;
}

+ (NSDate *)dateFromeDateString:(NSString *)dateString {
    if (![dateString containsString:@"月"]) {
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:dateString.longLongValue/ 1000.0];
        return date;
    }
    DRExtensionLock
    NSDateFormatter* formatter = [NSDateFormatter dr_dateFormatter];
    
    [formatter setAMSymbol:@"上午"];
    [formatter setPMSymbol:@"下午"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    if ([dateString componentsSeparatedByString:@":"].count > 2) {
        if (![dateString containsString:@"年"]) {
            dateString = [NSString stringWithFormat:@"%ld年%@",[NSDate date].year, dateString];
        }
        [formatter setDateFormat:@"yyyy年MM月dd日 E HH:mm:ss"];
    } else if ([dateString componentsSeparatedByString:@":"].count > 1) {
        if (![dateString containsString:@"年"]) {
            dateString = [NSString stringWithFormat:@"%ld年%@",[NSDate date].year, dateString];
        }
        [formatter setDateFormat:@"yyyy年MM月dd日 E HH:mm"];
    } else {
        [formatter setDateFormat:@"yyyy年MM月dd日"];
    }
    NSDate *date = [formatter dateFromString:dateString];
    
    return date;
}

-(NSString *)returnTimeStamp{
    NSTimeInterval interval=[self timeIntervalSince1970]*1000;
    return [NSString stringWithFormat:@"%.0f", interval];
}

+(NSDate *)dateWithTimeStamp:(NSString *)interval{
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:[interval doubleValue]/1000];
    return date;
}

-(NSDate *)dateFormaterWithFormatterString:(NSString *)formatterStr{
    DRExtensionLock
    NSDateFormatter *dateformater = [NSDateFormatter dr_dateFormatter];
    
    [dateformater setDateFormat:formatterStr];
    NSString *newDate = [dateformater stringFromDate:self];
    NSDate *date = [dateformater dateFromString:newDate];
    
    
    return date;
}

-(NSString *)dateWithFormatterString:(NSString *)formatterStr{
    DRExtensionLock
    NSDateFormatter *formatter = [NSDateFormatter dr_dateFormatter];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setCalendar: [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian]];
    [formatter setDateFormat:formatterStr];
    NSString *DateTime = [formatter stringFromDate:self];
    
    return DateTime;
}

+ (NSString *)stringFromeDate:(NSDate *)date formatterString:(NSString *)formatterStr {
    DRExtensionLock
    NSDateFormatter *dateFormatter = [NSDateFormatter dr_dateFormatter];
    dateFormatter.dateFormat = formatterStr;
    NSString *timeStr = [dateFormatter stringFromDate:date];
    
    return timeStr;
}

-(NSDate *)dateFormaterRemoverSecond{
    DRExtensionLock
    NSDateFormatter *dateformater = [NSDateFormatter dr_dateFormatter];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *newDate = [dateformater stringFromDate:self];
    NSDate *date = [dateformater dateFromString:newDate];
    
    return date;
}

-(NSDate *)dateFormaterWtihFormaterSting:(NSString *)formatterStr{
    DRExtensionLock
    NSDateFormatter *dateformater = [NSDateFormatter dr_dateFormatter];
    [dateformater setDateFormat:formatterStr];
    NSString *newDate = [dateformater stringFromDate:self];
    NSDate *date = [dateformater dateFromString:newDate];
    
    return date;
}

+(NSString *)getCurrentDate{//YYYY年MM月dd日
    DRExtensionLock
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter dr_dateFormatter];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setCalendar: [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian]];
    [formatter setDateFormat:@"YYYY年MM月dd日"];
    NSString *DateTime = [formatter stringFromDate:date];
    
    return DateTime;
}

+(NSString *)getCurrentYearString {// 年
    DRExtensionLock
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter dr_dateFormatter];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setCalendar: [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian]];
    [formatter setDateFormat:@"yyyy"];
    NSString *DateTime = [formatter stringFromDate:date];
    
    return DateTime;
}

+(NSString *)getCurrentDateYM{
    DRExtensionLock
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter dr_dateFormatter];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setCalendar: [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian]];
    [formatter setDateFormat:@"YYYY-MM"];
    NSString *DateTime = [formatter stringFromDate:date];
    
    return DateTime;
}

+(NSString *)getCurrentDateYMd{
    DRExtensionLock
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter dr_dateFormatter];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setCalendar: [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian]];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *DateTime = [formatter stringFromDate:date];
    
    return DateTime;
}

+(NSString *)getCurrentDateHH{
    DRExtensionLock
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter dr_dateFormatter];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setCalendar: [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian]];
    [formatter setDateFormat:@"HH"];
    NSString *DateTime = [formatter stringFromDate:date];
    
    return DateTime;
}

-(NSInteger )getDatemm{
    DRExtensionLock
    NSDateFormatter *formatter = [NSDateFormatter dr_dateFormatter];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setCalendar: [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian]];
    [formatter setDateFormat:@"mm"];
    NSString *DateTime = [formatter stringFromDate:self];
    
    return [DateTime integerValue];
}

-(NSInteger )getDateHH{
    DRExtensionLock
    NSDateFormatter *formatter = [NSDateFormatter dr_dateFormatter];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setCalendar: [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian]];
    [formatter setDateFormat:@"HH"];
    NSString *DateTime = [formatter stringFromDate:self];
    
    return [DateTime integerValue];
}

+(NSDate *)returnDayCurrentDateWithString:(NSString *)string{
    NSString *timeStr=[NSString stringWithFormat:@"%@ %@",[NSDate getCurrentDateYMd],string];
    return [NSDate getDateWithString:timeStr];
}

+(NSString *)getDateStringWithDate:(NSDate *)date{
    DRExtensionLock
    NSDateFormatter *formatter = [NSDateFormatter dr_dateFormatter];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setCalendar: [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian]];
    [formatter setDateFormat:@"MM-dd"];
    NSString *DateTime = [formatter stringFromDate:date];
    
    return DateTime;
}

+(NSString *)getHourAndMinuteStringWithDate:(NSDate *)date{
    DRExtensionLock
    NSDateFormatter *formatter = [NSDateFormatter dr_dateFormatter];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setCalendar: [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian]];
    [formatter setDateFormat:@"HH:mm"];
    NSString *DateTime = [formatter stringFromDate:date];
    
    return DateTime;
}


- (NSString *)getHHMM {
    DRExtensionLock
    NSDateFormatter *formatter = [NSDateFormatter dr_dateFormatter];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setCalendar: [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian]];
    [formatter setDateFormat:@"HHmm"];
    NSString *DateTime = [formatter stringFromDate:self];
    
    return DateTime;
}

//+(NSInteger )getHourWithStart:(NSDate *)start withEnd:(NSDate *)end{
//    NSCalendar* chineseClendar  = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSUInteger unitFlags        = NSCalendarUnitHour | NSCalendarUnitDay  ;
//    NSDateComponents *cps       = [chineseClendar components:unitFlags fromDate:start toDate:end  options:0];
//    return [cps hour];
//}

+(NSInteger )getHourWithStart:(NSDate *)start withEnd:(NSDate *)end{
    if ([NSDate compareDate:start withDate:end]==-1) {
        NSCalendar* chineseClendar  = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSUInteger unitFlags        = NSCalendarUnitHour | NSCalendarUnitDay  ;
        NSDateComponents *cps       = [chineseClendar components:unitFlags fromDate:start toDate:end  options:0];
        return [cps hour]+24;
    }else if([NSDate compareDate:start withDate:end]==0){
        return 0;
    }else{
        NSCalendar* chineseClendar  = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSUInteger unitFlags        = NSCalendarUnitHour | NSCalendarUnitDay  ;
        NSDateComponents *cps       = [chineseClendar components:unitFlags fromDate:start toDate:end  options:0];
        return [cps hour];
    }
}

+ (NSInteger)compareDate:(NSDate*)aDate withDate:(NSDate*)bDate
{
    DRExtensionLock
    NSInteger aa=0;
    NSDateFormatter *dateformater = [NSDateFormatter dr_dateFormatter];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *oneDayStr = [dateformater stringFromDate:aDate];
    NSString *anotherDayStr = [dateformater stringFromDate:bDate];
    
    NSDate *dateA = [dateformater dateFromString:oneDayStr];
    NSDate *dateB = [dateformater dateFromString:anotherDayStr];
    
    NSComparisonResult result = [dateA compare:dateB];
    if (result==NSOrderedSame)
    {
        //相等
        aa=0;
    }else if (result==NSOrderedAscending)
    {
        //bDate比aDate大
        aa=1;
    }else if (result==NSOrderedDescending)
    {
        //bDate比aDate小
        aa=-1;
    }
    return aa;
}

- (NSInteger)compareDateWithDate:(NSDate*)date formatter:(NSString *)formater
{
    DRExtensionLock
    NSInteger aa=0;
    NSDateFormatter *dateformater = [NSDateFormatter dr_dateFormatter];
    [dateformater setDateFormat:formater];
    
    NSString *oneDayStr = [dateformater stringFromDate:self];
    NSString *anotherDayStr = [dateformater stringFromDate:date];
    
    NSDate *dateA = [dateformater dateFromString:oneDayStr];
    NSDate *dateB = [dateformater dateFromString:anotherDayStr];
    
    NSComparisonResult result = [dateA compare:dateB];
    if (result==NSOrderedSame)
    {
        //相等
        aa=0;
    }else if (result==NSOrderedAscending)
    {
        //bDate比aDate大
        aa=1;
    }else if (result==NSOrderedDescending)
    {
        //bDate比aDate小
        aa=-1;
    }
    return aa;
}

+(NSArray *)getRecently7Day{
    NSMutableArray *days=[NSMutableArray array];
    NSDate *mydate=[NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    for (int i=0; i<7; i++) {
        NSDateComponents *adcomps = [[NSDateComponents alloc] init];
        [adcomps setYear:0];
        [adcomps setMonth:0];
        [adcomps setDay:+i];
        NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
        [days addObject:newdate];
    }
    return (NSArray *)days;
}

+(NSArray *)getRecentlyOneYear{
    NSMutableArray *days=[NSMutableArray array];
    NSDate *mydate=[[NSDate date]dateFormaterWithFormatterString:@"yyyy-MM-dd"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    for (int i=-200; i<165; i++) {
        NSDateComponents *adcomps = [[NSDateComponents alloc] init];
        [adcomps setYear:0];
        [adcomps setMonth:0];
        [adcomps setDay:+i];
        [adcomps setHour:0];
        [adcomps setMinute:0];
        NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
        [days addObject:newdate];
    }
    return (NSArray *)days;
}


-(NSDate *)getDateWithNextWeek:(NSString *)week{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    for (int i=0; i<7; i++) {
        NSDateComponents *adcomps = [[NSDateComponents alloc] init];
        [adcomps setYear:0];
        [adcomps setMonth:0];
        [adcomps setDay:+i];
        NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:self options:0];
        if ([[NSDate getWeekDayWithDate:newdate]isEqualToString:week]) {
            return newdate;
        }
    }
    return nil;
}

#pragma mark -时间戳转化为时间
+(NSDate *)dateWithTimeIntervalInt:(int64_t )timeInt{
    // 毫秒值转化为秒
    return [NSDate dateWithTimeIntervalSince1970:timeInt/ 1000.0];
}

#pragma mark -当前时间后一天
+(NSDate *)getBehindOneDayWithDate:(NSDate *)date{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:0];
    [adcomps setDay:+1];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:date options:0];
    return newdate;
}

-(NSDate *)getFrontOneDay{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:0];
    [adcomps setDay:-1];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:self options:0];
    return newdate;
}

#pragma mark -当前时间后一天
-(NSDate *)getBehindOneDay{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:0];
    [adcomps setDay:+1];
    [adcomps setHour:0];
    [adcomps setMinute:0];
    [adcomps setSecond:0];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:self options:0];
    return newdate;
}

#pragma mark -当前时间前一分
-(NSDate *)getFrontMinte{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:0];
    [adcomps setDay:0];
    [adcomps setHour:0];
    [adcomps setMinute:-1];
    [adcomps setSecond:0];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:self options:0];
    return newdate;
}

-(NSDate *)getFront3S{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:0];
    [adcomps setDay:0];
    [adcomps setHour:0];
    [adcomps setMinute:0];
    [adcomps setSecond:-3];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:self options:0];
    return newdate;
}

#pragma mark -当前时间后几个分钟
+(NSDate *)getBehindOneMinuteWithMinute:(NSInteger)minute{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:0];
    [adcomps setDay:0];
    [adcomps setHour:0];
    [adcomps setMinute:+minute];
    [adcomps setSecond:0];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate new] options:0];
    return newdate;
}

#pragma mark -当前时间前几个分钟
-(NSDate *)getFontDateWithMinute:(NSInteger)minute{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:0];
    [adcomps setDay:0];
    [adcomps setHour:0];
    [adcomps setMinute:-minute];
    [adcomps setSecond:0];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:self options:0];
    return newdate;
}

#pragma mark -当前时间后半个小时时间搓
+ (NSInteger)getBehindCurrentTimeHalfAnHourTimeInterval {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:0];
    [adcomps setDay:0];
    [adcomps setHour:0];
    [adcomps setMinute:+30];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
    return [newdate timeIntervalSince1970] *1000.0;
}

#pragma mark -获取一天时间
+(NSArray *)get24HourWithDate:(NSDate *)date{
    NSMutableArray *array=[NSMutableArray array];
    for (int i=0; i<24; i++) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        NSDateComponents *adcomps = [[NSDateComponents alloc] init];
        [adcomps setYear:0];
        [adcomps setMonth:0];
        [adcomps setDay:0];
        [adcomps setHour:+i];
        NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:date options:0];
        [array addObject:newdate];
    }
    return  array;
}

-(NSDate *)getDate7Day{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:0];
    [adcomps setDay:+7];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:self options:0];
    return newdate;
}

+(NSDate *)getDateWithString:(NSString *)string{
    DRExtensionLock
    NSDateFormatter *formatter = [NSDateFormatter dr_dateFormatter];
    
    [formatter setDateFormat : @"yyyy-MM-dd HH:mm"];
    NSString *stringTime = string;
    NSDate *date =   [formatter dateFromString:stringTime];
    
    
    return date;
}

+(NSDate *)getSecondDateWithString:(NSString *)string {
    DRExtensionLock
    NSDateFormatter *formatter = [NSDateFormatter dr_dateFormatter];
    
    [formatter setDateFormat : @"yyyy-MM-dd HH:mm:ss"];
    NSString *stringTime = string;
    NSDate *date =   [formatter dateFromString:stringTime];
    
    
    return date;
}

-(NSDate *)getRecentlyDateWithDay:(NSInteger)day{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:0];
    [adcomps setDay:+day];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:self options:0];
    return newdate;
}

+(NSString *)returnIntervalWithCurentDate:(NSString *)time{
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:[NSDate new] toDate:[NSDate dateWithTimeIntervalSince1970:[time longLongValue]/1000] options:0];
    //    kDR_LOG(@"%li分，%li时，%li秒",dateCom.hour,dateCom.minute,dateCom.second);
    
    if (dateCom.second>=0) {
        if (dateCom.year!=0) {//年
            return [NSString stringWithFormat:@"%li年",dateCom.year];
        }else if (dateCom.month!=0) {//天
            return [NSString stringWithFormat:@"%li个月",dateCom.month];
        }else if (dateCom.day!=0){
            return [NSString stringWithFormat:@"%li天",dateCom.day];
        }else if (dateCom.hour!=0){
            return [NSString stringWithFormat:@"%li时%li分",dateCom.hour,dateCom.minute];
        }else if (dateCom.minute!=0){
            return [NSString stringWithFormat:@"%li分%li秒",dateCom.minute,dateCom.second];
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

-(NSString *)differenceCurrentDateString{
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:self toDate:[NSDate new] options:0];
    //    kDR_LOG(@"%li分，%li时，%li秒",dateCom.hour,dateCom.minute,dateCom.second);
    
    if (dateCom.second>=0) {
        if (dateCom.year!=0) {//年
            return [NSString stringWithFormat:@"%li年",dateCom.year];
        }else if (dateCom.month!=0) {//天
            return [NSString stringWithFormat:@"%li个月",dateCom.month];
        }else if (dateCom.day!=0){
            return [NSString stringWithFormat:@"%li天",dateCom.day];
        }else if (dateCom.hour!=0){
            return [NSString stringWithFormat:@"%li时%li分钟",dateCom.hour,dateCom.minute];
        }else if (dateCom.minute!=0){
            return [NSString stringWithFormat:@"%li分钟",dateCom.minute];
        }else{
            return @"";
        }
    }else{
        return @"";
    }
}

-(NSString *)differenceCurrentDateCalendarUnitWithDate:(NSDate *)date{
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    // 对比时间差
    
    
    NSDate *fromDate=[NSDate dateWithString:[self dateStringFromFormatterString:@"yyyy-MM-dd HH:mm"] dateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *toDate=[NSDate dateWithString:[date dateStringFromFormatterString:@"yyyy-MM-dd HH:mm"] dateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDateComponents *dateCom = [calendar components:unit fromDate:fromDate toDate:toDate options:0];
    //    kDR_LOG(@"%li分，%li时，%li秒",dateCom.hour,dateCom.minute,dateCom.second);
    
    if (dateCom.second>=0) {
        if (dateCom.year!=0) {//年
            return [NSString stringWithFormat:@"%li,%@",dateCom.year,@"年"];
        }else if (dateCom.month!=0) {//天
            return [NSString stringWithFormat:@"%li,%@",dateCom.month,@"个月"];
        }else if (dateCom.day!=0){
            return [NSString stringWithFormat:@"%li,%@",dateCom.day,@"天"];
        }else if (dateCom.hour!=0){
            return [NSString stringWithFormat:@"%li,%@",dateCom.hour,@"小时"];
        }else if (dateCom.minute!=0){
            return [NSString stringWithFormat:@"%li,%@",dateCom.minute,@"分钟"];
        }else{
            return [NSString stringWithFormat:@"%i,%@",0,@"0"];
        }
    }else{
        return [NSString stringWithFormat:@"%i,%@",0,@"0"];
    }
}

-(NSString *)differenceCurrentDate{
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    // 对比时间差
    
    
    NSDate *fromDate=[NSDate dateWithString:[self dateStringFromFormatterString:@"yyyy-MM-dd"] dateFormat:@"yyyy-MM-dd"];
    NSDate *toDate=[NSDate dateWithString:[[NSDate new] dateStringFromFormatterString:@"yyyy-MM-dd"] dateFormat:@"yyyy-MM-dd"];
    
    NSDateComponents *dateCom = [calendar components:unit fromDate:fromDate toDate:toDate options:0];
    //    kDR_LOG(@"%li分，%li时，%li秒",dateCom.hour,dateCom.minute,dateCom.second);
    
    if (dateCom.second>=0) {
        if (dateCom.year!=0) {//年
            return [NSString stringWithFormat:@"%li%@",dateCom.year,@"年"];
        }else if (dateCom.month!=0) {//天
            return [NSString stringWithFormat:@"%li%@",dateCom.month,@"个月"];
        }else if (dateCom.day!=0){
            return dateCom.day>0?[NSString stringWithFormat:@"%li%@",dateCom.day,@"天"]:@"今天";
        }else{
            return @"今天";
        }
    }else{
        return @"今天";
    }
}

#pragma mark - 距离当前时间
- (NSString *)countDownToCurrentDate{
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    
    // 对比时间差
    NSDate *fromDate = [NSDate dateWithString:[self dateStringFromFormatterString:@"yyyy-MM-dd HH:mm"] dateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *toDate = [NSDate dateWithString:[[NSDate new] dateStringFromFormatterString:@"yyyy-MM-dd HH:mm"] dateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDateComponents *dateCom = [calendar components:unit fromDate:fromDate toDate:toDate options:0];
    
    NSString *before = @"已经过";
    NSString *after = @"还有";
    
    if (dateCom.second >= 0) {
        if (dateCom.year != 0) {//年
            return dateCom.year >0 ? [NSString stringWithFormat:@"%@%li%@",before,dateCom.year,@"年"] : [NSString stringWithFormat:@"%@%li%@",after,labs(dateCom.year),@"年"];
        }else if (dateCom.month != 0) {//月
            return dateCom.month >0 ? [NSString stringWithFormat:@"%@%li%@",before,dateCom.month,@"月"] : [NSString stringWithFormat:@"%@%li%@",after,labs(dateCom.month),@"月"];
        }else if (dateCom.day != 0){//天
            return dateCom.day >0 ? [NSString stringWithFormat:@"%@%li%@",before,dateCom.day,@"天"] : [NSString stringWithFormat:@"%@%li%@",after,labs(dateCom.day),@"天"];
        }else if (dateCom.hour != 0){//小时
            return dateCom.hour >0 ? [NSString stringWithFormat:@"%@%li%@",before,dateCom.hour,@"小时"] : [NSString stringWithFormat:@"%@%li%@",after,labs(dateCom.hour),@"小时"];
        }else if (dateCom.minute != 0){//分钟
            return dateCom.minute >0 ? [NSString stringWithFormat:@"%@%li%@",before,dateCom.minute,@"分钟"] : [NSString stringWithFormat:@"%@%li%@",after,labs(dateCom.minute),@"分钟"];
        }else{
            return @"今天";
        }
    }else{
        return @"今天";
    }
}

//- (NSString *)
//
//- (NSString *)stringWithDateComponents:(NSDateComponents *)components Unit:(NSCalendarUnit )unit{
//    switch (unit) {
//        case NSCalendarUnitYear:
//        {
//
//        }break;
//        case NSCalendarUnitMonth:
//        {
//
//        }break;
//        case NSCalendarUnitDay:
//        {
//
//        }break;
//        case NSCalendarUnitHour:
//        {
//
//        }break;
//        case NSCalendarUnitMinute:
//        {
//
//        }break;
//        default:{
//
//        }break;
//    }
//}

#pragma mark -对比时间差
-(NSDateComponents *)differenceTimeToDate:(NSDate *)toDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:self toDate:toDate options:0];
    return dateCom;
}

+ (NSString*)getCurrentWeekDay{
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:[NSDate new]];
    return [weekdays objectAtIndex:theComponents.weekday];
}

+ (NSString*)getWeekDayWithDate:(NSDate *)date{
    if (date) {
        NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
        NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
        return [weekdays objectAtIndex:theComponents.weekday];
    }else{
        return @"";
    }
}

- (NSInteger)getWeekDay{
    if (self) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
        NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:self];
        return theComponents.weekday;
    }else{
        return 0;
    }
}

+ (NSString*)getWeekWithDate:(NSDate *)date{
    if (date) {
        NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"日", @"一", @"二", @"三", @"四", @"五", @"六", nil];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
        NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
        return [weekdays objectAtIndex:theComponents.weekday];
    }else{
        return @"";
    }
}

#pragma mark -当前日期是否在本周中
-(BOOL)isInCurrentWeek{
    for (NSDate *date in [NSDate getWeekDays]) {
        if ([self compareDateWithDate:date formatter:@"yyyy-MM-dd"]==0) {
            return YES;
            break;
        }
    }
    return NO;
}

+ (NSDate *)dateWithDateString:(NSString *)string dateFormat:(NSString *)dateFormat {
    DRExtensionLock
    NSDateFormatter *formatter = [NSDateFormatter dr_dateFormatter];
    
    [formatter setDateFormat:dateFormat];
    NSDate *date = [formatter dateFromString:string];
    
    
    return date;
}

+ (int64_t)timestampWithYYYYMMDDHHMMSS:(NSString *)string{
    DRExtensionLock
    NSDateFormatter *formatter;
    
    formatter = [NSDateFormatter dr_dateFormatter];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [[formatter dateFromString:string] timeIntervalSince1970] * 1000;
}


#pragma mark -返回当前周是时间
+(NSArray *)getWeekDays{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekday|NSCalendarUnitDay fromDate:now];
    // 得到星期几
    // 1(星期天) 2(星期二) 3(星期三) 4(星期四) 5(星期五) 6(星期六) 7(星期天)
    NSInteger weekDay = [comp weekday];
    // 得到几号
    NSInteger day = [comp day];
    
    kDR_LOG(@"weekDay:%ld   day:%ld",weekDay,day);
    
    // 计算当前日期和这周的星期一和星期天差的天数
    long firstDiff,lastDiff;
    if (weekDay == 1) {
        firstDiff = 1;
        lastDiff = 0;
    }else{
        firstDiff = [calendar firstWeekday] - weekDay;
        lastDiff = 9 - weekDay;
    }
    
    // kDR_LOG(@"firstDiff:%ld   lastDiff:%ld",firstDiff,lastDiff);
    
    // 在当前日期(去掉了时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek= [calendar dateFromComponents:firstDayComp];
    
    NSDateComponents *lastDayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [lastDayComp setDay:day + lastDiff];
    NSDate *lastDayOfWeek= [calendar dateFromComponents:lastDayComp];
    DRExtensionLock
    NSDateFormatter *formater = [NSDateFormatter dr_dateFormatter];
    [formater setDateFormat:@"yyyy-MM-dd"];
    kDR_LOG(@"星期一开始 %@",[formater stringFromDate:firstDayOfWeek]);
    kDR_LOG(@"当前 %@",[formater stringFromDate:now]);
    kDR_LOG(@"星期天结束 %@",[formater stringFromDate:lastDayOfWeek]);
    
    
    NSMutableArray *days=[NSMutableArray array];
    
    // 需要对比的时间数据
    for (int i=0; i<7; i++) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *adcomps = [[NSDateComponents alloc] init];
        [adcomps setYear:0];
        [adcomps setMonth:0];
        [adcomps setDay:i];
        NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:firstDayOfWeek options:0];
        [days addObject:newdate];
    }
    
    return days;
}

#pragma mark -返回当前时间指定点
-(NSDate *)getAppointDateWithHour:(NSInteger)hour{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *newDate = [calendar dateByAddingUnit:NSCalendarUnitHour value:hour toDate:startDate options:0];
    return newDate;
}


#pragma mark -返回一天的小时
+(NSArray *)getDaytimes{
    NSMutableArray *times=[NSMutableArray array];
    for (int i=0; i<24; i++) {
        [times addObject:[NSString stringWithFormat:@"%i",i]];
    }
    return (NSArray *)times;
}

#pragma mark -返回小时的分
+(NSArray *)getHourtimes{
    NSMutableArray *times=[NSMutableArray array];
    for (int i=0; i<60; i++) {
        [times addObject:[NSString stringWithFormat:@"%i",i]];
    }
    return (NSArray *)times;
}

+(NSString *)returnMonthStringWithDate:(NSDate *)date{
    //    NSString *month=[date dateStringFromFormatterString:@"MM"];
    //    NSDictionary *monthDic=[NSDictionary dictionaryWithObjectsAndKeys:@"一",@"01",@"二",@"02",@"三",@"03",@"四",@"04",@"五",@"05",@"六",@"06",@"七",@"07",@"八",@"08",@"九",@"09",@"十",@"10",@"十一",@"11",@"十二",@"12", nil];
    //    return [[monthDic objectForKey:month] stringByAppendingString:@"月"];
    return [NSString stringWithFormat:@"%li月",date.month];
}

#pragma mark-当前
-(BOOL)isSameDay{
    if ([self compareDateWithDate:[NSDate new] formatter:@"yyyy-MM-dd"]==0) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark -下午7点到12点
+(BOOL)is7to12PM{
    if ([[NSDate getCurrentDateHH] integerValue]>=19 && [[NSDate getCurrentDateHH] integerValue]<=23) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)is5to9AM{
    if ([[NSDate getCurrentDateHH] integerValue]>=5 && [[NSDate getCurrentDateHH] integerValue]<=9) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)is22PMto2AM{
    if ([[NSDate getCurrentDateHH] integerValue]<=2 || [[NSDate getCurrentDateHH] integerValue]>=22) {
        return YES;
    }else{
        return NO;
    }
}

- (NSDate *)lastTime{
    int64_t endTimeInterval = [[self nextDay] timeIntervalSince1970] *1000.0 - 1000;
    return [NSDate dateWithTimeIntervalSince1970:endTimeInterval/1000];
}

- (NSString *)timeInterval{
    NSTimeInterval interval = [self timeIntervalSince1970] * 1000;
    return [NSString stringWithFormat:@"%.0f", interval];
}

/*
 返回年月日时分格式
 如 201809100810
 */
- (int64_t)yyyyMMddHHmm {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:[NSDate dateComponentsUnitsWithType:DRCalenderUnitsTypeMinte]
                                         fromDate:self];
    
    int64_t value = (long long)comp.year * 100000000LL + (long long)comp.month * 1000000LL + (long long)comp.day * 10000LL
    + (long long)comp.hour * 100LL + (long long)comp.minute;
    return value;
}

/*
 返回年月日时分秒数字格式
 如 20180910081000
 */
- (int64_t)yyyyMMddHHmmss {
    return self.yyyyMMddHHmm *100;
}

- (NSInteger)yyyyMMddNumber {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                         fromDate:self];
    
    return comp.year * 10000 + comp.month * 100 + comp.day;
}

- (int64_t)yyyyMMddHHNumber {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                         fromDate:self];
    
    return comp.year * 1000000 + comp.month * 10000 + comp.day * 100 + comp.hour;
}

- (int64_t)yyyyMMddHHMMTimestamp {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute
                                         fromDate:self];
    
    NSDate *date = [NSDate dateWithString:[NSString stringWithFormat:@"%04ld-%02ld-%02ld %02ld:%02ld", comp.year,  comp.month,  comp.day,  comp.hour,  (long)comp.minute] dateFormat:@"yyyy-MM-dd HH:mm"];
    
    return date.timestamp;
}

@end

@implementation NSDate (DRCalendar)

//日期相等
- (BOOL)dateEqualTo:(NSDate *)date {
    return [self timeIntervalSinceDate:date] == 0;
}

//大于传参日期
- (BOOL)dateGreaterThan:(NSDate *)date {
    return [self timeIntervalSinceDate:date] > 0;
}

//大于等于传参日期
- (BOOL)dateGreaterThanOrEqualTo:(NSDate *)date {
    return [self timeIntervalSinceDate:date] >= 0;
}

//小于传参日期
- (BOOL)dateLessThan:(NSDate *)date {
    return [self timeIntervalSinceDate:date] < 0;
}

//小于等于传参日期
- (BOOL)dateLessThanOrEqualTo:(NSDate *)date {
    return [self timeIntervalSinceDate:date] <= 0;
}

/**
 *  NSDate转字符串
 *  将0时区的NSDate 转成 8时区的时间文本
 */
- (NSString *)dateStringFromFormatterString:(NSString *)string {
    DRExtensionLock
    NSDateFormatter *formatter = [NSDateFormatter dr_dateFormatter];
    formatter.dateFormat = string;
    NSString *dateString = [formatter stringFromDate:self];
    
    return dateString;
}

//字符串转NSDate
+ (NSDate *)dateWithString:(NSString *)string {
    return [self dateWithString:string dateFormat:@"yyyy-MM-dd"];
}

/**
 *  字符串转NSDate
 *  将8时区的时间文本 转成 0时区的NSDate
 */
+ (NSDate *)dateWithString:(NSString *)string dateFormat:(NSString *)dateFormat {
    DRExtensionLock
    NSDateFormatter *formatter = [NSDateFormatter dr_dateFormatter];
    [formatter setDateFormat:dateFormat];
    NSDate *date = [formatter dateFromString:string];
    
    
    return date;
}

//时间戳转字符串
+ (NSString *)dateWithTimeInterval:(NSTimeInterval)timeInterval dateFormat:(NSString *)dateFormat {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [date dateStringFromFormatterString:dateFormat];
}

@end


@implementation NSDate (DRLunarCalendar)

- (NSCalendar *)lunarCalendar {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    [calendar setTimeZone:timeZone];
    [calendar setFirstWeekday:DRCalendarFirstDay];
    return calendar;
}

//是否同一月
- (BOOL)isEqualLunarMonthToDate:(NSDate *)date {
    NSUInteger unit = NSCalendarUnitMonth | NSCalendarUnitYear ;
    NSDateComponents *nowComp = [self.lunarCalendar components:unit fromDate:self];
    NSDateComponents *targetComp = [self.lunarCalendar components:unit fromDate:date];
    return (targetComp.year == nowComp.year) && (targetComp.month == nowComp.month);
}

//日 - 农历
- (NSString *)lunarDay {
    NSCalendar *calendar = self.lunarCalendar;
    NSArray *lunarDays = @[@"初一", @"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",@"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十"];
    NSInteger day = [calendar component:NSCalendarUnitDay fromDate:self];
    return lunarDays[day - 1];
}

// 农历 日 数字
- (NSString *)lunarDayNumber {
    NSCalendar *calendar = self.lunarCalendar;
    NSArray *lunarDays = @[@"1", @"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30"];
    NSInteger day = [calendar component:NSCalendarUnitDay fromDate:self];
    return lunarDays[day - 1];
}

//日 - 农历,日历展示
- (NSString *)lunarDayForCalendar {
    NSCalendar *calendar = self.lunarCalendar;
    NSInteger day = [calendar component:NSCalendarUnitDay fromDate:self];
    if (day == 1) {
        return self.lunarMonth;
    }
    return self.lunarDay;
}

//星期几
- (NSInteger)lunarWeekday {
    NSCalendar *calendar = self.lunarCalendar;
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:self];
    return [components weekday];
}

//月 - 农历
- (NSString *)lunarMonth {
    NSCalendar *calendar = self.lunarCalendar;
    NSArray *lunarMonths = @[@"正月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"冬月",@"腊月"];
    DRExtensionLock
    //闰月
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    
    if(components.isLeapMonth) {
        NSString *monthString = [NSString stringWithFormat:@"闰%@", lunarMonths[components.month - 1]];
        return monthString;
    }else {
        NSString *monthString = [NSString stringWithFormat:@"%@", lunarMonths[components.month - 1]];
        return monthString;
    }
}

//月 - 农历
- (NSString *)lunarNormalMonth {
    NSCalendar *calendar = self.lunarCalendar;
    NSArray *lunarMonths = @[@"正月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"十二月"];
    DRExtensionLock
    //闰月
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    if(components.isLeapMonth) {
        NSString *monthString = [NSString stringWithFormat:@"闰%@", lunarMonths[components.month - 1]];
        return monthString;
    }else {
        NSString *monthString = [NSString stringWithFormat:@"%@", lunarMonths[components.month - 1]];
        return monthString;
    }
}

// 农历 月 数字
- (NSString *)lunarMonthNumber {
    NSCalendar *calendar = self.lunarCalendar;
    NSArray *lunarMonths = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    DRExtensionLock
    
    //闰月
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    if(components.isLeapMonth) {
        NSString *monthString = [NSString stringWithFormat:@"%@.0", lunarMonths[components.month - 1]];
        return monthString;
    }else {
        NSString *monthString = [NSString stringWithFormat:@"%@", lunarMonths[components.month - 1]];
        return monthString;
    }
}

//大于等于闰月
- (BOOL)greaterThanOrEqualToLeapMonth {
    NSArray<NSDate *> *yearArray = [NSDate lunarMonthDateArrayInYear:self.year];
    NSDate *leapMonth;
    for (NSDate *date in yearArray) {
        if (date.isLeapMonth) {
            leapMonth = date;
            break;
        }
    }
    if (leapMonth) {
        if (self.lunarMonthNumber.integerValue > leapMonth.lunarMonthNumber.integerValue) {
            return YES;
        } else {
            return [self.lunarMonthNumber containsString:@"."];
        }
    }
    return NO;
}

// 是否是闰月
- (BOOL)isLeapMonth {
    NSDateComponents *components = [self.lunarCalendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    
    return components.isLeapMonth;
}

- (void)solarToLunarWithComplelte:(void (^)(NSInteger, NSInteger, NSInteger, BOOL leapMonth))complete {
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    unsigned unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:self];
    
    if(complete) {
        if(self.month < localeComp.month) {
            [localeComp setYear:self.year - 1];
        }else {
            [localeComp setYear:self.year];
        }
        
        complete(localeComp.year, localeComp.month, localeComp.day, localeComp.leapMonth);
    }
    
}

- (NSDate *)lunarToSolarWithLeap:(BOOL)isLeap{
    NSInteger lyear = self.year, lmonth = self.month, lday = self.day;
    NSDate *date = [self nextDayWithCount:-90];
    NSInteger index = 0;
    __block BOOL isTarget = false;
    
    while(index < 180) {
        [date solarToLunarWithComplelte:^(NSInteger year, NSInteger month, NSInteger day, BOOL leapMonth) {
            if(lmonth == month && lday == day && isLeap == leapMonth) {
                isTarget = true;
            }
        }];
        
        if(isTarget) {
            break;
        }
        
        date = [date nextDay];
        index++;
    }
    
    if(isTarget) {
        return date;
    }else {
        return [NSDate dateWithString:[NSString stringWithFormat:@"%04ld-%02ld-%02ld", lyear, lmonth, lday]
                           dateFormat:@"yyyy-MM-dd"];
    }
}

//年 - 农历
- (NSString *)lunarYear {
    NSCalendar *calendar = self.lunarCalendar;
    NSArray *heavenlyStems = @[@"甲", @"乙", @"丙", @"丁", @"戊", @"己", @"庚", @"辛", @"壬", @"癸"];
    NSArray *earthlyBranches = @[@"子", @"丑", @"寅", @"卯", @"辰", @"巳", @"午", @"未", @"申", @"酉", @"戌", @"亥"];
    NSInteger year = [calendar component:NSCalendarUnitYear fromDate:self];
    NSInteger heavenlyStemIndex = (year - 1) % heavenlyStems.count;
    NSInteger earthlyBrancheIndex = (year - 1) % earthlyBranches.count;
    
    NSString *string = [NSString stringWithFormat:@"%@%@", heavenlyStems[heavenlyStemIndex], earthlyBranches[earthlyBrancheIndex]];
    return string;
}

// 2019年

- (NSString *)lunarYearNumber {
    unsigned unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    NSDateComponents *localeComp = [self.lunarCalendar components:unitFlags fromDate:self];
    if(self.month < localeComp.month) {
        [localeComp setYear:self.year - 1];
    } else {
        [localeComp setYear:self.year];
    }
    return [NSString stringWithFormat:@"%ld年", localeComp.year];
}

//当月第一天Date
- (NSDate *)firstLunarDayInThisMonth {
    NSInteger year = self.year;
    if ((self.lunarMonthNumber.integerValue > 10) && (self.month < 3)) {
        //农历年末月份 且 对应新历在下一年的年初月份，则减少一年
        year = year - 1;
    }
    NSArray<NSDate *> *monthArray = [NSDate lunarMonthDateArrayInYear:year];
    NSDate *firstDate;
    for (NSDate *date in monthArray) {
        if ([date.lunarMonth isEqualToString:self.lunarMonth]) {
            firstDate = date;
            break;
        }
    }
    if (firstDate) {
        return firstDate;
    } else { //没找到对应月份，使用系统方法，不过会自动增加60年
        NSCalendar *calendar = self.lunarCalendar;
        NSDateComponents *comp = [calendar components:NSCalendarUnitDay fromDate:self];
        [comp setDay:1];
        NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
        return firstDayOfMonthDate;
    }
}

//当年第一天Date
- (NSDate *)firstLunarDayInThisYear {
    for (int i = 1; i <= 3 ; i++) { //遍历每年前三个月是否含有正月初一
        NSString *string = [NSString stringWithFormat:@"%@-%@", @(self.year), @(i)];
        NSDate *monthDate = [NSDate dateWithString:string dateFormat:@"yyyy-MM"];
        NSDate *dayDate;
        for (NSDate *date in [monthDate dayDateArrayInCurrentMonth]) {
            if ([date.lunarMonth isEqualToString:@"正月"] && [date.lunarDay isEqualToString:@"初一"]) {
                dayDate = date;
                break;
            }
        }
        if (dayDate != nil) {
            return dayDate;
        }
    }
    return [self firstLunarDayInThisMonth];
}

//这个月的第一天是周几
- (NSInteger)firstLunarWeekdayInThisMonth {
    NSCalendar *calendar = self.lunarCalendar;
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:self.firstDayInThisMonth];
    return firstWeekday;
}

//这个月有几天
- (NSInteger)totalLunarDaysInMonth {
    NSRange range = [self.lunarCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return range.length;
}

//一年有几天
- (NSInteger)totalLunarDaysInYear {
    NSRange range = [self.lunarCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:self];
    return range.length;
}

//这个月有多少个星期
- (NSInteger)totalLunarWeeksInMonth {
    NSRange weeksInMonth = [self.lunarCalendar rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:self];
    return weeksInMonth.length;
}

//之前一天Date
- (NSDate *)lastLunarDay {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = -1;
    NSDate *newDate = [self.lunarCalendar dateByAddingComponents:dateComponents toDate:self options:NSCalendarMatchPreviousTimePreservingSmallerUnits];
    return newDate;
}

//之后一天Date
- (NSDate *)nextLunarDay {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = +1;
    NSDate *newDate = [self.lunarCalendar dateByAddingComponents:dateComponents toDate:self options:NSCalendarMatchNextTimePreservingSmallerUnits];
    return newDate;
}

//上个月Date
- (NSDate *)lastLunarMonth {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [self.lunarCalendar dateByAddingComponents:dateComponents toDate:self options:NSCalendarMatchPreviousTimePreservingSmallerUnits];
    return newDate;
}

//下个月Date
- (NSDate *)nextLunarMonth {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [self.lunarCalendar dateByAddingComponents:dateComponents toDate:self options:NSCalendarMatchNextTimePreservingSmallerUnits];
    return newDate;
}

//当周每天Date数组
- (NSArray<NSDate *> *)lunarDayDateArrayInWeek {
    NSInteger weekDayCount = 7;
    NSMutableArray *dateArray = [NSMutableArray array];
    NSDate *date = self;
    NSInteger weekDay = [date lunarWeekday];
    NSInteger nextDayCount = weekDayCount - weekDay;
    //之前
    NSDate *lastDate = date;
    NSMutableArray *lastDateArray = [NSMutableArray array];
    for (int i = 1; i < weekDay; i++) {
        lastDate = [lastDate lastLunarDay];
        [lastDateArray addObject:lastDate];
    }
    [dateArray addObjectsFromArray:[[lastDateArray reverseObjectEnumerator] allObjects]];
    //当前
    [dateArray addObject:date];
    //之后
    for (int i = 0; i < nextDayCount; i++) {
        date = [date nextLunarDay];
        [dateArray addObject:date];
    }
    return dateArray.copy;
}

//当月每天Date数组
- (NSArray<NSDate *> *)lunarDayDateArrayInCurrentMonth {
    NSDate *firstDate = [self firstLunarDayInThisMonth];
    NSMutableArray<NSDate *> *dateArray = [NSMutableArray array];
    [dateArray addObject:firstDate];
    NSInteger itemCount = self.totalLunarDaysInMonth;
    for (int i = 1; i < itemCount; i++) {
        [dateArray addObject:dateArray.lastObject.nextLunarDay];
    }
    return dateArray;
}

//当月每天Date数组（上月几天+本月+下月几天）
- (NSArray<NSDate *> *)lunarDayDateArrayInMonth {
    NSMutableArray *dateArray = [NSMutableArray array];
    NSDate *newDate = [self firstLunarDayInThisMonth];
    NSInteger firstWeekday = [newDate firstLunarWeekdayInThisMonth] - 1;
    //1号之前
    NSDate *lastDate = newDate;
    NSMutableArray *lastDateArray = [NSMutableArray array];
    for (int i = 0; i < firstWeekday; i++) {
        lastDate = [lastDate lastLunarDay];
        [lastDateArray addObject:lastDate];
    }
    [dateArray addObjectsFromArray:[[lastDateArray reverseObjectEnumerator] allObjects]];
    //1号
    [dateArray addObject:newDate];
    //1号之后
    NSInteger itemCount = self.totalLunarWeeksInMonth * 7;
    for (int i = 1; i < itemCount - firstWeekday; i++) {
        newDate = [newDate nextLunarDay];
        [dateArray addObject:newDate];
    }
    return dateArray.copy;
}

//当年每天Date数组
- (NSArray<NSDate *> *)lunarDayDateArrayInYear {
    NSInteger yearDayCount = [self totalLunarDaysInYear];
    NSMutableArray<NSDate *> *array = [NSMutableArray array];
    for (int i = 0; i < yearDayCount; i++) {
        if (i == 0) {
            [array addObject:self.firstLunarDayInThisYear];
        } else {
            [array addObject:array.lastObject.nextDay];
        }
    }
    return array;
}

//获取某一年农历月份
+ (NSArray<NSDate *> *)lunarMonthDateArrayInYear:(NSInteger)year {
    NSMutableArray<NSDate *> *dateArray = [NSMutableArray array];
    NSString *string = [NSString stringWithFormat:@"%@-%@", @(year), @(1)];
    NSDate *date = [NSDate dateWithString:string dateFormat:@"yyyy-MM"];
    [dateArray addObject:date.firstLunarDayInThisYear];
    BOOL isEnd = NO;
    while (!isEnd) {
        NSDate *date = dateArray.lastObject.nextLunarMonth;
        [dateArray addObject:date];
        isEnd = [date.lunarMonth isEqualToString:@"腊月"];
        if (dateArray.count >= 13) {
            isEnd = YES;
        }
    }
    return dateArray.copy;
}

//获取当前日期前后N个月 - 农历
- (NSArray<NSDate *> *)lunarMonthDateArrayWithCount:(NSInteger)count {
    NSDate *firstDate = [self firstLunarDayInThisMonth];
    NSMutableArray<NSDate *> *weekArray = [NSMutableArray array];
    [weekArray addObject:firstDate];
    for (int w = 1; w < count; w++) {
        [weekArray insertObject:weekArray.firstObject.lastLunarMonth atIndex:0];
        [weekArray addObject:weekArray.lastObject.nextLunarMonth];
    }
    return weekArray.copy;
}

@end


@implementation NSDate (DRSolarCalendar)

- (NSCalendar *)calendar {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    [calendar setTimeZone:timeZone];
    [calendar setFirstWeekday:DRCalendarFirstDay];
    return calendar;
}

#pragma mark - 判断

//是否今天
- (BOOL)isToday {
    return [self isEqualDayToDate:[NSDate date]];
}

//是否今个星期
- (BOOL)isThisWeek {
    return [self isEqualWeekToDate:[NSDate date]];
}

//是否今个月
- (BOOL)isThisMonth {
    return [self isEqualMonthToDate:[NSDate date]];
}

//是否今年
- (BOOL)isThisYear {
    return [self isEqualYearToDate:[NSDate date]];
}

//是否同一时间段 HH:MM
- (BOOL)isEqualTimeToDate:(NSDate *)date {
    NSUInteger unit = NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear ;
    NSDateComponents *nowComp = [self.calendar components:unit fromDate:self];
    NSDateComponents *targetComp = [self.calendar components:unit fromDate:date];
    BOOL sameTime = NO;
    if (nowComp.minute < 30 && targetComp.minute < 30) {
        sameTime = YES;
    } else if(nowComp.minute >= 30 && targetComp.minute >= 30) {
        sameTime = YES;
    }
    return (targetComp.year == nowComp.year) && (targetComp.month == nowComp.month) && (targetComp.day == nowComp.day) && (targetComp.hour == nowComp.hour) && sameTime;
}

//是否同一小时
- (BOOL)isEqualHourToDate:(NSDate *)date {
    NSUInteger unit = NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear ;
    NSDateComponents *nowComp = [self.calendar components:unit fromDate:self];
    NSDateComponents *targetComp = [self.calendar components:unit fromDate:date];
    return (targetComp.year == nowComp.year) && (targetComp.month == nowComp.month) && (targetComp.day == nowComp.day) && (targetComp.hour == nowComp.hour);
}

//是否同一天
- (BOOL)isEqualDayToDate:(NSDate *)date {
    NSUInteger unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear ;
    NSDateComponents *nowComp = [self.calendar components:unit fromDate:self];
    NSDateComponents *targetComp = [self.calendar components:unit fromDate:date];
    return (targetComp.year == nowComp.year) && (targetComp.month == nowComp.month) && (targetComp.day == nowComp.day);
}

//是否同一星期
- (BOOL)isEqualWeekToDate:(NSDate *)date {
    NSDate *startWeek = date.firstDayInThisWeek;
    NSDate *selfStartWeek = self.firstDayInThisWeek;
    
    if([startWeek dateEqualTo:selfStartWeek]) {
        return true;
    }else {
        return false;
    }
    
    //    NSUInteger unit = NSCalendarUnitWeekOfYear | NSCalendarUnitYear ;
    //    NSDateComponents *nowComp = [self.calendar components:unit fromDate:date];
    //    NSDateComponents *targetComp = [self.calendar components:unit fromDate:self];
    //    if((targetComp.year == nowComp.year) && (targetComp.weekOfYear == nowComp.weekOfYear)) {
    //        return true;
    //    }else {
    //        return false;
    //    }
    //    return (targetComp.year == nowComp.year) && (targetComp.weekOfYear == nowComp.weekOfYear);
}

//是否同一月
- (BOOL)isEqualMonthToDate:(NSDate *)date {
    NSUInteger unit = NSCalendarUnitMonth | NSCalendarUnitYear ;
    NSDateComponents *nowComp = [self.calendar components:unit fromDate:self];
    NSDateComponents *targetComp = [self.calendar components:unit fromDate:date];
    return (targetComp.year == nowComp.year) && (targetComp.month == nowComp.month);
}

//是否同一年
- (BOOL)isEqualYearToDate:(NSDate *)date {
    NSUInteger unit = NSCalendarUnitYear ;
    NSDateComponents *nowComp = [self.calendar components:unit fromDate:self];
    NSDateComponents *targetComp = [self.calendar components:unit fromDate:date];
    return (targetComp.year == nowComp.year);
}

#pragma mark - 相差

//相差多少天
- (NSInteger)numberOfDaysDifferenceWithDate:(NSDate *)date {
    NSDateComponents *comps = [self.calendar components: NSCalendarUnitDay fromDate:self toDate:date  options:0];
    return [comps day];
}

//相差多少周
- (NSInteger)numberOfWeeksDifferenceWithDate:(NSDate *)date {
    NSDateComponents *comps = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear fromDate:self toDate:date  options:0];
    return [comps weekOfYear];
}

//相差多少月
- (NSInteger)numberOfMonthsDifferenceWithDate:(NSDate *)date {
    NSDateComponents *comps = [self.calendar components:NSCalendarUnitMonth fromDate:self toDate:date  options:0];
    return [comps month];
}

//相差多少年
- (NSInteger)numberOfYearsDifferenceWithDate:(NSDate *)date {
    NSDateComponents *comps = [self.calendar components:NSCalendarUnitYear fromDate:self toDate:date  options:0];
    return [comps year];
}

#pragma mark -

//秒
- (NSInteger)second {
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:self];
    return [components second];
}

//分钟
- (NSInteger)minute {
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self];
    return [components minute];
}

//小时
- (NSInteger)hour {
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour) fromDate:self];
    return [components hour];
}

//日
- (NSInteger)day {
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    return [components day];
}

//星期几
- (NSInteger)weekday {
    NSCalendar *calendar = self.calendar;
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:self];
    return [components weekday];
}

//中国式星期几
- (NSInteger)chinaWeekday {
    NSCalendar *calendar = self.calendar;
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:self];
    NSInteger weekDay = [components weekday] - 1;
    
    if(weekDay == 0) {
        return 7;
    }else {
        return weekDay;
    }
}

//星期几 - 中文
- (NSString *)weekdayString {
    switch (self.weekday) {
        case 1: return @"日";
        case 2: return @"一";
        case 3: return @"二";
        case 4: return @"三";
        case 5: return @"四";
        case 6: return @"五";
        case 7: return @"六";
        default: return @"日";
    }
}

//第几星期 - 月份
- (NSInteger)weekOfMonth {
    NSCalendar *calendar = self.calendar;
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth) fromDate:self];
    return [components weekOfMonth];
}

//第几星期 - 年
- (NSInteger)weekOfYear {
    NSCalendar *calendar = self.calendar;
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear) fromDate:self];
    return [components weekOfYear];
}

//月
- (NSInteger)month {
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    return [components month];
}

//月 - 中文
- (NSString *)monthString {
    switch (self.month) {
        case 1: return @"一";
        case 2: return @"二";
        case 3: return @"三";
        case 4: return @"四";
        case 5: return @"五";
        case 6: return @"六";
        case 7: return @"七";
        case 8: return @"八";
        case 9: return @"九";
        case 10: return @"十";
        case 11: return @"十一";
        case 12: return @"十二";
        default: return @"一";
    }
}


//月 - 中文
- (NSString *)solarMonthString {
    switch (self.month) {
        case 1: return @"1月";
        case 2: return @"2月";
        case 3: return @"3月";
        case 4: return @"4月";
        case 5: return @"5月";
        case 6: return @"6月";
        case 7: return @"7月";
        case 8: return @"8月";
        case 9: return @"9月";
        case 10: return @"10月";
        case 11: return @"11月";
        case 12: return @"12月";
        default: return @"1月";
    }
}

//时间戳 从1970年开始
- (int64_t)timestamp {
    return [self timeIntervalSince1970] * 1000;
}

//年
- (NSInteger)year {
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    return [components year];
}

//当月的第一天是周几
- (NSInteger)firstWeekdayInThisMonth {
    NSCalendar *calendar = self.calendar;
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday;
}

//当月有几天
- (NSInteger)totalDaysInMonth {
    NSRange daysInLastMonth = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return daysInLastMonth.length;
}

//当年有几天
- (NSInteger)totalDaysInYear {
    NSRange daysInLastYear = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:self];
    return daysInLastYear.length;
}

//当月有多少个星期
- (NSInteger)totalWeeksInMonth {
    NSRange weeksInMonth = [self.calendar rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:self];
    return weeksInMonth.length;
}

//当年有多少个星期
- (NSInteger)totalWeeksInYear {
    NSRange weeksInMonth = [self.calendar rangeOfUnit:NSCalendarUnitWeekOfYear inUnit:NSCalendarUnitYear forDate:self];
    return weeksInMonth.length;
}

//当周第一天Date
- (NSDate *)firstDayInThisWeek {
    NSCalendar *calendar = self.calendar;
    NSDate *firstDate;
    // 根据参数提供的时间点，返回所在日历单位的开始时间。如果startDate和interval均可以计算，则返回YES；否则返回NO
    BOOL result = [calendar rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&firstDate interval:nil forDate:self];
    if (result) {
        return firstDate;
    } else {
        //只适用第一天为星期日
        NSDateComponents *dateComponents = [calendar components:NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self];
        NSInteger weekday = [dateComponents weekday];
        if (weekday == self.calendar.firstWeekday) {
            return self;
        } else {
            NSInteger firstDiff = (- weekday + 1);
            NSInteger day = [dateComponents day];
            [dateComponents setDay:day+firstDiff];
            NSDate *firstDay = [calendar dateFromComponents:dateComponents];
            return firstDay;
        }
    }
}

//当周最后一条天Date
- (NSDate *)lastDayInThisWeek {
    return [self dayDateArrayInWeek].lastObject;
}

//当月第一天Date
- (NSDate *)firstDayInThisMonth {
    NSCalendar *calendar = self.calendar;
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    return firstDayOfMonthDate;
}

- (NSDate *)firstDateInThisMonth {
    return [self firstDayInThisMonth].midnight;
}

- (NSDate *)lastDateInThisMonth {
    return [self lastDayInThisMonth].endOfDate;
}

//当月最后一天Date
- (NSDate *)lastDayInThisMonth {
    NSInteger day = [self totalDaysInMonth];
    NSCalendar *calendar = self.calendar;
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    [comp setDay:day];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    return firstDayOfMonthDate;
}

//当年第一天
- (NSDate *)firstDayInThisYear {
    DRExtensionLock
    NSDateFormatter *format = [NSDateFormatter dr_dateFormatter];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [format dateFromString:[NSString stringWithFormat:@"%ld-01-01 00:00:00", self.year]];
    
    
    return date;
}

//当年最后一天
- (NSDate *)lastDayInThisYear {
    DRExtensionLock
    NSDateFormatter *format = [NSDateFormatter dr_dateFormatter];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [format dateFromString:[NSString stringWithFormat:@"%ld-12-31 23:23:59", self.year]];
    
    
    return date;
}

//下一年最后一天
- (NSDate *)nextYearLastDay {
    NSDateComponents *cmp = [self.calendar components:NSCalendarUnitYear fromDate:self];
    cmp.year += 1;
    cmp.month = 12;
    cmp.day = 31;
    cmp.hour = 23;
    cmp.minute = 59;
    cmp.second = 59;
    return [[self calendar] dateFromComponents:cmp];
}

+ (NSDate *)nextYearLastDay {
    return [NSDate date].nextYearLastDay;
}

+ (NSDate *)minDate {
    return [NSDate dateWithString:@"20000101" dateFormat:@"yyyyMMdd"];
}

//之前一天Date
- (NSDate *)lastDay {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = -1;
    NSDate *newDate = [self.calendar dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

//之后一天
- (NSDate *)nextDay {
    return [self nextDayWithCount:1];
}

//之前N天
- (NSDate *)lastDayWithCount:(NSInteger)count {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = -count;
    NSDate *newDate = [self.calendar dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

//之后N天
- (NSDate *)nextDayWithCount:(NSInteger)count {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = +count;
    NSDate *newDate = [self.calendar dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}


//上星期
- (NSDate *)lastWeek {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.weekOfYear = -1;
    NSDate *newDate = [self.calendar dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

//下个星期
- (NSDate *)nextWeek {
    return [self nextWeekWithCount:1];
}

//下N个星期
- (NSDate *)nextWeekWithCount:(NSInteger)count {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.weekOfYear = +count;
    NSDate *newDate = [self.calendar dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

//获取指定当月指定星期
- (NSDate *)weekInThisMonthWithCount:(NSInteger)count {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setWeekOfMonth:count - 1];
    NSDate *monthDate = [self firstDayInThisMonth];
    NSDate *newDate = [self.calendar dateByAddingComponents:comps toDate:monthDate options:0];
    if (count == 0) {
        return monthDate;
    } else {
        if (![newDate isEqualMonthToDate:monthDate]) { //获取date超过当月日期，设为当月最后一天
            newDate = monthDate.lastDayInThisMonth;
        }
        return newDate;
    }
}

//上个月
- (NSDate *)lastMonth {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [self.calendar dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

//下个月
- (NSDate *)nextMonth {
    return [self nextMonthWithCount:1];
}

//下N个月
- (NSDate *)nextMonthWithCount:(NSInteger)count {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +count;
    NSDate *newDate = [self.calendar dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

// 上一年
- (NSDate *)lastYear {
    return [self lastYearWithCount:1];
}

// 之前N年
- (NSDate *)lastYearWithCount:(NSInteger)count {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = -count;
    NSDate *newDate = [self.calendar dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

// 下一年
- (NSDate *)nextYear {
    return [self nextYearWithCount:1];
}

// 之后N年
- (NSDate *)nextYearWithCount:(NSInteger)count {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = +count;
    NSDate *newDate = [self.calendar dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

//加N个小时
- (NSDate *)nextHour:(CGFloat)n {
    NSInteger i = (NSInteger)n; // 取整数部分
    CGFloat f =  n - i; //取小数部分
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    if (i > 0) dateComponents.hour = +i;
    if (f > 0) dateComponents.minute = +(f * 60);
    NSDate *newDate = [self.calendar dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

//凌晨零点
- (NSDate *)midnight {
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    return [self.calendar dateFromComponents:components];
}

//晚上23:59:59
- (NSDate *)endOfDate {
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    components.hour = 23;
    components.minute = 59;
    components.second = 59;
    return [self.calendar dateFromComponents:components];
}

- (NSString *)YYYYMMDD {
    DRExtensionLock
    NSDateFormatter *formatter = [NSDateFormatter dr_dateFormatter];
    //设置你想要的格式
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //现在时间,你可以输出来看下是什么格式
    NSString *result = [formatter stringFromDate:self];
    
    
    return result;
}

- (NSString *)YYYYMM {
    DRExtensionLock
    NSDateFormatter *formatter = [NSDateFormatter dr_dateFormatter];
    //设置你想要的格式
    [formatter setDateFormat:@"yyyy-MM"];
    //现在时间,你可以输出来看下是什么格式
    NSString *result = [formatter stringFromDate:self];
    
    
    return result;
}

//时间调到对应时间，XX:00 或 XX:30
- (NSDate *)correctionTime {
    NSCalendar *calendar = self.calendar;
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self];
    if (self.minute < 30) {
        components.minute = 0;
    } else {
        components.minute = 30;
    }
    NSDate *newDate = [calendar dateFromComponents:components];
    return newDate;
}

//设置时间 年
- (NSDate *)correctionYear:(NSInteger)year {
    NSCalendar *calendar = self.calendar;
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:self];
    components.year = year;
    NSDate *newDate = [calendar dateFromComponents:components];
    return newDate;
}

//设置时间 月
- (NSDate *)correctionMonth:(NSInteger)month {
    NSCalendar *calendar = self.calendar;
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:self];
    
    components.month = month;
    NSDate *newDate = [calendar dateFromComponents:components];
    return newDate;
}

//设置时间 日
- (NSDate *)correctionDay:(NSInteger)day {
    NSCalendar *calendar = self.calendar;
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:self];
    components.day = day;
    NSDate *newDate = [calendar dateFromComponents:components];
    return newDate;
}

//设置时间 年月日时分秒
+ (NSDate *)correctionYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    NSDateComponents *components = [NSDateComponents new];
    components.year = year;
    components.month = month;
    components.day = day;
    components.hour = hour;
    components.minute = minute;
    components.second = second;
    NSDate *newDate = [[NSDate date].calendar dateFromComponents:components];
    return newDate;
}

//当月每天Date数组（上月几天+本月+下月几天）
- (NSArray<NSDate *> *)dayDateArrayInMonth {
    NSDate *firstDay = [self firstDayInThisMonth];
    NSInteger firstWeekday = [firstDay firstWeekdayInThisMonth] - 1;
    NSMutableArray<NSDate *> *dateArray = [NSMutableArray array];
    //1号
    [dateArray addObject:firstDay];
    //1号之前
    for (int i = 0; i < firstWeekday; i++) {
        [dateArray insertObject:dateArray.firstObject.lastDay atIndex:0];
    }
    //1号之后
    NSInteger itemCount = self.totalWeeksInMonth * 7;
    for (int i = 1; i < itemCount - firstWeekday; i++) {
        [dateArray addObject:dateArray.lastObject.nextDay];
    }
    return dateArray.copy;
}

//当月每天Date数组 - 六周（上月几天+本月+下月几天）
- (NSArray<NSDate *> *)dayDateArrayInMonthWithSixWeek {
    NSDate *firstDay = [self firstDayInThisMonth];
    NSInteger firstWeekday = [firstDay firstWeekdayInThisMonth] - 1;
    NSMutableArray<NSDate *> *dateArray = [NSMutableArray array];
    //1号
    [dateArray addObject:firstDay];
    //1号之前
    for (int i = 0; i < firstWeekday; i++) {
        [dateArray insertObject:dateArray.firstObject.lastDay atIndex:0];
    }
    //1号之后
    NSInteger itemCount = 6 * 7;
    for (int i = 1; i < itemCount - firstWeekday; i++) {
        [dateArray addObject:dateArray.lastObject.nextDay];
    }
    return dateArray.copy;
}

//当月每天Date数组
- (NSArray<NSDate *> *)dayDateArrayInCurrentMonth {
    NSDate *firstDate = [self firstDayInThisMonth];
    NSMutableArray<NSDate *> *dateArray = [NSMutableArray array];
    [dateArray addObject:firstDate];
    NSInteger itemCount = self.totalDaysInMonth;
    for (int i = 1; i < itemCount; i++) {
        [dateArray addObject:dateArray.lastObject.nextDay];
    }
    return dateArray;
}

//当周每天Date数组
- (NSArray<NSDate *> *)dayDateArrayInWeek {
    NSInteger weekDayCount = 7;
    NSDate *firstDay = [self firstDayInThisWeek];
    NSMutableArray<NSDate *> *dateArray = [NSMutableArray array];
    [dateArray addObject:firstDay];
    for (int i = 1; i < weekDayCount; i++) {
        [dateArray addObject:[dateArray.lastObject nextDay]];
    }
    return dateArray.copy;
}

//获取今年各月份 - 公历
+ (NSArray<NSDate *> *)monthDateArrayInThisYear {
    return [self monthDateArrayInYear:[NSDate date].year];
}

//获取某一年各天 - 公历
+ (NSArray<NSDate *> *)dayDateArrayInYear:(NSInteger)year {
    NSMutableArray<NSDate *> *dayArray = [NSMutableArray array];
    NSDate *date = [NSDate dateWithString:@(year).stringValue dateFormat:@"yyyy"];
    [dayArray addObject:date];
    for (NSInteger d = 2; d <= date.totalDaysInYear; d++) {
        [dayArray addObject:dayArray.lastObject.nextDay];
    }
    return dayArray.copy;
}

//获取某一年各月份 - 公历
+ (NSArray<NSDate *> *)monthDateArrayInYear:(NSInteger)year {
    NSMutableArray<NSDate *> *monthArray = [NSMutableArray array];
    NSDate *date = [NSDate dateWithString:@(year).stringValue dateFormat:@"yyyy"];
    [monthArray addObject:date];
    for (NSInteger m = 2; m <= 12; m++) {
        [monthArray addObject:monthArray.lastObject.nextMonth];
    }
    return monthArray.copy;
}

//获取某一日期之后(含该月份)的N个月 - 公历
- (NSArray<NSDate *> *)monthDateArrayNextWithCount:(NSInteger)count {
    NSDate *firstDate = self.firstDayInThisMonth;
    NSMutableArray<NSDate *> *monthArray = [NSMutableArray array];
    [monthArray addObject:firstDate];
    for (int w = 1; w <= count; w++) {
        [monthArray addObject:monthArray.lastObject.nextMonth];
    }
    return monthArray.copy;
}

//获取当前日期前后N年各个月 - 公历
- (NSArray<NSDate *> *)monthDateArrayWithYearCount:(NSInteger)count {
    NSDate *date = self;
    NSInteger minYear = date.year - count;
    NSInteger maxYear = date.year + count;
    NSMutableArray<NSDate *> *dateArray = [NSMutableArray array];
    for (NSInteger y = minYear; y <= maxYear; y++) {
        [dateArray addObjectsFromArray:[NSDate monthDateArrayInYear:y]];
    }
    return dateArray.copy;
}

//获取当前日期前后N年各个月 - 公历
+ (NSArray<NSDate *> *)monthDateArrayWithStartYear:(NSInteger)startYear
                                           endYear:(NSInteger)endYear{
    NSMutableArray<NSDate *> *dateArray = [NSMutableArray array];
    for (NSInteger y = startYear; y <= endYear; y++) {
        [dateArray addObjectsFromArray:[NSDate monthDateArrayInYear:y]];
    }
    return dateArray.copy;
}

//获取当前日期前后N个月 - 公历
- (NSArray<NSDate *> *)monthDateArrayWithCount:(NSInteger)count {
    NSDate *firstDate = [self firstDayInThisMonth];
    NSMutableArray<NSDate *> *monthArray = [NSMutableArray array];
    [monthArray addObject:firstDate];
    for (int w = 1; w < count; w++) {
        [monthArray insertObject:monthArray.firstObject.lastMonth atIndex:0];
        [monthArray addObject:monthArray.lastObject.nextMonth];
    }
    return monthArray.copy;
}

//获取当前日期前后N个星期 - 公历
- (NSArray<NSDate *> *)weekDateArrayWithCount:(NSInteger)count {
    NSDate *firstDate = [self firstDayInThisWeek];
    NSMutableArray<NSDate *> *weekArray = [NSMutableArray array];
    [weekArray addObject:firstDate];
    for (int w = 1; w < count; w++) {
        [weekArray insertObject:weekArray.firstObject.lastWeek atIndex:0];
        [weekArray addObject:weekArray.lastObject.nextWeek];
    }
    return weekArray.copy;
}

//获取当前日期前后N个星期 - 公历
- (NSArray<NSDate *> *)weekDateRangeArrayWithCount:(NSInteger)count {
    NSDate *firstDate = [self firstDayInThisWeek];
    NSMutableArray<NSDate *> *weekArray = [NSMutableArray array];
    [weekArray addObject:firstDate];
    for (int w = 1; w < count; w++) {
        [weekArray insertObject:weekArray.firstObject.lastWeek atIndex:0];
        [weekArray addObject:weekArray.lastObject.nextWeek.lastDayInThisWeek];
    }
    return weekArray.copy;
}

//获取当前日期前后N天 - 公历
- (NSArray<NSDate *> *)dayDateArrayWithCount:(NSInteger)count {
    NSMutableArray<NSDate *> *dayArray = [NSMutableArray array];
    [dayArray addObject:self];
    for (int d = 1; d < count; d++) {
        [dayArray insertObject:dayArray.firstObject.lastDay atIndex:0];
        [dayArray addObject:dayArray.lastObject.nextDay];
    }
    return dayArray.copy;
}

//获取一年还剩下的各天 - 公历
+ (NSArray<NSDate *> *)remainDayDateArrayInYear:(NSInteger)year {
    NSMutableArray<NSDate *> *dayArray = [NSMutableArray array];
    NSDate *date = [NSDate dateWithString:@(year).stringValue dateFormat:@"yyyy"];
    NSDate *today = [NSDate date].midnight;
    while ([today dateLessThan:date.nextYear.lastDay]) {
        [dayArray addObject:today];
        today = today.nextDay;
    }
    return dayArray.copy;
}

//获取星期几标题数组
+ (NSArray<NSString *> *)weekDayTitleArray {
    NSArray *titleArray = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六",];
    NSInteger firstWeekDay = DRCalendarFirstDay - 1;
    NSMutableArray *restltArray = [NSMutableArray array];
    for (NSInteger i = firstWeekDay; i < titleArray.count; i++) {
        [restltArray addObject:titleArray[i]];
    }
    NSInteger count = titleArray.count - restltArray.count;
    for (NSInteger i = 0; i < count; i++) {
        [restltArray addObject:titleArray[i]];
    }
    return restltArray;
}

/**
 更改date的小时分钟，并将秒置0
 
 @param hour 小时
 @param minute 分钟
 @return 设置小十分钟后的date
 */
- (NSDate *)resetHour:(NSInteger)hour minute:(NSInteger)minute {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmp = [calendar components:[NSDate dateComponentsUnitsWithType:DRCalenderUnitsTypeMinte] fromDate:self];
    cmp.hour = hour;
    cmp.minute = minute;
    return [calendar dateFromComponents:cmp];
}

/**
 获取日期时间字段组合
 
 @return 日期时间字段组合
 */
+ (NSInteger)dateComponentsUnitsWithType:(DRCalenderUnitsType)type {
    switch (type) {
        case DRCalenderUnitsTypeYear:
            return NSCalendarUnitYear;
            
        case DRCalenderUnitsTypeMonth:
            return NSCalendarUnitYear | NSCalendarUnitMonth;
            
        case DRCalenderUnitsTypeDay:
            return NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
            
        case DRCalenderUnitsTypeHour:
            return NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour;
            
        case DRCalenderUnitsTypeMinte:
            return NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
            
        case DRCalenderUnitsTypeSecend:
            return NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            
        default:
            break;
    }
}

/**
 拼接上另一个日期的小时分钟
 
 @param date 提供小时分钟的date
 @return 新的date
 */
- (NSDate *)resetHourMinuteWithDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayCmp = [calendar components:[NSDate dateComponentsUnitsWithType:DRCalenderUnitsTypeDay] fromDate:self];
    NSDateComponents *timeCmp = [calendar components:[NSDate dateComponentsUnitsWithType:DRCalenderUnitsTypeMinte] fromDate:date];
    dayCmp.hour = timeCmp.hour;
    dayCmp.minute = timeCmp.minute;
    return [calendar dateFromComponents:dayCmp];
}

@end

