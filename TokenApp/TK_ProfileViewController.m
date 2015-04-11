//
//  MFC_ProfileViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/2/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

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
#import "DetailedPhotoViewController.h"
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


@interface TK_ProfileViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegateFlowLayout,CustomProfileDelegate,UserDelegate>

@property (strong, nonatomic) IBOutlet UILabel *labelUserName;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewProfile;
@property UIImage *imageProfile;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewProfilePic;

@property (strong, nonatomic) IBOutlet UIButton *buttonCancelView;
@property (strong, nonatomic) IBOutlet UIButton *buttonEditProfile;


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
@property (retain,nonatomic)DetailedPhotoViewController *dvc;
@property PFUser *user;
@property (strong, nonatomic) IBOutlet UIButton *buttonSettings;

@property UIRefreshControl *mannyFresh;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;

@property (nonatomic,strong) NSArray *arrayOfContent;


@end

@implementation TK_ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Refresh Control Setup
    self.mannyFresh = [[UIRefreshControl alloc] init];
    self.mannyFresh.tintColor = [UIColor colorwithHexString:@"#72c74a" alpha:.9];
    [self.mannyFresh addTarget:self action:@selector(refershControlAction) forControlEvents:UIControlEventValueChanged];
    [self.collectionViewProfile addSubview:self.mannyFresh];
    self.collectionViewProfile.alwaysBounceVertical = YES;

    [self.navigationController.navigationBar setHidden:YES];
    [self.buttonCancelView setHidden:YES];

    self.collectionViewProfile.delegate = self;

    //Accessing User Singleton
    currentUser = [CurrentUser sharedSingleton];
    self.user = [PFUser currentUser];

    //Intialize Movie Player
    self.moviePlayer = [[MPMoviePlayerController alloc]init];

    self.arrayOfContent = [self loadArrayOfContent:currentUser.arrayOfPhotos arrayOfVideos:currentUser.arrayOfVideos];


//     NSURL *videoURL = [[currentUser.arrayOfVideos objectAtIndex:1]videoURL];
//
//    // create a movie player view controller
//    MPMoviePlayerViewController * controller = [[MPMoviePlayerViewController alloc]initWithContentURL:videoURL];
//
//    controller.moviePlayer.controlStyle = MPMovieSourceTypeStreaming;
//    [controller.moviePlayer prepareToPlay];
//    [controller.moviePlayer play];
//
//    // and present it
//    [self presentMoviePlayerViewControllerAnimated:controller];


}




-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotationAnimation.toValue = @(M_PI * -1.0);
//    rotationAnimation.duration = .4;
//    //    rotationAnimation.autoreverses = YES;
//    //    rotationAnimation.repeatCount = HUGE_VALF;
//    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    [self.buttonSettings.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.buttonEditProfile setHidden:NO];

    [self.collectionViewProfile reloadData];

    self.labelUserName.text = currentUser.userName;
    [self addObserver];
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    NSLog(@"View Did Disappear");
    [[NSNotificationCenter defaultCenter ]removeObserver:self];

}

#pragma mark - Button Press Methods


- (IBAction)onButtonPressSettings:(id)sender
{
    //Settings Icon rotation
//    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotationAnimation.toValue = @(M_PI * 2.0);
//    rotationAnimation.duration = 1;
//    rotationAnimation.autoreverses = YES;
//    rotationAnimation.repeatCount = HUGE_VALF;
//    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    [self.buttonSettings.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}


- (IBAction)onButtonPressCancel:(id)sender
{
    self.labelUserName.text = currentUser.userName;

    // Dismiss ActivityView with animation left to right
    [UIView animateWithDuration:0.5 animations:^{
    } completion:^(BOOL finished) {
        self.self.mainView.alpha = 1;
        self.mainView.transform = CGAffineTransformMakeTranslation(0, 0);
        [UIView animateKeyframesWithDuration:0.5/4 delay:0 options:0 animations:^{
            self.mainView.transform = CGAffineTransformMakeTranslation(10, 0);
        } completion:^(BOOL finished) {
            [UIView animateKeyframesWithDuration:0.5/4 delay:0 options:0 animations:^{
                self.mainView.transform = CGAffineTransformMakeTranslation(45, 0);
            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:0.5/4 delay:0 options:0 animations:^{
                    self.mainView.transform = CGAffineTransformMakeTranslation(340, 0);
                } completion:^(BOOL finished) {
                    [UIView animateKeyframesWithDuration:0.5/4 delay:0 options:0 animations:^{
                        self.mainView.transform = CGAffineTransformMakeTranslation(600, 0);
                    } completion:^(BOOL finished) {

                        [self.mainView removeFromSuperview];
                        [self.buttonCancelView setHidden:YES];
                        [self.buttonEditProfile setHidden:NO];
                    }];
                }];
            }];
        }];
    }];

}


