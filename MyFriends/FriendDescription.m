//
//  FriendDescription.m
//  MyFriends
//
//  Created by ann on 08.06.17.
//  Copyright (c) 2017 ann. All rights reserved.
//

#import "FriendDescription.h"


@interface FriendDescription()

@end

@implementation FriendDescription

@dynamic imagePath;
@dynamic firstName;
@dynamic lastName;
@dynamic phone;
@dynamic email;
@dynamic thumbnail;
@dynamic isFriend;
@dynamic idFriend;

- (NSString*)withImage
{
    return self.imagePath;
}

-(NSString *)titleFirstName
{
    return self.firstName;
}
-(NSString *)titleLastName
{
    return self.lastName;
}
-(NSString *)titlePhone
{
    return self.phone;
}
-(NSString *)titleEmail
{
    return self.email;
}

@end


