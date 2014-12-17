//
//  CreateContentViewController.m
//  TokenApp
//
//  Created by BASEL FARAG on 12/17/14.
//  Copyright (c) 2014 ABaselNotBasilProduction. All rights reserved.
//

#import "CreateContentViewController.h"

@interface CreateContentViewController ()

@end

@implementation CreateContentViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0]];

    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [titleView setImage:[UIImage imageNamed:@"MarkNav"]];
    [self.navigationItem setTitleView:titleView];

    photoButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height/2 - 100, 80, 80)];
    NSLog(@"self.view.frame.size.width returns %f", self.view.frame.size.width);

    [photoButton setTitle:@"" forState:UIControlStateNormal];
    [photoButton setBackgroundImage:[UIImage imageNamed:@"Photo"] forState:UIControlStateNormal];

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
