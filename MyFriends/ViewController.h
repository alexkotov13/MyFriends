//
//  ViewController.h
//  MyFriends
//
//  Created by ann on 06.06.17.
//  Copyright (c) 2017 ann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInformationViewController.h"
#import "ListUserViewController.h"
#import "FriendDescription.h"
#import "CoreDataManager.h"
#import "AppearanceManager.h"

@interface ViewController : UITableViewController <NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource>

@property(nonatomic, readwrite) CGSize viewScreen;

@property NSFetchedResultsController *fetchedResultsController;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;


@end