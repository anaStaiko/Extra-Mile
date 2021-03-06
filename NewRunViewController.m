//
//  NewRunViewController.m
//  Tracker_1
//
//  Created by Anastasiia Staiko on 11/29/15.
//  Copyright © 2015 Anastasiia Staiko. All rights reserved.

#import "NewRunViewController.h"
#import "DetailViewController.h"
#import "Run.h"
#import <CoreLocation/CoreLocation.h>
#import "Math.h"
#import "Location.h"
#import <MapKit/MapKit.h>
#import "DetailViewController.h"
#import "BadgeController.h"
#import "Badge.h"
#import <AudioToolbox/AudioToolbox.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>

static NSString * const detailSegueName = @"RunDetails";

@interface NewRunViewController () <UIActionSheetDelegate, CLLocationManagerDelegate, MKMapViewDelegate>

@property int seconds;
@property float distance;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) Run *run;
@property (nonatomic, strong) Badge *upcomingBadge;
@property (nonatomic, weak) IBOutlet UILabel *nextBadgeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *nextBadgeImageView;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *distLabel;
@property (nonatomic, weak) IBOutlet UILabel *paceLabel;
@property (nonatomic, weak) IBOutlet UIButton *startButton;
@property (nonatomic, weak) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UIButton *resumeButton;
@property (weak, nonatomic) IBOutlet UILabel *BadgeCenter;


- (IBAction)pause:(id)sender;
- (IBAction)resume:(id)sender;

@end

@implementation NewRunViewController

bool isShownImage = false;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    UIImage *image = [UIImage imageNamed:@"gradient-strip-top.png"];
    [navBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor darkGrayColor] forKey:NSForegroundColorAttributeName]];

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Main"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(aleartBack)];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.mapView.showsUserLocation = YES;
    self.mapView.showsBuildings = YES;
    [self.locationManager requestAlwaysAuthorization];
    
    // Compass
    _locationManager=[[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager startUpdatingHeading];
    _compassImageB.layer.opacity = 0;
    
    self.stopButton.hidden = NO;
    self.startButton.hidden = NO;
    self.pauseButton.hidden = YES;
    self.resumeButton.hidden = YES;
    
    
    self.timeLabel.text = @"00:00";
    self.timeLabel.hidden = NO;
    self.timeLabel.adjustsFontSizeToFitWidth = YES;
    self.distLabel.text = @"0.00";
    self.distLabel.hidden = NO;
    self.paceLabel.text = @"00:00";
    self.paceLabel.hidden = NO;
    self.nextBadgeLabel.text = @"0:00";
    self.nextBadgeLabel.hidden = NO;
    self.nextBadgeImageView.image = [UIImage imageNamed: @"badge1.png"];
    self.nextBadgeImageView.hidden = NO;
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 500, 500);
    [self.mapView setRegion:region animated:NO];
}


-(void)aleartBack {
    
    if (self.startButton.hidden == YES) {

        if (self.startButton.hidden == YES && self.pauseButton.hidden == YES) {
            // do nothing
        } else if (self.startButton.hidden == YES && self.resumeButton.hidden == YES)  {
            [self pauseTimer:_timer];
        }

        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Would you like to save your results before exiting?"
                                      message:@"This action can not be undone"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* save = [UIAlertAction
                               actionWithTitle:@"Save"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   [self.locationManager stopUpdatingLocation];
                                   [self.timer invalidate];
                                   [self saveRun];
                                   [self performSegueWithIdentifier:detailSegueName sender:nil];
                                   
                                   self.timeLabel.text = @"00:00";
                                   self.distLabel.text = @"0.00";
                                   self.paceLabel.text = @"00:00";
                                   self.nextBadgeLabel.text = @"0:00";
                                   self.pauseButton.hidden = YES;
                                   self.resumeButton.hidden = YES;
                                   self.startButton.hidden = NO;
                                   self.nextBadgeImageView.image = [UIImage imageNamed: @"badge1.png"];
                                   [self.locationManager stopUpdatingLocation];
                                   [self.mapView removeOverlays:self.mapView.overlays];
                               }];
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     
                                     [self dismissViewControllerAnimated:YES completion:nil];
                                     
                                     if (self.startButton.hidden == YES && self.pauseButton.hidden == YES) {
                                         // do nothing
                                     } else if (self.startButton.hidden == YES && self.resumeButton.hidden == YES)  {
                                         [self resumeTimer:_timer];
                                     }

                                 }];
        
        UIAlertAction* discard = [UIAlertAction
                                  actionWithTitle:@"Don't save"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action)
                                  {
                                      [self dismissViewControllerAnimated:YES completion:nil];
                                      [self.timer invalidate];
                                      [self.locationManager stopUpdatingLocation];
                                      [self.navigationController popToRootViewControllerAnimated:YES];

                                  }];
        
        [alert addAction:save];
        [alert addAction:cancel];
        [alert addAction:discard];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else {
         [self.navigationController popToRootViewControllerAnimated:YES];
    }
}



