//
//  NSDate+DRExtension.h
//  Records
//
//  Created by admin on 2017/11/3.
//  Copyright © 2017年 DR. All rights reserved.


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DRCalenderUnitsType) {
    DRCalenderUnitsTypeYear,    // 取年
    DRCalenderUnitsTypeMonth,   // 取年月
    DRCalenderUnitsTypeDay,     // 取年月日
    DRCalenderUnitsTypeHour,    // 取年月日小时
    DRCalenderUnitsTypeMinte,   // 取年月日小时分钟
    DRCalenderUnitsTypeSecend   // 取年月日小时分钟秒
};

@interface NSDate (DRExtension)
#pragma mark - 时间转化
+ (NSString *)stringFromeDate:(NSDate *)date formatterString:(NSString *)formatterStr;
+ (NSString *)stringFromeDate:(NSDate *)date; // yyyy-MM-dd HH:mm:ss  格林威治时间转北京时间
+ (NSString *)timeIntervalFromeTimeString:(NSString *)timeString; // 根据时间字符串返回时间戳
/**
 根据字符串返回 NSDate对象
 @param dateString yyyy-MM-dd HH:mm:ss / yyyy-MM-dd HH:mm / 时间戳 仅这三种格式
 @return NSDate
 */
+ (NSDate *)dateFromeDateString:(NSString *)dateString;
#pragma mark - 日期格式化
-(NSDate *)dateFormaterWithFormatterString:(NSString *)formatterStr;
#pragma mark -获取之前N天的日期
-(NSDate *)getRecentlyDateWithDay:(NSInteger)day;
-(NSDate *)dateFormaterRemoverSecond;
-(NSDate *)getDateWithNextWeek:(NSString *)week;
-(NSDate *)dateFormaterWtihFormaterSting:(NSString *)formatterStr;

#pragma mark -字符串转日期
+ (NSDate *)dateWithDateString:(NSString *)string dateFormat:(NSString *)dateFormat;

#pragma mark -返回当前时间指定点
-(NSDate *)getAppointDateWithHour:(NSInteger)hour;

#pragma mark -字符串转日期
+(NSDate *)getDateWithString:(NSString *)string;
+(NSDate *)getSecondDateWithString:(NSString *)string;
#pragma mark -后移7天
-(NSDate *)getDate7Day;
#pragma mark -返回当前周是时间
+(NSArray *)getWeekDays;
#pragma mark -时间戳转化为时间
+(NSDate *)dateWithTimeIntervalInt:(int64_t )timeInt;
#pragma mark -当前时间后几个分钟
+(NSDate *)getBehindOneMinuteWithMinute:(NSInteger)minute;
#pragma mark -当前时间后半个小时时间搓
+ (NSInteger)getBehindCurrentTimeHalfAnHourTimeInterval;
#pragma mark -当前时间后一天
+(NSDate *)getBehindOneDayWithDate:(NSDate *)date;
-(NSDate *)getFrontOneDay;
#pragma mark -当前时间后一天,去除时分秒
-(NSDate *)getBehindOneDay;
#pragma mark -当前时间前一分
-(NSDate *)getFrontMinte;
#pragma mark -返回当天的指定时间
+(NSDate *)returnDayCurrentDateWithString:(NSString *)string;
#pragma mark - 日期格式化
-(NSString *)dateWithFormatterString:(NSString *)formatterStr;
#pragma mark -获取当前时间
+(NSString *)getCurrentDate;//YYYY年MM月dd日
#pragma mark - 获取当前年
+(NSString *)getCurrentYearString;
#pragma mark -获取当前日期
+(NSString *)getDateStringWithDate:(NSDate *)date;
+(NSString *)getHourAndMinuteStringWithDate:(NSDate *)date;
#pragma mark -获取HHMM格式
- (NSString *)getHHMM;
#pragma mark -获取当前星期几
+(NSString *)getCurrentWeekDay;
#pragma mark -获取星期几
+ (NSString*)getWeekDayWithDate:(NSDate *)date;
- (NSInteger)getWeekDay;//返回NSInteger
+ (NSString*)getWeekWithDate:(NSDate *)dat;
#pragma mark -获取之前的7天
+(NSArray *)getRecently7Day;
#pragma mark -返回一天的小时
+(NSArray *)getDaytimes;
#pragma mark -返回一小时的分
+(NSArray *)getHourtimes;
#pragma mark -返回距离当前时间的间隔
+(NSString *)returnIntervalWithCurentDate:(NSString *)time;
#pragma mark -距离当前时间间隔
-(NSString *)differenceCurrentDateString;
-(NSString *)differenceCurrentDateCalendarUnitWithDate:(NSDate *)date;
-(NSString *)differenceCurrentDate;
#pragma mark - 距离当前时间
- (NSString *)countDownToCurrentDate;
#pragma mark -对比时间差
-(NSDateComponents *)differenceTimeToDate:(NSDate *)toDate;
#pragma mark -当前时间前几个分钟
-(NSDate *)getFontDateWithMinute:(NSInteger)minute;

