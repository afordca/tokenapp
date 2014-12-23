//
//  PTKContentDetailTableViewController.m
//  TokenApp
//
//  Created by BASEL FARAG on 12/19/14.
//  Copyright (c) 2014 ABaselNotBasilProduction. All rights reserved.
//

#import "PTKContentDetailTableViewController.h"
#import "Constants.h"
#import "Macros.h"
#import "TKUtility.h"
#import "TKCache.h"
#import "ProfilePersonalViewController.h"
#import "MBProgressHUD.h"

enum ActionSheetTags {
    MainActionSheetTag = 0,
    ConfirmDeleteActionSheetTag = 1
};

@interface PTKContentDetailTableViewController ()
@property (nonatomic, strong) UITextField *commentTextField;
@property (nonatomic, assign) BOOL likersQueryInProgress;

@end


@implementation PTKContentDetailTableViewController

@synthesize commentTextField;
@synthesize photo;
@synthesize likeUsers;

#pragma mark - Initialization

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:PTKPhotoDetailsViewControllerUserLikedUnlikedPhotoNotificationUserInfoLikedKey object:self.photo];
}

- (id)initWithPhoto:(PFObject *)aPhoto{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        //The classname to query on
        self.parseClassName = kPTKActivityClassKey;

        //Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;

        //Whether the built-in pagination is enabled
        self.paginationEnabled = YES;

        //The number of comments to show per page
        self.objectsPerPage = 30;

        self.photo = aPhoto;

        self.likersQueryInProgress = NO;
    }
    return self;
}


- (void)viewDidLoad {
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //Set Navigation titleview here

    //Set table view properties

    //Register to be notified when keyboard will be shown to scroll view
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLikedOrUnlikedPhoto:) name:PTKPhotoDetailsViewControllerUserLikedUnlikedPhotoNotificationUserInfoLikedKey object:self.photo];


}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIViewController 

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row <self.objects.count) { //A Comment Row
        PFObject *object = [self.objects objectAtIndex:indexPath.row];

        if (object) {
            NSString *commentString = [self.objects[indexPath.row] objectForKey:kPTKActivityClassKey];

            PFUser *commentAuthor = (PFUser *)[object objectForKey:kPTKActivityContentKey];

            NSString *nameString = @"";
            if (commentTextField) {
                nameString = [commentAuthor objectForKey:kTKUserDisplayNameKey];
            }

            return [PTKActivityCell heightForCellWithName:nameString contentString:commentString cellInsertWidth:kPTKCellInsertWidth];

        }
    }

    //Pagination row
    return 44.0f;

}

#pragma mark - PFQueryTableViewController 

-(PFQuery*)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:kPTKActivityPhotoKey equalTo:self.photo];
    [query includeKey:kPTKActivityFromUserKey];
    [query whereKey:kPTKActivityTypeKey equalTo:kPTKActivityTypeComment];
    [query orderByAscending:@"createdAt"];

    [query setCachePolicy:kPFCachePolicyNetworkOnly];

    /*If no objects are loaded in memory we look to the cache first to fille the table
    and then subsequenty do a query against the network. If there is no network connection,
    we hit the cache first.*/

    if (self.objects.count == 0 || [[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)]) {
        [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    }

    return query;

}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];

    [self reloadLikeBar];
    [self loadLikers];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *cellID = @"CommentCell";


}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == MainActionSheetTag) {
        if ([actionSheet destructiveButtonIndex] == buttonIndex) {
            // prompt to delete
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Are you sure you want to delete this photo?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"Yes, delete photo", nil) otherButtonTitles:nil];
            actionSheet.tag = ConfirmDeleteActionSheetTag;
            [actionSheet showFromTabBar:self.tabBarController.tabBar];
        } else {
            [self activityButtonAction:actionSheet];
        }
    } else if (actionSheet.tag == ConfirmDeleteActionSheetTag) {
        if ([actionSheet destructiveButtonIndex] == buttonIndex) {

            [self shouldDeletePhoto];
        }
    }
}



#pragma mark ()

- (void)showShareSheet {
    [[self.photo objectForKey:kPTKPhotoPictureKey] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            NSMutableArray *activityItems = [NSMutableArray arrayWithCapacity:3];

            // Prefill caption if this is the original poster of the photo, and then only if they added a caption initially.
            if ([[[PFUser currentUser] objectId] isEqualToString:[[self.photo objectForKey:kPTKPhotoUserKey] objectId]] && [self.objects count] > 0) {
                PFObject *firstActivity = self.objects[0];
                if ([[[firstActivity objectForKey:kPTKActivityFromUserKey] objectId] isEqualToString:[[self.photo objectForKey:kPTKPhotoUserKey] objectId]]) {
                    NSString *commentString = [firstActivity objectForKey:kPTKActivityContentKey];
                    [activityItems addObject:commentString];
                }
            }

            [activityItems addObject:[UIImage imageWithData:data]];
            [activityItems addObject:[NSURL URLWithString:[NSString stringWithFormat:@"https://anypic.org/#pic/%@", self.photo.objectId]]];

            UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            [self.navigationController presentViewController:activityViewController animated:YES completion:nil];
        }
    }];
}

