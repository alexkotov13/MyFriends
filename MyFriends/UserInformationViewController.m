//
//  UserInformationViewController.m
//  MyFriends
//
//  Created by ann on 08.06.17.
//  Copyright (c) 2017 ann. All rights reserved.
//

#import "UserInformationViewController.h"
#import "AppearanceManager.h"
#import "CoreDataManager.h"
#import "CameraViewController.h"

#define CENTRE_OBJECT 1
#define COUNT_OBJECTS 3
#define BOTTOM_MARGIN 95.0f
#define TOP_MARGIN 65.0f
#define LABEL_AND_BUTTON_HEIGHT 32.0f
#define LABEL_AND_BUTTON_WIGHT 200.0f

@interface UserInformationViewController ()  <UIScrollViewDelegate, UITextViewDelegate>
{
    NSIndexPath* _indexPath;
    NSMutableArray* _pages;
    NSInteger _countOfObjects;
    CGFloat _width, _height;
    UIToolbar* _toolBar;
    NSInteger _currIndex;
    UITextView * _firstNameTextView;
    UITextView * _lastNameTextView;
    UITextView * _phoneTextView;
    UITextView * _emailTextView;
    UIButton * _changeImage;
    UIImage *pickedImage;
    FriendDescription* _friendDescription;

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
        pickedImage = image;
        _friendDescription = friendDescription ;
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
    
    _width = self.view.frame.size.width;
    _height = self.view.frame.size.height;
    
    [[AppearanceManager shared] customizeViewController:self.view];
    [self createScrollView];
    //[self addItemsToScrollView];        
    
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

  
    _firstNameTextView = [self _drawTextViewWithText: NSLocalizedString(@"FirstNameTextView_text", nil) yTextView:_height + _width - _width * 0.6];
    _lastNameTextView = [self _drawTextViewWithText:NSLocalizedString(@"LastNameTextView_text", nil) yTextView:_height +_width - _width * 0.4];
    _emailTextView = [self _drawTextViewWithText:NSLocalizedString(@"EmailTextView_text", nil) yTextView:_height + _width - _width * 0.2];
    _phoneTextView = [self _drawTextViewWithText:NSLocalizedString(@"PhoneNameTextView_text", nil) yTextView:_height + _width];
    
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
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size; 
    CGPoint newSize = CGPointMake(0, keyboardSize.height + _scrollView.contentSize.height * 0.5);
    _scrollView.contentOffset = newSize;
}


-(void)_changeImageClick:(id)sender
{
    CameraViewController *cameraViewController = [[CameraViewController alloc]init];
    [self.navigationController pushViewController:cameraViewController animated:YES];
}

-(UITextView *)_drawTextViewWithText:(NSString*)placeholderText yTextView:(int)y
{
    UITextView * myTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, y, _width - 40, LABEL_AND_BUTTON_HEIGHT)];
    [myTextView setFont:[UIFont fontWithName:NSLocalizedString(@"Text_font", nil) size:14]];    
    myTextView.textColor = [UIColor lightGrayColor];
    myTextView.text = placeholderText;
    myTextView.delegate = self;
    [myTextView resignFirstResponder];
    [_scrollView addSubview:myTextView];
    return myTextView;
}

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    if (textView.textColor == [UIColor lightGrayColor]) {
        textView.text = NSLocalizedString(@"TextView_is_empty", nil);
        textView.textColor = [UIColor blackColor];
    }    
}

-(void) textViewDidChange:(UITextView *)textView
{   
    if(textView.text.length == 0){
        textView.textColor = [UIColor lightGrayColor];
        [self _setText:textView];
        [textView resignFirstResponder];
    }
}

- (void)_setText:(UITextView *)textView
{
    if(textView == _firstNameTextView)
        textView.text = NSLocalizedString(@"FirstNameTextView_text", nil);
    else if(textView == _lastNameTextView)
        textView.text = NSLocalizedString(@"LastNameTextView_text", nil);
    else if(textView == _emailTextView)
        textView.text = NSLocalizedString(@"EmailTextView_text", nil);
    else if(textView == _phoneTextView)
        textView.text = NSLocalizedString(@"PhoneTextView_text", nil);
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
//    FriendDescription* friendDescription = [_fetchedResultsController objectAtIndexPath:_indexPath];
    //_imageView.image = [UIImage imageWithContentsOfFile:friendDescription.imagePath];
    _imageView = [[UIImageView alloc] initWithImage:pickedImage];
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
    _friendDescription.firstName = _firstNameTextView.text;
    _friendDescription.lastName = _lastNameTextView.text;
    _friendDescription.email = _emailTextView.text;
    _friendDescription.phone = _phoneTextView.text;
    NSError* error = nil;
    NSManagedObjectContext *managedObjectContext = [[CoreDataManager sharedInstance] subContext];
    [managedObjectContext save:&error];
    [[CoreDataManager sharedInstance] saveContext];
    
    ViewController *viewController = [[ViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];   
  
}







@end
