//
//  CozyDevicesViewController.m
//  CozyApp
//
//  Created by Evan JIANG on 15/12/1.
//  Copyright © 2015年 Kii Inc. All rights reserved.
//

#import "CozyDevicesViewController.h"
#import "CozyObjC/Cozy.h"
#import "CozyDeviceCell.h"

@interface CozyDevicesViewController () <CozyDelegate>

@property (nonatomic, strong) Cozy           *cozy;
@property (nonatomic, strong) NSMutableArray *devicesArray;

@end

@implementation CozyDevicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.devicesArray = [NSMutableArray array];
    
    self.cozy = [Cozy new];
    self.cozy.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Cozy Delegate
- (void)didDiscoverDevice:(CozyDevice*)device
{
    if (![self.devicesArray containsObject:device]) {
        [self.devicesArray addObject:device];
    }
    [self.tableView reloadData];
}

- (void)didConnectToDevice:(CozyDevice *)device result:(NSString *)payload
{
    
}

- (void)connectFailed:(CozyDevice *)device error:(NSError *)error
{
    
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.devicesArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CozyDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    
    return cell;
}



@end
