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
@dynamic titleFriend;
@dynamic thumbnail;

-(void)setImagePathWithImage:(UIImage *)image
{
    NSDate* now = [NSDate date];
    NSString* caldate = [now description];
    NSString* recorderFilePath = [NSString stringWithFormat:@"%@/.png", caldate];
    NSData* data = UIImageJPEGRepresentation(image, 1.0f);
    [data writeToFile:recorderFilePath atomically:YES];
    self.imagePath = recorderFilePath;
}

- (void)prepareForDeletion
{
    [self deleteImageFromPath];
}

-(void)deleteImageFromPath
{
    if (self.imagePath)
    {
        NSString* image = self.imagePath;
        NSURL* fullURL = [NSURL fileURLWithPath: image];
        [[NSFileManager defaultManager] removeItemAtURL:fullURL error: nil];
    }
}

-(NSString *)title
{
    return self.titleFriend;
}

@end


