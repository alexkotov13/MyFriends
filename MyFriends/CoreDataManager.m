//
//  CoreDataManager.m
//  MyFriends
//
//  Created by ann on 08.06.17.
//  Copyright (c) 2017 ann. All rights reserved.
//


#import "CoreDataManager.h"

@interface CoreDataManager()

@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation CoreDataManager
@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize subContext = _subContext;

static CoreDataManager *sharedManager = nil;

+(CoreDataManager *) sharedInstance
{
    @synchronized(self)
    {
        if (!sharedManager)
        {
           //sharedManager= [NSAllocateObject([self class], 0, NULL) init];
           sharedManager = [[CoreDataManager alloc] init];
        }
    }
    return sharedManager;
}

- (id) copyWithZone:(NSZone*)zone
{
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setupManagedObjectContext];
        [self setupNewManagedObjectContext];
    }
    return self;
}

-(void)setupNewManagedObjectContext
{
    _subContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _subContext.parentContext = self.managedObjectContext;
}

- (void)setupManagedObjectContext
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSURL* documentDirectoryURL = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
    NSURL* persistentURL = [documentDirectoryURL URLByAppendingPathComponent:@"MyFriends.sqlite"];
    NSURL* modelURL = [[NSBundle mainBundle] URLForResource:@"MyFriends" withExtension:@"momd"];
    self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    NSError* error = nil;
    NSPersistentStore* persistentStore = [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:persistentURL options:nil error:&error];
    if (persistentStore)
    {
        self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        self.managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    else
    {
        NSLog(@"ERROR: %@", error.description);
    }
}

- (void)saveContext
{
    NSError* error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if (![managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Friends" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setFetchBatchSize:20];
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:_managedObjectContext sectionNameKeyPath:nil
                                                   cacheName:@"View"];
    self.fetchedResultsController = theFetchedResultsController;   
    return _fetchedResultsController;
}

@end
