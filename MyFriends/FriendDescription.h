//
//  FriendDescription.h
//  MyFriends
//
//  Created by ann on 08.06.17.
//  Copyright (c) 2017 ann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface FriendDescription : NSObject

@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) NSString * titleFriend;
@property (nonatomic, retain) id thumbnail;
-(void)setImagePathWithImage:(UIImage *)image;

@end
