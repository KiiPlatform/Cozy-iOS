//
//  CozyDevicesViewController.h
//  CozyApp
//
//  Created by Evan JIANG on 15/12/1.
//  Copyright © 2015年 Kii Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CozyDevicesViewController : UITableViewController

@property (nonatomic, strong) NSString *SSID;
@property (nonatomic, strong) NSString *BSSID;
@property (nonatomic, strong) NSString *password;

@end
