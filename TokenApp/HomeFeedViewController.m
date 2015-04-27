//
//  HomeFeedViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 4/26/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "HomeFeedViewController.h"

#import "MFC_HomeFeedViewController.h"
#import "TK_DescriptionViewController.h"
#import "CreateMainView.h"
#import "UIViewController+Camera.h"
#import "MFC_CreateViewController.h"

#import "CamerOverlay.h"
#import "TK_Manager.h"

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

    //TK Manager - Helper Methods

    self.arrayOfContent = [TK_Manager loadArrayOfContent:currentUser.arrayOfPhotos arrayOfVideos:currentUser.arrayOfVideos arrayOfLinks:currentUser.arrayOfLinks];

//    [currentUser loadArrayOfFollowers];
//    [currentUser setUserProfile];
//    [currentUser loadArrayOfPhotos];
//    [currentUser loadArrayOfVideos];
//    [currentUser loadArrayOfLinks];
//    [currentUser loadArrayOfPosts];
//    [currentUser loadArrayOfFollowing:NO row:0];
//    [currentUser loadActivityToCurrentUser];
//    [currentUser loadActivityFromCurrentUser];

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
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
