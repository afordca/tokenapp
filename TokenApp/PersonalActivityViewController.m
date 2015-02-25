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


    self.arrayOfActivity = [NSArray arrayWithArray:currentUser.arrayOfUserActivity];
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"toUser.objectId"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    self.arrayOfActivity  = [self.arrayOfActivity sortedArrayUsingDescriptors:sortDescriptors];



    
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
    NSString *stringMediaType = [[self.arrayOfActivity objectAtIndex:indexPath.row]objectForKey:@"mediaType"];
    PFObject *photo = [[self.arrayOfActivity objectAtIndex:indexPath.row]objectForKey:@"photo"];
    PFUser *toUser = [[self.arrayOfActivity objectAtIndex:indexPath.row]objectForKey:@"toUser"];


    cellActivity.labelUsername.text = [NSString stringWithFormat:@"%@ %@ a %@",currentUser.userName, type,stringMediaType];

    cellActivity.imageViewProfilePic.image = currentUser.profileImage;

    //Round Profile Pic
    cellActivity.imageViewProfilePic.layer.cornerRadius = cellActivity.imageViewProfilePic.frame.size.height /2;
    cellActivity.imageViewProfilePic.layer.masksToBounds = YES;
    cellActivity.imageViewProfilePic.layer.borderWidth = 0;

    PFFile *parseFileWithImage = [photo objectForKey:@"image"];
    NSURL *url = [NSURL URLWithString:parseFileWithImage.url];
    NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        cellActivity.imageViewPhoto.image = [UIImage imageWithData:data];
    }];

    return cellActivity;

}

@end
