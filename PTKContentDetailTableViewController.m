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
//#import "MBProgressHUD.h"

@interface PTKContentDetailTableViewController ()
@property (nonatomic, strong) UITextField *commentTextField;
@property (nonatomic, assign) BOOL likersQueryInProgress;

@end


@implementation PTKContentDetailTableViewController

@synthesize commentTextField;
@synthesize photo;

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



@end
