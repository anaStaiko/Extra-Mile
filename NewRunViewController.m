//
//  NewRunViewController.m
//  Tracker_1
//
//  Created by Anastasiia Staiko on 11/29/15.
//  Copyright © 2015 Anastasiia Staiko. All rights reserved.
//

#import "NewRunViewController.h"
#import "DetailViewController.h"
#import "Run.h"

static NSString * const detailSegueName = @"RunDetails";

@interface NewRunViewController () <UIActionSheetDelegate>

@property (nonatomic, strong) Run *run;

@property (nonatomic, weak) IBOutlet UILabel *promptLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *distLabel;
@property (nonatomic, weak) IBOutlet UILabel *paceLabel;
@property (nonatomic, weak) IBOutlet UIButton *startButton;
@property (nonatomic, weak) IBOutlet UIButton *stopButton;

@end

@implementation NewRunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.startButton.hidden = NO;
    self.promptLabel.hidden = NO;
    
    self.timeLabel.text = @"";
    self.timeLabel.hidden = YES;
    self.distLabel.hidden = YES;
    self.paceLabel.hidden = YES;
    self.stopButton.hidden = YES;
    
}

-(IBAction)startPressed:(id)sender {
    
    //hide the start UI
    self.startButton.hidden = YES;
    self.promptLabel.hidden = YES;
    
    //show the running UI
    self.timeLabel.hidden = NO;
    self.distLabel.hidden = NO;
    self.paceLabel.hidden = NO;
    self.stopButton.hidden = NO;
    
}

-(IBAction)stopPressed:(id)sender {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Would you like to save your results?"
                                  message:@"Save"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* save = [UIAlertAction
                         actionWithTitle:@"Save"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                              [self performSegueWithIdentifier:detailSegueName sender:nil];
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    UIAlertAction* discard = [UIAlertAction
                             actionWithTitle:@"Discard"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self.navigationController popToRootViewControllerAnimated:YES];

                                 
                             }];

    [alert addAction:save];
    [alert addAction:cancel];
    [alert addAction:discard];
    
    [self presentViewController:alert animated:YES completion:nil];

    }



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[segue destinationViewController] setRun:self.run];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
