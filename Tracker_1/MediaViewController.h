//
//  ViewController.h
//  MyMedia
//
//  Created by Anastasiia Staiko on 4/5/16.
//  Copyright © 2016 Anastasiia Staiko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "FiltersViewController.h"
#import <Social/Social.h>

@interface MediaViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate,FilterControllerDelegate,UITabBarDelegate>{
    
}
@property CIContext *context;
@property CIImage *beginImage;
@property CIImage *endImage;
@property UIImageOrientation orientation;


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *album;

@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

@property (nonatomic, strong) UIPopoverController *popoverAlbum;
@property (nonatomic, strong) UIPopoverController *popoverFilters;
//@property (weak, nonatomic) IBOutlet UISegmentedControl *seg;
@property FiltersViewController *filtersVC;

@property (weak, nonatomic) IBOutlet UIButton *loadPhotoProp;


//Touching the Segmented Control shows the Original or Filtered Image (iPad)
//- (IBAction)valueChanged:(UISegmentedControl *)sender;

//Shows the Photo Album
- (IBAction)loadPhoto:(id)sender;

//Saves the Photo in the Photo Album
- (IBAction)savePhoto:(id)sender;

//Opens the Camera to take a picture
//- (IBAction)takePhoto:(id)sender;
//Tweets the current Photo
- (IBAction)tweetAction:(id)sender;

- (IBAction)fbAction:(id)sender;


//shows the available Filters(iPad)
//- (IBAction)showFilters:(id)sender;


@end
