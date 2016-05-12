//
//  BadgeDetailsViewController.m
//  Tracker_1
//
//  Created by Anastasiia Staiko on 12/23/15.
//  Copyright © 2015 Anastasiia Staiko. All rights reserved.
//

#import "BadgeDetailsViewController.h"
#import "BadgeEarnStatus.h"
#import "Badge.h"
#import "Math.h"
#import "Run.h"
#import "BadgeController.h"
#import "PopupView.h"
#import "PopupViewAnimationFade.h"
//#import "Location.h"

@interface BadgeDetailsViewController () 

@property (nonatomic, weak) IBOutlet UIImageView *badgeImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *earnedLabel;
//@property (nonatomic, weak) IBOutlet UILabel *silverLabel;
//@property (nonatomic, weak) IBOutlet UILabel *goldLabel;
@property (nonatomic, weak) IBOutlet UILabel *bestLabel;


@property (weak, nonatomic) IBOutlet UILabel *bestDate;




@end

@implementation BadgeDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];

    self.nameLabel.text = self.earnStatus.badge.name;
    
    self.distanceLabel.text = [NSString stringWithFormat:@"%@ mi", [Math stringifyDistance:self.earnStatus.badge.distance]];
    
    self.badgeImageView.image = [UIImage imageNamed:self.earnStatus.badge.imageName];
    self.earnedLabel.text = [NSString stringWithFormat:@"Reached on %@" , [formatter stringFromDate:self.earnStatus.earnRun.timestamp]];
    
    
    
//    
//    self.myPace.text = [NSString stringWithFormat:@"%@", [Math stringifyAvgPaceFromDist:self.run.distance.floatValue overTime:self.run.duration.intValue]];

    
//    self.bestLabel.text = [NSString stringWithFormat:@"Your Best Result: %@ min/mi \n Reached on %@", [Math stringifyAvgPaceFromDist:self.earnStatus.bestRun.distance.floatValue overTime:self.earnStatus.bestRun.duration.intValue], [formatter stringFromDate:self.earnStatus.bestRun.timestamp]];
//    
    
    self.bestLabel.text = [NSString stringWithFormat:@"%@ min/mi", [Math stringifyAvgPaceFromDist:self.earnStatus.bestRun.distance.floatValue overTime:self.earnStatus.bestRun.duration.intValue]];

    
    
    self.bestDate.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:self.earnStatus.bestRun.timestamp]];
    
  
}


- (IBAction)popupViewFadeAction:(id)sender {
    
    PopupView *view = [PopupView defaultPopupView];
    view.parentVC = self;
    
    [self presentPopupView:view animation:[PopupViewAnimationFade new] dismissed:^{
        NSLog(@"View is loaded");
    }];
    
}



@end
