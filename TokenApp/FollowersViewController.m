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
    currentUser = [User sharedSingleton];
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
        cellFollowers.labelUsername.text = [[currentUser.arrayOfFollowing objectAtIndex:indexPath.row]objectForKey:@"username"];

        //Round Profile Pic
        cellFollowers.imageViewFollowerProfilePic.layer.cornerRadius = cellFollowers.imageViewFollowerProfilePic.frame.size.height /2;
        cellFollowers.imageViewFollowerProfilePic.layer.masksToBounds = YES;
        cellFollowers.imageViewFollowerProfilePic.layer.borderWidth = 0;

        //Follower Profile Pic
        PFFile *parseFileWithImage = [[currentUser.arrayOfFollowing objectAtIndex:indexPath.row] objectForKey:@"profileImage"];
        NSURL *url = [NSURL URLWithString:parseFileWithImage.url];
        NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
         {
             if (!data)
             {   // Default Profile Pic
                 cellFollowers.imageViewFollowerProfilePic.image = [UIImage imageNamed:@"ProfileDefault"];
             }
             else
             {   // Profile Pic
                 cellFollowers.imageViewFollowerProfilePic.image = [UIImage imageWithData:data];
             }
         }];

        //Set Follower / Following Status
        cellFollowers.imageViewFollowStatus.image = [currentUser followerStatus:[currentUser.arrayOfFollowing objectAtIndex:indexPath.row]];

    }
    else
    {
    //////////////// FOLLOWERS /////////////////////////

    // User that is following Current User
    cellFollowers.userFollower = [currentUser.arrayOfFollowers objectAtIndex:indexPath.row];
    cellFollowers.labelUsername.text = [[currentUser.arrayOfFollowers objectAtIndex:indexPath.row]objectForKey:@"username"];

    //Round Profile Pic
    cellFollowers.imageViewFollowerProfilePic.layer.cornerRadius = cellFollowers.imageViewFollowerProfilePic.frame.size.height /2;
    cellFollowers.imageViewFollowerProfilePic.layer.masksToBounds = YES;
    cellFollowers.imageViewFollowerProfilePic.layer.borderWidth = 0;

    //Follower Profile Pic
    PFFile *parseFileWithImage = [[currentUser.arrayOfFollowers objectAtIndex:indexPath.row] objectForKey:@"profileImage"];
    NSURL *url = [NSURL URLWithString:parseFileWithImage.url];
    NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        if (!data)
        {   // Default Profile Pic
            cellFollowers.imageViewFollowerProfilePic.image = [UIImage imageNamed:@"ProfileDefault"];
        }
        else
        {   // Profile Pic
            cellFollowers.imageViewFollowerProfilePic.image = [UIImage imageWithData:data];
        }
    }];

    //Set Follower / Following Status
    cellFollowers.imageViewFollowStatus.image = [currentUser followerStatus:[currentUser.arrayOfFollowers objectAtIndex:indexPath.row]];

    }

    return cellFollowers;
}


#pragma mark - FollowersTableViewCell Delegate Method

-(void)followerFollowingPressed:(PFUser *)user row:(NSInteger)row
{
    NSLog(@"%@",user);
    BOOL isFollowingFollower = [currentUser isFollowingFollower:user];

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
