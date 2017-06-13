//
//  UserInformationViewController.h
//  MyFriends
//
//  Created by ann on 08.06.17.
//  Copyright (c) 2017 ann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "FriendDescription.h"
#import "CoreDataManager.h"
 
@interface UserInformationViewController : UIViewController <NSFetchedResultsControllerDelegate>

-(id)initWithIndexOfObject:(NSIndexPath *)indexPath;
-(id)initWithImage:(UIImage *)image initWithFriendDescription:(FriendDescription*) friendDescription initWithIndexOfObject:(NSIndexPath *)indexPath;

@end
