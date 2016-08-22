//
//  ZYJNSTimer.h
//  MSWeakTimer-SampleProject
//
//  Created by Junze on 16/8/19.
//  Copyright © 2016年 MindSnacks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYJNSTimer : NSObject
@property (nonatomic, copy) NSString *timerName;

- (instancetype)init __attribute__ ((unavailable("init方法不可用,请用initWithTimeInterval/scheduledTimerWithTimeInterval...方法")));


- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval
                              target:(id)target selector:(SEL)selector
                            userInfo:(id)userInfo
                             repeats:(BOOL)repeats;

- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval
                              target:(id)target selector:(SEL)selector
                            userInfo:(id)userInfo
                             repeats:(BOOL)repeats
                         repeatCount:(NSUInteger)repeatCount;

- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval
                              target:(id)target selector:(SEL)selector
                            userInfo:(id)userInfo
                             repeats:(BOOL)repeats
                         repeatCount:(NSUInteger)repeatCount
                       dispatchQueue:(dispatch_queue_t)queue;

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                        target:(id)target selector:(SEL)selector
                                      userInfo:(id)userInfo
                                       repeats:(BOOL)repeats;


+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                              target:(id)target selector:(SEL)selector
                            userInfo:(id)userInfo
                             repeats:(BOOL)repeats
                         repeatCount:(NSUInteger)repeatCount;

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                              target:(id)target selector:(SEL)selector
                            userInfo:(id)userInfo
                             repeats:(BOOL)repeats
                         repeatCount:(NSUInteger)repeatCount
                       dispatchQueue:(dispatch_queue_t)queue;

/**
 * Starts the timer if it hadn't been schedule yet.
 */
- (void)schedule;

/**
 * make the timer to be fired syschronously Manually at the queue which you call this method
 */
- (void)fire;

/**
 * you can this method on repeatable timers in order to stop it from running and trying to call the delegate method
 * You can call this method from any queue, it doesn't have to be the queue from where you scheduled it.
 * Since it doesn't retain the delegate, unlike a regular `NSTimer`, your `dealloc` method will actually be called
 */
- (void)invalidate;

@end

@interface ZYJNSTimer (blocks)

+(instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                        block:(void (^)())inBlock
                                      repeats:(BOOL)repeats
                                  repeatCount:(NSUInteger)repeatCount;

+(instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                        block:(void (^)())inBlock
                                      repeats:(BOOL)repeats;

+(instancetype)timerWithTimeInterval:(NSTimeInterval)timeInterval
                               block:(void (^)())inBlock
                             repeats:(BOOL)repeats;

+(instancetype)timerWithTimeInterval:(NSTimeInterval)timeInterval
                               block:(void (^)())inBlock
                             repeats:(BOOL)repeats
                         repeatCount:(NSUInteger)repeatCount;

@end
