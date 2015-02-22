//
//  MFC_ProfileViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/2/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "MFC_ProfileViewController.h"
#import "TK_DescriptionViewController.h"
#import "UIViewController+Camera.h"
#import "TK_LinkViewController.h"
#import "TK_PostViewController.h"
#import "CamerOverlay.h"
#import "ProfileCollectionViewCell.h"
#import "UIViewController+Camera.h"
#import "ProfileCollectionReusableView.h"
#import <Parse/Parse.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

//transform values for full screen support
#define CAMERA_TRANSFORM_X 1
#define CAMERA_TRANSFORM_Y 1.12412
//iphone screen dimensions
#define SCREEN_WIDTH  320
#define SCREEN_HEIGTH 568


@interface MFC_ProfileViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegateFlowLayout,CustomProfileDelegate>

@property (strong, nonatomic) IBOutlet UILabel *labelUserName;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewProfile;
@property UIImage *imageProfile;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewProfilePic;


@property NSDictionary *dicViews;

@property CGPoint location;

// Create Main View
@property UIVisualEffectView *visualEffectView;
@property UIImagePickerController *imagePicker;
@property UIImage *imageCreatePhoto;
@property (strong, nonatomic) NSURL *videoURL;
@property (nonatomic) UIImagePickerControllerCameraFlashMode flashMode;
@property BOOL isVideo;

@property UIImagePickerController *imagePickerProfile;


@end

@implementation MFC_ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addObserver];

    [self.navigationController.navigationBar setHidden:YES];
    self.collectionViewProfile.delegate = self;

    //Accessing User Singleton
    currentUser = [User sharedSingleton];

    self.labelUserName.text = currentUser.userName;

}


#pragma mark - UICollectionView Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return currentUser.arrayOfPhotos.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellProfile" forIndexPath:indexPath];

    cell.imageViewProfileContent.image = currentUser.arrayOfPhotos[indexPath.row];



    return cell;
}

- (UICollectionReusableView *)collectionView: (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    ProfileCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                         UICollectionElementKindSectionHeader withReuseIdentifier:@"ProfileHeaderView" forIndexPath:indexPath];
    headerView.delegate = self;
    headerView.imageViewProfilePic.image = currentUser.profileImage;

    return headerView;
}

#pragma mark - CustomProfileDelegate Methods

-(void)tapOnCamera
{
    self.imagePickerProfile = [[UIImagePickerController alloc]init];
    self.imagePickerProfile.delegate = self;
    self.imagePickerProfile.allowsEditing = YES;
    self.imagePickerProfile.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePickerProfile.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];

   [self presentViewController:self.imagePickerProfile animated:YES completion:nil];
}

-(void)tapOnLibrary
{
    self.imagePickerProfile = [[UIImagePickerController alloc]init];
    self.imagePickerProfile.delegate = self;
    self.imagePickerProfile.allowsEditing = YES;
    self.imagePickerProfile.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    UIColor *backgroundColor = [UIColor colorWithRed:0.38 green:0.51 blue:0.85 alpha:1.0];
    self.imagePickerProfile.navigationBar.barTintColor = backgroundColor;
    self.imagePickerProfile.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePickerProfile.sourceType];
    [self presentViewController:self.imagePickerProfile animated:YES completion:nil];

}



@end