#pragma mark -日期比较
+ (NSInteger)compareDate:(NSDate*)aDate withDate:(NSDate*)bDate;
- (NSInteger)compareDateWithDate:(NSDate*)date formatter:(NSString *)formater;
+ (NSInteger)getHourWithStart:(NSDate *)start withEnd:(NSDate *)end;

#pragma mark -获取分钟
- (NSInteger )getDatemm;
#pragma mark -获取小时
- (NSInteger )getDateHH;

#pragma mark -当前日期是否在本周中
-(BOOL)isInCurrentWeek;
#pragma mark-当前日期
-(BOOL)isSameDay;
#pragma mark -下午7点到12点
+(BOOL)is7to12PM;
#pragma mark -下午22点到凌晨2点
+ (BOOL)is22PMto2AM;
#pragma mark -早上5点到9点
+ (BOOL)is5to9AM;

+(NSArray *)getRecentlyOneYear;
#pragma mark -获取一天小时
+(NSArray *)get24HourWithDate:(NSDate *)date;

#pragma mark -返回时间戳
-(NSString *)returnTimeStamp;
#pragma mark -时间戳返回date
+(NSDate *)dateWithTimeStamp:(NSString *)interval;

+(NSString *)getCurrentDateYMd;
+(NSString *)getCurrentDateYM;
+(NSString *)timeWithTimeIntervalInt:(int64_t )timeInt formatterString:(NSString *)formatterStr;
//+(NSDate *)getYMDDateWithTimeIntervalInt:(int64_t )timeInt;
+(NSString *)returnMonthStringWithDate:(NSDate *)date;
//当天最晚23:59:59
- (NSDate *)lastTime;
//返回时间戳
-(NSString *)timeInterval;

#pragma mark -返回前3秒
-(NSDate *)getFront3S;

/*
 返回对应的时间戳
 单位为毫秒
 string格式为:yyyy-MM-dd HH:mm:ss
 */
+ (int64_t)timestampWithYYYYMMDDHHMMSS:(NSString *)string;

/*
 返回年月日时分数字格式
 如 201809100810
 */
- (int64_t)yyyyMMddHHmm;

/*
 返回年月日时分秒数字格式
 如 20180910081000
 */
- (int64_t)yyyyMMddHHmmss;

/*
 返回年月日数字格式
 如 20180910
 */
- (NSInteger)yyyyMMddNumber;

/*
 返回年月日时数字格式
 如 2018091006
 */
- (int64_t)yyyyMMddHHNumber;

/*
 获取年月日时分的时间戳
 */
- (int64_t)yyyyMMddHHMMTimestamp;

@end


#pragma mark - 基于日历扩展
//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
static const NSInteger DRCalendarFirstDay = 2;
@interface NSDate (DRCalendar)

//日期相等
- (BOOL)dateEqualTo:(NSDate *)date;
//大于传参日期
- (BOOL)dateGreaterThan:(NSDate *)date;
//大于等于传参日期
- (BOOL)dateGreaterThanOrEqualTo:(NSDate *)date;
//小于传参日期
- (BOOL)dateLessThan:(NSDate *)date;
//小于等于传参日期
- (BOOL)dateLessThanOrEqualTo:(NSDate *)date;

//NSDate转字符串
- (NSString *)dateStringFromFormatterString:(NSString *)string;

//字符串转NSDate
+ (NSDate *)dateWithString:(NSString *)string;
+ (NSDate *)dateWithString:(NSString *)string dateFormat:(NSString *)dateFormat;

//时间戳转字符串
+ (NSString *)dateWithTimeInterval:(NSTimeInterval)timeInterval dateFormat:(NSString *)dateFormat;

@end


#pragma mark - 农历扩展
@interface NSDate (DRLunarCalendar)

//是否同一月
- (BOOL)isEqualLunarMonthToDate:(NSDate *)date;

//日 - 农历
- (NSString *)lunarDay;
//日 - 农历,日历展示
- (NSString *)lunarDayForCalendar;
//星期几
- (NSInteger)lunarWeekday;
//月 - 农历
- (NSString *)lunarMonth;
//年 - 农历
- (NSString *)lunarYear;
// 2019年
- (NSString *)lunarYearNumber;

