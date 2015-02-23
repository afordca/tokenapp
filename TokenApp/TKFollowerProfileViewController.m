//
//  TKFollowerProfileViewController.m
//  TokenApp
//
//  Created by BASEL FARAG on 2/20/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "TKFollowerProfileViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "Macros.h"
#import "TKUtility.h"
#import "TKCache.h"
#import "Constants.h" 

@interface TKFollowerProfileViewController ()

@property (nonatomic) bool isFollowing;
@property (nonatomic, strong) PFUser *user;

@end


@implementation TKFollowerProfileViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //Does logged in user follow this user?
    //Yes --> show 'unfollow"

    if (!self.user) {
        self.user = [PFUser currentUser];
        [[PFUser currentUser] fetchIfNeeded];
    }

//    if ([TKUtility userHasProfilePictures:self.user]) {
//        PFFile *imageFile = [self.user objectForKey:kPTKUserProfilePicMediumKey];
//        [profilePictureImageView setFile:imageFile];
//        [profilePictureImageView loadInBackground:^(UIImage *image, NSError *error) {
//            if (!error) {
//                [UIView animateWithDuration:0.2f animations:^{
//                    profilePictureBackgroundView.alpha = 1.0f;
//                    profilePictureImageView.alpha = 1.0f;
//                }];
//
//                UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[image applyDarkEffect]];
//                backgroundImageView.frame = self.tableView.backgroundView.bounds;
//                backgroundImageView.alpha = 0.0f;
//                [self.tableView.backgroundView addSubview:backgroundImageView];
//
//                [UIView animateWithDuration:0.2f animations:^{
//                    backgroundImageView.alpha = 1.0f;
//                }];
//            }
//        }];
//    } else {
//        profilePictureImageView.image = [TKUtility defaultProfilePicture];
//        [UIView animateWithDuration:0.2f animations:^{
//            profilePictureBackgroundView.alpha = 1.0f;
//            profilePictureImageView.alpha = 1.0f;
//        }];
//        
//
//
//    PFQuery *queryFollowingCount = [PFQuery queryWithClassName:kPTKActivityClassKey];
//    [queryFollowingCount whereKey:kPTKActivityTypeKey equalTo:kPTKActivityTypeFollow];
//    [queryFollowingCount whereKey:kPTKActivityFromUserKey equalTo:self.user];
//    [queryFollowingCount setCachePolicy:kPFCachePolicyCacheThenNetwork];
//    [queryFollowingCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
//        if (!error) {
//            [followingCountLabel setText:[NSString stringWithFormat:@"%d following", number]];
//        }
//    }];
//    
//
//    // check if the currentUser is following this user
//    PFQuery *queryIsFollowing = [PFQuery queryWithClassName:kPTKActivityClassKey];
//    [queryIsFollowing whereKey:kPTKActivityTypeKey equalTo:kPTKActivityTypeFollow];
//    [queryIsFollowing whereKey:kPTKActivityToUserKey equalTo:self.user];
//    [queryIsFollowing whereKey:kPTKActivityFromUserKey equalTo:[PFUser currentUser]];
//    [queryIsFollowing setCachePolicy:kPFCachePolicyCacheThenNetwork];
//    [queryIsFollowing countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
//        if (error && [error code] != kPFErrorCacheMiss) {
//            NSLog(@"Couldn't determine follow relationship: %@", error);
//            self.navigationItem.rightBarButtonItem = nil;
//        } else {
//            if (number == 0) {
//                [self configureFollowButton];
//            } else {
//                [self configureUnfollowButton];
//            }
//        }
//    }];
//
//}



}


@end
