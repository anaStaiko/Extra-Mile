//
//  MediaViewController.h
//  Tracker_1
//
//  Created by Anastasiia Staiko on 3/25/16.
//  Copyright © 2016 Anastasiia Staiko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Photos/Photos.h>



@interface MediaViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, MPMediaPickerControllerDelegate> {
        BOOL isSelectingAssetOne;
        BOOL isSelectingAssetTwo;
}


@property(nonatomic, strong) AVAsset *firstAsset;
@property(nonatomic, strong) AVAsset *secondAsset;
@property(nonatomic, strong) AVAsset *thirdAsset;
@property(nonatomic, strong) AVAsset *audioAsset;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;



- (IBAction)loadAssetOne:(id)sender;
- (IBAction)loadAssetTwo:(id)sender;
- (IBAction)loadAssetThree:(id)sender;
- (IBAction)loadAudio:(id)sender;
- (IBAction)mergeAndSave:(id)sender;
-(BOOL)startMediaBrowserFromViewController:(UIViewController*)controller usingDelegate:(id)delegate;
-(void)exportDidFinish:(AVAssetExportSession*)session;



@end
