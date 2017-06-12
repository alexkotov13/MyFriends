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
    UIScrollView * _scrollView;
    UITextView * _firstNameTextView;
    UITextView * _lastNameTextView;
    UITextView * _phoneTextView;
    UITextView * _emailTextView;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@end

@implementation UserInformationViewController
//@synthesize fetchedResultsController = _fetchedResultsController;

-(id)initWithIndexOfObject:(NSIndexPath *)indexPath
{
    self = [super init];
    if(self)
    {
        _indexPath = [indexPath init];
    }
    return self;
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

    
    self.title = @"Friends Information";
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(saveObject)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [[AppearanceManager shared] customizeBackBarButtonAppearanceForNavigationBar:self.navigationItem.leftBarButtonItem];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveObject)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [[AppearanceManager shared] customizeBackBarButtonAppearanceForNavigationBar:self.navigationItem.rightBarButtonItem];
    
    [[AppearanceManager shared] customizeTopNavigationBarAppearance:self.navigationController.navigationBar];
    
    /*_fetchedResultsController = [[CoreDataManager sharedInstance] fetchedResultsController];
    _fetchedResultsController.delegate = self;
    [NSFetchedResultsController deleteCacheWithName:@"View"];
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error])
    {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}*/

  
    _firstNameTextView = [self _drawTextViewWithText:@"First Name input" yTextView:_height + _width - _width * 0.8];
    _lastNameTextView = [self _drawTextViewWithText:@"Last Name input" yTextView:_height +_width - _width * 0.6];
    _emailTextView = [self _drawTextViewWithText:@"Email input" yTextView:_height + _width - _width * 0.4];
    _phoneTextView = [self _drawTextViewWithText:@"Phone input" yTextView:_height + _width - _width * 0.2];

}

-(UITextView *)_drawTextViewWithText:(NSString*)placeholderText yTextView:(int)y
{
    UITextView * myTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, y, _width - 50, LABEL_AND_BUTTON_HEIGHT)];
    [myTextView setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];    
    myTextView.textColor = [UIColor lightGrayColor];
    myTextView.text = placeholderText;
    myTextView.delegate = self;
    [myTextView resignFirstResponder];
    [self->_scrollView addSubview:myTextView];
    return myTextView;
}

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    if (textView.textColor == [UIColor lightGrayColor]) {
        //myTextView.editable = YES;
        //myTextView.selectedRange = NSMakeRange(0, 0);
        textView.text = @"";
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
        textView.text = @"First Name input";
    else if(textView == _lastNameTextView)
        textView.text = @"Last Name input";
    else if(textView == _emailTextView)
        textView.text = @"Email input";
    else if(textView == _phoneTextView)
        textView.text = @"Phone input";
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
    UIImage *faceImage = [UIImage imageNamed:@"Anna.jpg"];
    UIImageView * backdroundView = [[UIImageView alloc] initWithImage:faceImage];
    backdroundView.contentMode = UIViewContentModeScaleAspectFill;
    backdroundView.frame = CGRectMake(0, 0, _width, _height);
    [self->_scrollView addSubview:backdroundView];
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
    ViewController *viewController = [[ViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}



@end
