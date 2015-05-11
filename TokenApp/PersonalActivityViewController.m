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

    //User Activity Array
    self.arrayOfActivity = [NSArray new];
    self.arrayOfActivity = [NSArray arrayWithArray:currentUser.arrayOfFromUserActivity];

}

#pragma mark - UITableView Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayOfActivity.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserActivityTableViewCell *cellActivity = [tableView dequeueReusableCellWithIdentifier:@"UserActivity"];

    Activity *activity = [Activity new];
    activity = [currentUser.arrayOfFromUserActivity objectAtIndex:indexPath.row];

    //Set and Round Profile Pic
    cellActivity.imageViewProfilePic.image = currentUser.profileImage;
    cellActivity.imageViewProfilePic.layer.cornerRadius = cellActivity.imageViewProfilePic.frame.size.height /2;
    cellActivity.imageViewProfilePic.layer.masksToBounds = YES;
    cellActivity.imageViewProfilePic.layer.borderWidth = 0;

    //User Activity Description
    if (!activity.typeOfMedia)
    {
        //Follow activity
        cellActivity.labelUsername.text = [NSString stringWithFormat:@"%@ %@ %@",activity.fromUser.userName, activity.activityType,activity.toUser.userName];

            cellActivity.imageViewPhoto.image = activity.fromUser.profileImage;
            //Set and Round Profile Pic
            cellActivity.imageViewPhoto.layer.cornerRadius = cellActivity.imageViewPhoto.frame.size.height /2;
            cellActivity.imageViewPhoto.layer.masksToBounds = YES;
            cellActivity.imageViewPhoto.layer.borderWidth = 0;
    }

    {
        //Media activity
        cellActivity.labelUsername.text = [NSString stringWithFormat:@"%@ %@ a %@",activity.fromUser.userName, activity.activityType,activity.typeOfMedia];

        if (activity.photo)
        {
            cellActivity.imageViewPhoto.image = activity.photo.picture;
        }

    }
return cellActivity;


}

@end
