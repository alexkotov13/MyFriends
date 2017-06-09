//
//  ListUserViewController.h
//  MyFriends
//
//  Created by ann on 09.06.17.
//  Copyright (c) 2017 ann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendDescription.h"

@interface ListUserViewController: UITableViewController <NSFetchedResultsControllerDelegate>
@property(nonatomic, readwrite) CGSize viewScreen;

@property NSFetchedResultsController *fetchedResultsController;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
