//
//  ViewController.m
//  MyFriends
//
//  Created by ann on 06.06.17.
//  Copyright (c) 2017 ann. All rights reserved.
//

#import "ViewController.h"
//#import "UserInformationViewController.h"
#define COORDINATE 5
#define X_COORDINATE_FOR_LABEL 50
#define SIZE 35

@interface ViewController ()
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation ViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.title = @"My Friends";
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
     [[AppearanceManager shared] customizeBackBarButtonAppearanceForNavigationBar:self.navigationItem.leftBarButtonItem];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    [[AppearanceManager shared] customizeBackBarButtonAppearanceForNavigationBar:self.navigationItem.rightBarButtonItem];
    
    [[AppearanceManager shared] customizeTopNavigationBarAppearance:self.navigationController.navigationBar];  
    
    //[[AppearanceManager shared] customizeViewController:self.view];
    self.viewScreen = self.view.bounds.size;
    
    [self drawButton];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
    self.navigationController.navigationBarHidden = NO;
}

-(void)drawButton
{
    self.exitButton = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.exitButton setTitle:@"Exit" forState:UIControlStateNormal];
    [self.view addSubview:self.exitButton];
    [self.exitButton addTarget:self action:@selector(exitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [[AppearanceManager shared] customizeButtonAppearance:self.exitButton CoordinatesX:0 Y:self.viewScreen.height - 90 Width:self.viewScreen.width Radius:5];
    
}

-(void)btnBackClicked:(id)sender
{
    // [self.navigationController popToViewControllerAnimated:YES];
}

-(void)exitButtonClick:(id)sender
{
    NSString *nameAlert = @"Exit";
    self.alertExit = [[UIAlertView alloc] initWithTitle:nameAlert message:0 delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    [self.alertExit show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == self.alertExit)
        if (buttonIndex == 0)
            exit(0);
}


@end
