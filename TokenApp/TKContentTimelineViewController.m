//
//  TKContentTimelineViewController.m
//  TokenApp
//
//  Created by BASEL FARAG on 1/18/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "TKContentTimelineViewController.h"

#import "TKAccountViewController.h"
#import "PTKContentDetailTableViewController.h"
#import "TKUtility.h"
#import "TKLoadMoreCell.h"
#import "Macros.h"
#import "Constants.h"


@interface TKContentTimelineViewController ()
@property (nonatomic, assign) BOOL shouldReloadOnAppear;
@property (nonatomic, strong) NSMutableSet *reusableSectionHeaderViews;
@property (nonatomic, strong) NSMutableDictionary *outstandingSectionHeaderQueries;
@end


@implementation TKContentTimelineViewController

@synthesize reusableSectionHeaderViews;
@synthesize shouldReloadOnAppear;
@synthesize outstandingSectionHeaderQueries;

#pragma mark - Initialization


- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {

        self.outstandingSectionHeaderQueries = [NSMutableDictionary dictionary];

        // The className to query on
        self.parseClassName = kPTKPhotoClassKey;

        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;

        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;

        // The number of objects to show per page
        // self.objectsPerPage = 10;

        // Improve scrolling performance by reusing UITableView section headers
        self.reusableSectionHeaderViews = [NSMutableSet setWithCapacity:3];

        // The Loading text clashes with the dark Anypic design
        self.loadingViewEnabled = NO;

        self.shouldReloadOnAppear = NO;
    }
    return self;
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [super viewDidLoad];

    UIView *texturedBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    texturedBackgroundView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    self.tableView.backgroundView = texturedBackgroundView;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidPublishPhoto:) name:PTKTabBarControllerDidFinishEditingPhotoNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userFollowingChanged:) name:TKUtilityUserFollowingChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidDeletePhoto:) name:TKPhotoDetailsViewControllerUserDeletedPhotoNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLikeOrUnlikePhoto:) name:TKPhotoDetailsViewControllerUserLikedUnlikedPhotoNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLikeOrUnlikePhoto:) name:TKUtilityUserLikedUnlikedPhotoCallbackFinishedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidCommentOnPhoto:) name:TKPhotoDetailsViewControllerUserCommentedOnPhotoNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (self.shouldReloadOnAppear) {
        self.shouldReloadOnAppear = NO;
        [self loadObjects];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count * 2 + (self.paginationEnabled ? 1 : 0);
}


#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.paginationEnabled && (self.objects.count * 2) == indexPath.row) {
        // Load More Section
        return 44.0f;
    } else if (indexPath.row % 2 == 0) {
        return 44.0f;
    }

    return 320.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (![self objectAtIndexPath:indexPath]) {
        // Load More Cell
        [self loadNextPage];
    }
}


