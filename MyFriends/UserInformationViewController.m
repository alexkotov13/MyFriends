//
//  UserInformationViewController.m
//  MyFriends
//
//  Created by ann on 08.06.17.
//  Copyright (c) 2017 ann. All rights reserved.
//

#import "UserInformationViewController.h"

@interface UserInformationViewController ()
// NSIndexPath* _indexPath;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@end

@implementation UserInformationViewController

-(id)initWithIndexOfObject:(NSIndexPath *)indexPath
{
    self = [super init];
    if(self)
    {
        indexPath = [indexPath init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}



@end
