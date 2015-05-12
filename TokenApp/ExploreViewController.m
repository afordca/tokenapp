//
//  ExploreViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/17/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "ExploreViewController.h"
#import "TK_ProfileViewController.h"
#import "TK_DescriptionViewController.h"
#import "UIViewController+Camera.h"
#import "TK_LinkViewController.h"
#import "TK_PostViewController.h"
#import "ProfileCollectionViewCell.h"
#import "FollowersTableViewCell.h"
#import "CamerOverlay.h"
#import "ContentDetailViewController.h"
#import "OthersProfileViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

//transform values for full screen support
#define CAMERA_TRANSFORM_X 1
#define CAMERA_TRANSFORM_Y 1.12412
//iphone screen dimensions
#define SCREEN_WIDTH  320
#define SCREEN_HEIGTH 568

@interface ExploreViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,CameraOverlayDelegate,UITableViewDataSource,UITableViewDelegate,UITabBarDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property UIVisualEffectView *visualEffectView;

@property UIImagePickerController *imagePicker;
@property UIImage *imageCreatePhoto;
@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) NSString *stringVideoData;
@property (nonatomic) UIImagePickerControllerCameraFlashMode flashMode;
@property BOOL isVideo;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControlDiscover;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewDiscoverContent;

@property (weak, nonatomic) IBOutlet UITableView *tableViewDiscoverUser;

@property (strong,nonatomic) NSMutableArray *arrayOfDiscoverContent;
@property (strong,nonatomic) NSMutableArray *arrayOfDiscoverUsers;

@end

@implementation ExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationController.navigationBar setHidden:YES];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    if (self.segmentControlDiscover.selectedSegmentIndex == 0)
    {
        [self.tableViewDiscoverUser setHidden:YES];
        [self.collectionViewDiscoverContent setHidden:NO];
    }
    else
    {
        [self.collectionViewDiscoverContent setHidden:YES];
        [self.tableViewDiscoverUser setHidden:NO];
    }


    TK_Manager *manager = [TK_Manager new];
    [manager loadDiscoverActivity:^(BOOL result)
     {
         [manager loadArrayOfOtherUserContent:manager.arrayOfActivity completion:^(BOOL result)
          {
              self.arrayOfDiscoverContent = manager.arrayOfUserContent;

              [manager loadDiscoverUsers:^(BOOL result)
               {
                   NSMutableArray *dupeArray = [NSMutableArray new];
                   self.arrayOfDiscoverUsers = [NSMutableArray new];

                   dupeArray = manager.arrayOfDiscoverUsers;

                   NSMutableSet *names = [NSMutableSet set];
                   for (User *user in dupeArray)
                   {
                       NSString *userID = user.objectID;
                       if (![names containsObject:userID]) {
                           [self.arrayOfDiscoverUsers addObject:user];
                           [names addObject:userID];
                       }
                   }

                   [self.collectionViewDiscoverContent reloadData];
                   [self.tableViewDiscoverUser reloadData];
               }];
              
              
          }];
     }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

    [self addObserver];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    NSLog(@"View Did Disappear");
    [[NSNotificationCenter defaultCenter ]removeObserver:self];
}


