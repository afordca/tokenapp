//
//  OthersProfileViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 5/11/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "OthersProfileViewController.h"
#import "TK_ProfileViewController.h"
#import "TK_DescriptionViewController.h"
#import "UIViewController+Camera.h"
#import "TK_LinkViewController.h"
#import "TK_PostViewController.h"
#import "CamerOverlay.h"
#import "ProfileCollectionViewCell.h"
#import "UIViewController+Camera.h"
#import "UIColor+HEX.h"
#import "ProfileCollectionReusableView.h"
#import "PersonalActivityViewController.h"
#import "FollowersViewController.h"
#import "NotificationViewController.h"
#import "DetailedContentViewController.h"
#import "TK_Manager.h"

#import <Parse/Parse.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAsset.h>
#import <MediaPlayer/MediaPlayer.h>

//transform values for full screen support
#define CAMERA_TRANSFORM_X 1
#define CAMERA_TRANSFORM_Y 1.12412
//iphone screen dimensions
#define SCREEN_WIDTH  320
#define SCREEN_HEIGTH 568

//When user is clicked, the Following Personal View behavior is triggered using this nib name
#define FOLLOWINGVIEW_NIB_NAME "yYh-Bi-LcF-view-R8I-G1-Mba"

@interface OthersProfileViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegateFlowLayout,CustomProfileDelegate,UserDelegate>


@property (strong, nonatomic) IBOutlet UILabel *labelUserName;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewProfile;
@property UIImage *imageProfile;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewProfilePic;

@property (strong, nonatomic) IBOutlet UITextView *textViewBiography;


@property UIView *mainView;

@property NSDictionary *dicViews;

@property CGPoint location;

// Create Main View
@property UIVisualEffectView *visualEffectView;
@property UIImagePickerController *imagePicker;
@property UIImage *imageCreatePhoto;
@property (strong, nonatomic) NSURL *videoURL;
@property (nonatomic) UIImagePickerControllerCameraFlashMode flashMode;
@property BOOL isVideo;
@property (strong, nonatomic) NSString *stringVideoData;

@property UIImagePickerController *imagePickerProfile;
@property NSMutableArray *arrayOfFollowers;

@property (retain,nonatomic)PersonalActivityViewController *pvc;
@property (retain,nonatomic)FollowersViewController *fvc;
@property (retain,nonatomic)NotificationViewController *nvc;
@property (retain,nonatomic)DetailedContentViewController *dvc;
@property PFUser *user;

@property UIRefreshControl *mannyFresh;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;


@end

@implementation OthersProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionViewProfile.alwaysBounceVertical = YES;

    [self.navigationController.navigationBar setHidden:YES];

    self.collectionViewProfile.delegate = self;

    //Intialize Movie Player
    self.moviePlayer = [[MPMoviePlayerController alloc]init];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

    self.labelUserName.text = self.otherUser.userName;

