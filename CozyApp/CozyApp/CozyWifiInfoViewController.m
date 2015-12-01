//
//  CozyWifiInfoViewController.m
//  CozyApp
//
//  Created by Evan JIANG on 15/12/1.
//  Copyright © 2015年 Kii Inc. All rights reserved.
//

#import "CozyWifiInfoViewController.h"
@import SystemConfiguration.CaptiveNetwork;

@interface CozyWifiInfoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *wifiNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *changeWifiButton;
@property (weak, nonatomic) IBOutlet UISwitch *storePasswordSwitch;

@property (strong, nonatomic) NSDictionary *currentSSIDInfo;

@end

@implementation CozyWifiInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.passwordField becomeFirstResponder];
    
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"prefs:root=WIFI"]]) {
        [self.changeWifiButton setHidden:YES];
    }
    
    [self updateWifiInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleActiveNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)handleActiveNotification:(id)sender
{
    [self updateWifiInfo];
}

- (void)updateWifiInfo
{
    self.currentSSIDInfo = [self fetchSSIDInfo];
    if (self.currentSSIDInfo) {
        [self.wifiNameLabel setText:self.currentSSIDInfo[@"SSID"]];
    } else {
        [self.wifiNameLabel setText:nil];
    }
}

- (id)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    NSDictionary *info;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    return info;
}



- (IBAction)clickOnChangeWifi:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
