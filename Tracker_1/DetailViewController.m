//
//  DetailViewController.m
//  Tracker_1
//
//  Created by Anastasiia Staiko on 11/29/15.
//  Copyright © 2015 Anastasiia Staiko. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "DetailViewController.h"
#import "Run.h"
#import "Math.h"
#import "Location.h"
#import "Badge.h"
#import "BadgeController.h"
#import "MulticolorPolylineSegment.h"
#import "BadgeAnnotation.h"
#import "SWDetailViewController.h"
#import "SWShareScreenShot.h"

static float const mapPadding = 1.1f;  

@interface DetailViewController () <MKMapViewDelegate>

@property (strong, nonatomic) NSArray *colorSegmentArray;

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *paceLabel;
@property (nonatomic, weak) IBOutlet UIImageView *badgeImageView;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
    [self loadMap];
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    UIImage *image = [UIImage imageNamed:@"gradient-strip-top.png"];
    [navBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor darkGrayColor] forKey:NSForegroundColorAttributeName]];
    
}


- (void)configureView
{
    self.distanceLabel.text = [NSString stringWithFormat:@"%@", [Math stringifyDistance:self.run.distance.floatValue]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    self.dateLabel.text = [NSString stringWithFormat:@"%@",
                           [formatter stringFromDate:self.run.timestamp]];
    self.timeLabel.text = [NSString stringWithFormat:@"%@", [Math stringifySecondCount:self.run.duration.intValue usingLongFormat:NO]];
    self.timeLabel.adjustsFontSizeToFitWidth = YES;
    self.paceLabel.text = [NSString stringWithFormat:@"%@", [Math stringifyAvgPaceFromDist:self.run.distance.floatValue overTime:self.run.duration.intValue]];
    Badge *badge = [[BadgeController defaultController] bestBadgeForDistance:self.run.distance.floatValue];
    self.badgeImageView.image = [UIImage imageNamed:badge.imageName];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation
{
    BadgeAnnotation *badgeAnnotation = (BadgeAnnotation *)annotation;
    
    MKAnnotationView *annView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"checkpoint"];
    if (!annView) {
        annView=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"checkpoint"];
        annView.image = [UIImage imageNamed:@"mapPin"];
        annView.canShowCallout = YES;
    }
    
    UIImageView *badgeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 50)];
    badgeImageView.image = [UIImage imageNamed:badgeAnnotation.imageName];
    badgeImageView.contentMode = UIViewContentModeScaleAspectFit;
    annView.leftCalloutAccessoryView = badgeImageView;
    
    return annView;
}


- (MKCoordinateRegion)mapRegion
{
    MKCoordinateRegion region;
    Location *initialLoc = self.run.locations.firstObject;
    
    float minLat = initialLoc.latitude.floatValue;
    float minLng = initialLoc.longitude.floatValue;
    float maxLat = initialLoc.latitude.floatValue;
    float maxLng = initialLoc.longitude.floatValue;
    
    for (Location *location in self.run.locations) {
        if (location.latitude.floatValue < minLat) {
            minLat = location.latitude.floatValue;
        }
        if (location.longitude.floatValue < minLng) {
            minLng = location.longitude.floatValue;
        }
        if (location.latitude.floatValue > maxLat) {
            maxLat = location.latitude.floatValue;
        }
        if (location.longitude.floatValue > maxLng) {
            maxLng = location.longitude.floatValue;
        }
    }
    
    region.center.latitude = (minLat + maxLat) / 2.0f;
    region.center.longitude = (minLng + maxLng) / 2.0f;
    
    region.span.latitudeDelta = (maxLat - minLat) * mapPadding; // 10% padding
    region.span.longitudeDelta = (maxLng - minLng) * mapPadding; // 10% padding
    
    return region;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    
    if ([overlay isKindOfClass:[MulticolorPolylineSegment class]]) {
        MulticolorPolylineSegment *polyLine = (MulticolorPolylineSegment *)overlay;
        MKPolylineRenderer *aRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
        aRenderer.strokeColor = polyLine.color;
        aRenderer.lineWidth = 3;
        return aRenderer;    }
    
    return nil;
}

- (MKPolyline *)polyLine {
    
    CLLocationCoordinate2D coords[self.run.locations.count];
    
    for (int i = 0; i < self.run.locations.count; i++) {
        Location *location = [self.run.locations objectAtIndex:i];
        coords[i] = CLLocationCoordinate2DMake(location.latitude.doubleValue, location.longitude.doubleValue);
    }
    
    return [MKPolyline polylineWithCoordinates:coords count:self.run.locations.count];
}


- (void)loadMap
{
    if (self.run.locations.count > 0) {
        
        self.mapView.hidden = NO;
        
//        self.mapView.mapType = MKMapTypeSatellite;
        
        // set the map bounds
        [self.mapView setRegion:[self mapRegion]];
        
//        [self.mapView addOverlay:[self polyLine]];
        
        NSArray *colorSegmentArray = [Math colorSegmentsForLocations:self.run.locations.array];
        [self.mapView addOverlays:colorSegmentArray];
        
        [self.mapView addAnnotations:[[BadgeController defaultController] annotationsForRun:self.run]];
        
    } else {
        
        // no locations were found!
        self.mapView.hidden = YES;
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Error"
                                              message:@"Sorry, this run has no locations saved."
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 //Do some thing here
                                 [self dismissViewControllerAnimated:YES completion:nil];
                                  }];
        
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        
  }
}


- (void)setRun:(Run *)run
{
    if (_run != run) {
        _run = run;
        [self configureView];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    [[SWShareScreenShot shareManager] keepImageByCurrentViewController:self withName:@"SWShareViewController"];
    
}


@end
