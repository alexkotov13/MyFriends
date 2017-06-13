//
//  CameraViewController.h
//  MyFriends
//
//  Created by ann on 12.06.17.
//  Copyright (c) 2017 ann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppearanceManager.h"
#import "UserInformationViewController.h"

@interface CameraViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate>
-(id)initWithPointDescription:(FriendDescription*) friendDescription;

@end