#pragma mark - UICollectionView Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return currentUser.arrayOfPhotos.count;
    return self.arrayOfContent.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellProfile" forIndexPath:indexPath];

    if ([[self.arrayOfContent objectAtIndex:indexPath.row] isKindOfClass:[Photo class]])
    {
        Photo *photo = [Photo new];
        photo = [self.arrayOfContent objectAtIndex:indexPath.row];
        cell.imageViewProfileContent.image = photo.picture;
        cell.imageViewVideoIcon.alpha = 0;
        return cell;
    }
    if ([[self.arrayOfContent objectAtIndex:indexPath.row] isKindOfClass:[Video class]])
    {
        Video *video = [Video new];
        video = [self.arrayOfContent objectAtIndex:indexPath.row];
        cell.imageViewProfileContent.image = video.videoThumbnail;
        cell.imageViewVideoIcon.alpha = 1;

        return cell;
        
    }

    return nil;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.arrayOfContent objectAtIndex:indexPath.row] isKindOfClass:[Photo class]])
    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.dvc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"DetailPhotoViewController"];

        Photo *photo = [Photo new];
        photo = [self.arrayOfContent objectAtIndex:indexPath.row];
        self.dvc.detailPhoto = photo.picture;

        //Create blurEffect and intialize visualEffect View

        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        self.visualEffectView.frame = CGRectMake(0, 68, self.view.bounds.size.width, 452);
        [self.visualEffectView addSubview:self.dvc.view];
        self.visualEffectView.alpha = 0.f;
        [self.view addSubview:self.visualEffectView];
        [self.view bringSubviewToFront:self.visualEffectView];

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
    headerView.imageViewProfilePic.image = currentUser.profileImage;
    headerView.labelFollowersCount.text = [NSString stringWithFormat:@"%li",currentUser.arrayOfFollowers.count];
    headerView.labelFollowingCount.text = [NSString stringWithFormat:@"%li",currentUser.arrayOfFollowing.count];

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

-(void)presentActivityView
{
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(3, 70, 313, 445)];

    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.pvc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"PersonalActivity"];
    [self.mainView addSubview:self.pvc.view];
    self.mainView.alpha = 0;

    [self.view addSubview:self.mainView];
    [self.buttonCancelView setHidden:NO];
    [self.buttonEditProfile setHidden:YES];

// Present ActivityView with animation left to right

    [UIView animateWithDuration:0.5 animations:^{
    } completion:^(BOOL finished) {
        self.self.mainView.alpha = 1;
        self.mainView.transform = CGAffineTransformMakeTranslation(600, 0);
        [UIView animateKeyframesWithDuration:0.5/4 delay:0 options:0 animations:^{
            self.mainView.transform = CGAffineTransformMakeTranslation(340, 0);
        } completion:^(BOOL finished) {
            [UIView animateKeyframesWithDuration:0.5/4 delay:0 options:0 animations:^{
                self.mainView.transform = CGAffineTransformMakeTranslation(45, 0);
            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:0.5/4 delay:0 options:0 animations:^{
                    self.mainView.transform = CGAffineTransformMakeTranslation(10, 0);
                } completion:^(BOOL finished) {
                    [UIView animateKeyframesWithDuration:0.5/4 delay:0 options:0 animations:^{
                        self.mainView.transform = CGAffineTransformMakeTranslation(0, 0);
                    } completion:^(BOOL finished) {
                    }];
                }];
            }];
        }];
    }];
}

-(void)presentFollowersView
{
    self.labelUserName.text = @"Followers";
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(3, 70, 313, 445)];

    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.pvc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"FollowersActivity"];

    [self.mainView addSubview:self.pvc.view];
    self.mainView.alpha = 0;

    [self.view addSubview:self.mainView];
    [self.buttonCancelView setHidden:NO];
    [self.buttonEditProfile setHidden:YES];


    // Present ActivityView with animation left to right

    [UIView animateWithDuration:0.5 animations:^{
    } completion:^(BOOL finished) {
        self.self.mainView.alpha = 1;
        self.mainView.transform = CGAffineTransformMakeTranslation(600, 0);
        [UIView animateKeyframesWithDuration:0.5/4 delay:0 options:0 animations:^{
            self.mainView.transform = CGAffineTransformMakeTranslation(340, 0);
        } completion:^(BOOL finished) {
            [UIView animateKeyframesWithDuration:0.5/4 delay:0 options:0 animations:^{
                self.mainView.transform = CGAffineTransformMakeTranslation(45, 0);
            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:0.5/4 delay:0 options:0 animations:^{
                    self.mainView.transform = CGAffineTransformMakeTranslation(10, 0);
                } completion:^(BOOL finished) {
                    [UIView animateKeyframesWithDuration:0.5/4 delay:0 options:0 animations:^{
                        self.mainView.transform = CGAffineTransformMakeTranslation(0, 0);
                    } completion:^(BOOL finished) {
                    }];
                }];
            }];
        }];
    }];
}

