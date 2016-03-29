//
//  PicViewController.h
//  Tracker_1
//
//  Created by Anastasiia Staiko on 3/29/16.
//  Copyright © 2016 Anastasiia Staiko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface PicViewController : UIViewController

- (IBAction)takePhoto:(id)sender;

-(BOOL)startCameraControllerFromViewController:(UIViewController*)controller usingDelegate:(id )delegate;

-(void)photo:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void*)contextInfo;

@end
