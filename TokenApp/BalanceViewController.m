//
//  BalanceViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/17/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "BalanceViewController.h"

#import "TK_ProfileViewController.h"
#import "TK_DescriptionViewController.h"
#import "TK_LinkViewController.h"
#import "TK_PostViewController.h"
#import "UIViewController+Camera.h"
#import "CamerOverlay.h"
#import "BalanceTableViewCell.h"
#import "BalanceTransactionViewController.h"
#import "BalanceActivity.h"
#import "CurrentUser.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

//transform values for full screen support
#define CAMERA_TRANSFORM_X 1
#define CAMERA_TRANSFORM_Y 1.12412
//iphone screen dimensions
#define SCREEN_WIDTH  320
#define SCREEN_HEIGTH 568

@interface BalanceViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,CameraOverlayDelegate>

@property UIVisualEffectView *visualEffectView;

@property UIImagePickerController *imagePicker;
@property UIImage *imageCreatePhoto;
@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) NSString *stringVideoData;


@property (strong,nonatomic)NSNumber *numberOfTotalTokens;

@property (strong,nonatomic)NSNumber *numberOfPhotoTokens;
@property (strong,nonatomic)NSNumber *numberOfVideoTokens;
@property (strong,nonatomic)NSNumber *numberOfLinkTokens;
@property (strong,nonatomic)NSNumber *numberOfBlogTokens;
@property (strong,nonatomic)NSNumber *numberOfLoginBonus;
@property (strong,nonatomic)NSNumber *numberOfInviteBonus;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewBalanceProfilePic;

@property (strong, nonatomic) IBOutlet UILabel *labelUsername;
@property (strong, nonatomic) IBOutlet UILabel *labelAvailableTokens;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewBalance;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewActivity;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewRedeem;

@property (strong, nonatomic) IBOutlet UILabel *labelPhotoTokens;

@property (strong, nonatomic) IBOutlet UILabel *labelVideoTokens;

@property (strong, nonatomic) IBOutlet UILabel *labelScribeTokens;

@property (strong, nonatomic) IBOutlet UILabel *labelLinkTokens;

@property (strong, nonatomic) IBOutlet UILabel *labelSplashBonusTokens;

@property (strong, nonatomic) IBOutlet UILabel *labelInviteBonusTokens;

@property (nonatomic) UIImagePickerControllerCameraFlashMode flashMode;
@property (strong, nonatomic) IBOutlet UIButton *buttonBalance;

@property (strong, nonatomic) IBOutlet UIButton *buttonActivity;

@property (strong, nonatomic) IBOutlet UIButton *buttonRedeem;

@property BOOL isVideo;

@property UIView *mainView;
@property BalanceTransactionViewController *btvc;

@end

