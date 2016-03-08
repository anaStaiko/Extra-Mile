//
//  RunCell.h
//  Tracker_1
//
//  Created by Anastasiia Staiko on 12/22/15.
//  Copyright © 2015 Anastasiia Staiko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RunCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UIImageView *badgeImageView; 

@end
