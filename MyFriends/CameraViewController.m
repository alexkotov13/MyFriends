//
//  CameraViewController.m
//  MyFriends
//
//  Created by ann on 12.06.17.
//  Copyright (c) 2017 ann. All rights reserved.
//

#import "CameraViewController.h"
#import "UserInformationViewController.h"


CGSize view;

@interface CameraViewController ()
{
    UIButton *library;
    UIButton *camera;
    UIButton *cencel;
    FriendDescription* _friendDescription;
}
@property(nonatomic, retain) FriendDescription* friendDescription;
@end

@implementation CameraViewController

-(id)initWithPointDescription:(FriendDescription*) friendDescription
{
    self = [super init];
    if(self)
    {
        _friendDescription = friendDescription ;
    }
    return self;
}
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
    UIImage *pickedImage = [info objectForKey: UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [_friendDescription setImagePathWithImage:pickedImage];
    
    UserInformationViewController *userInformationViewController = [[UserInformationViewController alloc] initWithImage:pickedImage initWithFriendDescription:_friendDescription initWithIndexOfObject:nil];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSError* error = nil;
    NSManagedObjectContext *managedObjectContext = [[CoreDataManager sharedInstance] subContext];
    [managedObjectContext save:&error];
    [[CoreDataManager sharedInstance] saveContext];
}

-(void)cencelClick:(id)sender
{
    UserInformationViewController *userInformationViewController = [[UserInformationViewController alloc] init];
    [self.navigationController pushViewController:userInformationViewController animated:YES];
}

@end