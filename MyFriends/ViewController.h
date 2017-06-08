//
//  ViewController.h
//  MyFriends
//
//  Created by ann on 06.06.17.
//  Copyright (c) 2017 ann. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "AppearanceManager.h"
#import <CoreData/CoreData.h>


//@class UserInformationViewController;

@interface ViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) UserInformationViewController *userInformationViewController;


@property(nonatomic, readwrite) UIButton *exitButton;
@property(nonatomic, readwrite) UIAlertView *alertExit;
@property(nonatomic, readwrite) CGSize viewScreen;

@end