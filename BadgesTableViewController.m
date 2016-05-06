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


@interface BadgesTableViewController ()

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation BadgesTableViewController


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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
        
        if (!earnStatus.silverRun) {
            
            cell.silverImageView.hidden = NO;
        } else {
            cell.silverImageView.hidden = YES;
        }
        
        
        if (!earnStatus.goldRun) {
            cell.goldImageView.hidden = NO;
        } else {
            cell.goldImageView.hidden = YES;
        }
        
//        cell.silverImageView.hidden = !earnStatus.silverRun;
//        cell.goldImageView.hidden = !earnStatus.goldRun;

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


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
 
                
        BadgeEarnStatus *bStatus = [self.earnStatusArray objectAtIndex:indexPath.row];
        NSMutableArray *bArray = [[NSMutableArray alloc] init];
        [bArray insertObject:bStatus atIndex:0];

    
        [self.earnStatusArray removeObjectAtIndex:indexPath.row];
        
        NSMutableArray *savedArray = [NSMutableArray arrayWithObject:indexPath];
        
        [self.tableView deleteRowsAtIndexPaths:savedArray withRowAnimation:UITableViewRowAnimationAutomatic];

        
    }
}




// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
