//
//  MFC_HomeFeedViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/2/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "MFC_HomeFeedViewController.h"
#import "TK_DescriptionViewController.h"
#import "CreateMainView.h"
#import "UIViewController+Camera.h"
#import "MFC_CreateViewController.h"
#import "Constants.h"
#import "TKPhotoCell.h"
#import "CamerOverlay.h"
#import "TKUtility.h"
#import "TKCache.h"
#import "User.h"
#import "CurrentUser.h"
#import "AppDelegate.h"

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

//transform values for full screen support
#define CAMERA_TRANSFORM_X 1
#define CAMERA_TRANSFORM_Y 1.12412
//iphone screen dimensions
#define SCREEN_WIDTH  320
#define SCREEN_HEIGTH 568



@interface MFC_HomeFeedViewController ()<UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CameraOverlayDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableViewHomeFeed;
@property (nonatomic, assign) BOOL shouldReloadOnAppear;
@property (nonatomic, strong) NSMutableSet *reusableSectionHeaderViews;
@property (nonatomic, strong) NSMutableDictionary *outstandingSectionHeaderQueries;

@property UIVisualEffectView *visualEffectView;

@property UIImagePickerController *imagePicker;
@property UIImage *imageCreatePhoto;
@property (strong, nonatomic) NSURL *videoURL;

@property PFUser *user;
@property User *userNew;


@property (nonatomic) UIImagePickerControllerCameraFlashMode flashMode;


@property BOOL isVideo;


@end

@implementation MFC_HomeFeedViewController

@synthesize shouldReloadOnAppear;


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.userNew = [[User alloc]initWithUser:[PFUser currentUser]];


    [self.navigationController.navigationBar setHidden:YES];

    singleUser = [CurrentUser sharedSingleton];

    [singleUser loadArrayOfFollowers];
    [singleUser setUserProfile];
    [singleUser loadArrayOfPhotos];
    [singleUser loadArrayOfVideos];
    [singleUser loadArrayOfLinks];
    [singleUser loadArrayOfPosts];
    [singleUser loadArrayOfFollowing:NO row:0];
    [singleUser loadActivityToCurrentUser];
    [singleUser loadActivityFromCurrentUser];




}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self addObserver];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    if (self.shouldReloadOnAppear) {
        self.shouldReloadOnAppear = NO;
        [self loadObjects];
    }

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    NSLog(@"View Did Disappear");
    // [[NSNotificationCenter defaultCenter] postNotificationName:@"SendCancel" object:self];
    [[NSNotificationCenter defaultCenter ]removeObserver:self];

}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {

        self.outstandingSectionHeaderQueries = [NSMutableDictionary dictionary];

        // The className to query on
        self.parseClassName = kPTKPhotoClassKey;


        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;

        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;

        // The number of objects to show per page
        self.objectsPerPage = 10;

        // Improve scrolling performance by reusing UITableView section headers
        self.reusableSectionHeaderViews = [NSMutableSet setWithCapacity:3];

        self.shouldReloadOnAppear = NO;
    }
    return self;
}



#pragma mark - UITableView Delegate Methods


//-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return self.objects.count * 2 + (self.paginationEnabled ? 1 : 0);
//}



-(IBAction)unwindToHomeFeed:(UIStoryboard*)sender{}

#pragma mark - PFQueryTableViewcontroller 

- (PFQuery *)queryForTable {
    if (![PFUser currentUser]){
        PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
        [query setLimit:0];
        return query;
    }

    PFQuery *followingActivitiesQuery = [PFQuery queryWithClassName:kPTKActivityClassKey];
    [followingActivitiesQuery whereKey:kPTKActivityTypeFollow equalTo:kPTKActivityTypeFollow];
    [followingActivitiesQuery whereKey:kPTKActivityFromUserKey equalTo:[PFUser currentUser]];
    followingActivitiesQuery.limit = 1000;

    PFQuery *autoFollowUsersQuery = [PFUser query];
    [autoFollowUsersQuery whereKey:kPTKUserAutoFollowKey equalTo:@YES];

    PFQuery *photosFromFollowedUsersQuery = [PFQuery queryWithClassName:self.parseClassName];
    [photosFromFollowedUsersQuery whereKey:kPTKPhotoUserKey matchesKey:kPTKActivityToUserKey inQuery:followingActivitiesQuery];
    [photosFromFollowedUsersQuery whereKeyExists:kPTKPhotoPictureKey];

    PFQuery *photosFromCurrentUserQuery = [PFQuery queryWithClassName:self.parseClassName];
    [photosFromCurrentUserQuery whereKey:kPTKPhotoUserKey equalTo:[PFUser currentUser]];
     [photosFromCurrentUserQuery whereKeyExists:kPTKPhotoPictureKey];

    PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:photosFromCurrentUserQuery, photosFromFollowedUsersQuery, nil]];
    [query setLimit:30];
    [query includeKey:kPTKPhotoUserKey];
    [query orderByDescending:@"createdAt"];

    // A pull-to-refresh should always trigger a network request.
    [query setCachePolicy:kPFCachePolicyNetworkOnly];

    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    //
    // If there is no network connection, we will hit the cache first.
    if (self.objects.count == 0 || ![[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)]) {
        [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    }

    return query;

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
// and the imageView being the imageKey in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";

    //Photo
//    PFTableViewCell *cell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }

    TKPhotoCell *cell = (TKPhotoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[TKPhotoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.imageView.image = [UIImage imageNamed:@""];

    if (object) {
        cell.imageView.file = [object objectForKey:kPTKPhotoPictureKey];


        // PFQTVC will take care of asynchronously downloading files, but will only load them when the tableview is not moving. If the data is there, let's load it right away.
        if ([cell.imageView.file isDataAvailable]) {
            [cell.imageView loadInBackground];

        }
    }


    return cell;
}


//-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//
//
//}

//-(void)tableView:(UITableViewCell *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [UIView animateWithDuration:.3 animations:^{
//        self.cellPopOverView.frame = self.view.frame;
//    }];
//}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];

    // This method is called every time objects are loaded from Parse via the PFQuery
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.objects.count * 2 + (self.paginationEnabled ? 1 : 0);
//}
//
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
//
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//    if (![self objectAtIndexPath:indexPath]) {
//        // Load More Cell
//        [self loadNextPage];
//    }
//}


@end