#pragma mark - UICollectionView Delegate Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayOfDiscoverContent.count ;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellProfile" forIndexPath:indexPath];

    cell.imageViewVideoIcon.alpha = 0;
    cell.labelLinkURL.alpha = 0;
    cell.imageViewLinkURL.alpha = 0;
    cell.imageViewProfileContent.alpha = 1;


    HomeFeedPost *post = [self.arrayOfDiscoverContent objectAtIndex:indexPath.row];

    if ([post.mediaType isEqualToString:@"photo"])
    {
        Photo *photo = [Photo new];
        photo = post.photoPost;
        cell.imageViewProfileContent.image = photo.picture;
        cell.labelNoteMessage.alpha = 0;
        cell.labelNoteHeader.alpha = 0;
        cell.imageViewVideoIcon.alpha = 0;
        cell.labelLinkURL.alpha = 0;
        cell.imageViewLinkURL.alpha = 0;
        return cell;
    }
    if ([post.mediaType isEqualToString:@"video"])
    {
        Video *video = [Video new];
        video = post.videoPost;
        cell.imageViewProfileContent.image = video.videoThumbnail;
        cell.imageViewVideoIcon.alpha = 1;
        cell.labelNoteMessage.alpha = 0;
        cell.labelNoteHeader.alpha = 0;
        cell.labelLinkURL.alpha = 0;
        cell.imageViewLinkURL.alpha = 0;

        return cell;

    }
    if ([post.mediaType isEqualToString:@"link"])
    {
        Link *link = [Link new];
        link = post.linkPost;
        cell.imageViewProfileContent.alpha = 0;
        cell.imageViewVideoIcon.alpha = 0;
        cell.labelNoteMessage.alpha = 0;
        cell.labelNoteHeader.alpha = 0;
        cell.labelLinkURL.alpha = 1;
        cell.imageViewLinkURL.alpha = 1;
        cell.labelLinkURL.text = [link.urlLink absoluteString];

        return cell;
    }

    if ([post.mediaType isEqualToString:@"post"])
    {
        Post *note = [Post new];
        note = post.messagePost;
        cell.imageViewProfileContent.alpha = 0;
        cell.imageViewVideoIcon.alpha = 0;
        cell.labelLinkURL.alpha = 0;
        cell.imageViewLinkURL.alpha = 0;
        cell.labelNoteMessage.alpha = 1;
        cell.labelNoteHeader.alpha = 1;
        cell.labelNoteMessage.text = note.postMessage;
        cell.labelNoteHeader.text = note.postHeader;


        return cell;
    }
    
    return nil;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeFeedPost *post = [self.arrayOfDiscoverContent objectAtIndex:indexPath.row];

    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ContentDetailViewController *cdvc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ContentDetail"];

    cdvc.detailPost = post;

    [self.navigationController pushViewController: cdvc animated:YES];
}


#pragma mark - UITableView Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayOfDiscoverUsers.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FollowersTableViewCell *cellFollowers = [tableView dequeueReusableCellWithIdentifier:@"DiscoverUsersCell"];

    User *userDiscover = [self.arrayOfDiscoverUsers objectAtIndex:indexPath.row];

    cellFollowers.labelUsername.text = userDiscover.userName;

    //Round Profile Pic
    cellFollowers.imageViewFollowerProfilePic.layer.cornerRadius = cellFollowers.imageViewFollowerProfilePic.frame.size.height /2;
    cellFollowers.imageViewFollowerProfilePic.layer.masksToBounds = YES;
    cellFollowers.imageViewFollowerProfilePic.layer.borderWidth = 0;

    //Follower Profile Pic
    if (!userDiscover.profileImage)
    {   // Default Profile Pic
        cellFollowers.imageViewFollowerProfilePic.image = [UIImage imageNamed:@"ProfileDefault"];
    }
    else
    {   // Profile Pic
        cellFollowers.imageViewFollowerProfilePic.image = userDiscover.profileImage;
    }
return cellFollowers;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OthersProfileViewController *opvc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"OtherProfile"];

    User *userSelected = [self.arrayOfDiscoverUsers objectAtIndex:indexPath.row];

    opvc.otherUser = userSelected;
    
    TK_Manager *manager = [TK_Manager new];
    [manager loadarrayOfActivity:userSelected completion:^(BOOL result)
     {
         [manager loadArrayOfOtherUserContent:manager.arrayOfActivity completion:^(BOOL result)
          {
              opvc.arrayOfContent = manager.arrayOfUserContent;

              [self.navigationController pushViewController:opvc animated:YES];
          }];
     }];

}

#pragma mark - Segment Control

- (IBAction)segmentControlDiscover:(id)sender
{

    NSInteger selectedSegment = self.segmentControlDiscover.selectedSegmentIndex;

    if (selectedSegment == 0) {
        [self.tableViewDiscoverUser setHidden:YES];
        [self.collectionViewDiscoverContent setHidden:NO];
    }
    else{
        //toggle the correct view to be visible
        [self.collectionViewDiscoverContent setHidden:YES];
        [self.tableViewDiscoverUser setHidden:NO];
    }
}

@end
