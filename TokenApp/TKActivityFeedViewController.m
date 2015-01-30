//
//  TKActivityFeedViewController.m
//  
//
//  Created by BASEL FARAG on 1/8/15.
//
//

#import "TKActivityFeedViewController.h"
#import "Constants.h"
#import "MBProgressHUD.h"
#import "PTKContentDetailTableViewController.h"
#import "TKCache.h"
#import "PTKContentDetailTableViewController.h"
#import "TKSettingsButtonItem.h"
#import "TKActivityCell.h"
#import "TKLoadMoreCell.h"
#import "TKAccountViewController.h"
#import "TKSettingsActionDelegate.h"



@interface TKActivityFeedViewController ()

@property (nonatomic, strong) TKSettingsActionDelegate *settingsActionSheetDelegate;
@property (nonatomic, strong) NSDate *lastRefresh;
@property (nonatomic, strong) UIView *blankTimelineView;

@end


@implementation TKActivityFeedViewController

//@synthesize settingsActionSheetDelegate;
@synthesize lastRefresh;
@synthesize blankTimelineView;

#pragma mark - Initialization 

-(id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        //The Classname to query on
        self.parseClassName = kPTKActivityClassKey;

        //is built in pagination enabled?
        self.paginationEnabled = YES;

        //built in pull-to-refresh enabled?
        self.pullToRefreshEnabled = YES;

        //the number of objects to show per page
        self.objectsPerPage = 15;

        //The loading text clashes with the dark design
        self.loadingViewEnabled = YES;
    }
    return self;
}

#pragma mark - UIViewController 

