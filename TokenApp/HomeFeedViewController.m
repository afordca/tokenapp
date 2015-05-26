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
#import "TK_ProfileViewController.h"
#import "OthersProfileViewController.h"
#import "CreateMainView.h"
#import "UIViewController+Camera.h"
#import "UIColor+HEX.h"
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

#import "ContentDetailViewController.h"
#import "ContentWebViewController.h"

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


    PFUser *user = [PFUser currentUser];
    if ([user objectForKey:@"newuser"])
    {
        [user setObject:[NSNumber numberWithBool:NO] forKey:@"newuser"];
        [user saveInBackground];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self addObserver];

    if (currentUser.arrayOfHomeFeedContent.count < 10)
    {
        self.arrayOfContent = [NSMutableArray new];
        for (HomeFeedPost * post in currentUser.arrayOfHomeFeedContent)
        {
            [self.arrayOfContent addObject:post];
        }
    }
    else
    {
        self.noMoreResultsAvail = NO;
        self.arrayOfContent = [NSMutableArray new];
        for (int i = 0; i<10; i++)
        {
            [self.arrayOfContent addObject:currentUser.arrayOfHomeFeedContent[i]];
        }
    }

    [self.tableViewHomeFeed reloadData];
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    NSLog(@"HomeFeed View Did Disappear");
    [[NSNotificationCenter defaultCenter ]removeObserver:self];

    [self.arrayOfContent removeAllObjects];

    [self.tableViewHomeFeed reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"Memory Issue");
}

