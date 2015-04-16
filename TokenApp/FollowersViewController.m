//
//  FollowersViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/24/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "FollowersViewController.h"
#import "FollowersTableViewCell.h"
#import <Parse/Parse.h>

#define FOLLOWING_NIB_NAME "oKx-ym-ZPg-view-6PJ-wm-kNy"

@interface FollowersViewController ()<UITableViewDataSource, UITableViewDelegate,FollowersTableViewCellDelegate,UserDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableviewFollowers;
@property (strong, nonatomic) IBOutlet UITableView *tableViewFollowing;

@end

@implementation FollowersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    currentUser = [CurrentUser sharedSingleton];
    currentUser.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

}


#pragma mark UITableView Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.nibName isEqualToString:@FOLLOWING_NIB_NAME])
    {
        return currentUser.arrayOfFollowing.count;
    }
    else
    {
        return currentUser.arrayOfFollowers.count;
    }

    return 0;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FollowersTableViewCell *cellFollowers = [tableView dequeueReusableCellWithIdentifier:@"FollowersActivity"];
    cellFollowers.delegate = self;
    cellFollowers.row = indexPath.row;


    if ([self.nibName isEqualToString:@FOLLOWING_NIB_NAME] || [tableView isEqual:self.tableViewFollowing])
    {
    //////////////// FOLLOWING /////////////////////////
        // User that is following Current User
        cellFollowers.userFollower = [currentUser.arrayOfFollowing objectAtIndex:indexPath.row];
        cellFollowers.labelUsername.text = [[currentUser.arrayOfFollowing objectAtIndex:indexPath.row]userName];

        //Round Profile Pic
        cellFollowers.imageViewFollowerProfilePic.layer.cornerRadius = cellFollowers.imageViewFollowerProfilePic.frame.size.height /2;
        cellFollowers.imageViewFollowerProfilePic.layer.masksToBounds = YES;
        cellFollowers.imageViewFollowerProfilePic.layer.borderWidth = 0;

        //Follower Profile Pic
        if (![[currentUser.arrayOfFollowing objectAtIndex:indexPath.row]profileImage])
        {   // Default Profile Pic
            cellFollowers.imageViewFollowerProfilePic.image = [UIImage imageNamed:@"ProfileDefault"];
        }
        else
        {   // Profile Pic
            cellFollowers.imageViewFollowerProfilePic.image = [[currentUser.arrayOfFollowing objectAtIndex:indexPath.row]profileImage];
        }


        //Set Follower / Following Status

         NSString *objectID = [[currentUser.arrayOfFollowing objectAtIndex:indexPath.row]objectID];

        cellFollowers.imageViewFollowStatus.image = [currentUser followerStatus:objectID];

    }
    else
    {
    //////////////// FOLLOWERS /////////////////////////

    // User that is following Current User
    cellFollowers.userFollower = [currentUser.arrayOfFollowers objectAtIndex:indexPath.row];
    cellFollowers.labelUsername.text = [[currentUser.arrayOfFollowers objectAtIndex:indexPath.row]userName];

    //Round Profile Pic
    cellFollowers.imageViewFollowerProfilePic.layer.cornerRadius = cellFollowers.imageViewFollowerProfilePic.frame.size.height /2;
    cellFollowers.imageViewFollowerProfilePic.layer.masksToBounds = YES;
    cellFollowers.imageViewFollowerProfilePic.layer.borderWidth = 0;

    if (![[currentUser.arrayOfFollowers objectAtIndex:indexPath.row]profileImage])
    {   // Default Profile Pic
        cellFollowers.imageViewFollowerProfilePic.image = [UIImage imageNamed:@"ProfileDefault"];
    }
    else
    {   // Profile Pic
        cellFollowers.imageViewFollowerProfilePic.image = [[currentUser.arrayOfFollowers objectAtIndex:indexPath.row]profileImage];
    }

    //Set Follower / Following Status

        NSString *objectID = [[currentUser.arrayOfFollowers objectAtIndex:indexPath.row]objectID];

    cellFollowers.imageViewFollowStatus.image = [currentUser followerStatus:objectID];

    }

    return cellFollowers;
}


#pragma mark - FollowersTableViewCell Delegate Method

-(void)followerFollowingPressed:(User *)user row:(NSInteger)row
{
    NSLog(@"%@",user);
    BOOL isFollowingFollower = [currentUser isFollowingFollower:user.objectID];

    if (isFollowingFollower)
    {
        //Unfollow this user
        [currentUser removeUserFromFollowing:user row:row];

    }
    else
    {
        //Follow this user
        [currentUser addUserToFollowing:user row:row];
        
        
    }
}

#pragma mark - User Delegate Methods


-(void)reloadTableAfterArrayUpdate:(NSInteger)row
{
    //Call reload on the main thread
    [self.tableViewFollowing performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];

    NSArray *indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]];
    //You can add one or more indexPath in this array...

    [self.tableviewFollowers reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
}

-(void)reloadCollectionAfterArrayUpdate
{

}



@end
