//
//  PersonalActivityViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/22/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "PersonalActivityViewController.h"
#import "UserActivityTableViewCell.h"
#import "Post.h"
#import <Parse/Parse.h>
#import <AVFoundation/AVFoundation.h>


@interface PersonalActivityViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableViewProfileActivity;
@property NSMutableArray *arrayOfActivity;
@property NSInteger likesCount;
@property NSInteger photoCount;

@property CGFloat currentPosition;

@property (strong, nonatomic) IBOutlet UITableView *tableViewPersonalActivity;

@property BOOL isVideo;
@property BOOL noMoreResultsAvail;
@property BOOL loading;


@end

@implementation PersonalActivityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];


    self.tableViewProfileActivity.delegate = self;


}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    currentUser = [CurrentUser sharedSingleton];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

    if (currentUser.arrayOfHomeFeedContent.count < 10)
    {
        self.arrayOfActivity = [NSMutableArray new];
        for (Activity * activity in currentUser.arrayOfPersonalActivityContent)
        {
            [self.arrayOfActivity addObject:activity];
        }
    }
    else
    {
        self.noMoreResultsAvail = NO;
        self.arrayOfActivity = [NSMutableArray new];
        for (int i = 0; i<10; i++)
        {
            [self.arrayOfActivity addObject:currentUser.arrayOfPersonalActivityContent[i]];
        }
    }

    [self.tableViewProfileActivity reloadData];

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [self.arrayOfActivity removeAllObjects];

    [self.tableViewProfileActivity reloadData];
}


#pragma mark - UITableView Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayOfActivity.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserActivityTableViewCell *cellActivity = [tableView dequeueReusableCellWithIdentifier:@"UserActivity"];

    Activity *personalActivity = [self.arrayOfActivity objectAtIndex:indexPath.row];

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
        cellActivity.labelUsername.text = [NSString stringWithFormat:@"%@ is now following %@",userName,toUsername];
        cellActivity.imageViewPhoto.image = personalActivity.toUserProfilepic;
    }

    else if ([personalActivity.activityType isEqual:@"posted"])
    {
        cellActivity.labelUsername.text = [NSString stringWithFormat:@"%@ shared a %@",userName,mediaType];
        cellActivity.imageViewPhoto.image = personalActivity.imageContent;
    }

    else if ([personalActivity.activityType isEqual:@"liked"])
    {
        cellActivity.labelUsername.text = [NSString stringWithFormat:@"%@ %@ %@",userName,action, mediaType];
        cellActivity.imageViewPhoto.image = personalActivity.imageContent;

    }

    if ([personalActivity.typeOfMedia isEqual:@"note"]) {

        Post *post = personalActivity.post;

        cellActivity.labelUsername.text = [NSString stringWithFormat:@"%@ %@ %@:'%@'",userName,action, mediaType, post.postHeader];

//        [cellActivity.imageViewPhoto setHidden:YES];
    }

    return cellActivity;
}

#pragma UIScroll View Method::
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!self.loading) {
        float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (endScrolling >= scrollView.contentSize.height)
        {
            [self performSelector:@selector(loadDataDelayed) withObject:nil afterDelay:1];

        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{


    //Top Scroll
    if (scrollView.contentOffset.y < self.currentPosition)
    {
        NSLog(@"Scroll up");

        //Show Tab Bar

    }
    //Bottom Scroll
    else if (scrollView.contentOffset.y > self.currentPosition)
    {
        NSLog(@"Scroll down");
    }
    //Setting the current position of the WebView scroll
    self.currentPosition = scrollView.contentOffset.y;

}
#pragma UserDefined Method for generating data which are show in Table :::
-(void)loadDataDelayed
{
//    if (self.arrayOfActivity.count == currentUser.arrayOfPersonalActivityContent.count)
//    {
        NSLog(@"End of Feed");

        NSInteger skip = self.arrayOfActivity.count;

        [currentUser loadHomeFeedActivity:skip limit:10 type:@"personal" completion:^(BOOL result)
         {
             if (result) {

             [currentUser loadPersonalActivityContent:^(BOOL result)
              {
                  for (int i = 0; i<currentUser.arrayOfPersonalActivityContent.count; i++)
                  {
                      [self.arrayOfActivity addObject:currentUser.arrayOfPersonalActivityContent[i]];
                  }

                  [self.tableViewProfileActivity reloadData];
              }];

             }
         }];

}


@end