- (void)handleCommentTimeout:(NSTimer *)aTimer {
    [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"New Comment", nil) message:NSLocalizedString(@"Your comment will be posted next time there is an Internet connection.", nil)  delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Dismiss", nil), nil];
    [alert show];
}

- (void)shouldPresentAccountViewForUser:(PFUser *)user {
    ProfilePersonalViewController *accountViewController = [[ProfilePersonalViewController alloc] initWithStyle:UITableViewStylePlain];
    NSLog(@"Presenting account view controller with user: %@", user);
    [accountViewController setUser:user];
    [self.navigationController pushViewController:accountViewController animated:YES];
}
- (BOOL)currentUserOwnsPhoto {
    return [[[self.photo objectForKey:kPTKPhotoUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]];
}

- (void)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)userLikedOrUnlikedPhoto:(NSNotification *)note {
    [self.headerView reloadLikeBar];
}

- (void)keyboardWillShow:(NSNotification*)note {
    // Scroll the view to the comment text box
    NSDictionary* info = [note userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self.tableView setContentOffset:CGPointMake(0.0f, self.tableView.contentSize.height-kbSize.height) animated:YES];
}


-(void)loadLikers {
    if (self.likersQueryInProgress) {
        return;
    }

    self.likersQueryInProgress = YES;
    PFQuery *query = [TKUtility queryForActivitiesOnPhoto:photo cachePolicy:kPFCachePolicyNetworkOnly];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.likersQueryInProgress = NO;
        if (error){
            [self reloadLikeBar];
            return;
        }

        NSMutableArray *likers = [NSMutableArray array];
        NSMutableArray *commenters = [NSMutableArray array];

        BOOL isLikedByCurrentUser = NO;

        for (PFObject *activity in objects){
            if ([[activity objectForKey:kPTKActivityTypeKey] isEqualToString:kPTKActivityTypeKey] && [activity objectForKey:kPTKActivityFromUserKey]) {
                [likers addObject:[activity objectForKey:kPTKActivityFromUserKey]];
            } else if ([[activity objectForKey:kPTKActivityFromUserKey] isEqualToString:kPTKActivityTypeComment] && [activity objectForKey:kPTKActivityFromUserKey]) {
                [commenters addObject:[activity objectForKey:kPTKActivityFromUserKey]];
            }

            if ([[[activity objectForKey:kPTKActivityFromUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                isLikedByCurrentUser = YES;
            }
        }

        [[TKCache sharedCache] setAttributesForPhoto:photo likers:likers commenters:commenters likedByCurrentUser:isLikedByCurrentUser];
    }];
}

- (void)shouldDeletePhoto {
    //Delete all activities related to this photo
    PFQuery *query = [PFQuery queryWithClassName:kPTKActivityClassKey];
    [query whereKey:kPTKActivityPhotoKey equalTo:self.photo];
    [query findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            for (PFObject *activity in activities) {
                [activity deleteEventually];
            }
        }
        //Delete Photo
        [self.photo deleteEventually];
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:photo object:[self.photo objectId]];
    [self.navigationController popViewControllerAnimated:YES];



}

-(void)setLikeButtonState:(BOOL)selected {
    if (selected) {
        [self.likeButton setTitleEdgeInsets:UIEdgeInsetsMake( -1.0f, 0.0f, 0.0f, 0.0f)];
    } else {
        [self.likeButton setTitleEdgeInsets:UIEdgeInsetsMake( 0.0f, 0.0f, 0.0f, 0.0f)];
    }
    [self.likeButton setSelected:selected];
}



-(void)reloadLikeBar {
    self.likeUsers = [[TKCache sharedCache] likersForPhoto:self.photo];
    [self setLikeButtonState:[[TKCache sharedCache] isPhotoLikedByCurrentUser:self.photo]];
    [self.likeButton addTarget:self action:@selector(didTapLikePhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didTapLikePhotoButtonAction:(UIButton *)button {
    if (delegate && [delegate respondsToSelector:@selector(photoHeaderView:didTapLikePhotoButton:photo:)]) {
        [delegate photoHeaderView:self didTapLikePhotoButton:button photo:self.photo];
    }
}



@end
