//
//  PastRunsViewController.h
//  Tracker_1
//
//  Created by Anastasiia Staiko on 12/22/15.
//  Copyright © 2015 Anastasiia Staiko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PastRunsViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *runArray; 

@end