#pragma mark - UITableView Delegate Methods

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrayOfContent.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HomeFeedPost *post = [self.arrayOfContent objectAtIndex:section];

    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    headerView.backgroundColor = [UIColor whiteColor];

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(2, 6, 3, 38)];
    lineView.backgroundColor = [UIColor colorwithHexString:@"#72c74a" alpha:.9];

    UIImageView *profilePic = [[UIImageView alloc]initWithFrame:CGRectMake(8, 6, 38, 38)];
    profilePic.image = post.userProfilePic;

    UILabel *labelUsername = [[UILabel alloc]initWithFrame:CGRectMake(54, 11, 147, 21)];
    labelUsername.text = post.userName;

    labelUsername.tag = section;

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [labelUsername addGestureRecognizer:tapGestureRecognizer];
    labelUsername.userInteractionEnabled = YES;

    [headerView addSubview:lineView];
    [headerView addSubview:profilePic];
    [headerView addSubview:labelUsername];

    return headerView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
    cell.labelHeader.alpha = 0;
    cell.lableNoteMessage.alpha = 1;
    cell.labelLinkDescription.alpha = 0;
    cell.labelLinkTitle.alpha = 0;

    if (self.arrayOfContent.count !=0)
    {
        HomeFeedPost *post = [self.arrayOfContent objectAtIndex:indexPath.section];

        if ([post.mediaType isEqualToString:@"photo"])
        {
            Photo *photo = post.photoPost;

            cell.labelHomeFeedUsername.text = post.userName;
            cell.imageViewHomeFeedContent.image = photo.picture;
            cell.imageViewHomeFeedProfilePic.image = post.userProfilePic;
            cell.imageViewVideoIcon.alpha = 0;
            cell.labelLinkURL.alpha = 0;
            cell.imageViewLinkURL.alpha = 0;
            cell.viewLinkBlackBackground.alpha = 0;
            cell.labelHeader.alpha = 0;
            cell.lableNoteMessage.alpha = 0;
            cell.labelLinkDescription.alpha = 0;
            cell.labelLinkTitle.alpha = 0;
            return cell;
        }
        if ([post.mediaType isEqualToString:@"video"])
        {
            Video *video = post.videoPost;

            cell.labelHomeFeedUsername.text = post.userName;
            cell.imageViewHomeFeedContent.image = video.videoThumbnail;
            cell.imageViewHomeFeedProfilePic.image = post.userProfilePic;
            cell.imageViewVideoIcon.alpha = 1;
            cell.labelLinkURL.alpha = 0;
            cell.imageViewLinkURL.alpha = 0;
            cell.viewLinkBlackBackground.alpha = 0;
            cell.labelHeader.alpha = 0;
            cell.lableNoteMessage.alpha = 0;
            cell.labelLinkDescription.alpha = 0;
            cell.labelLinkTitle.alpha = 0;

            return cell;

        }
        if ([post.mediaType isEqualToString:@"link"])
        {
            Link *link = post.linkPost;

            cell.labelHomeFeedUsername.text = post.userName;
            cell.imageViewHomeFeedProfilePic.image = post.userProfilePic;
            cell.imageViewHomeFeedContent.alpha = 0;
            cell.imageViewVideoIcon.alpha = 0;
            cell.labelHeader.alpha = 0;
            cell.lableNoteMessage.alpha = 0;
            cell.viewLinkBlackBackground.alpha = 0;
            cell.labelLinkURL.alpha = 1;
            cell.imageViewLinkURL.alpha = 1;
            cell.imageViewLinkURL.image = link.linkImage;
            cell.viewLinkBlackBackground.alpha = 1;
            cell.labelLinkURL.text = [link.urlLink absoluteString];
            cell.labelLinkDescription.alpha = 1;
            cell.labelLinkDescription.text = link.linkDescription;
            cell.labelLinkTitle.alpha = 1;
            cell.labelLinkTitle.text = link.linkTitle;
            
            return cell;
        }
        if ([post.mediaType isEqualToString:@"post"])
        {
            Post *note = post.messagePost;

            cell.labelHomeFeedUsername.text = post.userName;
            cell.imageViewHomeFeedProfilePic.image = post.userProfilePic;
            cell.imageViewHomeFeedContent.alpha = 0;
            cell.imageViewVideoIcon.alpha = 0;
            cell.labelLinkURL.alpha = 0;
            cell.imageViewLinkURL.alpha = 0;
            cell.viewLinkBlackBackground.alpha = 1;
            cell.labelHeader.alpha = 1;
            cell.lableNoteMessage.alpha = 1;
            cell.lableNoteMessage.text = note.postMessage;
            cell.labelHeader.text = note.postHeader;
            cell.labelLinkDescription.alpha = 0;
            cell.labelLinkTitle.alpha = 0;

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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeFeedPost *post = [self.arrayOfContent objectAtIndex:indexPath.section];

    if ([post.mediaType  isEqual: @"link"])
    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ContentWebViewController *cwvc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ContentWebView"];

        Link *link = post.linkPost;

        cwvc.stringWebURL = [link.urlLink absoluteString];
        cwvc.linkContent = link;

        [self.navigationController pushViewController:cwvc animated:YES];
    }
    else
    {

    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ContentDetailViewController *cdvc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ContentDetail"];

    cdvc.detailPost = post;

    [self.navigationController pushViewController: cdvc animated:YES];

    }

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
    if (self.arrayOfContent.count == currentUser.arrayOfHomeFeedContent.count)
    {
        NSLog(@"End of Feed");

        NSInteger skip = self.arrayOfContent.count + 10;

        [currentUser loadHomeFeedActivity:skip limit:10 type:@"home" completion:^(BOOL result)
         {
             [currentUser loadHomeFeedContent:^(BOOL result) 
              {
                  for (int i = self.arrayOfContent.count; i<currentUser.arrayOfHomeFeedContent.count; i++)
                  {
                      [self.arrayOfContent addObject:currentUser.arrayOfHomeFeedContent[i]];
                  }
              }];
         }];

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


#pragma mark - UITapGesture Methods

-(void)labelTapped:(UITapGestureRecognizer*)sender
{
    NSLog(@"Working");

    UILabel *labelUsername = (UILabel *)sender.view;
    NSLog(@"Tag:%li",labelUsername.tag);

    HomeFeedPost *postUser = [self.arrayOfContent objectAtIndex:labelUsername.tag];

    User *userToPresent = postUser.user;

    [self presentUserProfile:userToPresent];

}

#pragma mark - Segue Method

-(void)presentUserProfile:(User*)user
{
    if ([user.objectID isEqualToString:currentUser.userID])
    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TK_ProfileViewController *pvc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Profile"];

        [self.navigationController pushViewController:pvc animated:YES];
    }
    else
    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OthersProfileViewController *opvc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"OtherProfile"];

        opvc.otherUser = user;

        TK_Manager *manager = [TK_Manager new];

        [manager loadFollowing:user.objectID completion:^(BOOL result)
        {
            [manager loadFollowers:user.objectID user:user.pfUser completion:^(BOOL result)
           {
               [manager loadarrayOfActivity:user completion:^(BOOL result)
               {
                    [manager loadArrayOfOtherUserContent:manager.arrayOfActivity completion:^(BOOL result)
                     {
                         opvc.arrayOfContent = manager.arrayOfUserContent;
                         opvc.arrayOfFollowers = manager.arrayOfFollowers;
                         opvc.arrayOfFollowing = manager.arrayOfFollowing;

                         [self.navigationController pushViewController:opvc animated:YES];
                     }];
                }];
           }];
       }];


    }
}

@end
