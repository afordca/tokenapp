//
//  TKContentTimelineViewController.m
//  TokenApp
//
//  Created by BASEL FARAG on 12/24/14.
//  Copyright (c) 2014 ABaselNotBasilProduction. All rights reserved.
//

#import "TKContentTimelineViewController.h"
#import "Constants.h"
#import "TKUtility.h"

@interface TKContentTimelineViewController ()
@property (nonatomic, assign) BOOL shouldReloadOnAppear;
@property (nonatomic, strong) NSMutableSet *reusableSectionHeaderViews;
@property (nonatomic, strong) NSMutableDictionary *outstandingSectionHeaderQueries;

@end

@implementation TKContentTimelineViewController
@synthesize reusableSectionHeaderViews;
@synthesize shouldReloadOnAppear;
@synthesize outstandingSectionHeaderQueries;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


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
         self.objectsPerPage = 10;

        // Improve scrolling performance by reusing UITableView section headers
        self.reusableSectionHeaderViews = [NSMutableSet setWithCapacity:3];

        self.loadingViewEnabled = NO;

        self.shouldReloadOnAppear = NO;
    }
    return self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
