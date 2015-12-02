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
@property (nonatomic, strong) NSMutableSet   *connectingDevices;
@property (nonatomic, strong) NSMutableSet   *connectedDevices;

@end

@implementation CozyDevicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.devicesArray = [NSMutableArray array];
    self.connectingDevices = [NSMutableSet set];
    self.connectedDevices = [NSMutableSet set];
    
    self.cozy = [[Cozy alloc] initWithSSID:self.SSID BSSID:self.BSSID andPassword:self.password];
    self.cozy.delegate = self;
    
    [self.cozy scanForCozyDevices];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.copy stopScan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    CozyDevice *device = self.devicesArray[indexPath.row];
    cell.deviceNameLabel.text = device.name;
    if ([self.connectingDevices containsObject:device]) {
        [cell.connectButton setHidden:YES];
        [cell.progressView setHidden:NO];
        [cell.progressView startAnimating];
    } else {
        [cell.connectButton setHidden:NO];
        [cell.progressView setHidden:YES];
    }
    
    if ([self.connectedDevices containsObject:device]) {
        [cell.connectButton setBackgroundImage:[UIImage imageNamed:@"succ"] forState:UIControlStateNormal];
    } else {
        [cell.connectButton setBackgroundImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CozyDevice *device = self.devicesArray[indexPath.row];
    if ([self.connectedDevices containsObject:device])
        return;
    [self.connectingDevices addObject:device];
    [self.cozy connectTo:device];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
