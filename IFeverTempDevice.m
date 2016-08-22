//
//  IFeverTempDevice.m
//  NewMom
//
//  Created by Junze on 16/8/18.
//  Copyright © 2016年 peter. All rights reserved.
//

#import "IFeverTempDevice.h"
#import "ZYJNSTimer.h"

@interface IFeverTempDevice()
{
    long long _timerCounter;
}
@property (nonatomic, strong) NSTimer *countTimer;
@property (nonatomic, strong) NSMutableArray *scanedDeviceArray;
@property (nonatomic, strong) ZYJNSTimer *scanTimer;
@end
@implementation IFeverTempDevice

#pragma mark - init

- (void)initBlueToothDevice
{
    self.blueManage = [JLBleManager shareInstance];
    self.blueManage.delegate = self;
    [self addObserver:self forKeyPath:@"currentStatus" options:NSKeyValueObservingOptionNew context:nil];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initBlueToothDevice];
    }
    return self;
}



#pragma mark - public method
- (BOOL)isBlueToothOpen
{
    return [self.blueManage isBleOpen];
}

//扫描设备
-(void)scanDevice
{
    __weak typeof(self) w_self = self;
    
    [self.blueManage stopScan];
    [self.blueManage scanDevice];
    
    self.scanTimer = [ZYJNSTimer scheduledTimerWithTimeInterval:6 block:^(uint64_t count)
    {
        if (count == 4)
        {
            [w_self.blueManage stopScan];
        }
        [w_self.blueManage stopScan];
        [w_self.blueManage scanDevice];
    } repeats:YES repeatCount:4];
    
    self.currentStatus = BlueToothDeviceIsScanning;
}

//停止扫描
-(void)stopScan
{
    [self.blueManage stopScan];
}

//连接设备
-(void)connectDevice:(NSString *)deviceMac
{
    
}


//断开连接
-(void)disConnectDevice:(NSString *)deviceMac
{
    
}


//获取电量
- (void)getBattery:(NSString *)deviceMac
{
    
}


//华氏度  摄氏度
//- (void)changeTemperatureUnit:(NSString *)deviceMac withUnit:(TemUnitType)type;

#pragma mark - JLBleManagerDelegate
//连接成功回调
-(void)didConnect:(NSString *)deviceMac
{
    
}

//断开连接回调
-(void)didDisconnect:(NSString *)deviceMac
{
    
}

//普通数据回调
-(void)dispatch:(NSString *)deviceMac
    revDataInfo:(NSDictionary *)revDataInfo
       dataType:(DataType)type
{
    
}

#pragma mark - property init

- (void)timeClockEvent
{
    _timerCounter++;
}

- (NSTimer *)countTimer
{
    if (_countTimer == nil)
    {
        _countTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeClockEvent) userInfo:nil repeats:YES];
    }
    return _countTimer;
}

- (NSMutableArray *)scanedDeviceArray
{
    if (_scanedDeviceArray == nil)
    {
        _scanedDeviceArray = [[NSMutableArray alloc] init];
    }
    return _scanedDeviceArray;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"currentStatus"];
}


@end

@implementation NSTimer(Universal)

- (void)resumeTimer
{
    self.fireDate = [NSDate distantPast];
}

- (void)pauseTimer
{
    self.fireDate = [NSDate distantFuture];
}

@end




