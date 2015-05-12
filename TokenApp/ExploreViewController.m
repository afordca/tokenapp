//
//  ExploreViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/17/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "ExploreViewController.h"
#import "TK_ProfileViewController.h"
#import "TK_DescriptionViewController.h"
#import "UIViewController+Camera.h"
#import "TK_LinkViewController.h"
#import "TK_PostViewController.h"
#import "CamerOverlay.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

//transform values for full screen support
#define CAMERA_TRANSFORM_X 1
#define CAMERA_TRANSFORM_Y 1.12412
//iphone screen dimensions
#define SCREEN_WIDTH  320
#define SCREEN_HEIGTH 568

@interface ExploreViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,CameraOverlayDelegate,UITableViewDataSource,UITabBarDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property UIVisualEffectView *visualEffectView;

@property UIImagePickerController *imagePicker;
@property UIImage *imageCreatePhoto;
@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) NSString *stringVideoData;
@property (nonatomic) UIImagePickerControllerCameraFlashMode flashMode;
@property BOOL isVideo;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControlDiscover;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewDiscoverContent;

@property (strong, nonatomic) IBOutlet UITableView *tableViewDiscoverUser;

@end

@implementation ExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationController.navigationBar setHidden:YES];
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
    [[NSNotificationCenter defaultCenter ]removeObserver:self];
}


#pragma mark - UICollectionView Delegate Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
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
