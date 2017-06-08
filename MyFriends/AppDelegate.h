//
//  AppDelegate.h
//  MyFriends
//
//  Created by ann on 06.06.17.
//  Copyright (c) 2017 ann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataManager.h"
#import "CoreData/CoreData.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (NSURL *)applicationDocumentsDirectory;

@end
