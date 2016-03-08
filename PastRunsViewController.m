//
//  PastRunsViewController.m
//  Tracker_1
//
//  Created by Anastasiia Staiko on 12/22/15.
//  Copyright © 2015 Anastasiia Staiko. All rights reserved.
//

#import "PastRunsViewController.h"
#import "DetailViewController.h"
#import "Run.h"
#import "RunCell.h"
#import "Math.h"
#import "BadgeController.h"
#import "Badge.h"

@interface PastRunsViewController () {
    
    NSMutableArray *rowsContent;
}

@end

@implementation PastRunsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
//    self.clearsSelectionOnViewWillAppear = YES;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    self.tableView.allowsMultipleSelectionDuringEditing = NO;
}



#pragma mark - Contents Assignment


-(void)setRunArray:(NSArray *)runArray {
    
    rowsContent = [NSMutableArray arrayWithArray:runArray];
    [self.tableView reloadData];
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return rowsContent.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RunCell *cell = (RunCell *)[tableView dequeueReusableCellWithIdentifier:@"RunCell"];
    Run *runObject = [rowsContent objectAtIndex:indexPath.row];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    cell.dateLabel.text = [formatter stringFromDate:runObject.timestamp];
    
    cell.distanceLabel.text = [Math stringifyDistance:runObject.distance.floatValue];
    
    Badge *badge = [[BadgeController defaultController] bestBadgeForDistance:runObject.distance.floatValue];
    cell.badgeImageView.image = [UIImage imageNamed:badge.imageName];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue destinationViewController] isKindOfClass:[DetailViewController class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Run *run = [rowsContent objectAtIndex:indexPath.row];
        [(DetailViewController *)[segue destinationViewController] setRun:run];
    }
}


#pragma mark - Table Changes


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
      
        [rowsContent removeObjectAtIndex:indexPath.row];

        
        NSMutableArray *savedArray = [NSMutableArray arrayWithObject:indexPath];
        
        [self.tableView deleteRowsAtIndexPaths:savedArray withRowAnimation:UITableViewRowAnimationAutomatic];


    }
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    
    return YES;
}



//#pragma mark Row reordering
// Determine whether a given row is eligible for reordering or not.
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
////// Process the row move. This means updating the data model to correct the item indices.
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
//      toIndexPath:(NSIndexPath *)toIndexPath {
//    NSString *item = [rowsContent objectAtIndex:fromIndexPath.row];
//    [rowsContent removeObject:item];
//    [rowsContent insertObject:item atIndex:toIndexPath.row];
//}
//




@end
