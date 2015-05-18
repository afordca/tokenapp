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

//    [self.singleUser loadHomeFeedActivity:0 completion:^(BOOL result)
//    {
//         [self.singleUser loadHomeFeedContent:^(BOOL result)
//          {
              [self.navigationController popToRootViewControllerAnimated:YES];
//          }];
//     }];
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

        self.likes = self.likes + photo.numberOfLikes;
        NSString *stringLikes = [NSString stringWithFormat:@"%li",self.likes];
        NSString *contentID = photo.photoID;

        contentCell.labelNumberOfLikes.text = stringLikes;
        contentCell.imageViewContent.image = photo.picture;
        contentCell.labelContentDescription.text = photo.photoDescription;



        //Check if User likes content already

        UITapGestureRecognizer *tapGestureRecognizerLike = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTapped:)];

        [self checkUserLike:@"Photo" contentID:contentID completion:^(BOOL result)
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


        self.likes = self.likes + video.numberOfLikes;
        NSString *stringLikes = [NSString stringWithFormat:@"%li",self.likes];
        NSString *contentID = video.videoID;

        contentCell.labelNumberOfLikes.text = stringLikes;
        contentCell.labelContentDescription.text = video.videoDescription;

        //Check if User likes content already

        UITapGestureRecognizer *tapGestureRecognizerLike = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTapped:)];

        [self checkUserLike:@"Video" contentID:contentID completion:^(BOOL result)
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

    NSString *className;
    NSString *contentID;
    NSString *contentType = self.detailPost.mediaType;

    if ([self.detailPost.mediaType isEqualToString:@"photo"])
    {
        Photo *photo = self.detailPost.photoPost;
        className = @"Photo";
        contentID = photo.photoID;
    }

    else if ([self.detailPost.mediaType isEqualToString:@"video"])
    {
        Video *video = self.detailPost.videoPost;
       className = @"Video";
        contentID = video.videoID;
    }

    else if ([self.detailPost.mediaType isEqualToString:@"link"])
    {
        className = @"Link";
    }

    else //Note
    {
        className = @"Note";
    }

    PFQuery *queryContent = [PFQuery queryWithClassName:className];
    [queryContent whereKey:@"objectId" equalTo:contentID];

    PFObject *updatedContent = [queryContent getFirstObject];
    [updatedContent incrementKey:@"numberOfLikes" byAmount:[NSNumber numberWithInt:1]];

    PFRelation *relation = [updatedContent relationForKey:@"Likers"];
    [relation addObject:self.currentUser];

    [updatedContent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         NSLog( @"Content Updated");

         PFObject *activity = [PFObject objectWithClassName:@"Activity"];


         [activity setObject:@"like" forKey:@"type"];
         [activity setObject:contentType forKey:@"mediaType"];
         [activity setObject:self.currentUser forKey:@"fromUser"];
         [activity setObject:updatedContent forKey:contentType];
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

-(void)checkUserLike:(NSString*)type contentID:(NSString*)contentID completion:(void (^)(BOOL))completionHandler
{
     PFQuery *queryPhoto = [PFQuery queryWithClassName:type];
    [queryPhoto whereKey:@"objectId" equalTo:contentID];

    // Using PFQuery
    [queryPhoto whereKey:@"Likers" equalTo:[PFObject objectWithoutDataWithClassName:@"User" objectId:self.currentUser.objectId]];

    //[queryPhoto whereKey:@"Likers" equalTo:self.currentUser];
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