-(void)viewDidLoad {


    [super viewDidLoad];

    UIView *texturedBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    [texturedBackgroundView setBackgroundColor:[UIColor blackColor]];
    self.tableView.backgroundView = texturedBackgroundView;

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogoNavigationBar.png"]];

    // Add Settings button
    self.navigationItem.rightBarButtonItem = [[TKSettingsButtonItem alloc] initWithTarget:self action:@selector(settingsButtonAction:)];

    self.blankTimelineView = [[UIView alloc] initWithFrame:self.tableView.bounds];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"ActivityFeedBlank.png"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(24.0f, 113.0f, 271.0f, 140.0f)];
    [button addTarget:self action:@selector(inviteFriendsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.blankTimelineView addSubview:button];

    lastRefresh = [[NSUserDefaults standardUserDefaults] objectForKey:kTKUserDefaultsActivityFeedViewControllerLastRefreshKey];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.separatorColor = [UIColor colorWithRed:30.0f/255.0f green:30.0f/255.0f blue:30.0f/255.0f alpha:1.0f];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) {
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        NSString *activityString = [TKActivityFeedViewController stringForActivityType:(NSString*)[object objectForKey:kPTKActivityTypeKey]];

        PFUser *user = (PFUser*)[object objectForKey:kPTKActivityFromUserKey];
        NSString *nameString = NSLocalizedString(@"Someone", nil);
        if (user && [user objectForKey:kTKUserDisplayNameKey] && [[user objectForKey:kTKUserDisplayNameKey] length] > 0) {
            nameString = [user objectForKey:kTKUserDisplayNameKey];
        }

        return [TKActivityCell heightForCellWithName:nameString contentString:activityString];
    } else {
        return 44.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.objects.count) {
        PFObject *activity = [self.objects objectAtIndex:indexPath.row];
        if ([activity objectForKey:kPTKActivityPhotoKey]) {
            PTKContentDetailTableViewController *detailViewController = [[PTKContentDetailTableViewController alloc] initWithPhoto:[activity objectForKey:kPTKActivityPhotoKey]];
            [self.navigationController pushViewController:detailViewController animated:YES];
        } else if ([activity objectForKey:kPTKActivityFromUserKey]) {
            TKAccountViewController *detailViewController = [[TKAccountViewController alloc] initWithStyle:UITableViewStylePlain];
            NSLog(@"Presenting account view controller with user: %@", [activity objectForKey:kPTKActivityFromUserKey]);
            [detailViewController setUser:[activity objectForKey:kPTKActivityFromUserKey]];
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
    } else if (self.paginationEnabled) {
        // load more
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

    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:kPTKActivityToUserKey equalTo:[PFUser currentUser]];
    [query whereKey:kPTKActivityFromUserKey notEqualTo:[PFUser currentUser]];
    [query whereKeyExists:kPTKActivityFromUserKey];
    [query includeKey:kPTKActivityFromUserKey];
    [query includeKey:kPTKActivityPhotoKey];
    [query orderByDescending:@"createdAt"];

    [query setCachePolicy:kPFCachePolicyNetworkOnly];

    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    //
    // If there is no network connection, we will hit the cache first.
    if (self.objects.count == 0 || ![[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)]) {
        [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    }

    return query;
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];

    lastRefresh = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:lastRefresh forKey:kTKUserDefaultsActivityFeedViewControllerLastRefreshKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [MBProgressHUD hideHUDForView:self.view animated:YES];

    if (self.objects.count == 0 && ![[self queryForTable] hasCachedResult]) {
        self.tableView.scrollEnabled = NO;
        self.navigationController.tabBarItem.badgeValue = nil;

        if (!self.blankTimelineView.superview) {
            self.blankTimelineView.alpha = 0.0f;
            self.tableView.tableHeaderView = self.blankTimelineView;

            [UIView animateWithDuration:0.200f animations:^{
                self.blankTimelineView.alpha = 1.0f;
            }];
        }
    } else {
        self.tableView.tableHeaderView = nil;
        self.tableView.scrollEnabled = YES;

        NSUInteger unreadCount = 0;
        for (PFObject *activity in self.objects) {
            if ([lastRefresh compare:[activity createdAt]] == NSOrderedAscending && ![[activity objectForKey:kPTKActivityTypeKey] isEqualToString:kPTKActivityTypeJoined]) {
                unreadCount++;
            }
        }

        if (unreadCount > 0) {
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)unreadCount];
        } else {
            self.navigationController.tabBarItem.badgeValue = nil;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"ActivityCell";

    TKActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TKActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setDelegate:self];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }

    [cell setActivity:object];;

    if ([lastRefresh compare:[object createdAt]] == NSOrderedAscending) {
        [cell setIsNew:YES];
    } else {
        [cell setIsNew:NO];
    }

    [cell hideSeparator:(indexPath.row == self.objects.count - 1)];

    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *LoadMoreCellIdentifier = @"LoadMoreCell";

    TKLoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadMoreCellIdentifier];
    if (!cell) {
        cell = [[TKLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadMoreCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.hideSeparatorBottom = YES;
        cell.mainView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}


#pragma mark - TKActivityCellDelegate Methods

- (void)cell:(TKActivityCell *)cellView didTapActivityButton:(PFObject *)activity {
    // Get image associated with the activity
    PFObject *photo = [activity objectForKey:kPTKActivityPhotoKey];

    // Push single photo view controller
    PTKContentDetailTableViewController *photoViewController = [[PTKContentDetailTableViewController alloc] initWithPhoto:photo];
    [self.navigationController pushViewController:photoViewController animated:YES];
}

- (void)cell:(TKBaseCellText *)cellView didTapUserButton:(PFUser *)user {
    // Push account view controller
    TKAccountViewController *accountViewController = [[TKAccountViewController alloc] initWithStyle:UITableViewStylePlain];
    NSLog(@"Presenting account view controller with user: %@", user);
    [accountViewController setUser:user];
    [self.navigationController pushViewController:accountViewController animated:YES];
}


#pragma mark - TKActivityFeedViewController

+ (NSString *)stringForActivityType:(NSString *)activityType {
    if ([activityType isEqualToString:kPTKActivityTypeLike]) {
        return NSLocalizedString(@"liked your photo", nil);
    } else if ([activityType isEqualToString:kPTKActivityTypeFollow]) {
        return NSLocalizedString(@"started following you", nil);
    } else if ([activityType isEqualToString:kPTKActivityTypeComment]) {
        return NSLocalizedString(@"commented on your photo", nil);
    } else if ([activityType isEqualToString:kPTKActivityTypeJoined]) {
        return NSLocalizedString(@"joined Token", nil);
    } else {
        return nil;
    }
}



@end
