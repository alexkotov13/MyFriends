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

@property (nonatomic, readwrite) NSFetchedResultsController *fetchedResultsController;
@property NSManagedObjectContext *managedObjectContext;
//@property NSManagedObjectContext *subContext;

+ (CoreDataManager *)sharedInstance;
- (NSFetchedResultsController *)fetchedResultsController;
- (void)saveContext;

@end