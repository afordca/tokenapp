//
//  CustomTabBar.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/12/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "CustomTabBar.h"

@implementation CustomTabBar

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [UIColor blackColor];

        //Add Home Feed Button

        UIButton *btnHomeFeed = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnHomeFeed setImage:[UIImage imageNamed:@"Feed"] forState:UIControlStateNormal];
        [btnHomeFeed setTintColor:[UIColor whiteColor]];

        //set the frame
        CGRect btnHomeFrame = CGRectMake(10, 5, 50, 40);
        btnHomeFeed.frame = btnHomeFrame;
        [btnHomeFeed addTarget:self
                     action:@selector(clickHome)
           forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:btnHomeFeed];

        //Add Discover Button

        UIButton *btnDiscover = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnDiscover setImage:[UIImage imageNamed:@"Discover"] forState:UIControlStateNormal];
        [btnDiscover setTintColor:[UIColor whiteColor]];

        //set the frame
        CGRect btnDiscoverFrame = CGRectMake(70, 5, 50, 40);
        btnDiscover.frame = btnDiscoverFrame;
        [btnDiscover addTarget:self
                        action:@selector(clickDiscover)
              forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:btnDiscover];

        //Add Create Button

        UIButton *btnCreate = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnCreate setImage:[UIImage imageNamed:@"Upload"] forState:UIControlStateNormal];
        [btnCreate setContentMode:UIViewContentModeScaleAspectFit];
        [btnCreate setTintColor:[UIColor whiteColor]];

        //set the frame
        CGRect btnCreateFrame = CGRectMake(130, 5, 50, 40);
        btnCreate.frame = btnCreateFrame;
        [btnCreate addTarget:self
                        action:@selector(clickCreate)
              forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:btnCreate];

        //Add Profile Button

        UIButton *btnProfile = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnProfile setImage:[UIImage imageNamed:@"Profile"] forState:UIControlStateNormal];
        [btnProfile setTintColor:[UIColor whiteColor]];

        //set the frame
        CGRect btnProfileFrame = CGRectMake(190, 5, 50, 40);
        btnProfile.frame = btnProfileFrame;
        [btnProfile addTarget:self
                      action:@selector(clickProfile)
            forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:btnProfile];

        //Add Balance Button

        UIButton *btnBalance = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnBalance setImage:[UIImage imageNamed:@"Balance"] forState:UIControlStateNormal];
        [btnBalance setTintColor:[UIColor whiteColor]];

        //set the frame
        CGRect btnBalanceFrame = CGRectMake(250, 5, 50, 40);
        btnBalance.frame = btnBalanceFrame;
        [btnBalance addTarget:self
                       action:@selector(clickBalance)
             forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:btnBalance];

    }
    return self;
}

-(void)clickHome
{
    NSLog(@"Click Home");
    [self.delegate onClickHomeFeed];
}

-(void)clickDiscover
{
    NSLog(@"Click Discover");
    [self.delegate onClickDiscover];
}

-(void)clickCreate
{
    NSLog(@"Click Create");
    [self.delegate onClickCreate];
}

-(void)clickProfile
{
    NSLog(@"Click Profile");
    [self.delegate onClickProfile];
}

-(void)clickBalance
{
    NSLog(@"Click Balance");
    [self.delegate onClickBalance];
}

@end
