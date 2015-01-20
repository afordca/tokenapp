//
//  TKHomeViewController.m
//  TokenApp
//
//  Created by BASEL FARAG on 12/24/14.
//  Copyright (c) 2014 ABaselNotBasilProduction. All rights reserved.
//

#import "TKHomeViewController.h"

@interface TKHomeViewController ()

@end

@implementation TKHomeViewController
@synthesize firstLaunch;




- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [titleView setImage:[UIImage imageNamed:@"MarkNav"]];
    [self.navigationItem setTitleView:titleView];

    NSLog(@"Create content present");


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
