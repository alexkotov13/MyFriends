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



@property (nonatomic) NSString * imagePath;
@property (nonatomic) NSString * firstName;
@property (nonatomic) NSString * lastName;
@property (nonatomic) NSString * phone;
@property (nonatomic) NSString * email;
@property (nonatomic) BOOL isFriend;
@property (nonatomic) NSString * idFriend;
@property (nonatomic) id thumbnail;

@end
