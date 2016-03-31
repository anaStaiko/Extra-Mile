//
//  HomeViewController.h
//  Tracker_1
//
//  Created by Anastasiia Staiko on 11/29/15.
//  Copyright © 2015 Anastasiia Staiko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewRunViewController.h"
#import "BadgesTableViewController.h"
#import "PastRunsViewController.h"
#import "BadgeController.h"
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

@interface HomeViewController : UIViewController  <CLLocationManagerDelegate, MKMapViewDelegate> {
    
    CLLocationManager *locationManager;
    IBOutlet UIImageView *compassImage;
    
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) CLLocationManager *locationManager;

@end