-(void)presentFollowingView
{
    self.labelUserName.text = @"Following";
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(3, 70, 313, 445)];

    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.pvc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"FollowingActivity"];

    [self.mainView addSubview:self.pvc.view];
    self.mainView.alpha = 0;

    [self.view addSubview:self.mainView];
    [self.buttonCancelView setHidden:NO];
    [self.buttonEditProfile setHidden:YES];


    // Present ActivityView with animation left to right

    [UIView animateWithDuration:0.5 animations:^{
    } completion:^(BOOL finished) {
        self.self.mainView.alpha = 1;
        self.mainView.transform = CGAffineTransformMakeTranslation(600, 0);
        [UIView animateKeyframesWithDuration:0.5/4 delay:0 options:0 animations:^{
            self.mainView.transform = CGAffineTransformMakeTranslation(340, 0);
        } completion:^(BOOL finished) {
            [UIView animateKeyframesWithDuration:0.5/4 delay:0 options:0 animations:^{
                self.mainView.transform = CGAffineTransformMakeTranslation(45, 0);
            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:0.5/4 delay:0 options:0 animations:^{
                    self.mainView.transform = CGAffineTransformMakeTranslation(10, 0);
                } completion:^(BOOL finished) {
                    [UIView animateKeyframesWithDuration:0.5/4 delay:0 options:0 animations:^{
                        self.mainView.transform = CGAffineTransformMakeTranslation(0, 0);
                    } completion:^(BOOL finished) {
                    }];
                }];
            }];
        }];
    }];
}


-(void)presentNotificationsView
{
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(3, 70, 313, 445)];

    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.nvc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Notifications"];
    [self.mainView addSubview:self.nvc.view];
    self.mainView.alpha = 0;

    [self.view addSubview:self.mainView];
    [self.buttonCancelView setHidden:NO];
    [self.buttonEditProfile setHidden:YES];


    // Present ActivityView with animation left to right

    [UIView animateWithDuration:0.5 animations:^{
    } completion:^(BOOL finished) {
        self.self.mainView.alpha = 1;
        self.mainView.transform = CGAffineTransformMakeTranslation(600, 0);
        [UIView animateKeyframesWithDuration:0.5/4 delay:0 options:0 animations:^{
            self.mainView.transform = CGAffineTransformMakeTranslation(340, 0);
        } completion:^(BOOL finished) {
            [UIView animateKeyframesWithDuration:0.5/4 delay:0 options:0 animations:^{
                self.mainView.transform = CGAffineTransformMakeTranslation(45, 0);
            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:0.5/4 delay:0 options:0 animations:^{
                    self.mainView.transform = CGAffineTransformMakeTranslation(10, 0);
                } completion:^(BOOL finished) {
                    [UIView animateKeyframesWithDuration:0.5/4 delay:0 options:0 animations:^{
                        self.mainView.transform = CGAffineTransformMakeTranslation(0, 0);
                    } completion:^(BOOL finished) {
                    }];
                }];
            }];
        }];
    }];
}

#pragma mark - UIImagePicker Methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (picker == self.imagePicker) {
        NSLog(@"TEST");
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
    else
    {
        NSLog(@"TEST,Profile");
//
        PFUser *user = [PFUser currentUser];
//        currentUser = [User sharedSingleton];

        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];

        if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
            self.imageProfile = [info objectForKey:UIImagePickerControllerOriginalImage];

            if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera)
            {
                UIImageWriteToSavedPhotosAlbum(self.imageProfile, nil, nil, nil);
            }
        }

        self.imageProfile = [self squareImageFromImage:self.imageProfile scaledToSize:200];

        NSData *dataFromImage = UIImagePNGRepresentation(self.imageProfile);
        PFFile *imageFile = [PFFile fileWithName:@"profile.png" data:dataFromImage];
        [user setObject:imageFile forKey:@"profileImage"];

        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"%@", [error userInfo]);
            } else {
                currentUser.profileImage = self.imageProfile;

                [self.collectionViewProfile reloadData];
            }
        }];
        
        [self dismissViewControllerAnimated:YES completion:^
        {

        }];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{

    if (picker != self.imagePicker)
    {
        self.imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];

    }
    else
    {

    [self setUpCamera];

    self.imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    [self dismissViewControllerAnimated:YES completion:^{
        [self presentViewController:self.imagePicker animated:NO completion:nil];

    }];
    }
    
}

#pragma mark User Delegate Methods

-(void)reloadCollectionAfterArrayUpdate
{
    [self.collectionViewProfile reloadData];
}

#pragma mark - Helper Methods

-(void)refershControlAction
{
    //Refresh HeaderView of CollectionView
    [self.collectionViewProfile reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,1)]];

    [currentUser loadArrayOfPhotos];
    [self.mannyFresh endRefreshing];
}

-(NSArray*)loadArrayOfContent:(NSMutableArray*)arrayOfPhotos arrayOfVideos:(NSMutableArray*)arrayOfVideos
{

    NSArray *arrayOfContent = [NSMutableArray new];
    arrayOfContent = [NSArray arrayWithArray:[arrayOfPhotos arrayByAddingObjectsFromArray:arrayOfVideos]];

//    NSSortDescriptor *sortDescriptor;
//    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt"
//                                                 ascending:YES];
//    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
//    NSArray *sortedArray;
//    sortedArray = [arrayOfContent sortedArrayUsingDescriptors:sortDescriptors];

    return arrayOfContent;
}


@end
