//
//  CameraViewController.h
//  MyFriends
//
//  Created by ann on 12.06.17.
//  Copyright (c) 2017 ann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInformationViewController.h"
#import "ViewController.h"

@interface CameraViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

-(id)initWithFriendDescription:(FriendDescription*) friendDescription initWithIndexOfObject:(NSIndexPath *)indexPath;

@end
