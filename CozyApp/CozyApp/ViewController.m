//
//  ViewController.m
//  CozyApp
//
//  Created by Evan JIANG on 15/12/1.
//  Copyright © 2015年 Kii Inc. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setTitle:@"Kii Cozy"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([segue.identifier isEqualToString:@"kii_onboarding"]) {
        delegate.kiiOnboard = YES;
    } else if ([segue.identifier isEqualToString:@"onboarding"]) {
        delegate.kiiOnboard = NO;
    }
}

@end
