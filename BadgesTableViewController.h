//
//  BadgesTableViewController.h
//  Tracker_1
//
//  Created by Anastasiia Staiko on 12/17/15.
//  Copyright © 2015 Anastasiia Staiko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BadgesTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *earnStatusArray;

@end
