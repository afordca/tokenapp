//
//  MFC_HomeFeedViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/2/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "MFC_HomeFeedViewController.h"
#import "Constants.h"


@interface MFC_HomeFeedViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableViewHomeFeed;
@property (nonatomic, assign) BOOL shouldReloadOnAppear;
@property (nonatomic, strong) NSMutableSet *reusableSectionHeaderViews;
@property (nonatomic, strong) NSMutableDictionary *outstandingSectionHeaderQueries;

@end

@implementation MFC_HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

        self.outstandingSectionHeaderQueries = [NSMutableDictionary dictionary];

        // The className to query on
        //self.className = kPAPPhotoClassKey;

        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;

        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;

        // The number of objects to show per page
        self.objectsPerPage = 10;

        // Improve scrolling performance by reusing UITableView section headers
        self.reusableSectionHeaderViews = [NSMutableSet setWithCapacity:3];

        self.shouldReloadOnAppear = NO;
    }
    return self;
}

#pragma mark - UITableView Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(IBAction)unwindToHomeFeed:(UIStoryboard*)sender{}

#pragma mark - PFQueryTableViewcontroller 

//- (PFQuery *)queryForTable {
//    if (![PFUser currentUser]){
//        PFQuery *query = [PFQuery queryWithClassName:self.className];
//        [query ]
//
//
//    }
//}

@end