//    self.labelUserName.text = currentUser.userName;
//    [self.collectionViewProfile reloadData];
    [self addObserver];
    
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    NSLog(@"View Did Disappear");
    [[NSNotificationCenter defaultCenter ]removeObserver:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Press Methods

- (IBAction)onButtonPressCancel:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UICollectionView Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayOfContent.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellProfile" forIndexPath:indexPath];

    cell.imageViewVideoIcon.alpha = 0;
    cell.labelLinkURL.alpha = 0;
    cell.imageViewLinkURL.alpha = 0;
    cell.imageViewProfileContent.alpha = 1;


    HomeFeedPost *post = [self.arrayOfContent objectAtIndex:indexPath.row];

    if ([post.mediaType isEqualToString:@"photo"])
    {
        Photo *photo = [Photo new];
        photo = post.photoPost;
        cell.imageViewProfileContent.image = photo.picture;
        cell.labelNoteMessage.alpha = 0;
        cell.labelNoteHeader.alpha = 0;
        cell.imageViewVideoIcon.alpha = 0;
        cell.labelLinkURL.alpha = 0;
        cell.imageViewLinkURL.alpha = 0;
        return cell;
    }
    if ([post.mediaType isEqualToString:@"video"])
    {
        Video *video = [Video new];
        video = post.videoPost;
        cell.imageViewProfileContent.image = video.videoThumbnail;
        cell.imageViewVideoIcon.alpha = 1;
        cell.labelNoteMessage.alpha = 0;
        cell.labelNoteHeader.alpha = 0;
        cell.labelLinkURL.alpha = 0;
        cell.imageViewLinkURL.alpha = 0;

        return cell;

    }
    if ([post.mediaType isEqualToString:@"link"])
    {
        Link *link = [Link new];
        link = post.linkPost;
        cell.imageViewProfileContent.alpha = 0;
        cell.imageViewVideoIcon.alpha = 0;
        cell.labelNoteMessage.alpha = 0;
        cell.labelNoteHeader.alpha = 0;
        cell.labelLinkURL.alpha = 1;
        cell.imageViewLinkURL.alpha = 1;
        cell.labelLinkURL.text = [link.urlLink absoluteString];

        return cell;
    }

    if ([post.mediaType isEqualToString:@"post"])
    {
        Post *note = [Post new];
        note = post.messagePost;
        cell.imageViewProfileContent.alpha = 0;
        cell.imageViewVideoIcon.alpha = 0;
        cell.labelLinkURL.alpha = 0;
        cell.imageViewLinkURL.alpha = 0;
        cell.labelNoteMessage.alpha = 1;
        cell.labelNoteHeader.alpha = 1;
        cell.labelNoteMessage.text = note.postMessage;
        cell.labelNoteHeader.text = note.postHeader;


        return cell;
    }

    return nil;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeFeedPost *content = [self.arrayOfContent objectAtIndex:indexPath.row];

    if ([content.mediaType isEqualToString:@"photo"])
    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.dvc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"DetailPhotoViewController"];

        Photo *photo = [Photo new];
        photo = content.photoPost;
        self.dvc.detailPhoto = photo;

        //Create blurEffect and intialize visualEffect View

        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        self.visualEffectView.frame = CGRectMake(0, 68, self.view.bounds.size.width, 452);
        [self.visualEffectView addSubview:self.dvc.view];
        self.visualEffectView.alpha = 0.f;
        [self.view addSubview:self.visualEffectView];
        [self.view bringSubviewToFront:self.visualEffectView];

        self.labelUserName.text = @"Photo";

        [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.visualEffectView setAlpha:1.f];
        } completion:^(BOOL finished) {

        }];

    }

    if ([content.mediaType isEqualToString:@"video"])
    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.dvc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"DetailPhotoViewController"];

        Video *video = [Video new];
        video = content.videoPost;
        self.dvc.detailVideo = video;

        //Create blurEffect and intialize visualEffect View

        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        self.visualEffectView.frame = CGRectMake(0, 68, self.view.bounds.size.width, 452);
        [self.visualEffectView addSubview:self.dvc.view];
        self.visualEffectView.alpha = 0.f;
        [self.view addSubview:self.visualEffectView];
        [self.view bringSubviewToFront:self.visualEffectView];

        self.labelUserName.text = @"Video";

        [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.visualEffectView setAlpha:1.f];
        } completion:^(BOOL finished) {

        }];

    }
    if ([content.mediaType isEqualToString:@"link"])
    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.dvc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"DetailPhotoViewController"];

        Link *link = [Link new];
        link = content.linkPost;
        self.dvc.detailLink = link;

        //Create blurEffect and intialize visualEffect View

        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        self.visualEffectView.frame = CGRectMake(0, 68, self.view.bounds.size.width, 452);
        [self.visualEffectView addSubview:self.dvc.view];
        self.visualEffectView.alpha = 0.f;
        [self.view addSubview:self.visualEffectView];
        [self.view bringSubviewToFront:self.visualEffectView];

        self.labelUserName.text = @"Link";

        [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.visualEffectView setAlpha:1.f];
        } completion:^(BOOL finished) {

        }];

    }

    if ([content.mediaType isEqualToString:@"post"])
    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.dvc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"DetailPhotoViewController"];

        Post *note = [Post new];
        note = content.messagePost;
        self.dvc.detailPost = note;

        //Create blurEffect and intialize visualEffect View

        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        self.visualEffectView.frame = CGRectMake(0, 68, self.view.bounds.size.width, 452);
        [self.visualEffectView addSubview:self.dvc.view];
        self.visualEffectView.alpha = 0.f;
        [self.view addSubview:self.visualEffectView];
        [self.view bringSubviewToFront:self.visualEffectView];

        self.labelUserName.text = @"Post";

        [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.visualEffectView setAlpha:1.f];
        } completion:^(BOOL finished) {

        }];

    }

}

- (UICollectionReusableView *)collectionView: (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    ProfileCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                                 UICollectionElementKindSectionHeader withReuseIdentifier:@"ProfileHeaderView" forIndexPath:indexPath];
    headerView.delegate = self;

    if (self.otherUser.profileImage)
    {
        headerView.imageViewProfilePic.image = self.otherUser.profileImage;

    }
    else
    {
        headerView.imageViewProfilePic.image = [UIImage imageNamed:@"ProfileDefault"];

    }
//
//    headerView.labelFollowersCount.text = [NSString stringWithFormat:@"%li",currentUser.arrayOfFollowers.count];
//    headerView.labelFollowingCount.text = [NSString stringWithFormat:@"%li",currentUser.arrayOfFollowing.count];
//    headerView.textViewBiography.text = currentUser.Biography;
//    
    return headerView;
}




@end
