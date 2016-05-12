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
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (nonatomic, strong) UIPopoverController *popoverAlbum;
@property (nonatomic, strong) UIPopoverController *popoverFilters;
@property FiltersViewController *filtersVC;
@property (weak, nonatomic) IBOutlet UIButton *loadPhotoProp;

- (IBAction)loadPhoto:(id)sender;
- (IBAction)savePhoto:(id)sender;
- (IBAction)tweetAction:(id)sender;
- (IBAction)fbAction:(id)sender;

@end
