//
//  BadgeDetailsViewController.h
//  Tracker_1
//
//  Created by Anastasiia Staiko on 12/23/15.
//  Copyright © 2015 Anastasiia Staiko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BadgeEarnStatus;

@class Run;

@interface BadgeDetailsViewController : UIViewController

@property (strong, nonatomic) BadgeEarnStatus *earnStatus;

@property (strong, nonatomic) Run *run;

@end