- (void)eachSecond {
    
    self.seconds++;
    self.timeLabel.text = [NSString stringWithFormat:@"%@", [Math stringifySecondCount:self.seconds usingLongFormat:NO]];
    self.distLabel.text = [NSString stringWithFormat:@"%@", [Math stringifyDistance:self.distance]];
    self.paceLabel.text = [NSString stringWithFormat:@"%@", [Math stringifyAvgPaceFromDist:self.distance overTime:self.seconds]];
    
    if (_distance > 48280.32) {
        self.nextBadgeLabel.text = @"00:00";
        self.nextBadgeImageView.hidden = YES;
        self.BadgeCenter.textAlignment = NSTextAlignmentRight;
        
    } else {
        self.nextBadgeLabel.text = [NSString stringWithFormat:@"%@", [Math stringifyDistance:(self.upcomingBadge.distance - self.distance)]];
        [self checkNextBadge];

    }
    }

- (void)checkNextBadge
{
    Badge *nextBadge = [[BadgeController defaultController] nextBadgeForDistance:self.distance];
    
    if (self.upcomingBadge
        && ![nextBadge.name isEqualToString:self.upcomingBadge.name]) {
        [self playSuccessSound];
    }
    self.upcomingBadge = nextBadge;
    self.nextBadgeImageView.image = [UIImage imageNamed:nextBadge.imageName];
}

- (void)playSuccessSound
{
//   vibrate
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}


- (void)startLocationUpdates
{
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.activityType = CLActivityTypeFitness;
    self.locationManager.allowsBackgroundLocationUpdates = YES;
    self.locationManager.pausesLocationUpdatesAutomatically = NO;
    self.locationManager.distanceFilter = 10; // meters
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    [self.locationManager startUpdatingHeading];

}


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *newLocation in locations) {
        
        NSDate *eventDate = newLocation.timestamp;
        
        NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
        
        if (fabs(howRecent) < 10.0 && newLocation.horizontalAccuracy < 20) {
            
            // update distance
                        if (self.locations.count > 0) {
                            self.distance += [newLocation distanceFromLocation:self.locations.lastObject];
                            
                                        if (self.locations.count > 0) {
                                            self.distance += [newLocation distanceFromLocation:self.locations.lastObject];
                            
                                            CLLocationCoordinate2D coords[2];
                                            coords[0] = ((CLLocation *)self.locations.lastObject).coordinate;
                                            coords[1] = newLocation.coordinate;
                            
                                            MKCoordinateRegion region =
                                            MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500);
                                            [self.mapView setRegion:region animated:YES];
                                            
                                            [self.mapView addOverlay:[MKPolyline polylineWithCoordinates:coords count:2]];

                                        }
        
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
    
    self.startButton.hidden = YES;
    self.pauseButton.hidden = NO;
    self.resumeButton.hidden = YES;
    
    self.timeLabel.hidden = NO;
    self.distLabel.hidden = NO;
    self.paceLabel.hidden = NO;
    self.stopButton.hidden = NO;
    
    self.seconds = 0;
    self.distance = 0;
    self.locations = [NSMutableArray array];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self
                                                selector:@selector(eachSecond) userInfo:nil repeats:YES];
    self.mapView.hidden = NO;
    self.nextBadgeImageView.hidden = NO;
    self.nextBadgeLabel.hidden = NO;
      self.locationManager.allowsBackgroundLocationUpdates = YES;
    [self startLocationUpdates];

}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *polyLine = (MKPolyline *)overlay;
        MKPolylineRenderer *aRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
        aRenderer.strokeColor = [UIColor colorWithRed:0 green:206 blue:209 alpha:1.0];
        aRenderer.lineWidth = 3;
        return aRenderer;
    }
    return nil;
}

