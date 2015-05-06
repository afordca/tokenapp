//
//  HomeFeedViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 4/26/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "HomeFeedViewController.h"
#import "HomeFeedTableViewCell.h"
#import "MFC_HomeFeedViewController.h"
#import "TK_DescriptionViewController.h"
#import "CreateMainView.h"
#import "UIViewController+Camera.h"
#import "MFC_CreateViewController.h"
#import "CamerOverlay.h"
#import "TK_Manager.h"
#import "User.h"
#import "CurrentUser.h"
#import "Photo.h"
#import "Video.h"
#import "Link.h"
#import "Post.h"
#import "HomeFeedPost.h"

#import "AppDelegate.h"

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

//transform values for full screen support
#define CAMERA_TRANSFORM_X 1
#define CAMERA_TRANSFORM_Y 1.12412
//iphone screen dimensions
#define SCREEN_WIDTH  320
#define SCREEN_HEIGTH 568

@interface HomeFeedViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CameraOverlayDelegate>


@property UIVisualEffectView *visualEffectView;

@property UIImagePickerController *imagePicker;
@property (nonatomic) UIImagePickerControllerCameraFlashMode flashMode;
@property UIImage *imageCreatePhoto;
@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) NSString *stringVideoData;
@property (strong,nonatomic) NSMutableArray *arrayOfContent;


@property PFUser *user;
@property User *userNew;

@property CGFloat currentPosition;



@property (strong, nonatomic) IBOutlet UITableView *tableViewHomeFeed;

@property BOOL isVideo;
@property BOOL noMoreResultsAvail;
@property BOOL loading;


@end

@implementation HomeFeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController.navigationBar setHidden:YES];

    currentUser = [CurrentUser sharedSingleton];
    [currentUser setUserProfile];

    self.noMoreResultsAvail = NO;
    self.arrayOfContent = [NSMutableArray new];
    for (int i = 0; i<10; i++)
    {
        [self.arrayOfContent addObject:currentUser.arrayOfHomeFeedContent[i]];
    }
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self addObserver];

    [self.tableViewHomeFeed reloadData];
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    NSLog(@"View Did Disappear");
    // [[NSNotificationCenter defaultCenter] postNotificationName:@"SendCancel" object:self];
    [[NSNotificationCenter defaultCenter ]removeObserver:self];
    
}

#pragma mark - UITableView Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return currentUser.arrayOfHomeFeedContent.count;

    if ([self.arrayOfContent count] == 0)
    {
        return 0;
    }
    else
    {
        return  self.arrayOfContent.count;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeFeedCell"];

    cell.labelHomeFeedUsername.text = @"";
    cell.imageViewHomeFeedContent.alpha = 1;
    cell.imageViewVideoIcon.alpha = 0;
    cell.labelLinkURL.alpha = 0;
    cell.imageViewLinkURL.alpha = 0;
    cell.viewLinkBlackBackground.alpha = 0;

    if (self.arrayOfContent.count !=0)
    {
        HomeFeedPost *post = [self.arrayOfContent objectAtIndex:indexPath.row];

        if ([post.mediaType isEqualToString:@"photo"])
        {

            cell.labelHomeFeedUsername.text = post.userName;
            cell.imageViewHomeFeedContent.image = post.contentImage;
            cell.imageViewHomeFeedProfilePic.image = post.userProfilePic;
            cell.imageViewVideoIcon.alpha = 0;
            cell.labelLinkURL.alpha = 0;
            cell.imageViewLinkURL.alpha = 0;
            cell.viewLinkBlackBackground.alpha = 0;
            return cell;
        }
        if ([post.mediaType isEqualToString:@"video"])
        {
            cell.labelHomeFeedUsername.text = post.userName;
            cell.imageViewHomeFeedContent.image = post.contentImage;
            cell.imageViewHomeFeedProfilePic.image = post.userProfilePic;
            cell.imageViewVideoIcon.alpha = 1;
            cell.labelLinkURL.alpha = 0;
            cell.imageViewLinkURL.alpha = 0;
            cell.viewLinkBlackBackground.alpha = 0;

            return cell;

        }
        if ([post.mediaType isEqualToString:@"link"])
        {
            cell.labelHomeFeedUsername.text = post.userName;
            cell.imageViewHomeFeedProfilePic.image = post.userProfilePic;
            cell.imageViewHomeFeedContent.alpha = 0;
            cell.imageViewVideoIcon.alpha = 0;
            cell.labelLinkURL.alpha = 1;
            cell.imageViewLinkURL.alpha = 1;
            cell.viewLinkBlackBackground.alpha = 1;
            cell.labelLinkURL.text = post.linkURL;
            
            return cell;
        }

        else
        {
            if (!self.noMoreResultsAvail)
            {
                spinner.hidden =NO;
                cell.textLabel.text=nil;


                spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                spinner.frame = CGRectMake(150, 10, 24, 50);
                [cell addSubview:spinner];
                if ([self.arrayOfContent count] >= 10)
                {
                    [spinner startAnimating];
                }
            }

            else
            {
                [spinner stopAnimating];
                spinner.hidden=YES;

                cell.textLabel.text=nil;

                UILabel* loadingLabel = [[UILabel alloc]init];
                loadingLabel.font=[UIFont boldSystemFontOfSize:14.0f];
                loadingLabel.textColor = [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0];
                loadingLabel.numberOfLines = 0;
                loadingLabel.text=@"No More data Available";
                loadingLabel.frame=CGRectMake(85,20, 302,25);
                [cell addSubview:loadingLabel];
            }

        }
    }

    return cell;

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

        //Hide Tab Bar

        

//        [UIView animateWithDuration:0.5 animations:^{
//        } completion:^(BOOL finished) {
//            self.self.mainView.alpha = 1;
//            self.mainView.transform = CGAffineTransformMakeTranslation(600, 0);
//            [UIView animateKeyframesWithDuration:0.5/4 delay:0 options:0 animations:^{
//                self.mainView.transform = CGAffineTransformMakeTranslation(340, 0);
//            } completion:^(BOOL finished) {
//                [UIView animateKeyframesWithDuration:0.5/4 delay:0 options:0 animations:^{
//                    self.mainView.transform = CGAffineTransformMakeTranslation(45, 0);
//                } completion:^(BOOL finished) {
//                    [UIView animateKeyframesWithDuration:0.5/4 delay:0 options:0 animations:^{
//                        self.mainView.transform = CGAffineTransformMakeTranslation(10, 0);
//                    } completion:^(BOOL finished) {
//                        [UIView animateKeyframesWithDuration:0.5/4 delay:0 options:0 animations:^{
//                            self.mainView.transform = CGAffineTransformMakeTranslation(0, 0);
//                        } completion:^(BOOL finished) {
//                        }];
//                    }];
//                }];
//            }];
//        }];

    }
    //Setting the current position of the WebView scroll
    self.currentPosition = scrollView.contentOffset.y;

}


#pragma UserDefined Method for generating data which are show in Table :::
-(void)loadDataDelayed
{

    if (self.arrayOfContent.count == currentUser.arrayOfHomeFeedContent.count)
    {
        NSLog(@"End of Feed");
    }
    else
    {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
        int countInt = (int)self.arrayOfContent.count;
        int countFeedInt = (int)currentUser.arrayOfHomeFeedContent.count;

        for (int i=countInt; i<countFeedInt; i++)
        {
            [array addObject: currentUser.arrayOfHomeFeedContent[i]];
        }
        [self.arrayOfContent addObjectsFromArray:array];
        [self.tableViewHomeFeed reloadData];
    }


}

@end
