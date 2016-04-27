//
//  FiltersViewController.h
//  MyMedia
//
//  Created by Anastasiia Staiko on 4/5/16.
//  Copyright © 2016 Anastasiia Staiko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThumbNail.h"
#import "Filters.h"



@protocol FilterControllerDelegate <NSObject>

-(void) userDidMakeChoice:(NSString *)choice;

@end

@interface FiltersViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) id <FilterControllerDelegate> delegate;

@property NSArray *properties;
@property (weak, nonatomic) UIPopoverController *popoverController;
@property (weak, nonatomic) IBOutlet UITableView *tView;
@property UIImage *image;
@property NSMutableDictionary *previews;

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;


- (IBAction)goBack:(id)sender;



@end