-(IBAction)stopPressed:(id)sender {

    if (self.startButton.hidden == YES && self.pauseButton.hidden == YES) {
     // do nothing
    } else if (self.startButton.hidden == YES && self.resumeButton.hidden == YES)  {
        [self pauseTimer:_timer];
    }

    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Would you like to save your results?"
                                  message:@""
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* save = [UIAlertAction
                         actionWithTitle:@"Save"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                              [self.timer invalidate];
                              [self.locationManager stopUpdatingLocation];
                              [self saveRun];
                              [self performSegueWithIdentifier:detailSegueName sender:nil];
                             
                             self.timeLabel.text = @"00:00";
                             self.distLabel.text = @"0.00";
                             self.paceLabel.text = @"00:00";
                             self.nextBadgeLabel.text = @"0:00";
                             self.pauseButton.hidden = YES;
                             self.resumeButton.hidden = YES;
                             self.startButton.hidden = NO;
                             self.nextBadgeImageView.image = [UIImage imageNamed: @"badge1.png"];
                             [self.locationManager stopUpdatingLocation];
                             [self.mapView removeOverlays:self.mapView.overlays];

                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self dismissViewControllerAnimated:YES completion:nil];
                                 if (self.startButton.hidden == YES && self.pauseButton.hidden == YES) {
                                    // do nothing
                                 } else if (self.startButton.hidden == YES && self.resumeButton.hidden == YES)  {
                                     [self resumeTimer:_timer];
                                 }
 
                             }];
    
    UIAlertAction* discard = [UIAlertAction
                             actionWithTitle:@"Discard"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self dismissViewControllerAnimated:YES completion:nil];
                                 [self.timer invalidate];
                                 self.timeLabel.text = @"00:00";
                                 self.distLabel.text = @"0.00";
                                 self.paceLabel.text = @"00:00";
                                 self.nextBadgeLabel.text = @"0:00";
                                 self.pauseButton.hidden = YES;
                                 self.resumeButton.hidden = YES;
                                 self.startButton.hidden = NO;
                                 self.nextBadgeImageView.image = [UIImage imageNamed: @"badge1.png"];
                                 [self.locationManager stopUpdatingLocation];
                                 [self.mapView removeOverlays:self.mapView.overlays];

                             }];

    [alert addAction:save];
    [alert addAction:cancel];
    [alert addAction:discard];
    
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)alertController:(UIAlertController *)alerController clickedButtonAtIndex:(NSInteger)buttonIndex {
    
        [self.locationManager stopUpdatingLocation];
    
        // save
        if (buttonIndex == 0) {
            [self saveRun]; 
            [self performSegueWithIdentifier:detailSegueName sender:nil];
    
            // discard
        } else if (buttonIndex == 1) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[segue destinationViewController] setRun:self.run];
}


// Take Photo and Record Video

- (IBAction)recordAndPlay:(id)sender {
    
    [self startCameraControllerFromViewController:self usingDelegate:self];
}


- (IBAction)takePhoto:(id)sender {
    
    [self startCameraControllerFromViewController1:self usingDelegate:self];
}


-(BOOL)startCameraControllerFromViewController:(UIViewController*)controller
                                 usingDelegate:(id )delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil)) {
        return NO;
    }
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = delegate;
    [controller presentViewController:cameraUI animated:YES completion:nil];
    return YES;
}


-(BOOL)startCameraControllerFromViewController1:(UIViewController*)controller
                                 usingDelegate:(id )delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil)) {
        return NO;
    }
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = delegate;
    [controller presentViewController:cameraUI animated:YES completion:nil];
    return YES;
}


// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (self.startButton.hidden == YES && self.pauseButton.hidden == YES) {
        // do nothing
        
            self.startButton.hidden = YES;
            self.pauseButton.hidden = YES;
            self.resumeButton.hidden = NO;
        
    } else if (self.startButton.hidden == YES && self.resumeButton.hidden == YES)  {
        
        self.startButton.hidden = YES;
        self.pauseButton.hidden = NO;
        self.resumeButton.hidden = YES;
    }
}


// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    // Handle a still image capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToSave = editedImage;
        } else {
            imageToSave = originalImage;
        }
        
        // Save the new image (original or edited) to the Camera Roll
        UIImageWriteToSavedPhotosAlbum (imageToSave, self, @selector(photo:didFinishSavingWithError:contextInfo:), nil);
    }
    
//     Handle a movie capture
        if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0)
            == kCFCompareEqualTo) {
    
            NSString *moviePath = [(NSURL *)[info objectForKey:
                                    UIImagePickerControllerMediaURL] path];
    
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
                UISaveVideoAtPathToSavedPhotosAlbum (
                                                     moviePath, self,  @selector(video:didFinishSavingWithError:contextInfo:), nil);
            }
        }
    
    [picker dismissViewControllerAnimated:NO completion:nil];
}


