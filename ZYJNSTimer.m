//
//  ZYJNSTimer.m
//  MSWeakTimer-SampleProject
//
//  Created by Junze on 16/8/19.
//  Copyright © 2016年 MindSnacks. All rights reserved.
//

#import "ZYJNSTimer.h"
#import <libkern/OSAtomic.h>
@interface ZYJNSTimer()

@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, strong) id userInfo;
@property (nonatomic, assign) BOOL repeats;
@property (nonatomic, assign) NSUInteger repeatCount;
@property (nonatomic, strong) dispatch_queue_t privateSerialQueue;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) BOOL isInalidate;
@property (nonatomic, strong) dispatch_semaphore_t semphore;
@property (nonatomic, assign) uint64_t counter;
@property (nonatomic, assign) BOOL isSuspend;
@end

@implementation ZYJNSTimer

- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats
{
    ZYJNSTimer *timer = [self initWithTimeInterval:timeInterval target:target selector:selector userInfo:userInfo repeats:repeats repeatCount:0 dispatchQueue:dispatch_get_main_queue()];
    
    return timer;
}

- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats repeatCount:(NSUInteger)repeatCount
{
    ZYJNSTimer *timer = [self initWithTimeInterval:timeInterval target:target selector:selector userInfo:userInfo repeats:repeats repeatCount:repeatCount dispatchQueue:dispatch_get_main_queue()];
    
    return timer;
}

- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats repeatCount:(NSUInteger)repeatCount dispatchQueue:(dispatch_queue_t)queue
{
    if ((self = [super init]))
    {
        self.timeInterval = timeInterval;
        self.target = target;
        self.selector = selector;
        self.userInfo = [userInfo copy];
        self.repeats = repeats;
        self.repeatCount = repeatCount;
        NSString *privateQueueName = [NSString stringWithFormat:@"com.damowang.timer.%p", self];
        self.privateSerialQueue = dispatch_queue_create([privateQueueName cStringUsingEncoding:NSASCIIStringEncoding], DISPATCH_QUEUE_SERIAL);
        
        dispatch_set_target_queue(self.privateSerialQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
        
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                                0,
                                                0,
                                                self.privateSerialQueue);
       
        
    }
    
    return self;
}

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats
{
    ZYJNSTimer *timer = [[ZYJNSTimer alloc] initWithTimeInterval:timeInterval target:target selector:selector userInfo:userInfo repeats:repeats repeatCount:0 dispatchQueue:dispatch_get_main_queue()];
    
    [timer schedule];
    
    return timer;
}

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats repeatCount:(NSUInteger)repeatCount
{
    ZYJNSTimer *timer = [[ZYJNSTimer alloc] initWithTimeInterval:timeInterval target:target selector:selector userInfo:userInfo repeats:repeats repeatCount:repeatCount dispatchQueue:dispatch_get_main_queue()];
    
    [timer schedule];
    
    return timer;
}

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats repeatCount:(NSUInteger)repeatCount dispatchQueue:(dispatch_queue_t)queue
{
    ZYJNSTimer *timer = [[ZYJNSTimer alloc] initWithTimeInterval:timeInterval target:target selector:selector userInfo:userInfo repeats:repeats repeatCount:repeatCount dispatchQueue:queue];
    
    [timer schedule];
    
    return timer;

}

- (void)configTimer
{
    dispatch_source_set_timer(self.timer,
                              dispatch_time(DISPATCH_TIME_NOW, self.timeInterval * NSEC_PER_SEC),
                              self.timeInterval * NSEC_PER_SEC,
                              0.1*NSEC_PER_SEC);
}

- (void)schedule
{
    [self configTimer];
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.timer, ^{
        [weakSelf timerFired];
    });
    dispatch_resume(self.timer);
}

- (void)fire
{
    [self timerFired];
}

- (void)timerFired
{
    if (self.isInalidate)
    {
        return;
    }
    
    // we don't need worry about this warning because the selector we call'ing doesn't return a+1 object
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.target performSelector:self.selector withObject:self];
#pragma clang diagnostic pop
    
    if (!self.repeats)
    {
        [self invalidate];
    }
}

- (void)invalidate
{
    if (!self.isInalidate)
    {
        self.repeatCount = 0;
        self.counter = 0;
        self.isInalidate = YES;
        if (self.timer)
        {
            dispatch_async(self.privateSerialQueue, ^{
                dispatch_source_cancel(self.timer);
                self.timer = nil;
            });
  
        }
    }
}

// init property

- (void)setIsInalidate:(BOOL)isInalidate
{
    dispatch_semaphore_wait(self.semphore, DISPATCH_TIME_FOREVER);
    _isInalidate = isInalidate;
    dispatch_semaphore_signal(self.semphore);
}

- (dispatch_semaphore_t)semphore
{
    if (_semphore == nil)
    {
        _semphore = dispatch_semaphore_create(1);
    }
    return _semphore;
}

- (void)dealloc
{
    [self invalidate];
    NSLog(@"%@dealloc",self.timerName);
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ %p> \n time_interval=%f \n target=%@ \n selector=%@ userInfo=%@ \n repeats=%@ repeatCount=%@ \n timer=%@",
            NSStringFromClass([self class]),
            self,
            self.timeInterval,
            self.target,
            NSStringFromSelector(self.selector),
            self.userInfo,
            @(self.repeats),
            @(self.repeatCount),
            self.timer];
}

@end

@implementation ZYJNSTimer (blocks)

+ (void)blockTimeFired:(ZYJNSTimer *)timer
{
    timer.counter++;
    if (timer.repeats)
    {
        if ([timer userInfo])
        {
            void (^block)() = (void (^)())[timer userInfo];
            block();
        }
        
        if (timer.repeatCount > 0)// set repeatCount
        {
            if (timer.counter >= timer.repeatCount)
            {
                [timer invalidate];
            }
        }

    }
    else
    {
        if ([timer userInfo])
        {
            void (^block)() = (void (^)())[timer userInfo];
            block();
        }
        [timer invalidate];
    }
    
}

+(instancetype)timerWithTimeInterval:(NSTimeInterval)timeInterval block:(void (^)())inBlock repeats:(BOOL)repeats repeatCount:(NSUInteger)repeatCount
{
    ZYJNSTimer *timer = [[ZYJNSTimer alloc] initWithTimeInterval:timeInterval target:self selector:@selector(blockTimeFired:) userInfo:inBlock repeats:repeats repeatCount:repeatCount];
    return timer;
}

+(instancetype)timerWithTimeInterval:(NSTimeInterval)timeInterval block:(void (^)())inBlock repeats:(BOOL)repeats
{
    ZYJNSTimer *timer = [[ZYJNSTimer alloc] initWithTimeInterval:timeInterval target:self selector:@selector(blockTimeFired:) userInfo:inBlock repeats:repeats repeatCount:0];
    return timer;
}

+(instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval block:(void (^)())inBlock repeats:(BOOL)repeats repeatCount:(NSUInteger)repeatCount
{
    ZYJNSTimer *timer = [[ZYJNSTimer alloc] initWithTimeInterval:timeInterval target:self selector:@selector(blockTimeFired:) userInfo:inBlock repeats:repeats repeatCount:repeatCount];
    [timer schedule];
    
    return timer;
}

+(instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval block:(void (^)())inBlock repeats:(BOOL)repeats
{
    ZYJNSTimer *timer = [[ZYJNSTimer alloc] initWithTimeInterval:timeInterval target:self selector:@selector(blockTimeFired:) userInfo:inBlock repeats:repeats repeatCount:0];
    [timer schedule];
    
    return timer;
}
                         
@end
