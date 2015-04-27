//
//  TK_TabBarViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/12/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "TK_TabBarViewController.h"
#import "MFC_CreateViewController.h"
#import "CustomTabBar.h"

@interface TK_TabBarViewController ()<CustomTabBarDelegate>
@property (strong, nonatomic) IBOutlet UITabBar *tabBarNavigation;

@end

@implementation TK_TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //add the custom tabbarcontroller
    CustomTabBar *customTabBar = [[CustomTabBar alloc] initWithFrame:CGRectMake(0,self.view.bounds.size.height - 49, self.view.bounds.size.width, 49)];

    customTabBar.delegate = self;


    [self.view addSubview:customTabBar];


    self.tabBarNavigation.hidden = NO;


}

#pragma mark - Custom TabBar Delegate Methods

-(void)onClickHomeFeed
{
    NSLog(@"Home");
    self.selectedIndex = 0;
}

-(void)onClickDiscover
{
    NSLog(@"Discover");
    self.selectedIndex = 1;
}

-(void)onClickCreate
{
    NSLog(@"Create");


    // Notification setup
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CreateMainView" object:self];

}

-(void)onClickProfile
{
    NSLog(@"Profile");
    self.selectedIndex = 3;
}

-(void)onClickBalance
{
    NSLog(@"Balance");
    self.selectedIndex = 2;
}



@end
