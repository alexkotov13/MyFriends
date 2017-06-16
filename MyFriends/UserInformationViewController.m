//
//  UserInformationViewController.m
//  MyFriends
//
//  Created by ann on 08.06.17.
//  Copyright (c) 2017 ann. All rights reserved.
//

#import "UserInformationViewController.h"
#import "CameraViewController.h"
#import <QuartzCore/QuartzCore.h>

#define CENTRE_OBJECT 1
#define COUNT_OBJECTS 3
#define BOTTOM_MARGIN 95.0f
#define TOP_MARGIN 65.0f
#define LABEL_AND_BUTTON_HEIGHT 32.0f
#define LABEL_AND_BUTTON_WIGHT 200.0f

@interface UserInformationViewController ()  <UIScrollViewDelegate, UITextFieldDelegate,NSFetchedResultsControllerDelegate>
{
    NSIndexPath* _indexPath;
    NSMutableArray* _pages;
    NSInteger _countOfObjects;
    CGFloat _width, _height;
    UIToolbar* _toolBar;
    NSInteger _currIndex;
    UITextField * _firstNameTextField;
    UITextField * _lastNameTextField;
    UITextField * _phoneTextField;
    UITextField * _emailTextField;
    UIButton * _changeImage;
    UIImage *_pickedImage;
    FriendDescription* _friendDescription;
    BOOL flagValidate;
    CGSize keyboardSize;
}

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property UIScrollView * scrollView;
@property(nonatomic,retain) UIImageView* imageView;
@property(nonatomic, retain) UIImage* image;
@end

@implementation UserInformationViewController

//@synthesize fetchedResultsController = _fetchedResultsController;

- (id)initWithImage:(UIImage *)image initWithFriendDescription:(FriendDescription*) friendDescription initWithIndexOfObject:(NSIndexPath *)indexPath
{
    self = [super init];
    if (self)
    {
        _pickedImage = image;
        _friendDescription = friendDescription;
        _indexPath = indexPath;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    flagValidate = YES;
    _width = self.view.frame.size.width;
    _height = self.view.frame.size.height;
    
    [[AppearanceManager shared] customizeViewController:self.view];
    [self createScrollView];
    
    [self setFetchedController];
    
    self.title = NSLocalizedString(@"Title_for_user_information_view_controller", nill);
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(saveObject)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [[AppearanceManager shared] customizeBackBarButtonAppearanceForNavigationBar:self.navigationItem.leftBarButtonItem];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Saved_button_title", nill) style:UIBarButtonItemStyleBordered target:self action:@selector(saveObject)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [[AppearanceManager shared] customizeBackBarButtonAppearanceForNavigationBar:self.navigationItem.rightBarButtonItem];
    
    [[AppearanceManager shared] customizeTopNavigationBarAppearance:self.navigationController.navigationBar];
    
    _fetchedResultsController = [[CoreDataManager sharedInstance] fetchedResultsController];
    _fetchedResultsController.delegate = self;
    [NSFetchedResultsController deleteCacheWithName:@"View"];
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error])
    {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    _firstNameTextField = [self _drawTextFieldWithText:_friendDescription.firstName placeholderWithTextField:NSLocalizedString(@"FirstNameTextView_text", nil) yTextField:_height + _width - _width * 0.6];
    _lastNameTextField = [self _drawTextFieldWithText:_friendDescription.lastName placeholderWithTextField:NSLocalizedString(@"LastNameTextView_text", nil) yTextField:_height +_width - _width * 0.4];
    _emailTextField = [self _drawTextFieldWithText:_friendDescription.email placeholderWithTextField:NSLocalizedString(@"EmailTextView_text", nil) yTextField:_height + _width - _width * 0.2];
    _phoneTextField = [self _drawTextFieldWithText:_friendDescription.phone placeholderWithTextField:NSLocalizedString(@"PhoneTextView_text", nil) yTextField:_height + _width];
    
    _changeImage = [[UIButton alloc]initWithFrame:CGRectZero];
    [_changeImage setTitle:NSLocalizedString(@"Change_image_button_title", nil) forState:UIControlStateNormal];
    [_changeImage addTarget:self action:@selector(_changeImageClick:) forControlEvents:UIControlEventTouchUpInside];
    [[AppearanceManager shared] customizeButtonAppearance:_changeImage CoordinatesX:20 Y:_height + _width - _width * 0.85 Width:_width - 40 Radius:10];
    [_scrollView addSubview:_changeImage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myNotificationMethod:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
}
- (void)myNotificationMethod:(NSNotification*)notification
{
    keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    //CGPoint newSize = CGPointMake(0, keyboardSize.height + _scrollView.contentSize.height * 0.5);
    //_scrollView.contentOffset = newSize;
    _scrollView.contentSize = CGSizeMake(_width, keyboardSize.height + _height * 2);
}

-(void)_changeImageClick:(id)sender
{
    CameraViewController *cameraViewController = [[CameraViewController alloc]initWithFriendDescription:_friendDescription initWithIndexOfObject:_indexPath];
    [self.navigationController pushViewController:cameraViewController animated:YES];
}

-(UITextField*)_drawTextFieldWithText:(NSString*)text placeholderWithTextField:(NSString*)placeholder yTextField:(int)y
{
    UITextField *myTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, y, _width - 40, LABEL_AND_BUTTON_HEIGHT)];
    [myTextField setFont:[UIFont fontWithName:NSLocalizedString(@"Text_font", nil) size:18]];
    myTextField.textColor = [UIColor blackColor];
    myTextField.backgroundColor = [UIColor whiteColor];
    myTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    myTextField.textAlignment = NSTextAlignmentCenter;
    myTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    myTextField.text = text;
    myTextField.placeholder = placeholder;
    myTextField.delegate = self;
    [myTextField resignFirstResponder];
    [_scrollView addSubview:myTextField];
    return myTextField;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if(textField ==_firstNameTextField)
    {
        CGPoint newSize = CGPointMake(0, _firstNameTextField.frame.origin.y + 40);
        _scrollView.contentOffset = newSize;
    }
    if(textField ==_lastNameTextField)
    {
        CGPoint newSize = CGPointMake(0, _lastNameTextField.frame.origin.y + 40);
        _scrollView.contentOffset = newSize;
    }
    if(textField ==_emailTextField)
    {
        CGPoint newSize = CGPointMake(0, _emailTextField.frame.origin.y + 40);
        _scrollView.contentOffset = newSize;
    }
    
    if(textField ==_phoneTextField)
    {
        CGPoint newSize = CGPointMake(0, _phoneTextField.frame.origin.y + 40);
        _scrollView.contentOffset = newSize;
    }
    return YES;
}

