//
//  NewRunViewController.h
//  Tracker_1
//
//  Created by Anastasiia Staiko on 11/29/15.
//  Copyright © 2015 Anastasiia Staiko. All rights reserved. 
//

#import <UIKit/UIKit.h>


@interface NewRunViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

// Record Video

- (IBAction)recordAndPlay:(id)sender;
- (IBAction)takePhoto:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *compassImageB;

- (IBAction)compassButtonTog:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *compassButton;

-(BOOL)startCameraControllerFromViewController:(UIViewController*)controller usingDelegate:(id )delegate;
-(void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void*)contextInfo;
-(void)photo:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void*)contextInfo;

@end
