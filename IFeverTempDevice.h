//
//  IFeverTempDevice.h
//  NewMom
//
//  Created by Junze on 16/8/18.
//  Copyright © 2016年 peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iFoSDK/JLBleManager.h>

typedef NS_ENUM(NSInteger,BlueToothDeviceStatus)
{
    BlueToothDeviceDefault,
    BlueToothDeviceIsScanning,
    BlueToothDeviceScanningSuccessful,
    BlueToothDeviceScanningFail,
    BlueToothDeviceIsConnnecting,
    BlueToothDeviceConnectingFail,
    BlueToothDeviceConnectingSuccessful,
    BlueToothDeviceDisConnectingUnexpected,
};



@protocol BlueToothDeviceDelegate <NSObject>

- (void)BlueToothDeviceStatusChanged:(BlueToothDeviceStatus)status;

@end


// 中间类
@interface IFeverTempDevice : NSObject<JLBleManagerDelegate>
@property (nonatomic, strong) JLBleManager *blueManage;
@property (nonatomic, copy) NSString *currentBlueToothName;
@property (nonatomic, assign) BlueToothDeviceStatus currentStatus;
@property (nonatomic, assign) BlueToothDeviceStatus preStatus;


-(BOOL)isBlueToothOpen;

//扫描设备
-(void)scanDevice;

//停止扫描
-(void)stopScan;

//连接设备
-(void)connectDevice:(NSString *)deviceMac;


//断开连接
-(void)disConnectDevice:(NSString *)deviceMac;


//获取电量
- (void)getBattery:(NSString *)deviceMac;


//华氏度  摄氏度
- (void)changeTemperatureUnit:(NSString *)deviceMac withUnit:(TemUnitType)type;

/*
 DFU固件升级
 **/
-(void)hardwareUpgradeWithDeviceMac:(NSString *)deviceMac;
@end

@interface NSTimer(Universal)

- (void)resumeTimer;
- (void)pauseTimer;

@end
