//
//  Math.h
//  Tracker_1
//
//  Created by Anastasiia Staiko on 11/30/15.
//  Copyright © 2015 Anastasiia Staiko. All rights reserved. 
//

#import <Foundation/Foundation.h>

@interface Math : NSObject

+ (NSString *)stringifyDistance:(float)meters;
+ (NSString *)stringifySecondCount:(int)seconds usingLongFormat:(BOOL)longFormat;
+ (NSString *)stringifyAvgPaceFromDist:(float)meters overTime:(int)seconds;

+ (NSArray *)colorSegmentsForLocations:(NSArray *)locations; 

@end

