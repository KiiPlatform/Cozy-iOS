//
//  CozyObjC.h
//  CozyObjC
//
//  Created by Evan JIANG on 15/12/1.
//  Copyright © 2015年 Kii Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreBluetooth;


#define COZY_CONFIG_SERVICE_UUID        @"E20A39F4-73F5-4BC4-A12F-17D1AD666661"
#define COZY_CONFIG_CHARACTERISTIC_UUID @"08590F7E-DB05-467E-8757-72F6F66666D4"

@interface CozyDevice : NSObject

@property (nonatomic, strong)    CBPeripheral *peripheral;
@property (nonatomic, readonly)  NSString     *name;
@property (nonatomic, readonly)  NSString     *UUID;

@end

@protocol CozyDelegate <NSObject>

- (void)didDiscoverDevice:(CozyDevice*)device;

- (void)didConnectToDevice:(CozyDevice*)device result:(NSDictionary*)payload;

- (void)connectFailed:(CozyDevice*)device error:(NSError*)error;

@end


@interface Cozy : NSObject

@property (nonatomic, weak) id<CozyDelegate> delegate;
@property (nonatomic, strong) NSString *SSID;
@property (nonatomic, strong) NSString *BSSID;
@property (nonatomic, strong) NSString *password;

- (instancetype)initWithSSID:(NSString*)SSID BSSID:(NSString*)BSSID andPassword:(NSString*)password;
- (void)scanForCozyDevices;
- (void)stopScan;
- (void)connectTo:(CozyDevice*)device;

@end
