//
//  ThumbNail.h
//  MyMedia
//
//  Created by Anastasiia Staiko on 4/5/16.
//  Copyright © 2016 Anastasiia Staiko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Filters.h"
#import "FiltersViewController.h"

#define THUMBNAIL_SIZE 70

@interface ThumbNail : NSObject

//Creates a Square Thumbnail from an UIImage with the Size defined above
+(UIImage *) createThumbNailFromImage : (UIImage *) image;

@end
