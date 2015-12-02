//
//  CozyObjC.m
//  CozyObjC
//
//  Created by Evan JIANG on 15/12/1.
//  Copyright © 2015年 Kii Inc. All rights reserved.
//

#import "Cozy.h"

@implementation CozyDevice

- (NSString*)name
{
    if (self.peripheral.name)
        return self.peripheral.name;
    return self.UUID;
}

- (NSString*)UUID
{
    return [self.peripheral.identifier UUIDString];
}

-(BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[CozyDevice class]]) {
        return NO;
    }
    CozyDevice *other = object;
    return [self.peripheral.identifier isEqual:other.peripheral.identifier];
}

@end

@interface Cozy() <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) CBCentralManager *central;
@property (nonatomic)   BOOL scanning;
@property (nonatomic, strong) NSMutableDictionary *deviceMap;

@end

@implementation Cozy

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.central = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        self.deviceMap = [NSMutableDictionary dictionary];
    }
    return self;
}

- (instancetype)initWithSSID:(NSString*)SSID BSSID:(NSString*)BSSID andPassword:(NSString*)password
{
    self = [self init];
    self.SSID = SSID;
    self.BSSID = BSSID;
    self.password = password;
    return self;
}

- (void)scanForCozyDevices
{
    self.scanning = YES;
    [self.central scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:COZY_CONFIG_SERVICE_UUID]] options:nil];
}

- (void)stopScan
{
    [self.central stopScan];
}

- (void)connectTo:(CozyDevice *)device
{
    [self.deviceMap setObject:device forKey:device.peripheral.identifier];
    [self.central connectPeripheral:device.peripheral options:nil];
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn
        && self.scanning) {
        [self scanForCozyDevices];
    }
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(nonnull CBPeripheral *)peripheral advertisementData:(nonnull NSDictionary<NSString *,id> *)advertisementData RSSI:(nonnull NSNumber *)RSSI
{
    
    for (CBService *service in peripheral.services)
    {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:COZY_CONFIG_SERVICE_UUID]])
        {
            NSLog(@"Service found with UUID: %@", service.UUID);
            [peripheral discoverCharacteristics:nil forService:service];
            break;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(didDiscoverDevice:)]) {
        CozyDevice *device = [CozyDevice new];
        device.peripheral = peripheral;
        [self.delegate didDiscoverDevice:device];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    
    NSLog(@"Did connect to peripheral: %@", peripheral);
    peripheral.delegate = self;
    [peripheral discoverServices:@[[CBUUID UUIDWithString:COZY_CONFIG_SERVICE_UUID]]];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"didDiscoverServices");
    
    if (error)
    {
        NSLog(@"Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
        CozyDevice *device = [self.deviceMap objectForKey:peripheral.identifier];
        if ([self.delegate respondsToSelector:@selector(connectFailed:error:)])
            [self.delegate connectFailed:device error:error];
        return;
    }
    
    
    for (CBService *service in peripheral.services)
    {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:COZY_CONFIG_SERVICE_UUID]])
        {
            NSLog(@"Service found with UUID: %@", service.UUID);
            [peripheral discoverCharacteristics:nil forService:service];
            break;
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
    if (error)
    {
        NSLog(@"Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
        
        CozyDevice *device = [self.deviceMap objectForKey:peripheral.identifier];
        if ([self.delegate respondsToSelector:@selector(connectFailed:error:)])
            [self.delegate connectFailed:device error:error];
        return;
    }
    
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:COZY_CONFIG_CHARACTERISTIC_UUID]]) {
            NSLog(@"didDiscoverCharacteristicsForService:%@",characteristic);
            [peripheral readValueForCharacteristic:characteristic];
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            NSDictionary *dict = @{@"SSID":self.SSID,
                                   @"BSSID":self.BSSID?self.BSSID:@"",
                                   @"password":self.password};
            NSError *jsonError;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                               options:0
                                                                 error:&jsonError];
            [peripheral writeValue:jsonData forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
    }
    
    // Notification has started
    if (characteristic.isNotifying) {
        NSLog(@"Notification began on %@", characteristic);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        NSLog(@"Error updating value for characteristic %@ error: %@", characteristic.UUID, [error localizedDescription]);
        CozyDevice *device = [self.deviceMap objectForKey:peripheral.identifier];
        if ([self.delegate respondsToSelector:@selector(connectFailed:error:)])
            [self.delegate connectFailed:device error:error];
        return;
    }
    
    NSString *str = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    NSLog(@"Got %@",str);
    
    NSError *jsonError;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:characteristic.value
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    NSLog(@"Received：%@",json);
    CozyDevice *device = [self.deviceMap objectForKey:peripheral.identifier];
    if ([json[@"result"] boolValue]) {
        if ([self.delegate respondsToSelector:@selector(didConnectToDevice:result:)])
            [self.delegate didConnectToDevice:device result:json];
    } else {
        NSError *err = [NSError errorWithDomain:@"Cozy" code:1 userInfo:json];
        if ([self.delegate respondsToSelector:@selector(connectFailed:error:)])
            [self.delegate connectFailed:device error:err];
    }
}

@end
