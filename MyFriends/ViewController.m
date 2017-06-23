//
//  ViewController.m
//  MyFriends
//
//  Created by ann on 06.06.17.
//  Copyright (c) 2017 ann. All rights reserved.
//

#import "ViewController.h"


#define SIZE 35
#define COORDINATE 5
#define X_COORDINATE_FOR_LABEL 50

@interface ViewController ()
{
    CGFloat _width, _height;
    UIImage *_smallImage;
    FriendDescription *_info;
    NSMutableArray *_contentList;
    NSMutableArray *_filteredContentList;
    BOOL _isSearching;
}
@property (nonatomic, strong) UISearchBar *searchBar;
@property (strong, nonatomic) UISearchDisplayController *searchBarController;
@end

@implementation ViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _width = self.view.frame.size.width;
    _height = self.view.frame.size.height;
    
   
    
    [self setFetchedController];
    [self drawButton];
}
 
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
    self.navigationController.navigationBarHidden = NO;
}

-(void)drawButton
{
    self.title = NSLocalizedString(@"Title_for_view_controller", nil);
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    [[AppearanceManager shared] customizeBackBarButtonAppearanceForNavigationBar:self.navigationItem.leftBarButtonItem];
    //UIImage *faceImage = [UIImage imageNamed:@"updateButton"];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(editObject)];
    self.navigationItem.rightBarButtonItem = editButton;
    [[AppearanceManager shared] customizeBackBarButtonAppearanceForNavigationBar:self.navigationItem.rightBarButtonItem];
    
    [[AppearanceManager shared] customizeTopNavigationBarAppearance:self.navigationController.navigationBar];
    self.viewScreen = self.view.bounds.size;
}

-(void)setFetchedController
{
    _fetchedResultsController = [[CoreDataManager sharedInstance] fetchedResultsController];
    _fetchedResultsController.delegate = self;
    [NSFetchedResultsController deleteCacheWithName:@"View"];
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
}

-(void)editObject
{      
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    [newManagedObject setValue:@"Friend" forKey:@"firstName"];
    [newManagedObject setValue:@"" forKey:@"lastName"];
    [newManagedObject setValue:@"photo.png" forKey:@"imagePath"];
    UIImage *image = [UIImage imageNamed:@"photo.png"];
    [newManagedObject setValue:image forKey:@"thumbnail"];
    [newManagedObject setValue:@YES forKey:@"isFriend"];
    
    NSManagedObjectID *moID = [newManagedObject objectID];
    NSString *aString = [[moID URIRepresentation] absoluteString];
    [newManagedObject setValue:aString forKey:@"idFriend"];
    
    [[CoreDataManager sharedInstance] saveContext];
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
    //    if (editingStyle == UITableViewCellEditingStyleDelete)
    //    {
    //        // Delete the managed object for the given index path
    //        NSManagedObjectContext *context = [[CoreDataManager sharedInstance] managedObjectContext];
    //        _info = [_fetchedResultsController objectAtIndexPath:indexPath];
    //        [context deleteObject:_info.firstName];
    //        _info.isFriend = YES;
    //        _info.idFriend;
    _info = [_fetchedResultsController objectAtIndexPath:indexPath];
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        _info.isFriend = NO;
        NSManagedObjectContext *context = [[CoreDataManager sharedInstance] managedObjectContext];
        NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [context deleteObject:managedObject];
        [context save:nil];
        [tableView reloadData];
    }
    [[CoreDataManager sharedInstance] saveContext];
    
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
    _info = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    if(_info.isFriend)
    {
        _smallImage = [_info thumbnail];
        cell.imageView.image = _smallImage;
        cell.textLabel.text = [NSString stringWithFormat:@"%@%@%@",_info.firstName, @" ", _info.lastName];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _info = [_fetchedResultsController objectAtIndexPath:indexPath];
    _smallImage = [_info thumbnail];
    UserInformationViewController *userInformationViewController = [[UserInformationViewController alloc] initWithImage:_smallImage initWithFriendDescription:_info initWithIndexOfObject:indexPath];
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
