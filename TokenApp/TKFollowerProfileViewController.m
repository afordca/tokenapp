//
//  TKFollowerProfileViewController.m
//  TokenApp
//
//  Created by BASEL FARAG on 2/20/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "TKFollowerProfileViewController.h"

@interface TKFollowerProfileViewController ()

@property (nonatomic) bool isFollowing;

@end


@implementation TKFollowerProfileViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //Does logged in user follow this user?
    //Yes --> show 'unfollow"


    self.isFollowing = FALSE;


    
}

-(void)importUsersFollowers:(NSString *)
{

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
