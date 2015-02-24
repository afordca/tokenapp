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
#import <Parse/PFQuery.h>



@interface TKFollowerProfileViewController ()

@property (nonatomic) bool isFollowing;
@property (nonatomic, strong) PFUser *user;
@property (weak, nonatomic) IBOutlet UILabel *countForFollowers;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet PFImageView *profilePictureImageView;

@end


@implementation TKFollowerProfileViewController


- (id)initWithUser:(PFUser *)aUser {
    if (self) {
        self.user = aUser;

        if (!aUser) {
            [NSException raise:NSInvalidArgumentException format:@"TKAccountViewController init exception: user cannot be nil"];
        }

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //Does logged in user follow this user?
    //Yes --> show 'unfollow"

    if (!self.user) {
        self.user = [PFUser currentUser];
        [[PFUser currentUser] fetchIfNeeded];
    }

    if ([TKUtility userHasProfilePictures:self.user]) {
        PFFile *imageFile = [self.user objectForKey:kPTKUserProfilePicMediumKey];
        [self.profilePictureImageView setFile:imageFile];
        [self.profilePictureImageView loadInBackground:^(UIImage *image, NSError *error) {
            if (!error) {
                [UIView animateWithDuration:0.2f animations:^{
                    self.profilePictureImageView.alpha = 1.0f;
                }];
            }
        }];
    } else {
        self.profilePictureImageView.image = [TKUtility defaultProfilePicture];
        [UIView animateWithDuration:0.2f animations:^{
            self.profilePictureImageView.alpha = 1.0f;
        }];
        


    PFQuery *queryFollowingCount = [PFQuery queryWithClassName:kPTKActivityClassKey];
    [queryFollowingCount whereKey:kPTKActivityTypeKey equalTo:kPTKActivityTypeFollow];
    [queryFollowingCount whereKey:kPTKActivityFromUserKey equalTo:self.user];
    [queryFollowingCount setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [queryFollowingCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            [self.countForFollowers setText:[NSString stringWithFormat:@"%d following", number]];
        }
    }];

    if (![[self.user objectId] isEqualToString:[[PFUser currentUser] objectId]]) {

    // check if the currentUser is following this user
    PFQuery *queryIsFollowing = [PFQuery queryWithClassName:kPTKActivityClassKey];
    [queryIsFollowing whereKey:kPTKActivityTypeKey equalTo:kPTKActivityTypeFollow];
    [queryIsFollowing whereKey:kPTKActivityToUserKey equalTo:self.user];
    [queryIsFollowing whereKey:kPTKActivityFromUserKey equalTo:[PFUser currentUser]];
    [queryIsFollowing setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [queryIsFollowing countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (error && [error code] != kPFErrorCacheMiss) {
            NSLog(@"Couldn't determine follow relationship: %@", error);
            self.navigationItem.rightBarButtonItem = nil;
        } else {
            if (number == 0) {
                [self configureFollowButton];
            } else {
                [self configureUnFollowButton];
            }
        }
    }];

}
    }

}

- (PFQuery *)queryForTable {
    if (!self.user) {
        PFQuery *query = [PFQuery queryWithClassName:self.user.parseClassName];
        [query setLimit:0];
        return query;
    }

    PFQuery *query = [PFQuery queryWithClassName:self.user.parseClassName];
    query.cachePolicy = kPFCachePolicyNetworkOnly;
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    [query whereKey:kPTKPhotoUserKey equalTo:self.user];
    [query orderByDescending:@"createdAt"];
    [query includeKey:kPTKPhotoUserKey];

    return query;
}

-(void)followButtonAction:(id)sender
{
    [TKUtility followUserEventually:self.user block:^(BOOL succeeded, NSError *error) {
        if (error) {
            [self configureFollowButton];
        }
    }];
}

-(void)configureFollowButton
{
    //Set logic here to toggle button from follow to unfollow 
    [[TKCache sharedCache] setFollowStatus:NO user:self.user];
}

-(void)configureUnFollowButton
{
    [[TKCache sharedCache] setFollowStatus:YES user:self.user];
}


@end
