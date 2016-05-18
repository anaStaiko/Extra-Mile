//
//  HomeViewController.m
//  Tracker_1
//
//  Created by Anastasiia Staiko on 11/29/15.
//  Copyright © 2015 Anastasiia Staiko. All rights reserved.
//

#import "HomeViewController.h"


@interface HomeViewController ()

@property (strong, nonatomic) NSArray *runArray;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) NSArray *earnStatusArray;

@end

@implementation HomeViewController

@synthesize locationManager;
bool isShown = false;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.mapView.showsUserLocation = YES;
    self.mapView.showsBuildings = YES;

    locationManager=[[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.activityType = CLActivityTypeFitness;
    locationManager.headingFilter = 1;
    locationManager.distanceFilter = 10; // meters
    [locationManager requestAlwaysAuthorization];
    
    [locationManager startUpdatingLocation];
    [locationManager startUpdatingHeading];

    UINavigationBar *navBar = self.navigationController.navigationBar;
    UIImage *image = [UIImage imageNamed:@"gradient-strip-top.png"];
    [navBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [_toolBar setBackgroundImage:[UIImage imageNamed:@"gradient-strip-bottom-main-screen"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    compassImage.layer.opacity = 0;

}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:userLocation.coordinate fromEyeCoordinate:CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude) eyeAltitude:10000];
    [mapView setCamera:camera animated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Run" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    self.runArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *nextController = [segue destinationViewController];
    if ([nextController isKindOfClass:[NewRunViewController class]]) {
        ((NewRunViewController *) nextController).managedObjectContext = self.managedObjectContext;
    } else if ([nextController isKindOfClass:[PastRunsViewController class]]) {
        ((PastRunsViewController *) nextController).runArray = [self.runArray mutableCopy];
    } else if ([nextController isKindOfClass:[BadgesTableViewController class]]) {
        ((BadgesTableViewController *) nextController).earnStatusArray = [[BadgeController defaultController] earnStatusesForRuns:self.runArray];
    }
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    
}


//Compass

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    // Convert Degree to Radian and move the needle
    float oldRad = -manager.heading.trueHeading * M_PI / 180.0f;
    float newRad = -newHeading.trueHeading * M_PI / 180.0f;
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         compassImage.transform = CGAffineTransformMakeRotation(newRad);
                     }];
     NSLog(@"%f (%f) => %f (%f)", manager.heading.trueHeading, oldRad, newHeading.trueHeading, newRad);
}


- (IBAction)btnToggleClick:(id)sender {
   
    if (!isShown) {
            [UIImageView animateWithDuration:0.5 animations:^{
                compassImage.layer.opacity = 1;
        }];
        isShown = true;
    } else {
            [UIImageView animateWithDuration:0.5 animations:^{
                compassImage.layer.opacity = 0;
        }];
        isShown = false;
    }
}


@end
