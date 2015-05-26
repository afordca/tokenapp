//
//  PersonalActivityViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/22/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "PersonalActivityViewController.h"
#import "UserActivityTableViewCell.h"
#import <Parse/Parse.h>
#import <AVFoundation/AVFoundation.h>


@interface PersonalActivityViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableViewProfileActivity;
@property NSArray *arrayOfActivity;
@property NSInteger likesCount;
@property NSInteger photoCount;

@end

@implementation PersonalActivityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableViewProfileActivity.delegate = self;
    //Accessing User Singleton

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    currentUser = [CurrentUser sharedSingleton];

}


#pragma mark - UITableView Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return currentUser.arrayOfPersonalActivityContent.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserActivityTableViewCell *cellActivity = [tableView dequeueReusableCellWithIdentifier:@"UserActivity"];

    Activity *personalActivity = [currentUser.arrayOfPersonalActivityContent objectAtIndex:indexPath.row];

    //Username
    NSString *userName = currentUser.userName;
    //Action
    NSString *action = personalActivity.activityType;
    //toUserName
    NSString *toUsername = personalActivity.toUserName;
    //mediaType
    NSString *mediaType = personalActivity.typeOfMedia;

    //Set and Round Profile Pic Image
    cellActivity.imageViewProfilePic.image = currentUser.profileImage;
    cellActivity.imageViewProfilePic.layer.cornerRadius = cellActivity.imageViewProfilePic.frame.size.height /2;
    cellActivity.imageViewProfilePic.layer.masksToBounds = YES;
    cellActivity.imageViewProfilePic.layer.borderWidth = 0;

    if ([personalActivity.activityType isEqual:@"followed"]) {
        cellActivity.labelUsername.text = [NSString stringWithFormat:@"%@ %@ %@",userName,action,toUsername];
        cellActivity.imageViewPhoto.image = personalActivity.toUserProfilepic;
    }

    else if ([personalActivity.activityType isEqual:@"posted"])
    {
        cellActivity.labelUsername.text = [NSString stringWithFormat:@"%@ %@ %@",userName,action,mediaType];
        cellActivity.imageViewPhoto.image = personalActivity.imageContent;
    }

    else if ([personalActivity.activityType isEqual:@"liked"])
    {
        cellActivity.labelUsername.text = [NSString stringWithFormat:@"%@ %@ %@",userName,action, mediaType];
        cellActivity.imageViewPhoto.image = personalActivity.imageContent;

    }

    return cellActivity;
}

@end
