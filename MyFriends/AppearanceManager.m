//
//  AppearanceManager.m
//  MyFriends
//
//  Created by admin on 18.02.16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "AppearanceManager.h"
#import <QuartzCore/QuartzCore.h>

@implementation AppearanceManager

+ (instancetype)shared
{
    static AppearanceManager* instance = nil;
    
    if(!instance)
    {
        instance = [[AppearanceManager alloc] init];
    }
    return instance;
}


- (void)customizeButtonAppearance:(UIButton*)button CoordinatesX:(int)x Y:(int)y Width:(int)width Radius:(int)r
{
    [button setFrame:CGRectMake(x, y, width, 50)];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [[button layer] setBorderColor:[UIColor blackColor].CGColor];
    [[button layer] setBorderWidth:2];
    [[button layer] setCornerRadius:r];
    
    UIColor *topColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    UIColor *bottomColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    theViewGradient.frame = button.bounds;
    [theViewGradient setCornerRadius:r];
    [button.layer insertSublayer:theViewGradient atIndex:0];
}

- (void)customizeTopNavigationBarAppearance:(UINavigationBar*)navBar
{
    [navBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:UITextAttributeTextColor]];
    [navBar setTintColor:[UIColor colorWithWhite:0.7 alpha:1.0]];
    navBar.translucent = NO;
}

- (void)customizeToolbar:(UIToolbar*)toolbar
{
    [toolbar setTintColor:[UIColor colorWithWhite:0.7 alpha:1.0]];
}

- (void)customizeBackBarButtonAppearanceForNavigationBar:(UIBarButtonItem*)backBarButton
{
    [backBarButton setTintColor:[UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0]];
}

- (void)customizeViewController:(UIView*)view
{
    UIColor *topColor = [UIColor colorWithRed:92/255.0 green:196/255.0 blue:244/255.0 alpha:1.0];
    UIColor *Color = [UIColor colorWithRed:0 green:0 blue:0.5  alpha:1.0];
    UIColor *bottomColor = [UIColor colorWithRed:47/255.0 green:146/255.0 blue:229/255.0  alpha:1.0];
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)topColor.CGColor, (id)Color.CGColor, (id)bottomColor.CGColor, nil];
    theViewGradient.frame = view.bounds;
    theViewGradient.zPosition = 0.0f;
    [view.layer insertSublayer:theViewGradient atIndex:0];
    
}

@end
