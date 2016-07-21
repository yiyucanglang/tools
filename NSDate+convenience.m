//
//  NSDate+convenience.m
//
//  Created by in 't Veen Tjeerd on 4/23/12.
//  Copyright (c) 2012 Vurig Media. All rights reserved.
//

#import "NSDate+convenience.h"
#import <objc/runtime.h>

#define firstWeekDay  2   //范围 1-7  1 sunday 2 mon ... 7 saturday
@implementation NSDate (Convenience)


-(NSInteger)year
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitYear fromDate:self];
    return [components year];
}


-(NSInteger)month
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitMonth fromDate:self];
    return [components month];
}

-(NSInteger)day
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitDay fromDate:self];
    return [components day];
}

// 返回每月1号是所属周的第几天
-(NSInteger)firstWeekDayInMonth
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    //设置一周的第一天是哪天  sunday is  1  monday 2  ...
    //set which day is the first day in week
    [gregorian setFirstWeekday:firstWeekDay];
    
    
    //Set date to first of month
    NSDateComponents *comps = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay fromDate:self];
    [comps setDay:1];
    NSDate *newDate = [gregorian dateFromComponents:comps];

    return [gregorian ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:newDate];
}

-(NSDate *)offsetMonth:(int)numMonths
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:numMonths];
    return [gregorian dateByAddingComponents:offsetComponents
                                                   toDate:self options:0];
}

-(NSDate *)offsetHours:(int)hours
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setHour:hours];
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:self options:0];
}

-(NSDate *)offsetDay:(int)numDays
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:numDays];
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:self options:0];
}

-(NSInteger)numDaysInMonth
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSRange rng = [cal rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    NSUInteger numberOfDaysInMonth = rng.length;
    return numberOfDaysInMonth;
}


- (NSDate *)firstDayOfMonth
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                              initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
   
    NSDateComponents *comps = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay fromDate:self];
    [comps setDay:1];
    NSDate *startDate = [gregorian dateFromComponents:comps];
    
    return startDate;

}

- (NSDate *)endDayOfMonth
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                              initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay fromDate:self];
    [comps setDay:[self numDaysInMonth]];
    NSDate *endDate = [gregorian dateFromComponents:comps];
    
    return endDate;
}


//当前日期所在周的首日日期
- (NSDate *)dateStartOfWeek
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:firstWeekDay];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self];

    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    
    [componentsToSubtract setDay: - ((([components weekday] - [gregorian firstWeekday])
                                      + 7 ) % 7)];
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:self options:0];
    
    NSDateComponents *componentsStripped = [gregorian components: (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate: beginningOfWeek];
    
    beginningOfWeek = [gregorian dateFromComponents: componentsStripped];
    
    return beginningOfWeek;
}

- (NSDate *)dateEndOfWeek
{
    NSCalendar *gregorian =[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
   [gregorian setFirstWeekday:firstWeekDay];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self];
    
    
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setDay: + ((([components weekday] - [gregorian firstWeekday])
                                      + 7 ) % 7)+6];
    NSDate *endOfWeek = [gregorian dateByAddingComponents:componentsToAdd toDate:self options:0];
    
    NSDateComponents *componentsStripped = [gregorian components: (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate: endOfWeek];
    endOfWeek = [gregorian dateFromComponents: componentsStripped];
    return endOfWeek;
}

+(NSDate *)dateStartOfDay:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components =
    [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth |
                           NSCalendarUnitDay) fromDate: date];
    return [gregorian dateFromComponents:components];
}
@end
