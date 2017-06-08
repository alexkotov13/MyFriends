//
//  AppearanceManager.h
//  MyFriends
//
//  Created by admin on 18.02.16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppearanceManager : NSObject

+ (instancetype)shared;

//- (void)customizeBarButtonAppearance:(UIBarButtonItem*)barButton;
-(void)customizeButtonAppearance:(UIButton*)button CoordinatesX:(int)x Y:(int)y Width:(int)width Radius:(int)r;
- (void)customizeTopNavigationBarAppearance:(UINavigationBar*)navBar;
- (void)customizeBackBarButtonAppearanceForNavigationBar:(UIBarButtonItem*)backBarButton;
- (void)customizeToolbar:(UIToolbar*)toolbar;
- (void)customizeViewController:(UIView*)view;


@end
