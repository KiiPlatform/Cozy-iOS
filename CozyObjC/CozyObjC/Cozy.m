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
    return self.peripheral.name;
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

@interface Cozy() <CBCentralManagerDelegate>

@property (nonatomic, strong) CBCentralManager *central;


@end

@implementation Cozy

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.central = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return self;
}



- (void)scanForCozyDevices
{
    [self.central scanForPeripheralsWithServices:@[COZY_CONFIG_SERVICE_UUID] options:nil];
}

- (void)connectTo:(CozyDevice *)device
{
    
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(nonnull CBPeripheral *)peripheral advertisementData:(nonnull NSDictionary<NSString *,id> *)advertisementData RSSI:(nonnull NSNumber *)RSSI
{
    
}


@end
