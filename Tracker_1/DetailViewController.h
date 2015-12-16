//
//  DetailViewController.h
//  Tracker_1
//
//  Created by Anastasiia Staiko on 11/29/15.
//  Copyright © 2015 Anastasiia Staiko. All rights reserved. 
//

#import <UIKit/UIKit.h>

@import MapKit;

@class Run;

@interface DetailViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) Run *run;

//@property (strong, nonatomic) id detailItem;
//@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

