//
//  Filters.h
//  MyMedia
//
//  Created by Anastasiia Staiko on 4/5/16.
//  Copyright © 2016 Anastasiia Staiko. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ThumbNail.h"
#import "FiltersViewController.h"

@interface Filters : NSObject
//Class method to return all the availabe Filters in an Array of Strings
+(NSArray *) getAllFilters;

//Class method to return the Filtered Image
+(CIImage *) changeImage:(CIImage *) image withFilter:(NSString *) filter;
@end
