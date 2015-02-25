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

@interface FollowersViewController ()<UITableViewDataSource, UITableViewDelegate>
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

    // User that is following Current User

    cellFollowers.labelUsername.text = [[currentUser.arrayOfFollowers objectAtIndex:indexPath.row]objectForKey:@"username"];

    //Round Profile Pic
    cellFollowers.imageViewFollowerProfilePic.layer.cornerRadius = cellFollowers.imageViewFollowerProfilePic.frame.size.height /2;
    cellFollowers.imageViewFollowerProfilePic.layer.masksToBounds = YES;
    cellFollowers.imageViewFollowerProfilePic.layer.borderWidth = 0;

    PFFile *parseFileWithImage = [[currentUser.arrayOfFollowers objectAtIndex:indexPath.row] objectForKey:@"profileImage"];
    NSURL *url = [NSURL URLWithString:parseFileWithImage.url];
    NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        cellFollowers.imageViewFollowerProfilePic.image = [UIImage imageWithData:data];
    }];

    return cellFollowers;
}

@end
