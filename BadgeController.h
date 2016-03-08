//
//  BadgeController.h
//  Tracker_1
//
//  Created by Anastasiia Staiko on 12/17/15.
//  Copyright © 2015 Anastasiia Staiko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Badge;
@class Run;

extern float const silverMultiplier;
extern float const goldMultiplier;

@interface BadgeController : NSObject

+ (BadgeController *)defaultController;

- (NSArray *)earnStatusesForRuns:(NSArray *)runArray;

- (Badge *)bestBadgeForDistance:(float)distance;

- (Badge *)nextBadgeForDistance:(float)distance;

- (NSArray *)annotationsForRun:(Run *)run; 

@end