#pragma mark - validate

-(void) textFieldDidEndEditing:(UITextField  *)textField
{
    if(textField ==_firstNameTextField)
    {
        NSString *regex = @"[A-Za-z]+";
        NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if ([nameTest evaluateWithObject:textField.text] == NO)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Enter Valid First Name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            UIImageView *imgforLeft=[[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 20, 20)];
            [imgforLeft setImage:[UIImage imageNamed:@"error.png"]];
            textField.leftView = imgforLeft;
            flagValidate = NO;
        }
        else
        {
            textField.leftView.backgroundColor = [UIColor whiteColor];
            textField.layer.borderWidth= 0;
            flagValidate = YES;
        }
    }
    if(textField ==_lastNameTextField)
    {
        NSString *regex = @"[A-Za-z]+";
        NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if ([nameTest evaluateWithObject:textField.text] == NO)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Enter Valid Last Name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            UIImageView *imgforLeft=[[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 20, 20)];
            [imgforLeft setImage:[UIImage imageNamed:@"error.png"]];
            textField.leftView = imgforLeft;
            flagValidate = NO;
        }
        else
        {
            textField.leftView.backgroundColor = [UIColor whiteColor];
            textField.layer.borderWidth= 0;
            flagValidate = YES;
        }
    }
    
    if(textField ==_emailTextField)
    {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if ([emailTest evaluateWithObject:textField.text] == NO)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Enter Valid Email Address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            UIImageView *imgforLeft=[[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 20, 20)];
            [imgforLeft setImage:[UIImage imageNamed:@"error.png"]];
            textField.leftView = imgforLeft;
            flagValidate = NO;
        }
        else
        {
            textField.leftView.backgroundColor = [UIColor whiteColor];
            textField.layer.borderWidth= 0;
            flagValidate = YES;
        }
    }
    if(textField ==_phoneTextField &&  flagValidate == YES)
    {
        textField.layer.borderWidth= 0;
    }    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField ==_firstNameTextField)
    {
        [self textFieldBorderStyle:textField];
    }
    if(textField ==_lastNameTextField)
    {
        [self textFieldBorderStyle:textField];
    }
    if(textField ==_emailTextField)
    {
        [self textFieldBorderStyle:textField];
    }
    
    if(textField ==_phoneTextField)
    {
        [self textFieldBorderStyle:textField];
        
        NSUInteger currentLength = textField.text.length;
        NSCharacterSet *numbers = [NSCharacterSet decimalDigitCharacterSet];
        if (range.length == 1)
        {
            return YES;
        }
        if ([numbers characterIsMember:[string characterAtIndex:0]])
        {
            if ( currentLength == 3 )
            {
                if (range.length != 1)
                {
                    NSString *firstThreeDigits = [textField.text substringWithRange:NSMakeRange(0, 3)];
                    NSString *updatedText;
                    if ([string isEqualToString:@"-"])
                    {
                        updatedText = [NSString stringWithFormat:@"%@",firstThreeDigits];
                    }
                    else
                    {
                        updatedText = [NSString stringWithFormat:@"%@-",firstThreeDigits];
                    }
                    [textField setText:updatedText];
                }
            }
            else if ( currentLength > 3 && currentLength < 8 )
            {
                if ( range.length != 1 )
                {
                    NSString *firstThree = [textField.text substringWithRange:NSMakeRange(0, 3)];
                    NSString *dash = [textField.text substringWithRange:NSMakeRange(3, 1)];
                    
                    NSUInteger newLenght = range.location - 4;
                    
                    NSString *nextDigits = [textField.text substringWithRange:NSMakeRange(4, newLenght)];
                    
                    NSString *updatedText = [NSString stringWithFormat:@"%@%@%@",firstThree,dash,nextDigits];
                    
                    [textField setText:updatedText];
                }
            }
            else if ( currentLength == 8 )
            {
                if ( range.length != 1 )
                {
                    NSString *areaCode = [textField.text substringWithRange:NSMakeRange(0, 3)];
                    
                    NSString *firstThree = [textField.text substringWithRange:NSMakeRange(4, 3)];
                    
                    NSString *nextDigit = [textField.text substringWithRange:NSMakeRange(7, 1)];
                    
                    [textField setText:[NSString stringWithFormat:@"%@-%@-%@",areaCode,firstThree,nextDigit]];
                }
            }
            NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
            if (proposedNewLength > 12)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Numbers all"   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                flagValidate = NO;
                return NO;
            }
            flagValidate = YES;
            return YES;
        }
        else
        {
            flagValidate = NO;
            return NO;
        }
        return YES;
    }
    return YES;
}

