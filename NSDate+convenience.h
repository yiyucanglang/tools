//
//  NSDate+convenience.h
//
//  Created by in 't Veen Tjeerd on 4/23/12.
//  Copyright (c) 2012 Vurig Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Convenience)



- (NSDate *)offsetMonth:(int)numMonths;
- (NSDate *)offsetDay:(int)numDays;
- (NSDate *)offsetHours:(int)hours;
- (NSInteger)numDaysInMonth;
- (NSInteger)firstWeekDayInMonth;
- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;

- (NSDate *)firstDayOfMonth;
- (NSDate *)endDayOfMonth;

- (NSDate *)dateStartOfWeek;
- (NSDate *)dateEndOfWeek;

+(NSDate *)dateStartOfDay:(NSDate *)date;

@end
