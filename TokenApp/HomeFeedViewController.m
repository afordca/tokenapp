//
//  HomeFeedViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 4/26/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "HomeFeedViewController.h"
#import "HomeFeedTableViewCell.h"
#import "MFC_HomeFeedViewController.h"
#import "TK_DescriptionViewController.h"
#import "CreateMainView.h"
#import "UIViewController+Camera.h"
#import "MFC_CreateViewController.h"
#import "CamerOverlay.h"
#import "TK_Manager.h"
#import "User.h"
#import "CurrentUser.h"
#import "Photo.h"
#import "Video.h"
#import "Link.h"
#import "Post.h"
#import "HomeFeedPost.h"

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

@interface HomeFeedViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CameraOverlayDelegate>


@property UIVisualEffectView *visualEffectView;

@property UIImagePickerController *imagePicker;
@property UIImage *imageCreatePhoto;
@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) NSString *stringVideoData;


@property PFUser *user;
@property User *userNew;

@property (nonatomic,strong) NSArray *arrayOfContent;

@property (nonatomic) UIImagePickerControllerCameraFlashMode flashMode;


@property BOOL isVideo;

@end

@implementation HomeFeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController.navigationBar setHidden:YES];

    currentUser = [CurrentUser sharedSingleton];
    [currentUser setUserProfile];

}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self addObserver];

}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    NSLog(@"View Did Disappear");
    // [[NSNotificationCenter defaultCenter] postNotificationName:@"SendCancel" object:self];
    [[NSNotificationCenter defaultCenter ]removeObserver:self];
    
}

#pragma mark - UITableView Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return currentUser.arrayOfHomeFeedContent.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeFeedCell"];

    cell.labelHomeFeedUsername.text = @"";
    cell.imageViewHomeFeedContent.alpha = 1;
    cell.imageViewVideoIcon.alpha = 0;
    cell.labelLinkURL.alpha = 0;
    cell.imageViewLinkURL.alpha = 0;
    cell.viewLinkBlackBackground.alpha = 0;

    HomeFeedPost *post = [currentUser.arrayOfHomeFeedContent objectAtIndex:indexPath.row];



    if ([post.mediaType isEqualToString:@"photo"])
    {

        cell.labelHomeFeedUsername.text = post.userName;
        cell.imageViewHomeFeedContent.image = post.contentImage;
        cell.imageViewHomeFeedProfilePic.image = post.userProfilePic;
        cell.imageViewVideoIcon.alpha = 0;
        cell.labelLinkURL.alpha = 0;
        cell.imageViewLinkURL.alpha = 0;
        cell.viewLinkBlackBackground.alpha = 0;
        return cell;
    }
//    if ([post.mediaType isEqualToString:@"video"])
//    {
//        Video *video = [Video new];
//        video = [currentUser.arrayOfHomeFeedContent objectAtIndex:indexPath.row];
//        cell.labelHomeFeedUsername.text = @"";
//        cell.imageViewHomeFeedContent.image = video.videoThumbnail;
//        cell.imageViewVideoIcon.alpha = 1;
//        cell.labelLinkURL.alpha = 0;
//        cell.imageViewLinkURL.alpha = 0;
//        cell.viewLinkBlackBackground.alpha = 0;
//
//        return cell;
//
//    }
//    if ([post.mediaType isEqualToString:@"link"])
//    {
//        Link *link = [Link new];
//        link = [currentUser.arrayOfHomeFeedContent objectAtIndex:indexPath.row];
//        cell.labelHomeFeedUsername.text = @"";
//        cell.imageViewHomeFeedContent.alpha = 0;
//        cell.imageViewVideoIcon.alpha = 0;
//        cell.labelLinkURL.alpha = 1;
//        cell.imageViewLinkURL.alpha = 1;
//        cell.viewLinkBlackBackground.alpha = 1;
//        cell.labelLinkURL.text = [link.urlLink absoluteString];
//
//        return cell;
//    }

    return nil;

}

@end
