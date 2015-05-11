//
//  ContentDetailViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 5/11/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "ContentDetailViewController.h"
#import "ContentDetailTableViewCell.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ContentDetailViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *labelUsername;
@property (strong,nonatomic) MPMoviePlayerController *videoController;

@end

@implementation ContentDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.labelUsername.text = self.detailPost.userName;
}

#pragma mark - Button Press Methods

- (IBAction)onButtonPressCancel:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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


- (void)videoPlayBackDidFinish:(NSNotification *)notification {

    // Stop the video player
    [self.videoController stop];

    // Play video player
    [self.videoController play];
    
}

@end
