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
    currentUser = [User sharedSingleton];

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

    NSString *type = [[self.arrayOfActivity objectAtIndex:indexPath.row]objectForKey:@"type"];
    PFUser *user = [[self.arrayOfActivity objectAtIndex:indexPath.row]objectForKey:@"toUser"];
    NSString *stringMediaType = [[self.arrayOfActivity objectAtIndex:indexPath.row]objectForKey:@"mediaType"];
    PFObject *photo = [[self.arrayOfActivity objectAtIndex:indexPath.row]objectForKey:@"photo"];


    //Set and Round Profile Pic
    cellActivity.imageViewProfilePic.image = currentUser.profileImage;
    cellActivity.imageViewProfilePic.layer.cornerRadius = cellActivity.imageViewProfilePic.frame.size.height /2;
    cellActivity.imageViewProfilePic.layer.masksToBounds = YES;
    cellActivity.imageViewProfilePic.layer.borderWidth = 0;

    //User Activity Description
    if (!stringMediaType)
    {
        //Follow activity
        cellActivity.labelUsername.text = [NSString stringWithFormat:@"%@ %@ %@",currentUser.userName, type,user.username];

        PFFile *parseFileWithImage = [user objectForKey:@"profileImage"];
        NSURL *url = [NSURL URLWithString:parseFileWithImage.url];
        NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            cellActivity.imageViewPhoto.image = [UIImage imageWithData:data];
            //Set and Round Profile Pic
            cellActivity.imageViewPhoto.layer.cornerRadius = cellActivity.imageViewPhoto.frame.size.height /2;
            cellActivity.imageViewPhoto.layer.masksToBounds = YES;
            cellActivity.imageViewPhoto.layer.borderWidth = 0;
        }];
    }
    else
    {
        //Media activity
        cellActivity.labelUsername.text = [NSString stringWithFormat:@"%@ %@ a %@",currentUser.userName, type,stringMediaType];


        PFFile *parseFileWithImage = [photo objectForKey:@"image"];
        NSURL *url = [NSURL URLWithString:parseFileWithImage.url];
        NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            cellActivity.imageViewPhoto.image = [UIImage imageWithData:data];
        }];


    }
return cellActivity;


}

@end