@implementation BalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver];

    //Accessing User Singleton
    currentUser = [CurrentUser sharedSingleton];
    currentUser.arrayOfBalanceActivity = [NSMutableArray new];

    [self.navigationController.navigationBar setHidden:YES];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

    self.imageViewBalanceProfilePic.image = currentUser.profileImage;
    self.labelUsername.text = currentUser.userName;

    currentUser.numberOfTotalTokens = [NSNumber numberWithInt:0];
    currentUser.numberOfPhotoTokens = [NSNumber numberWithInt:0];
    currentUser.numberOfVideoTokens = [NSNumber numberWithInt:0];
    currentUser.numberOfLinkTokens = [NSNumber numberWithInt:0];
    currentUser.numberOfBlogTokens = [NSNumber numberWithInt:0];
    currentUser.numberOfLoginBonusTokens = [NSNumber numberWithInt:0];
    currentUser.numberOfInviteBonusTokens = [NSNumber numberWithInt:0];

    PFUser *user = [PFUser currentUser];

    PFQuery *queryForActivity = [PFQuery queryWithClassName:@"Activity"];
    [queryForActivity whereKey:@"type" equalTo:@"viewed"];

    [queryForActivity includeKey:@"link"];
    [queryForActivity includeKey:@"note"];
    [queryForActivity includeKey:@"photo"];
    [queryForActivity includeKey:@"video"];
    [queryForActivity orderByAscending:@"createdAt"];
    [queryForActivity findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error)
         {
             NSLog(@"Error:%@",[error userInfo]);
         }
         else
         {
             for (PFObject *activity in objects)
             {

                 if ([[[activity objectForKey:@"toUser"]objectId] isEqualToString:currentUser.userID])
                 {
                     //Total Tokens
                     int value = [currentUser.numberOfTotalTokens intValue];
                     currentUser.numberOfTotalTokens = [NSNumber numberWithInt:value + 1];

                     //Photo Tokens
                     if ([[activity objectForKey:@"mediaType"]isEqualToString:@"photo"])
                     {
                         int value = [currentUser.numberOfPhotoTokens intValue];
                         currentUser.numberOfPhotoTokens = [NSNumber numberWithInt:value + 1];
                     }

                     //Video Tokens
                     if ([[activity objectForKey:@"mediaType"]isEqualToString:@"video"])
                     {
                         int value = [currentUser.numberOfVideoTokens intValue];
                         currentUser.numberOfVideoTokens = [NSNumber numberWithInt:value + 1];
                     }

                     //Blog Tokens
                     if ([[activity objectForKey:@"mediaType"]isEqualToString:@"note"])
                     {
                         int value = [currentUser.numberOfBlogTokens intValue];
                         currentUser.numberOfBlogTokens = [NSNumber numberWithInt:value + 1];
                     }

                     //Link Tokens
                     if ([[activity objectForKey:@"mediaType"]isEqualToString:@"link"])
                     {
                         int value = [currentUser.numberOfLinkTokens intValue];
                         currentUser.numberOfLinkTokens = [NSNumber numberWithInt:value + 1];
                     }

                     //Balance Activity Date
                     NSDateFormatter *df = [[NSDateFormatter alloc] init];
                     [df setDateFormat:@"MMM dd, yyyy"];
                     NSString *dateActivity = [df stringFromDate:activity.createdAt];


                     //Balance Activity Description

                     NSString *activityDescription = @"Added Tokens";


                     //Balance Transaction * ADD random Generated Number to prefix this count
                     int transaction = [currentUser.BalanceTransactionNumber intValue];
                     currentUser.BalanceTransactionNumber = [NSNumber numberWithInt:transaction + 1];

                     int balance = [currentUser.runningBalance intValue];
                     currentUser.runningBalance = [NSNumber numberWithInt:balance +1];
                     
                     BalanceActivity *balanceActivity = [[BalanceActivity alloc]initWithBalanceDescription:activityDescription balanceDate:dateActivity transactionNumber:currentUser.BalanceTransactionNumber runningBalance:currentUser.runningBalance];
                     
                     [currentUser.arrayOfBalanceActivity addObject:balanceActivity];
                 }



             }

             self.labelAvailableTokens.text = [currentUser.numberOfTotalTokens stringValue];

             self.labelPhotoTokens.text = [currentUser.numberOfPhotoTokens stringValue];
             self.labelVideoTokens.text = [currentUser.numberOfVideoTokens stringValue];
             self.labelLinkTokens.text = [currentUser.numberOfLinkTokens stringValue];
             self.labelScribeTokens.text = [currentUser.numberOfBlogTokens stringValue];

             self.labelSplashBonusTokens.text = @"0";
             self.labelInviteBonusTokens.text = @"0";


         }
         
     }];


}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    NSLog(@"View Did Disappear");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SendCancel" object:self];

}

#pragma mark - Button Press Methods

- (IBAction)presentBalanceView:(id)sender
{
    NSLog(@"BalanceView Pressed");
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
                        [self.buttonActivity setEnabled:YES];
                      
                    }];
                }];
            }];
        }];
    }];

}

- (IBAction)presentActivity:(id)sender
{
     NSLog(@"Activity Pressed");

    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 171, 320, 180)];

    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.btvc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"BalanceActivity"];
    [self.mainView addSubview:self.btvc.view];
    self.mainView.alpha = 0;

    [self.view addSubview:self.mainView];

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

                        [self.buttonActivity setEnabled:NO];
                    }];
                }];
            }];
        }];
    }];

}

- (IBAction)presentRedeemView:(id)sender
{
     NSLog(@"Redeem Pressed");
}



@end
