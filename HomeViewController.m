//
//  HomeViewController.m
//  Tracker_1
//
//  Created by Anastasiia Staiko on 11/29/15.
//  Copyright © 2015 Anastasiia Staiko. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController () {
    
     BOOL checked;
}

@property (strong, nonatomic) NSArray *runArray;

@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@end

@implementation HomeViewController

@synthesize locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.mapView.showsUserLocation = YES;
    self.mapView.showsBuildings = YES;
    
//    if (self.locationManager == nil) {
//        self.locationManager = [[CLLocationManager alloc] init];
//    }

   locationManager=[[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.activityType = CLActivityTypeFitness;
    
    locationManager.headingFilter = 1;
    
//    locationManager = [CLLocationManager new];

    // Movement threshold for new events.
   locationManager.distanceFilter = 10; // meters
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    [locationManager startUpdatingHeading];

   
    UINavigationBar *navBar = self.navigationController.navigationBar;
    UIImage *image = [UIImage imageNamed:@"gradient-strip-top.png"];
    [navBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [_toolBar setBackgroundImage:[UIImage imageNamed:@"gradient-strip-bottom-main-screen"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    
    self->compassImage.hidden = YES;
    

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

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    // Convert Degree to Radian and move the needle
    float oldRad =  -manager.heading.trueHeading * M_PI / 180.0f;
    float newRad =  -newHeading.trueHeading * M_PI / 180.0f;
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         compassImage.transform = CGAffineTransformMakeRotation(newRad);
                     }];
    //	CABasicAnimation *theAnimation;
    //    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    //    theAnimation.fromValue = [NSNumber numberWithFloat:oldRad];
    //    theAnimation.toValue=[NSNumber numberWithFloat:newRad];
    //    theAnimation.duration = 0.01f;
    //
    //    [compassImage.layer addAnimation:theAnimation forKey:@"animateMyRotation"];
    //    compassImage.transform = CGAffineTransformMakeRotation(newRad);
    NSLog(@"%f (%f) => %f (%f)", manager.heading.trueHeading, oldRad, newHeading.trueHeading, newRad);
}

    

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)compass:(id)sender {
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    checked = [defaults boolForKey:@"boxIsChecked"];
    
     self->compassImage.hidden = NO;
    
//    
//    if (compassImage.hidden == NO) {
//        compassImage.hidden = YES;
//        
//    }
    
//    if(!checked) {
//        self->compassImage.hidden = YES;
//
//    } else if(checked) {
//      self->compassImage.hidden = NO;
//    }
//    [defaults synchronize];
//}
//
//-(void)checkTheBox {
//    if(!checked) {
//        self->compassImage.hidden = YES;
//
//    } else if(checked) {
//        self->compassImage.hidden = NO;
//    }
}



@end
