//
//  ViewController.m
//  MyFriends
//
//  Created by ann on 06.06.17.
//  Copyright (c) 2017 ann. All rights reserved.
//

#import "ViewController.h"
#import "AppearanceManager.h"
#define COORDINATE 5
#define X_COORDINATE_FOR_LABEL 50
#define SIZE 35

@interface ViewController ()
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation ViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.title = @"My Friends";
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
     [[AppearanceManager shared] customizeBackBarButtonAppearanceForNavigationBar:self.navigationItem.leftBarButtonItem];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    [[AppearanceManager shared] customizeBackBarButtonAppearanceForNavigationBar:self.navigationItem.rightBarButtonItem];
    
    [[AppearanceManager shared] customizeTopNavigationBarAppearance:self.navigationController.navigationBar];  
    
    //[[AppearanceManager shared] customizeViewController:self.view];
    self.viewScreen = self.view.bounds.size;    
    [self drawButton];
    
    //_fetchedResultsController = [[CoreDataManager sharedInstance].fetchedResultsController];
    _fetchedResultsController.delegate = self;
    [NSFetchedResultsController deleteCacheWithName:@"Root"];
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error])
    {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
    self.navigationController.navigationBarHidden = NO;
}

-(void)drawButton
{
    self.exitButton = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.exitButton setTitle:@"Exit" forState:UIControlStateNormal];
    [self.view addSubview:self.exitButton];
    [self.exitButton addTarget:self action:@selector(exitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [[AppearanceManager shared] customizeButtonAppearance:self.exitButton CoordinatesX:0 Y:self.viewScreen.height - 90 Width:self.viewScreen.width Radius:5];
    
}

-(void)insertNewObject
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:@"First Name" forKey:@"firstName"];
    [newManagedObject setValue:@"Last Name" forKey:@"lastName"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

-(void)exitButtonClick:(id)sender
{
    NSString *nameAlert = @"Exit";
    self.alertExit = [[UIAlertView alloc] initWithTitle:nameAlert message:0 delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    [self.alertExit show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == self.alertExit)
        if (buttonIndex == 0)
            exit(0);
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
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
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(COORDINATE, COORDINATE, SIZE, SIZE)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *smallImage = [info thumbnail];
    //UIImage *smallImage = [[UIImage alloc] initWithContentsOfFile:@"photo.jpg"];
    imageView.image = smallImage;
    [cell addSubview:imageView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(X_COORDINATE_FOR_LABEL, COORDINATE, self.view.frame.size.width - SIZE * 2, SIZE)];
    label.text = info.titleFriend;
    [cell addSubview:label];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{     
    UserInformationViewController *userInformationViewController = [[UserInformationViewController alloc] initWithIndexOfObject:indexPath];
    [self.navigationController pushViewController:userInformationViewController animated:YES];
}



@end
