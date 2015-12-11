//
//  NewRunViewController.m
//  Tracker_1
//
//  Created by Anastasiia Staiko on 11/29/15.
//  Copyright © 2015 Anastasiia Staiko. All rights reserved. 
//

#import "NewRunViewController.h"
#import "DetailViewController.h"
#import "Run.h"
#import <CoreLocation/CoreLocation.h>
#import "Math.h"
#import "Location.h"


static NSString * const detailSegueName = @"RunDetails";

@interface NewRunViewController () <UIActionSheetDelegate, CLLocationManagerDelegate>

@property int seconds;
@property float distance;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) Run *run;

@property (nonatomic, weak) IBOutlet UILabel *promptLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *distLabel;
@property (nonatomic, weak) IBOutlet UILabel *paceLabel;
@property (nonatomic, weak) IBOutlet UIButton *startButton;
@property (nonatomic, weak) IBOutlet UIButton *stopButton;

@end

@implementation NewRunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.startButton.hidden = NO;
    self.promptLabel.hidden = NO;
    
    self.timeLabel.text = @"";
    self.timeLabel.hidden = YES;
    self.distLabel.hidden = YES;
    self.paceLabel.hidden = YES;
    self.stopButton.hidden = YES;
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
}


- (void)eachSecond {
    self.seconds++;
    self.timeLabel.text = [NSString stringWithFormat:@"Time: %@",  [Math stringifySecondCount:self.seconds usingLongFormat:NO]];
    self.distLabel.text = [NSString stringWithFormat:@"Distance: %@", [Math stringifyDistance:self.distance]];
    self.paceLabel.text = [NSString stringWithFormat:@"Pace: %@",  [Math stringifyAvgPaceFromDist:self.distance overTime:self.seconds]];
}


- (void)startLocationUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.activityType = CLActivityTypeFitness;
    
    // Movement threshold for new events.
    self.locationManager.distanceFilter = 10; // meters
    
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *newLocation in locations) {
        if (newLocation.horizontalAccuracy < 20) {
            
            // update distance
            if (self.locations.count > 0) {
                self.distance += [newLocation distanceFromLocation:self.locations.lastObject];
            }
            
            [self.locations addObject:newLocation];
        }
    }
}


- (void)saveRun {
    Run *newRun = [NSEntityDescription insertNewObjectForEntityForName:@"Run"
                                                inManagedObjectContext:self.managedObjectContext];
    
    newRun.distance = [NSNumber numberWithFloat:self.distance];
    newRun.duration = [NSNumber numberWithInt:self.seconds];
    newRun.timestamp = [NSDate date];
    
    NSMutableArray *locationArray = [NSMutableArray array];
    for (CLLocation *location in self.locations) {
        Location *locationObject = [NSEntityDescription insertNewObjectForEntityForName:@"Location"
                                                                 inManagedObjectContext:self.managedObjectContext];
        
        locationObject.timestamp = location.timestamp;
        locationObject.latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
        locationObject.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
        [locationArray addObject:locationObject];
    }
    
    newRun.locations = [NSOrderedSet orderedSetWithArray:locationArray];
    self.run = newRun;
    
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}


-(IBAction)startPressed:(id)sender {
    
    //hide the start UI
    self.startButton.hidden = YES;
    self.promptLabel.hidden = YES;
    
    //show the running UI
    self.timeLabel.hidden = NO;
    self.distLabel.hidden = NO;
    self.paceLabel.hidden = NO;
    self.stopButton.hidden = NO;
    
    self.seconds = 0;
    self.distance = 0;
    self.locations = [NSMutableArray array];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self
                                                selector:@selector(eachSecond) userInfo:nil repeats:YES];
    [self startLocationUpdates];
    
}

-(IBAction)stopPressed:(id)sender {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Would you like to save your results?"
                                  message:@"Save"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* save = [UIAlertAction
                         actionWithTitle:@"Save"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                              [self saveRun];
                              [self performSegueWithIdentifier:detailSegueName sender:nil];
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    UIAlertAction* discard = [UIAlertAction
                             actionWithTitle:@"Discard"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self.navigationController popToRootViewControllerAnimated:YES];

                                 
                             }];

    [alert addAction:save];
    [alert addAction:cancel];
    [alert addAction:discard];
    
    [self presentViewController:alert animated:YES completion:nil];

    }


/////////


//- (IBAction)stopPressed:(id)sender
//{
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self
//                                                    cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
//                                                    otherButtonTitles:@"Save", @"Discard", nil];
//    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
//    [actionSheet showInView:self.view];
//}
//
//
//




-(void)alertController:(UIAlertController *)alerController clickedButtonAtIndex:(NSInteger)buttonIndex {
    
        [self.locationManager stopUpdatingLocation];
    
        // save
        if (buttonIndex == 0) {
            [self saveRun]; ///< ADD THIS LINE
            [self performSegueWithIdentifier:detailSegueName sender:nil];
    
            // discard
        } else if (buttonIndex == 1) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    
}


//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    [self.locationManager stopUpdatingLocation];
//    
//    // save
//    if (buttonIndex == 0) {
//        [self saveRun]; ///< ADD THIS LINE
//        [self performSegueWithIdentifier:detailSegueName sender:nil];
//        
//        // discard
//    } else if (buttonIndex == 1) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
//}

/////////


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[segue destinationViewController] setRun:self.run];
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

@end
