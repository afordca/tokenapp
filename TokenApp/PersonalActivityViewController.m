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
    currentUser = [CurrentUser sharedSingleton];
    [currentUser loadHomeFeedActivity:0 limit:10 type:@"personal" completion:^(BOOL result) {
        [self.tableViewProfileActivity reloadData];
    }];


}


#pragma mark - UITableView Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return currentUser.arrayOfPersonalActivity.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserActivityTableViewCell *cellActivity = [tableView dequeueReusableCellWithIdentifier:@"UserActivity"];

    //Set and Round Profile Pic Image
    cellActivity.imageViewProfilePic.image = currentUser.profileImage;
    cellActivity.imageViewProfilePic.layer.cornerRadius = cellActivity.imageViewProfilePic.frame.size.height /2;
    cellActivity.imageViewProfilePic.layer.masksToBounds = YES;
    cellActivity.imageViewProfilePic.layer.borderWidth = 0;

    PFObject *activity = [currentUser.arrayOfPersonalActivity objectAtIndex:indexPath.row];

    //Username
    NSString *fromUser = [[activity objectForKey:@"fromUser"]objectForKey:@"username"];

    //Activity Type
    NSString *activityAction;
    if ([[activity objectForKey:@"type"]isEqualToString:@"follow"])
    {
        activityAction = @"followed";
    }
    else if ([[activity objectForKey:@"type"]isEqualToString:@"like"])
    {
        activityAction = @"liked";
    }
    else if ([[activity objectForKey:@"type"]isEqualToString:@"post"])

    {
        activityAction = @"post";
    }

    cellActivity.labelUsername.text = [NSString stringWithFormat:@"%@ %@",fromUser,activityAction];


    
return cellActivity;


}

@end
