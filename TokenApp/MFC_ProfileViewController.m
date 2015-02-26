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
#import "PersonalActivityViewController.h"
#import "FollowersViewController.h"
#import "NotificationViewController.h"
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

@property (strong, nonatomic) IBOutlet UIButton *buttonCancelView;
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

@property UIImagePickerController *imagePickerProfile;

@property (retain,nonatomic)PersonalActivityViewController *pvc;
@property (retain,nonatomic)FollowersViewController *fvc;
@property (retain,nonatomic)NotificationViewController *nvc;

@end

@implementation MFC_ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self addObserver];

    [self.navigationController.navigationBar setHidden:YES];
    [self.buttonCancelView setHidden:YES];
    self.collectionViewProfile.delegate = self;

    //Accessing User Singleton
    currentUser = [User sharedSingleton];

    self.labelUserName.text = currentUser.userName;

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

#pragma mark - Button Press Methods

- (IBAction)onButtonPressCancel:(id)sender
{
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
                    }];
                }];
            }];
        }];
    }];

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
    headerView.labelFollowersCount.text = [NSString stringWithFormat:@"%li",currentUser.arrayOfFollowers.count];

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
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(3, 70, 313, 445)];

    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.pvc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"FollowersActivity"];
    [self.mainView addSubview:self.pvc.view];
    self.mainView.alpha = 0;

    [self.view addSubview:self.mainView];
    [self.buttonCancelView setHidden:NO];

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


            }
        }];
        
        [self dismissViewControllerAnimated:YES completion:^{


        }];


    }


}


@end
