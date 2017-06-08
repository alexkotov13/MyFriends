//
//  CoreDataManager.h
//  MyFriends
//
//  Created by ann on 08.06.17.
//  Copyright (c) 2017 ann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"


@interface CoreDataManager : NSObject

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectContext *subContext;

+ (CoreDataManager *)sharedInstance;
- (void)saveContext;

@end