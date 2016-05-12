//
//  BadgesTableViewController.m
//  Tracker_1
//
//  Created by Anastasiia Staiko on 12/17/15.
//  Copyright © 2015 Anastasiia Staiko. All rights reserved.
//

#import "BadgesTableViewController.h"
#import "BadgeEarnStatus.h"
#import "BadgeCell.h"
#import "Badge.h"
#import "Math.h"
#import "Run.h"
#import "BadgeDetailsViewController.h"
#import "AppDelegate.h"
#import "BadgeController.h"


@interface BadgesTableViewController ()

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation BadgesTableViewController

bool isHidden = true;


-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    

   }



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue destinationViewController] isKindOfClass:[BadgeDetailsViewController class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        BadgeEarnStatus *earnStatus = [self.earnStatusArray objectAtIndex:indexPath.row];
        [(BadgeDetailsViewController *)[segue destinationViewController] setEarnStatus:earnStatus];
    }
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.earnStatusArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BadgeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BadgeCell" forIndexPath:indexPath];
    BadgeEarnStatus *earnStatus = [self.earnStatusArray objectAtIndex:indexPath.row];
    
    if (earnStatus.earnRun) {
        cell.nameLabel.textColor = [UIColor blackColor];
        cell.nameLabel.text = earnStatus.badge.name;
        cell.descLabel.textColor = [UIColor grayColor];
        cell.descLabel.text = [NSString stringWithFormat:@"Earned: %@", [self.dateFormatter stringFromDate:earnStatus.earnRun.timestamp]];
        cell.badgeImageView.image = [UIImage imageNamed:earnStatus.badge.imageName];

        cell.userInteractionEnabled = YES;
    } else {
        cell.nameLabel.textColor = nil;
        cell.nameLabel.text = nil;
        cell.descLabel.textColor = nil;
        cell.descLabel.text = nil;
        cell.badgeImageView.image = nil;
        cell.silverImageView.hidden = YES;
        cell.goldImageView.hidden = YES;
        cell.userInteractionEnabled = NO;
    }
    return cell;
}



@end
