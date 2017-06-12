//
//  CameraViewController.m
//  MyFriends
//
//  Created by ann on 12.06.17.
//  Copyright (c) 2017 ann. All rights reserved.
//

#import "CameraViewController.h"


CGSize view;

@interface CameraViewController ()
{
    UIButton *library;
    UIButton *camera;
    UIButton *cencel;
}
@end

@implementation CameraViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    [[AppearanceManager shared] customizeViewController:self.view];
    view = self.view.bounds.size;
    [self drawButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
    self.navigationController.navigationBarHidden = YES;
}

-(void)drawButton
{
    library = [[UIButton alloc]initWithFrame:CGRectZero];
    [library setTitle:NSLocalizedString(@"Choose_library_button", nil) forState:UIControlStateNormal];
    [self.view addSubview:library];
    [library addTarget:self action:@selector(libraryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [[AppearanceManager shared] customizeButtonAppearance:library CoordinatesX:view.width / 4 - 60 Y:view.height / 4  Width:view.width - 40 Radius:10];
    
    camera = [[UIButton alloc]initWithFrame:CGRectZero];
    [camera setTitle:NSLocalizedString(@"Choose_camera_button", nil) forState:UIControlStateNormal];
    [self.view addSubview:camera];
    [camera addTarget:self action:@selector(cameraButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [[AppearanceManager shared] customizeButtonAppearance:camera CoordinatesX:view.width / 4 - 60 Y:view.height / 2.2 Width:view.width - 40 Radius:10];
    
    cencel = [[UIButton alloc]initWithFrame:CGRectZero];
    [cencel setTitle:NSLocalizedString(@"Cancel_button_title", nil) forState:UIControlStateNormal];
    [self.view addSubview:cencel];
    [cencel addTarget:self action:@selector(cencelClick:) forControlEvents:UIControlEventTouchUpInside];
    [[AppearanceManager shared] customizeButtonAppearance:cencel CoordinatesX:view.width / 4 - 60 Y:view.height / 1.5 Width:view.width - 40 Radius:10];
}
UIImagePickerController *imagePicker;
- (void)libraryButtonClick:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Alert_Library_title", nil)                                                        message:NSLocalizedString(@"Message_alert_Library", nil)                              
                                                      delegate:nil
                                             cancelButtonTitle:NSLocalizedString(@"OK_button_title", nil)
                                             otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
    }
}

- (void) imagePickerController:(UIImagePickerController *)picker
 didFinishPickingMediaWithInfo:(NSDictionary *)info
{    
    //    imagePicker = [[UIImagePickerController alloc]init];
    //    [self.navigationController pushViewController:imagePicker animated:YES];
    UserInformationViewController *userInformationViewController = [[UserInformationViewController alloc]init];
    [self.navigationController pushViewController:userInformationViewController animated:YES];    
}

- (void)cameraButtonClick:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Alert_Camera_title", nil)                                                       message:NSLocalizedString(@"Message_alert_Camera", nil)
                                                      delegate:nil
                                             cancelButtonTitle:NSLocalizedString(@"OK_button_title", nil)
                                             otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
    }
}

-(void)cencelClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end