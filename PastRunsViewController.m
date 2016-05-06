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
#import "NewRunViewController.h"
#import "AppDelegate.h"


@interface PastRunsViewController ()


@end

@implementation PastRunsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
//    self.clearsSelectionOnViewWillAppear = YES;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor darkGrayColor] forKey:NSForegroundColorAttributeName]];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Contents Assignment

//
//-(void)setRunArray:(NSArray *)runArray {
//    _runArray = [runArray mutableCopy];
//    [self.tableView reloadData];
//}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.runArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RunCell *cell = (RunCell *)[tableView dequeueReusableCellWithIdentifier:@"RunCell"];
    Run *runObject = [self.runArray objectAtIndex:indexPath.row];
    
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
        Run *run = [self.runArray objectAtIndex:indexPath.row];
        [(DetailViewController *)[segue destinationViewController] setRun:run];
    }
}


#pragma mark - Table Changes

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    Run *run = [self.runArray objectAtIndex:indexPath.row];
        NSMutableArray * dArray=[[NSMutableArray alloc]init];
        [dArray insertObject:run atIndex:0];
        
    AppDelegate* tempDelegate= [[UIApplication sharedApplication] delegate];
        [tempDelegate.managedObjectContext deleteObject:run];
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] saveContext];
     
    NSError *error = nil;
    [self.managedObjectContext save:&error];
        
    if (error) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
        }
    
      
        [self.runArray removeObjectAtIndex:indexPath.row];

        NSMutableArray *savedArray = [NSMutableArray arrayWithObject:indexPath];
        
        [self.tableView deleteRowsAtIndexPaths:savedArray withRowAnimation:UITableViewRowAnimationAutomatic];


    }
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.

    
    return YES;
}


@end