-(void)textFieldBorderStyle:(UITextField*)textField
{
    textField.borderStyle = UITextBorderStyleLine;
    textField.layer.borderColor = [[UIColor redColor]CGColor];
    textField.layer.borderWidth= 2.0;
    textField.leftViewMode = UITextFieldViewModeAlways;    
}

-(void)createScrollView
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.contentMode = UIViewContentModeScaleAspectFit;
    _scrollView.frame = CGRectMake(0, 0,_width, _height);
	_scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = YES;
    NSInteger viewcount = 2;
    _scrollView.contentSize = CGSizeMake(_width, _height * viewcount);
    [self.view addSubview:_scrollView];
    [self drawbackdroundImage];
}

-(void)drawbackdroundImage
{
    //FriendDescription* friendDescription = [_fetchedResultsController objectAtIndexPath:_indexPath];
    //_imageView.image = [UIImage imageWithContentsOfFile:friendDescription.imagePath];
    _imageView = [[UIImageView alloc] initWithImage:_pickedImage];
    [_imageView setContentMode:UIViewContentModeScaleAspectFit];
    _imageView.frame = CGRectMake(0, 0, _width, _height);
    [_scrollView addSubview:_imageView];
}

-(void)setFetchedController
{
    _fetchedResultsController = [[CoreDataManager sharedInstance] fetchedResultsController];
    [NSFetchedResultsController deleteCacheWithName:@"Root"];
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    _countOfObjects = _fetchedResultsController.fetchedObjects.count;
}

-(void)saveObject
{
    if(flagValidate)
    {
        if(_firstNameTextField.textColor == [UIColor blackColor])
        {
            _friendDescription.firstName = _firstNameTextField.text;
            _friendDescription.lastName = _lastNameTextField.text;
            _friendDescription.email = _emailTextField.text;
            _friendDescription.phone = _phoneTextField.text;
        }
        NSError* error = nil;
        NSManagedObjectContext *managedObjectContext = [[CoreDataManager sharedInstance] subContext];
        [managedObjectContext save:&error];
        [[CoreDataManager sharedInstance] saveContext];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save !" message:@"Changes saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        ViewController *viewController = [[ViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Enter Valid Data." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)cencelClick:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Changes don't saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
