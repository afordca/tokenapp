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

@interface FollowersViewController ()<UITableViewDataSource, UITableViewDelegate,FollowersTableViewCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableviewFollowers;

@end

@implementation FollowersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    currentUser = [User sharedSingleton];

}

#pragma mark UITableView Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return currentUser.arrayOfFollowers.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FollowersTableViewCell *cellFollowers = [tableView dequeueReusableCellWithIdentifier:@"FollowersActivity"];
    cellFollowers.delegate = self;

    PFUser *userFollowing = [currentUser.arrayOfFollowers objectAtIndex:indexPath.row];

    // User that is following Current User
    cellFollowers.labelUsername.text = [[currentUser.arrayOfFollowers objectAtIndex:indexPath.row]objectForKey:@"username"];

    //Round Profile Pic
    cellFollowers.imageViewFollowerProfilePic.layer.cornerRadius = cellFollowers.imageViewFollowerProfilePic.frame.size.height /2;
    cellFollowers.imageViewFollowerProfilePic.layer.masksToBounds = YES;
    cellFollowers.imageViewFollowerProfilePic.layer.borderWidth = 0;

    //Follower Profile Pic
    PFFile *parseFileWithImage = [[currentUser.arrayOfFollowers objectAtIndex:indexPath.row] objectForKey:@"profileImage"];
    NSURL *url = [NSURL URLWithString:parseFileWithImage.url];
    NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        cellFollowers.imageViewFollowerProfilePic.image = [UIImage imageWithData:data];
    }];

    for (PFUser *followingUser in currentUser.arrayOfFollowing)
    {
        if ([followingUser.objectId isEqual:userFollowing.objectId]) {
            cellFollowers.buttonFollowerFollowing.imageView.image = [UIImage imageNamed:@"Following"];
        }
        else
        {
            cellFollowers.buttonFollowerFollowing.imageView.image = [UIImage imageNamed:@"FollowAdd"];

        }
    }

    return cellFollowers;
}

#pragma mark - FollowersTableViewCell Delegate Method

-(void)followerFollowingPressed:(NSString *)status
{
    NSLog(@"TEST Status: %@",status);
    [self.tableviewFollowers reloadData];
    

}


@end