-(void)video:(NSString*)videoPath didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    if (error) {
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Error"
                                      message:@"Video Saving Failed"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self dismissViewControllerAnimated:YES completion:nil];
                                 
                                 if (self.startButton.hidden == YES && self.pauseButton.hidden == YES) {

                                     self.startButton.hidden = YES;
                                     self.pauseButton.hidden = YES;
                                     self.resumeButton.hidden = NO;
                                     
                                 } else if (self.startButton.hidden == YES && self.resumeButton.hidden == YES)  {

                                     self.startButton.hidden = YES;
                                     self.pauseButton.hidden = NO;
                                     self.resumeButton.hidden = YES;
                                 }

                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Video Saved"
                                      message:@"Saved to Photo Album"
                                      preferredStyle:UIAlertControllerStyleAlert];
 
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self dismissViewControllerAnimated:YES completion:nil];

                                 if (self.startButton.hidden == YES && self.pauseButton.hidden == YES) {
                                     
                                     self.startButton.hidden = YES;
                                     self.pauseButton.hidden = YES;
                                     self.resumeButton.hidden = NO;
                                     
                                 } else if (self.startButton.hidden == YES && self.resumeButton.hidden == YES)  {

                                     self.startButton.hidden = YES;
                                     self.pauseButton.hidden = NO;
                                     self.resumeButton.hidden = YES;
                                 }

                             }];

        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


-(void)photo:(NSString*)videoPath didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    if (error) {
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Error"
                                      message:@"Photo Saving Failed"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self dismissViewControllerAnimated:YES completion:nil];
                                 
                                 if (self.startButton.hidden == YES && self.pauseButton.hidden == YES) {
                                     
                                     self.startButton.hidden = YES;
                                     self.pauseButton.hidden = YES;
                                     self.resumeButton.hidden = NO;
                                     
                                 } else if (self.startButton.hidden == YES && self.resumeButton.hidden == YES)  {

                                     self.startButton.hidden = YES;
                                     self.pauseButton.hidden = NO;
                                     self.resumeButton.hidden = YES;
                                 }

                             }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {

        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Photo Saved"
                                      message:@"Saved to Photo Album"
                                      preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self dismissViewControllerAnimated:YES completion:nil];
                                 
                                 if (self.startButton.hidden == YES && self.pauseButton.hidden == YES) {

                                     self.startButton.hidden = YES;
                                     self.pauseButton.hidden = YES;
                                     self.resumeButton.hidden = NO;
                                     
                                 } else if (self.startButton.hidden == YES && self.resumeButton.hidden == YES)  {
                                     
                                     self.startButton.hidden = YES;
                                     self.pauseButton.hidden = NO;
                                     self.resumeButton.hidden = YES;
                                 }
  
                             }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    // Convert Degree to Radian and move the needle
    float oldRad = -manager.heading.trueHeading * M_PI / 180.0f;
    float newRad = -newHeading.trueHeading * M_PI / 180.0f;
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         _compassImageB.transform = CGAffineTransformMakeRotation(newRad);
                     }];
    NSLog(@"%f (%f) => %f (%f)", manager.heading.trueHeading, oldRad, newHeading.trueHeading, newRad);
}


- (IBAction)compassButtonTog:(id)sender {

    if (!isShownImage) {
        [UIImageView animateWithDuration:0.5 animations:^{
            _compassImageB.layer.opacity = 1;
        }];
        isShownImage = true;
    } else {
        [UIImageView animateWithDuration:0.5 animations:^{
            _compassImageB.layer.opacity = 0;
        }];
        isShownImage = false;
    }
   
}


NSDate *pauseStart, *previousFireDate;

-(void) pauseTimer:(NSTimer *)timer {
    
    pauseStart = [NSDate dateWithTimeIntervalSinceNow:0];
    
    previousFireDate = [timer fireDate];
    
    [timer setFireDate:[NSDate distantFuture]];
}

-(void) resumeTimer:(NSTimer *)timer {
    
    float pauseTime = -1*[pauseStart timeIntervalSinceNow];
    
    [timer setFireDate:[previousFireDate initWithTimeInterval:pauseTime sinceDate:previousFireDate]];
    
}



- (IBAction)pause:(id)sender {
    
    [self pauseTimer:_timer];
    self.pauseButton.hidden = YES;
    self.resumeButton.hidden = NO;
}

- (IBAction)resume:(id)sender {
    
    [self resumeTimer:_timer];
    self.pauseButton.hidden = NO;
    self.resumeButton.hidden = YES;
}



@end
