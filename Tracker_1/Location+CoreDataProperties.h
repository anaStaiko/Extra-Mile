//
//  Location+CoreDataProperties.h
//  Tracker_1
//
//  Created by Anastasiia Staiko on 11/29/15.
//  Copyright © 2015 Anastasiia Staiko. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model. 
//

#import "Location.h"

NS_ASSUME_NONNULL_BEGIN

@interface Location (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *timestamp;
@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSManagedObject *run;

@end

NS_ASSUME_NONNULL_END
