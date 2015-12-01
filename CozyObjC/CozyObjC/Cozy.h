//
//  CozyObjC.h
//  CozyObjC
//
//  Created by Evan JIANG on 15/12/1.
//  Copyright © 2015年 Kii Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreBluetooth;

#define COZY_STATUS_NONE              0
#define COZY_STATUS_CONNECTING        1
#define COZY_STATUS_CONNECTED         2
#define COZY_STATUS_CONNECT_FAILED    3

#define COZY_CONFIG_SERVICE_UUID        @"E20A39F4-73F5-4BC4-A12F-17D1AD666661"
#define COZY_CONFIG_CHARACTERISTIC_UUID @"08590F7E-DB05-467E-8757-72F6F66666D4"

@interface CozyDevice : CBPeripheral

@property (nonatomic) int status;

@end

@protocol CozyDelegate <NSObject>

- (void)didDiscoverDevice:(NSString*)name;

- (void)didConnectToDevice:(CozyDevice*)device result:(NSString*)payload;

- (void)connectFailed:(CozyDevice*)device error:(NSError*)error;

@end


@interface Cozy : NSObject

@property (nonatomic, weak) id<CozyDelegate> delegate;
@property (nonatomic, strong) NSString *SSID;
@property (nonatomic, strong) NSString *BSSID;
@property (nonatomic, strong) NSString *password;

- (void)scanForCozyDevices;
- (void)connectTo:(CozyDevice*)device;

@end
