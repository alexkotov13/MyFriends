//
//  ViewController.h
//  MyFriends
//
//  Created by ann on 06.06.17.
//  Copyright (c) 2017 ann. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "UserInformationViewController.h"
#import "CoreDataManager.h"
#import "FriendDescription.h"



@interface ViewController : UITableViewController <NSFetchedResultsControllerDelegate>




@property(nonatomic, readwrite) UIButton *exitButton;
@property(nonatomic, readwrite) UIAlertView *alertExit;
@property(nonatomic, readwrite) CGSize viewScreen;

@end