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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *image = [[SWShareScreenShot shareManager].images objectForKey:@"SWShareViewController"];
    
    if (image) {
        self.imageView.image = image;
        self.image = image;
    }
    
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
  
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
