//
//  MFC_HomeFeedViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/2/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "MFC_HomeFeedViewController.h"

@interface MFC_HomeFeedViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableViewHomeFeed;

@end

@implementation MFC_HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

@end
