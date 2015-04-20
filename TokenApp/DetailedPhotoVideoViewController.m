//
//  DetailedPhotoViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 4/9/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "DetailedPhotoVideoViewController.h"
#import "UIColor+HEX.h"
#import <MediaPlayer/MediaPlayer.h>
#import "TKContentDetailFooter.h"
#import "TKUtility.h"
#import "TKCache.h"

@interface DetailedPhotoVideoViewController () <TKContentDetailFooterViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIButton *buttonComment;
@property (strong, nonatomic) IBOutlet UIButton *buttonLike;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewDetailPhoto;
@property (strong, nonatomic) MPMoviePlayerController *videoController;
@property (nonatomic, strong) UITextField *commentTextField;


@end

@implementation DetailedPhotoVideoViewController
@synthesize commentTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];

    //self.likeUsers = nil;


    if (self.detailPhoto)
    {
            self.imageViewDetailPhoto.image = self.detailPhoto.picture;

    }
    else
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



    //Setup LoginButton Appearance
    CALayer *layerComment = self.buttonComment.layer;
    layerComment.backgroundColor = [[UIColor clearColor] CGColor];
    layerComment.borderColor = [[UIColor colorwithHexString:@"#72c74a" alpha:.9]CGColor];
    layerComment.borderWidth = 1.5f;

    CALayer *layerLike = self.buttonLike.layer;
    layerLike.backgroundColor = [[UIColor clearColor] CGColor];
    layerLike.borderColor = [[UIColor colorwithHexString:@"#72c74a" alpha:.9]CGColor];
    layerLike.borderWidth = 1.5f;

    //Setup table footer
    TKContentDetailFooter *footerView = [[TKContentDetailFooter alloc]initWithFrame:[TKContentDetailFooter rectForView]];
    self.tableView.tableFooterView = footerView;


}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];

    NSLog(@"DetailPhoto did disappear!");

    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];

     //Stop the video player and remove it from view
    [self.videoController stop];
    [self.videoController.view removeFromSuperview];
    self.videoController = nil;

    TKContentDetailFooter *footerView = [[TKContentDetailFooter alloc]initWithFrame:self.view.frame];
    commentTextField = footerView.commentField;
    commentTextField.delegate = self;
    self.tableView.tableFooterView = footerView; 
}



- (void)videoPlayBackDidFinish:(NSNotification *)notification
{

    // Stop the video player
    [self.videoController stop];

    // Play video player
    [self.videoController play];

}




@end
