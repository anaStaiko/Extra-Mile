//
//  ViewController.m
//  MyMedia
//
//  Created by Anastasiia Staiko on 4/5/16.
//  Copyright © 2016 Anastasiia Staiko. All rights reserved.
//

#import "MediaViewController.h"
#import "Filters.h"
#import "ThumbNail.h"

@interface MediaViewController () <UIGestureRecognizerDelegate>

@end

@implementation MediaViewController

@synthesize tabBar=_tabBar;
@synthesize context=_context;
@synthesize beginImage=_beginImage;
@synthesize endImage=_endImage;
@synthesize orientation=_orientation;
@synthesize filtersVC;
@synthesize popoverFilters;
@synthesize popoverAlbum;

//shows all the CI Foto Filters and their attributes
-(void)logAllFilters {
    NSArray *properties = [CIFilter filterNamesInCategory:
                           kCICategoryBuiltIn];
//    NSLog(@"%@", properties);
    for (NSString *filterName in properties) {
        CIFilter *fltr = [CIFilter filterWithName:filterName];
        NSLog(@"%@", [fltr attributes]);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // loads a default Image
    NSString *filePath =
    [[NSBundle mainBundle] pathForResource:@"image" ofType:@"png"];
    NSURL *fileNameAndPath = [NSURL fileURLWithPath:filePath];
    self.tabBar.delegate=self;
    self.beginImage = [CIImage imageWithContentsOfURL:fileNameAndPath];
    self.endImage=self.beginImage;
    self.context = [CIContext contextWithOptions:nil];
    
    CGImageRef cgimg = [self.context createCGImage:self.beginImage fromRect:[self.beginImage extent]];
    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    self.imageView.image = newImage;
    
    CGImageRelease(cgimg);
    
    //making sure the tab "Original Image" is selected at the start
    [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:0]];
    
    [self logAllFilters];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor darkGrayColor] forKey:NSForegroundColorAttributeName]];
    
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
 
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    
    [self.imageView addGestureRecognizer:tapGestureRecognizer];
    
    tapGestureRecognizer.delegate = self;
    
}

- (void) handleTapFrom: (UITapGestureRecognizer *)recognizer
{
    if ( self.loadPhotoProp.layer.opacity == 1) {
        [UIButton animateWithDuration:0.4 animations:^{
            self.loadPhotoProp.layer.opacity = 0;        }];
    } else {
        
        [UIButton animateWithDuration:0.4 animations:^{
            self.loadPhotoProp.layer.opacity = 1;        }];

    }
}


//opens the Photo Album on the Device
- (IBAction)loadPhoto:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO) {
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Error"
                                      message:@"No Saved Album Found"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self dismissViewControllerAnimated:YES completion:nil];
                             }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
        pickerC.delegate = self;

        [self presentViewController:pickerC animated:YES completion:nil];
        
    }
}

//saves the filtered Image
- (IBAction)savePhoto:(id)sender {
    // 1
    CIImage *saveToSave = self.endImage;
    // 2
    CIContext *softwareContext = [CIContext
                                  contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)} ];
    // 3
    CGImageRef cgImg = [softwareContext createCGImage:saveToSave
                                             fromRect:[saveToSave extent]];
    // 4
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:cgImg
                                 metadata:[saveToSave properties]
                          completionBlock:^(NSURL *assetURL, NSError *error) {
                              
                              if (error) {
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Photo Saving Failed"
                                                                                 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                  [alert show];
                              } else {
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Photo Saved" message:@"Saved To Photo Album"
                                                                                 delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                  [alert show];
                              }
                              
                              // 5
                              CGImageRelease(cgImg);
                          }];

}


- (IBAction)tweetAction:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"Enter Tweet Text!"];
        [tweetSheet addImage:self.imageView.image];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}


- (IBAction)fbAction:(id)sender {
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController * fbSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [fbSheet setInitialText:@"Enter FB Text!"];
        [fbSheet addImage:self.imageView.image];
        [self presentViewController:fbSheet animated:YES completion:Nil];
    }
}

//an image was picked from the Image Picker Controller
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //the ImagePicker Controller is dismissed
    [self.popoverAlbum dismissPopoverAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //the selected Image is converted into a CIImage
    UIImage *gotImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.orientation = gotImage.imageOrientation;
    
    gotImage = [self rotateImage:gotImage];

    //Changing Image-related properties
    self.beginImage = [CIImage imageWithCGImage:gotImage.CGImage];
    self.endImage=self.beginImage;
    
    CGImageRef cgimg = [self.context createCGImage:self.beginImage fromRect:[self.beginImage extent]];
    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    self.imageView.image = newImage;
    CGImageRelease(cgimg);
    //set the tabBar/Segmented Control to "Original Image"
    [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:0]];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (UIImage*) rotateImage:(UIImage* )src {
    
    UIImageOrientation orientation = src.imageOrientation;
    
    UIGraphicsBeginImageContext(src.size);
    
    [src drawAtPoint:CGPointMake(0, 0)];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orientation == UIImageOrientationRight) {
        CGContextRotateCTM (context, [self radians:90]);
    } else if (orientation == UIImageOrientationLeft) {
        CGContextRotateCTM (context, [self radians:90]);
    } else if (orientation == UIImageOrientationDown) {
        // do nothing
    } else if (orientation == UIImageOrientationUp) {
        CGContextRotateCTM (context, [self radians:0]);
    }
    
    return UIGraphicsGetImageFromCurrentImageContext();
}

- (CGFloat) radians:(int)degrees {
    return (degrees/180)*(22/7);
}


// When no image is selected, the Image Picker is just dismissed
- (void)imagePickerControllerDidCancel: (UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


//Creating FiltersViewController and showing the Filters to pick from
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"filterSegue"]) {
        
        FiltersViewController *fVC = (FiltersViewController *) segue.destinationViewController;
        [fVC setDelegate:self];
        UIImage *newImage = [ThumbNail createThumbNailFromImage:self.imageView.image];
        
        fVC.image=newImage;
    }
}

//delegate method from FiltersViewController

- (void)userDidMakeChoice:(NSString *)choice{
    CIImage *image=nil;
    //Check which picture needs to be modified(Original or Filtered)
    if(self.tabBar.selectedItem.tag==1){
        image=self.endImage;
    }else {
        image = self.beginImage;
        //set tab Tab Bar to"Filtered Image" if user is Filtering the Original Image
        [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:1]];
    }
    
    //Apply the Filter
    CIImage *outputImage = [Filters changeImage:image withFilter:choice];
    self.endImage=outputImage;
    
    CGImageRef cgimg =
    [self.context createCGImage:outputImage fromRect:[outputImage extent]];
    
    //show the Filtered Image
    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    self.imageView.image = newImage;
    
    CGImageRelease(cgimg);
    
}

//tab Bar Delegate - Shows the Original or Filtered Image
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    NSInteger tag = item.tag;
    if(tag==0){
        
        CGImageRef cgimg = [self.context createCGImage:self.beginImage fromRect:[self.beginImage extent]];
        
        UIImage *newImage = [UIImage imageWithCGImage:cgimg];
        self.imageView.image = newImage;
        CGImageRelease(cgimg);
    }else {
        CGImageRef cgimg = [self.context createCGImage:self.endImage fromRect:[self.endImage extent]];
        
        UIImage *newImage = [UIImage imageWithCGImage:cgimg];
        self.imageView.image = newImage;
        CGImageRelease(cgimg);
        
    }
    
}



@end
