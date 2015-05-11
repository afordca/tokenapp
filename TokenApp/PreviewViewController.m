//
//  PreviewViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 5/10/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "PreviewViewController.h"
#import <MediaPlayer/MediaPlayer.h>


@interface PreviewViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageViewPreview;

@property (strong, nonatomic) IBOutlet UIButton *buttonCancel;
@property (strong, nonatomic) IBOutlet UIButton *buttonNext;

@property (strong,nonatomic) MPMoviePlayerController *videoController;

@end

@implementation PreviewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.imagePhotoPreview)
    {
        self.imageViewPreview.image = self.imagePhotoPreview;
    }
    else
    {
        self.videoController = [[MPMoviePlayerController alloc] init];
        [self.videoController setContentURL:self.urlVideoPreview];
        [self.videoController setScalingMode:MPMovieScalingModeAspectFill];
        [self.videoController.view setFrame:CGRectMake (0, 0, 320, 334)];
        [self.view addSubview:self.videoController.view];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(videoPlayBackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:self.videoController];
        [self.videoController play];
    }
}

- (IBAction)onButtonPressCancel:(id)sender {
}

- (IBAction)onButtonPressNext:(id)sender {
}

- (void)videoPlayBackDidFinish:(NSNotification *)notification {

    // Stop the video player
    [self.videoController stop];

    // Play video player
    [self.videoController play];
    
}


@end
