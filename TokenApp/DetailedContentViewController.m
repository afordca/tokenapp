//
//  DetailedPhotoViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 4/9/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "DetailedContentViewController.h"
#import "UIColor+HEX.h"
#import <MediaPlayer/MediaPlayer.h>

@interface DetailedContentViewController  ()

@property (strong, nonatomic) IBOutlet UIButton *buttonComment;
@property (strong, nonatomic) IBOutlet UIButton *buttonLike;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewDetailPhoto;
@property (strong,nonatomic) MPMoviePlayerController *videoController;
@property (strong, nonatomic) IBOutlet UIView *viewLinkURL;
@property (strong, nonatomic) IBOutlet UILabel *labelLinkURL;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewLinkURL;

@end

@implementation DetailedContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.detailPhoto)
    {
            self.imageViewDetailPhoto.image = self.detailPhoto.picture;

    }
    else if(self.detailVideo)
    {
        self.videoController = [[MPMoviePlayerController alloc] init];
        [self.videoController setContentURL:self.detailVideo.videoURL];
         [self.videoController setScalingMode:MPMovieScalingModeAspectFill];
        [self.videoController.view setFrame:CGRectMake (4, 4, 313, 300)];
        [self.view addSubview:self.videoController.view];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(videoPlayBackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:self.videoController];
        [self.videoController play];

    }
    else
    {
        self.imageViewDetailPhoto.alpha = 0;
        self.viewLinkURL.alpha = 1;
        //self.labelLinkURL.alpha = 0;
        self.imageViewLinkURL.alpha = 1;
       // self.labelLinkURL.text = [self.detailLink.urlLink absoluteString];
        self.buttonlinkURL.titleLabel.text = [self.detailLink.urlLink absoluteString];

        NSString *stringURL = [self.detailLink.urlLink absoluteString];

        [self.buttonlinkURL setTitle:stringURL forState:UIControlStateNormal];
    }

    //Setup LoginButton Appearance
    CALayer *layerComment = self.buttonComment.layer;
    layerComment.backgroundColor = [[UIColor clearColor] CGColor];
    layerComment.borderColor = [[UIColor colorwithHexString:@"#72c74a" alpha:.9]CGColor];
    layerComment.borderWidth = 1.5f;

    CALayer *layerLike = self.buttonLike.layer;
    layerLike.backgroundColor = [[UIColor clearColor] CGColor];
    layerLike.borderColor = [[UIColor colorwithHexString:@"#72c74a" alpha:.9]CGColor];
    layerLike.borderWidth = 1.5f;

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];

    NSLog(@"DetailPhoto did disappear!");

    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];

    // Stop the video player and remove it from view
    [self.videoController stop];
    [self.videoController.view removeFromSuperview];
    self.videoController = nil;
}


- (void)videoPlayBackDidFinish:(NSNotification *)notification {

    // Stop the video player
    [self.videoController stop];

    // Play video player
    [self.videoController play];

}

@end