#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable {
    if (![PFUser currentUser]) {
        PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
        [query setLimit:0];
        return query;
    }

    PFQuery *followingActivitiesQuery = [PFQuery queryWithClassName:kPTKActivityClassKey];
    [followingActivitiesQuery whereKey:kPTKActivityTypeKey equalTo:kTKActivityTypeFollow];
    [followingActivitiesQuery whereKey:kPTKActivityFromUserKey equalTo:[PFUser currentUser]];
    followingActivitiesQuery.cachePolicy = kPFCachePolicyNetworkOnly;
    followingActivitiesQuery.limit = 1000;

    PFQuery *autoFollowUsersQuery = [PFUser query];
    [autoFollowUsersQuery whereKey:kPTKUserAutoFollowKey equalTo:@YES];

    PFQuery *photosFromFollowedUsersQuery = [PFQuery queryWithClassName:self.parseClassName];
    [photosFromFollowedUsersQuery whereKey:kPTKPhotoUserKey matchesKey:kPTKActivityClassKey inQuery:followingActivitiesQuery];
    [photosFromFollowedUsersQuery whereKeyExists:kPTKPhotoPictureKey];

    PFQuery *photosFromCurrentUserQuery = [PFQuery queryWithClassName:self.parseClassName];
    [photosFromCurrentUserQuery whereKey:kPTKPhotoUserKey equalTo:[PFUser currentUser]];
    [photosFromCurrentUserQuery whereKeyExists:kPTKPhotoPictureKey];

    PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:photosFromFollowedUsersQuery, photosFromCurrentUserQuery, nil]];
    [query setLimit:30];
    [query includeKey:kPTKPhotoUserKey];
    [query orderByDescending:@"createdAt"];

    // A pull-to-refresh should always trigger a network request.
    [query setCachePolicy:kPFCachePolicyNetworkOnly];

    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    //
    // If there is no network connection, we will hit the cache first.
    if (self.objects.count == 0 || ![[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)]) {
        [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    }

    /*
     This query will result in an error if the schema hasn't been set beforehand. While Parse usually handles this automatically, this is not the case for a compound query such as this one. The error thrown is:

     Error: bad special key: __type

     To set up your schema, you may post a photo with a caption. This will automatically set up the Photo and Activity classes needed by this query.

     You may also use the Data Browser at Parse.com to set up your classes in the following manner.

     Create a User class: "User" (if it does not exist)

     Create a Custom class: "Activity"
     - Add a column of type pointer to "User", named "fromUser"
     - Add a column of type pointer to "User", named "toUser"
     - Add a string column "type"

     Create a Custom class: "Photo"
     - Add a column of type pointer to "User", named "user"

     You'll notice that these correspond to each of the fields used by the preceding query.
     */

    return query;
}

- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = [self indexForObjectAtIndexPath:indexPath];
    if (index < self.objects.count) {
        return self.objects[index];
    }

    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";

    NSUInteger index = [self indexForObjectAtIndexPath:indexPath];

    if (indexPath.row % 2 == 0) {
        // Header
        return [self detailPhotoCellForRowAtIndexPath:indexPath];
    } else {
        // Photo
        TKPhotoCell *cell = (TKPhotoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if (cell == nil) {
            cell = [[TKPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.photoButton addTarget:self action:@selector(didTapOnPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
        }

        cell.photoButton.tag = index;
        cell.imageView.image = [UIImage imageNamed:@"PlaceholderPhoto.png"];

        if (object) {
            cell.imageView.file = [object objectForKey:kPTKPhotoPictureKey];

            // PFQTVC will take care of asynchronously downloading files, but will only load them when the tableview is not moving. If the data is there, let's load it right away.
            if ([cell.imageView.file isDataAvailable]) {
                [cell.imageView loadInBackground];
            }
        }

        return cell;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *LoadMoreCellIdentifier = @"LoadMoreCell";

    TKLoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadMoreCellIdentifier];
    if (!cell) {
        cell = [[TKLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadMoreCellIdentifier];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        cell.hideSeparatorBottom = YES;
        cell.mainView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}


#pragma mark - TKPhotoTimelineViewController

- (TKPhotoHeaderView *)dequeueReusableSectionHeaderView {
    for (TKPhotoHeaderView *sectionHeaderView in self.reusableSectionHeaderViews) {
        if (!sectionHeaderView.superview) {
            // we found a section header that is no longer visible
            return sectionHeaderView;
        }
    }

    return nil;
}


#pragma mark - TKPhotoHeaderViewDelegate

- (void)photoHeaderView:(TKPhotoHeaderView *)photoHeaderView didTapUserButton:(UIButton *)button user:(PFUser *)user {
    TKAccountViewController *accountViewController = [[TKAccountViewController alloc] initWithUser:user];
    NSLog(@"Presenting account view controller with user: %@", user);
    [accountViewController setUser:user];
    [self.navigationController pushViewController:accountViewController animated:YES];
}

- (void)photoHeaderView:(TKPhotoHeaderView *)photoHeaderView didTapLikePhotoButton:(UIButton *)button photo:(PFObject *)photo {
    [photoHeaderView shouldEnableLikeButton:NO];

    BOOL liked = !button.selected;
    [photoHeaderView setLikeStatus:liked];

    NSString *originalButtonTitle = button.titleLabel.text;

    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];

    NSNumber *likeCount = [numberFormatter numberFromString:button.titleLabel.text];
    if (liked) {
        likeCount = [NSNumber numberWithInt:[likeCount intValue] + 1];
        [[TKCache sharedCache] incrementLikerCountForPhoto:photo];
    } else {
        if ([likeCount intValue] > 0) {
            likeCount = [NSNumber numberWithInt:[likeCount intValue] - 1];
        }
        [[TKCache sharedCache] decrementLikerCountForPhoto:photo];
    }

    [[TKCache sharedCache] setPhotoIsLikedByCurrentUser:photo liked:liked];

    [button setTitle:[numberFormatter stringFromNumber:likeCount] forState:UIControlStateNormal];

    if (liked) {
        [TKUtility likePhotoInBackground:photo block:^(BOOL succeeded, NSError *error) {
            TKPhotoHeaderView *actualHeaderView = (TKPhotoHeaderView *)[self tableView:self.tableView viewForHeaderInSection:button.tag];
            [actualHeaderView shouldEnableLikeButton:YES];
            [actualHeaderView setLikeStatus:succeeded];

            if (!succeeded) {
                [actualHeaderView.likeButton setTitle:originalButtonTitle forState:UIControlStateNormal];
            }
        }];
    } else {
        [TKUtility unlikePhotoInBackground:photo block:^(BOOL succeeded, NSError *error) {
            TKPhotoHeaderView *actualHeaderView = (TKPhotoHeaderView *)[self tableView:self.tableView viewForHeaderInSection:button.tag];
            [actualHeaderView shouldEnableLikeButton:YES];
            [actualHeaderView setLikeStatus:!succeeded];

            if (!succeeded) {
                [actualHeaderView.likeButton setTitle:originalButtonTitle forState:UIControlStateNormal];
            }
        }];
    }
}

- (void)photoHeaderView:(TKPhotoHeaderView *)photoHeaderView didTapCommentOnPhotoButton:(UIButton *)button  photo:(PFObject *)photo {
    TKPhotoDetailsViewController *photoDetailsVC = [[TKPhotoDetailsViewController alloc] initWithPhoto:photo];
    [self.navigationController pushViewController:photoDetailsVC animated:YES];
}


#pragma mark - ()

- (UITableViewCell *)detailPhotoCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DetailPhotoCell";

    if (self.paginationEnabled && indexPath.row == self.objects.count * 2) {
        // Load More section
        return nil;
    }

    NSUInteger index = [self indexForObjectAtIndexPath:indexPath];

    TKPhotoHeaderView *headerView = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!headerView) {
        headerView = [[TKPhotoHeaderView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, self.view.bounds.size.width, 44.0f) buttons:TKPhotoHeaderButtonsDefault];
        headerView.delegate = self;
        headerView.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    PFObject *object = [self objectAtIndexPath:indexPath];
    headerView.photo = object;
    headerView.tag = index;
    [headerView.likeButton setTag:index];

    NSDictionary *attributesForPhoto = [[TKCache sharedCache] attributesForPhoto:object];

    if (attributesForPhoto) {
        [headerView setLikeStatus:[[TKCache sharedCache] isPhotoLikedByCurrentUser:object]];
        [headerView.likeButton setTitle:[[[TKCache sharedCache] likeCountForPhoto:object] description] forState:UIControlStateNormal];
        [headerView.commentButton setTitle:[[[TKCache sharedCache] commentCountForPhoto:object] description] forState:UIControlStateNormal];

        if (headerView.likeButton.alpha < 1.0f || headerView.commentButton.alpha < 1.0f) {
            [UIView animateWithDuration:0.200f animations:^{
                headerView.likeButton.alpha = 1.0f;
                headerView.commentButton.alpha = 1.0f;
            }];
        }
    } else {
        headerView.likeButton.alpha = 0.0f;
        headerView.commentButton.alpha = 0.0f;

        @synchronized(self) {
            // check if we can update the cache
            NSNumber *outstandingSectionHeaderQueryStatus = [self.outstandingSectionHeaderQueries objectForKey:@(index)];
            if (!outstandingSectionHeaderQueryStatus) {
                PFQuery *query = [TKUtility queryForActivitiesOnPhoto:object cachePolicy:kPFCachePolicyNetworkOnly];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    @synchronized(self) {
                        [self.outstandingSectionHeaderQueries removeObjectForKey:@(index)];

                        if (error) {
                            return;
                        }

                        NSMutableArray *likers = [NSMutableArray array];
                        NSMutableArray *commenters = [NSMutableArray array];

                        BOOL isLikedByCurrentUser = NO;

                        for (PFObject *activity in objects) {
                            if ([[activity objectForKey:kPTKActivityTypeKey] isEqualToString:kPTKActivityTypeLike] && [activity objectForKey:kTKActivityFromUserKey]) {
                                [likers addObject:[activity objectForKey:kPTKActivityFromUserKey]];
                            } else if ([[activity objectForKey:kPTKActivityTypeKey] isEqualToString:kPTKActivityTypeComment] && [activity objectForKey:kPTKActivityFromUserKey]) {
                                [commenters addObject:[activity objectForKey:kPTKActivityFromUserKey]];
                            }

                            if ([[[activity objectForKey:kPTKActivityFromUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                                if ([[activity objectForKey:kPTKActivityTypeKey] isEqualToString:kPTKActivityTypeLike]) {
                                    isLikedByCurrentUser = YES;
                                }
                            }
                        }

                        [[TKCache sharedCache] setAttributesForPhoto:object likers:likers commenters:commenters likedByCurrentUser:isLikedByCurrentUser];

                        if (headerView.tag != index) {
                            return;
                        }

                        [headerView setLikeStatus:[[TKCache sharedCache] isPhotoLikedByCurrentUser:object]];
                        [headerView.likeButton setTitle:[[[TKCache sharedCache] likeCountForPhoto:object] description] forState:UIControlStateNormal];
                        [headerView.commentButton setTitle:[[[TKCache sharedCache] commentCountForPhoto:object] description] forState:UIControlStateNormal];

                        if (headerView.likeButton.alpha < 1.0f || headerView.commentButton.alpha < 1.0f) {
                            [UIView animateWithDuration:0.200f animations:^{
                                headerView.likeButton.alpha = 1.0f;
                                headerView.commentButton.alpha = 1.0f;
                            }];
                        }
                    }
                }];
            }
        }
    }

    return headerView;
}

- (NSIndexPath *)indexPathForObject:(PFObject *)targetObject {
    for (int i = 0; i < self.objects.count; i++) {
        PFObject *object = [self.objects objectAtIndex:i];
        if ([[object objectId] isEqualToString:[targetObject objectId]]) {
            return [NSIndexPath indexPathForRow:i*2+1 inSection:0];
        }
    }

    return nil;
}

- (void)userDidLikeOrUnlikePhoto:(NSNotification *)note {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)userDidCommentOnPhoto:(NSNotification *)note {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)userDidDeletePhoto:(NSNotification *)note {
    // refresh timeline after a delay
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^(void){
        [self loadObjects];
    });
}

- (void)userDidPublishPhoto:(NSNotification *)note {
    if (self.objects.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }

    [self loadObjects];
}

- (void)userFollowingChanged:(NSNotification *)note {
    NSLog(@"User following changed.");
    self.shouldReloadOnAppear = YES;
}


- (void)didTapOnPhotoAction:(UIButton *)sender {
    PFObject *photo = [self.objects objectAtIndex:sender.tag];
    if (photo) {
        TKPhotoDetailsViewController *photoDetailsVC = [[TKPhotoDetailsViewController alloc] initWithPhoto:photo];
        [self.navigationController pushViewController:photoDetailsVC animated:YES];
    }
}

/*
 For each object in self.objects, we display two cells. If pagination is enabled, there will be an extra cell at the end.
 NSIndexPath     index self.objects
 0 0 HEADER      0
 0 1 PHOTO       0
 0 2 HEADER      1
 0 3 PHOTO       1
 0 4 LOAD MORE
 */

- (NSIndexPath *)indexPathForObjectAtIndex:(NSUInteger)index header:(BOOL)header {
    return [NSIndexPath indexPathForItem:(index * 2 + (header ? 0 : 1)) inSection:0];
}

- (NSUInteger)indexForObjectAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row / 2;
}



@end
