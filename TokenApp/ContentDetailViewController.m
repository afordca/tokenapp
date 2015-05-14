//
//  ContentDetailViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 5/11/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "ContentDetailViewController.h"
#import "ContentDetailTableViewCell.h"
#import "CurrentUser.h"
#import <Parse/Parse.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ContentDetailViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableViewContentDetail;
@property (strong, nonatomic) IBOutlet UILabel *labelUsername;
@property (strong,nonatomic) MPMoviePlayerController *videoController;

@property PFUser *currentUser;
@property CurrentUser *singleUser;

@property NSInteger likes;
@property BOOL liked;
@end

@implementation ContentDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentUser = [PFUser currentUser];
    self.singleUser = [CurrentUser sharedSingleton];
    self.labelUsername.text = self.detailPost.userName;
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
}
#pragma mark - Button Press Methods

- (IBAction)onButtonPressCancel:(id)sender
{

    [self.singleUser loadHomeFeedActivity:^(BOOL result)
     {
         [self.singleUser loadHomeFeedContent:^(BOOL result)
          {
              [self.navigationController popToRootViewControllerAnimated:YES];
          }];
     }];
}

#pragma mark - UITableView Delegate Methods


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContentDetailTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"ContentCell"];

    if ([self.detailPost.mediaType isEqualToString:@"photo"])
    {
        Photo *photo = self.detailPost.photoPost;

        contentCell.imageViewContent.image = photo.picture;
        contentCell.labelContentDescription.text = photo.photoDescription;

        self.likes = self.likes + photo.numberOfLikes;
        NSString *stringLikes = [NSString stringWithFormat:@"%li",self.likes];
        contentCell.labelNumberOfLikes.text = stringLikes;

        //Check if User likes content already

        UITapGestureRecognizer *tapGestureRecognizerLike = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTapped:)];


        [self checkUserLike:^(BOOL result)
        {
            if (self.liked)
            {
                contentCell.imageViewLike.image = [UIImage imageNamed:@"LikeFill"];
                [contentCell.imageViewLike removeGestureRecognizer:tapGestureRecognizerLike];
                contentCell.imageViewLike.userInteractionEnabled = NO;

            }
            else
            {

                tapGestureRecognizerLike.numberOfTapsRequired = 1;
                [contentCell.imageViewLike addGestureRecognizer:tapGestureRecognizerLike];
                contentCell.imageViewLike.userInteractionEnabled = YES;
            }

        }];

        return contentCell;
    }
    if ([self.detailPost.mediaType isEqualToString:@"video"])
    {
        Video *video = self.detailPost.videoPost;

        self.videoController = [[MPMoviePlayerController alloc] init];
        [self.videoController setContentURL:video.videoURL];
        [self.videoController setScalingMode:MPMovieScalingModeAspectFill];
        [self.videoController.view setFrame:CGRectMake (0, 0, 320, 298)];
        [contentCell addSubview:self.videoController.view];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(videoPlayBackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:self.videoController];
        [self.videoController play];


        return contentCell;

    }
    if ([self.detailPost.mediaType isEqualToString:@"link"])
    {
        Link *link = self.detailPost.linkPost;


        return contentCell;
    }

    if ([self.detailPost.mediaType isEqualToString:@"post"])
    {
        Post *note = self.detailPost.messagePost;


        return contentCell;
    }


    return nil;
}

#pragma mark - Video Methods

- (void)videoPlayBackDidFinish:(NSNotification *)notification {

    // Stop the video player
    [self.videoController stop];

    // Play video player
    [self.videoController play];
    
}

#pragma mark - UITapGesture Methods

-(void)likeTapped:(UITapGestureRecognizer*)sender
{
    NSLog(@"Like Tapped");

    PFQuery *queryPhoto = [PFQuery queryWithClassName:@"Photo"];
    [queryPhoto whereKey:@"objectId" equalTo:self.detailPost.photoPost.photoID];

    PFObject *updatedPhoto = [queryPhoto getFirstObject];
    [updatedPhoto incrementKey:@"numberOfLikes" byAmount:[NSNumber numberWithInt:1]];

    PFRelation *relation = [updatedPhoto relationForKey:@"Likers"];
    [relation addObject:self.currentUser];

    [updatedPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         NSLog( @"Photo Updated");

         PFObject *activity = [PFObject objectWithClassName:@"Activity"];


         [activity setObject:@"like" forKey:@"type"];
         [activity setObject:@"photo" forKey:@"mediaType"];
         [activity setObject:self.currentUser forKey:@"fromUser"];
         [activity setObject:updatedPhoto forKey:@"photo"];
         [activity setObject:self.currentUser.objectId forKey:@"fromUserID"];
         [activity setValue:self.currentUser.username forKey:@"username"];

         [activity saveInBackgroundWithBlock:^(BOOL success, NSError* error)
          {
              if (error) {
                  NSLog(@"%@",[error userInfo]);
              }
              else
              {
                  NSLog(@"Like Activity Saved");
                  self.likes = self.likes + 1;
                  [self.tableViewContentDetail reloadData];

              }
          }];
         
     }];
}

#pragma mark - Helper Methods

-(void)checkUserLike:(void (^)(BOOL))completionHandler;
{
    PFQuery *queryPhoto = [PFQuery queryWithClassName:@"Photo"];
    [queryPhoto whereKey:@"Likers" equalTo:self.currentUser];
    [queryPhoto findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error) {
             NSLog(@"%@",[error userInfo]);
         }
         else
         {
             if (!objects.count==0)
             {
                 self.liked = YES;
                 completionHandler(YES);
             }

             else
             {
                 self.liked = NO;
                 completionHandler(YES);
             }
         }

         
     }];

}

@end
