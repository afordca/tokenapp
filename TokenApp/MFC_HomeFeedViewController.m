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
#import "Constants.h"
#import "TKPhotoCell.h"
#import "CamerOverlay.h"
#import "TKUtility.h"
#import "TKCache.h"
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

@property (nonatomic) UIImagePickerControllerCameraFlashMode flashMode;


@property BOOL isVideo;


@end

@implementation MFC_HomeFeedViewController

@synthesize shouldReloadOnAppear;


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self addObserver];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    if (self.shouldReloadOnAppear) {
        self.shouldReloadOnAppear = NO;
        [self loadObjects];
    }

    //Has to be unregistered always, otherwise nav controllers down the line will call this method
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
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
#pragma mark - Helper Methods

-(void)addObserver
{
    // Observer for when CREATE button is pressed. Presents Create Main View
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"CreateMainView"
                                               object:nil];
    // Observer for when CANCEL button is pressed. Removes the CreateMainView from superview
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"SendCancel"
                                               object:nil];

    // Observer for when TAKE PHOTO button is pressed. UIImagePickerController presented
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"TakePhoto"
                                               object:nil];

    // Observer for when Post Note button is pressed.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"PostNote"
                                               object:nil];

    // Observer for when Post Note button is pressed.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"PostLink"
                                               object:nil];
}

-(void)pushSegueToDescriptionViewController
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TK_DescriptionViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Description"];
    vc.imagePhoto = self.imageCreatePhoto;
    vc.urlVideo = self.videoURL;
    vc.isVideo = self.isVideo;
    [self.navigationController pushViewController: vc animated:YES];

}


#pragma mark - Notification Methods


- (void)receivedNotification:(NSNotification *) notification {

    if ([[notification name] isEqualToString:@"CreateMainView"])
    {
        //Create blurEffect and intialize visualEffect View

        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];

#warning Revisit these magic numbers!!! Add them to Constants Class

        self.visualEffectView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 520);

        UIView *mainView = [[[NSBundle mainBundle] loadNibNamed:@"CreateMainView"
                                                          owner:self
                                                        options:nil] objectAtIndex:0];

        [self.visualEffectView addSubview:mainView];
        [self.view addSubview:self.visualEffectView];
        [self.view bringSubviewToFront:self.visualEffectView];

    }

    else if ([[notification name] isEqualToString:@"SendCancel"])
    {
        [self.visualEffectView removeFromSuperview];
    }

    else if ([[notification name] isEqualToString:@"TakePhoto"])
    {
        [self setUpCamera];

        self.imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    }
    else if ([[notification name] isEqualToString:@"PostNote"])
    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Post"];
        [self.navigationController pushViewController: vc animated:YES];

    }
    else if ([[notification name] isEqualToString:@"PostLink"])
    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Link"];
        [self.navigationController pushViewController: vc animated:YES];

    }

}

#pragma mark - Camera Methods

-(void)setUpCamera
{
    //UIImagePicker Setup

    self.isVideo = NO;

    //create an overlay view instance
    CamerOverlay *overlay = [[CamerOverlay alloc]
                             initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH)];
    overlay.delegate = self;

    self.imagePicker = [UIImagePickerController new];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;

    self.flashMode = UIImagePickerControllerCameraFlashModeAuto;
    self.imagePicker.cameraFlashMode = self.flashMode;

    //hide all controls
    self.imagePicker.showsCameraControls = NO;
    self.imagePicker.navigationBarHidden = YES;
    self.imagePicker.toolbarHidden = YES;

    self.imagePicker.cameraViewTransform =
    CGAffineTransformScale(self.imagePicker.cameraViewTransform,
                           CAMERA_TRANSFORM_X,
                           CAMERA_TRANSFORM_Y);

    //set our custom overlay view
    self.imagePicker.cameraOverlayView = overlay;

}

#pragma mark - CameraOverlay Delegate Methods

-(void)onClickCameraLibrary
{
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];

}

//IBAction (for switching between front and rear camera).
-(void)onClickCameraReverse:(NSString *)customClass
{
    if(self.imagePicker.cameraDevice == UIImagePickerControllerCameraDeviceFront)
    {
        self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
    else
    {
        self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
}

-(void)onClickCameraCapturePhoto
{
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;

    if (self.isVideo)
    {
        [self.imagePicker startVideoCapture];
    }
    else
    {
        [self.imagePicker takePicture];
    }

}

-(void)onClickCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)onClickFlashMode
{
    if (self.flashMode == UIImagePickerControllerCameraFlashModeAuto) {
        //toggle your button to "on"
        self.flashMode = UIImagePickerControllerCameraFlashModeOn;
    }else if (self.flashMode == UIImagePickerControllerCameraFlashModeOn){
        //toggle your button to "Off"
        self.flashMode = UIImagePickerControllerCameraFlashModeOff;
    }else if (self.flashMode == UIImagePickerControllerCameraFlashModeOff){
        //toggle your button to "Auto"
        self.flashMode = UIImagePickerControllerCameraFlashModeAuto;
    }
}

#pragma mark - UIImagePicker Methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];

    // Check if photo

    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        self.imageCreatePhoto = [info objectForKey:UIImagePickerControllerOriginalImage];

        // Pictures taken from camera shot are stored to device
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            //Save to Photos Album
            UIImageWriteToSavedPhotosAlbum(self.imageCreatePhoto, nil, nil, nil);

        }

        [self pushSegueToDescriptionViewController];
  //  [self performSegueWithIdentifier:@"pushToDescription" sender:self];




    }
    // Check if Video

    else if ([mediaType isEqualToString:@"public.movie"])
    {
        self.videoURL = info[UIImagePickerControllerMediaURL];

        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            // Saving the video / // Get the new unique filename
            NSString *sourcePath = [[info objectForKey:@"UIImagePickerControllerMediaURL"]relativePath];
            UISaveVideoAtPathToSavedPhotosAlbum(sourcePath,nil,nil,nil);
            // [self performSegueWithIdentifier:@"pushToDescription" sender:self];
            [self pushSegueToDescriptionViewController];


        }
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self setUpCamera];
    self.imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    [self dismissViewControllerAnimated:YES completion:^{
        [self presentViewController:self.imagePicker animated:NO completion:nil];

    }];
}

#pragma mark - Prepare Segue Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    NSLog(@"Prepare for segue");

    if ([segue.identifier  isEqual: @"pushToDescription"])
    {
        TK_DescriptionViewController *tkDescriptionViewController = [segue destinationViewController];
        tkDescriptionViewController.imagePhoto = self.imageCreatePhoto;
        tkDescriptionViewController.urlVideo = self.videoURL;
        tkDescriptionViewController.isVideo = self.isVideo;
        
    }
//- (void)userFollowingChanged:(NSNotification *)note {
//    NSLog(@"User following changed.");
//    self.shouldReloadOnAppear = YES;
//
//    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 50.0f)];
//
//}
}

@end