// 农历 月 数字
- (NSString *)lunarMonthNumber;

//月 - 农历
- (NSString *)lunarNormalMonth;
// 农历 日 数字
- (NSString *)lunarDayNumber;

//大于等于闰月
- (BOOL)greaterThanOrEqualToLeapMonth;
// 是否是闰年
- (BOOL)isLeapMonth;

//当年第一天Date
- (NSDate *)firstLunarDayInThisYear;

//上个月Date
- (NSDate *)lastLunarMonth;
//下个月Date
- (NSDate *)nextLunarMonth;

//当周每天Date数组
- (NSArray<NSDate *> *)lunarDayDateArrayInWeek;
//当月每天Date数组
- (NSArray<NSDate *> *)lunarDayDateArrayInCurrentMonth;
//当月每天Date数组（上月几天+本月+下月几天）
- (NSArray<NSDate *> *)lunarDayDateArrayInMonth;

//获取某一年农历月份
+ (NSArray<NSDate *> *)lunarMonthDateArrayInYear:(NSInteger)year;
//获取当前日期前后N个月 - 农历
- (NSArray<NSDate *> *)lunarMonthDateArrayWithCount:(NSInteger)count;

//公历转农历
- (void)solarToLunarWithComplelte:(void (^)(NSInteger year, NSInteger month, NSInteger , BOOL leapMonth))complete;

//农历转公历
- (NSDate *)lunarToSolarWithLeap:(BOOL)isLeap;
@end


#pragma mark - 公历扩展
@interface NSDate (DRSolarCalendar)

//时间戳 从1970年开始
- (int64_t)timestamp;

//是否今天
- (BOOL)isToday;
//是否今个星期
- (BOOL)isThisWeek;
//是否今个月
- (BOOL)isThisMonth;
//是否今年
- (BOOL)isThisYear;

//是否同一时间段 HH:MM
- (BOOL)isEqualTimeToDate:(NSDate *)date;
//是否同一小时
- (BOOL)isEqualHourToDate:(NSDate *)date;
//是否同一天
- (BOOL)isEqualDayToDate:(NSDate *)date;
//是否同一星期
- (BOOL)isEqualWeekToDate:(NSDate *)date;
//是否同一月
- (BOOL)isEqualMonthToDate:(NSDate *)date;
//是否同一年
- (BOOL)isEqualYearToDate:(NSDate *)date;

//相差多少天
- (NSInteger)numberOfDaysDifferenceWithDate:(NSDate *)date;
//相差多少周
- (NSInteger)numberOfWeeksDifferenceWithDate:(NSDate *)date;
//相差多少月
- (NSInteger)numberOfMonthsDifferenceWithDate:(NSDate *)date;
//相差多少年
- (NSInteger)numberOfYearsDifferenceWithDate:(NSDate *)date;

//秒
- (NSInteger)second;
//分钟
- (NSInteger)minute;
//小时
- (NSInteger)hour;
//日
- (NSInteger)day;
//星期几
- (NSInteger)weekday;
//中国式星期几
- (NSInteger)chinaWeekday;
//星期几 - 中文
- (NSString *)weekdayString;
//第几星期 - 月份
- (NSInteger)weekOfMonth;
//第几星期 - 年
- (NSInteger)weekOfYear;
//月
- (NSInteger)month;
//月 - 中文
- (NSString *)monthString;
//月 - 数字加月， 如 “10月”
- (NSString *)solarMonthString;
//年
- (NSInteger)year;
//年-月-日(yyyy-mm-dd)
- (NSString *)YYYYMMDD;
//年-月(yyyy-mm)
- (NSString *)YYYYMM;
//当月的第一天是周几
- (NSInteger)firstWeekdayInThisMonth;
//当月有几天
- (NSInteger)totalDaysInMonth;
//当年有几天
- (NSInteger)totalDaysInYear;
//当月有多少个星期
- (NSInteger)totalWeeksInMonth;
//当年有多少个星期
- (NSInteger)totalWeeksInYear;
//当周第一天Date
- (NSDate *)firstDayInThisWeek;
//当周最后一条天Date
- (NSDate *)lastDayInThisWeek;
//当月第一天Date
- (NSDate *)firstDayInThisMonth;
//当月第一天的凌晨
- (NSDate *)firstDateInThisMonth;
//当月最后一天Date
- (NSDate *)lastDayInThisMonth;
//当月最后一天23:59：59
- (NSDate *)lastDateInThisMonth;
//当年第一天
- (NSDate *)firstDayInThisYear;
//当年最后一天
- (NSDate *)lastDayInThisYear;
//下一年最后一天
- (NSDate *)nextYearLastDay;
+ (NSDate *)nextYearLastDay;
+ (NSDate *)minDate;

