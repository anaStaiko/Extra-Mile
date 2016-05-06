//
//  SWDetailViewController.m
//  ScreenShot
//
//  Created by Anastasiia Staiko on 4/12/16.
//  Copyright © 2016 Anastasiia Staiko. All rights reserved.
//

#import "SWDetailViewController.h"
#import "SWShareScreenShot.h"

@interface SWDetailViewController ()


@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation SWDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


//- (BOOL) prefersStatusBarHidden {
//    return YES;
//}




//- (IBAction)back:(id)sender {
//    
//    UIViewController *prevVC = [self.navigationController.viewControllers objectAtIndex:1];
//    [self.navigationController popToViewController:prevVC animated:YES];
//    
    
    
    
    
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *image = [[SWShareScreenShot shareManager].images objectForKey:@"SWShareViewController"];
    
    if (image) {
        self.imageView.image = image;
        self.image = image;
    }
    
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    
//     [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor darkGrayColor] forKey:NSForegroundColorAttributeName]];
////    
//    UINavigationBar *navBar = self.navigationController.navigationBar;
    
//    
    UIImage *imageNav = [UIImage imageNamed:@"gradient-strip-top.png"];
    [_navBar setBackgroundImage:imageNav forBarMetrics:UIBarMetricsDefault];
}



- (IBAction)share:(id)sender {
    
    UIActivityViewController *activityController = nil;
    activityController = [[UIActivityViewController alloc] initWithActivityItems:@[self.image]
                                                           applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

@end
