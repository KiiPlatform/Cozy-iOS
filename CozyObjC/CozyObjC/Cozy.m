//
//  CozyObjC.m
//  CozyObjC
//
//  Created by Evan JIANG on 15/12/1.
//  Copyright © 2015年 Kii Inc. All rights reserved.
//

#import "Cozy.h"

@implementation CozyDevice


@end

@interface Cozy()

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


@end