//之前一天
- (NSDate *)lastDay;
//之后一天
- (NSDate *)nextDay;
//之前N天
- (NSDate *)lastDayWithCount:(NSInteger)count;
//之后N天
- (NSDate *)nextDayWithCount:(NSInteger)count;
//上星期
- (NSDate *)lastWeek;
//下个星期
- (NSDate *)nextWeek;
//下N个星期
- (NSDate *)nextWeekWithCount:(NSInteger)count;
//获取指定当月指定星期
- (NSDate *)weekInThisMonthWithCount:(NSInteger)count;
//上个月
- (NSDate *)lastMonth;
//下个月
- (NSDate *)nextMonth;
//下N个月
- (NSDate *)nextMonthWithCount:(NSInteger)count;
// 上一年
- (NSDate *)lastYear;
// 之前N年
- (NSDate *)lastYearWithCount:(NSInteger)count;
// 下一年
- (NSDate *)nextYear;
// 之后N年
- (NSDate *)nextYearWithCount:(NSInteger)count;
//加N个小时
- (NSDate *)nextHour:(CGFloat)n;
//凌晨十二点
- (NSDate *)midnight;
//当天23:59:59
- (NSDate *)endOfDate;
//时间调到对应时间，XX:00 或 XX:30
- (NSDate *)correctionTime;
//设置时间 年
- (NSDate *)correctionYear:(NSInteger)year;
//设置时间 月
- (NSDate *)correctionMonth:(NSInteger)month;
//设置时间 日
- (NSDate *)correctionDay:(NSInteger)day;
//设置时间 年月日时分秒
+ (NSDate *)correctionYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;

//当月每天Date数组（上月几天+本月+下月几天）
- (NSArray<NSDate *> *)dayDateArrayInMonth;
//当月每天Date数组
- (NSArray<NSDate *> *)dayDateArrayInCurrentMonth;
//当周每天Date数组
- (NSArray<NSDate *> *)dayDateArrayInWeek;
//当月每天Date数组 - 六周（上月几天+本月+下月几天）
- (NSArray<NSDate *> *)dayDateArrayInMonthWithSixWeek;

//获取今年各月份 - 公历
+ (NSArray<NSDate *> *)monthDateArrayInThisYear;
//获取某一年各天 - 公历
+ (NSArray<NSDate *> *)dayDateArrayInYear:(NSInteger)year;
//获取一年还剩下的各天 - 公历
+ (NSArray<NSDate *> *)remainDayDateArrayInYear:(NSInteger)year ;
//获取某一年各月份 - 公历
+ (NSArray<NSDate *> *)monthDateArrayInYear:(NSInteger)year;
//获取当前日期前后N年各个月 - 公历
- (NSArray<NSDate *> *)monthDateArrayWithYearCount:(NSInteger)count;
//获取当前日期前后N个月 - 公历
- (NSArray<NSDate *> *)monthDateArrayWithCount:(NSInteger)coun;
//获取当前日期前后N个星期 - 公历
- (NSArray<NSDate *> *)weekDateArrayWithCount:(NSInteger)count;
//获取当前日期前后N个星期 - 公历, 当前时间前以第一天， 当前时间后以周最后一天
- (NSArray<NSDate *> *)weekDateRangeArrayWithCount:(NSInteger)count;
//获取当前日期前后N天 - 公历
- (NSArray<NSDate *> *)dayDateArrayWithCount:(NSInteger)count;
//获取某一日期之后(含该月份)的N个月 - 公历
- (NSArray<NSDate *> *)monthDateArrayNextWithCount:(NSInteger)count;

//获取星期几标题数组
+ (NSArray<NSString *> *)weekDayTitleArray;

+ (NSArray<NSDate *> *)monthDateArrayWithStartYear:(NSInteger)startYear
                                           endYear:(NSInteger)endYear;

/**
 更改date的小时分钟，并将秒置0

 @param hour 小时
 @param minute 分钟
 @return 设置小十分钟后的date
 */
- (NSDate *)resetHour:(NSInteger)hour minute:(NSInteger)minute;

/**
 获取日期时间字段组合

 @return 日期时间字段组合
 */
+ (NSInteger)dateComponentsUnitsWithType:(DRCalenderUnitsType)type;

/**
 拼接上另一个日期的小时分钟
 
 @param date 提供小时分钟的date
 @return 新的date
 */
- (NSDate *)resetHourMinuteWithDate:(NSDate *)date;

@end
