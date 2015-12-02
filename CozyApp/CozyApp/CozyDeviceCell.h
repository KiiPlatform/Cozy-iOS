//
//  CozyDeviceCell.h
//  CozyApp
//
//  Created by Evan JIANG on 15/12/1.
//  Copyright © 2015年 Kii Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CozyObjC/Cozy.h"

@interface CozyDeviceCell : UITableViewCell

@property (weak, nonatomic) CozyDevice  *device;

@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@end
