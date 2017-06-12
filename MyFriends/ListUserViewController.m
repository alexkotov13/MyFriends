//
//  ListUserViewController.m
//  MyFriends
//
//  Created by ann on 09.06.17.
//  Copyright (c) 2017 ann. All rights reserved.
//

#import "ListUserViewController.h"
#import "AppearanceManager.h"
#import "CoreDataManager.h"
#import "AFNetworking.h"
#define SIZE 35

@interface ListUserViewController ()
@end

@implementation ListUserViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Title_for_list_user_view_controller", nill);
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    [[AppearanceManager shared] customizeBackBarButtonAppearanceForNavigationBar:self.navigationItem.leftBarButtonItem];
    
    UIBarButtonItem *updateButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(updateObject)];
    self.navigationItem.rightBarButtonItem = updateButton;
    [[AppearanceManager shared] customizeBackBarButtonAppearanceForNavigationBar:self.navigationItem.rightBarButtonItem];
    
    [[AppearanceManager shared] customizeTopNavigationBarAppearance:self.navigationController.navigationBar];
    self.viewScreen = self.view.bounds.size;
    
    _fetchedResultsController = [[CoreDataManager sharedInstance] fetchedResultsController];
    _fetchedResultsController.delegate = self;
    [NSFetchedResultsController deleteCacheWithName:@"View"];
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error])
    {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    NSURL *url = [[NSURL alloc] initWithString:NSLocalizedString(@"URL_title", nill)];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"%@", JSON);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
    }];    
    [operation start];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
    self.navigationController.navigationBarHidden = NO;
}

-(void)updateObject
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    [newManagedObject setValue:@"First Name" forKey:@"firstName"];
    [newManagedObject setValue:@"Last Name" forKey:@"lastName"];
  
    
    [self saveContext];
}
- (void)saveContext {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id  sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [[CoreDataManager sharedInstance] managedObjectContext];
        FriendDescription *info = [_fetchedResultsController objectAtIndexPath:indexPath];
        [context deleteObject:info];
        
        [[CoreDataManager sharedInstance] saveContext];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellSeparatorStyleSingleLine;
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

-(void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    FriendDescription *info = [_fetchedResultsController objectAtIndexPath:indexPath];
    // UIImage *smallImage = [info thumbnail];
    UIImage * image = [UIImage imageNamed:@"Yuliya.jpg"];
    cell.imageView.image = image;
    cell.textLabel.text = @"Yuliya";
    //    //label.text = info.titleFriend;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInformationViewController *userInformationViewController = [[UserInformationViewController alloc] init];
    [self.navigationController pushViewController:userInformationViewController animated:YES];
}

#pragma mark - NSFetchResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

@end
