//
//  CustomTabBar.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/12/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "CustomTabBar.h"
#import "UIColor+HEX.h"

@implementation CustomTabBar

@synthesize btnHomeFeed;
@synthesize btnProfile;
@synthesize btnDiscover;
@synthesize btnBalance;
@synthesize btnCreate;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {

        self.backgroundColor = [UIColor blueColor];

        //Add Home Feed Button

        btnHomeFeed = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnHomeFeed setImage:[UIImage imageNamed:@"Feed"] forState:UIControlStateNormal];
        [btnHomeFeed setTintColor:[UIColor colorwithHexString:@"#72c74a" alpha:.9]];

        //set the frame
        CGRect btnHomeFrame = CGRectMake(10, 5, 50, 40);
        btnHomeFeed.frame = btnHomeFrame;
        [btnHomeFeed addTarget:self
                     action:@selector(clickHome)
           forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:btnHomeFeed];


        //Add Discover Button

        btnDiscover = [UIButton buttonWithType:UIButtonTypeRoundedRect];
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

        btnCreate = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnCreate setImage:[UIImage imageNamed:@"Upload"] forState:UIControlStateNormal];
        [btnCreate setBackgroundColor:[UIColor clearColor]];
        [btnCreate setTintColor:[UIColor whiteColor]];

        [btnCreate setEnabled:YES];

        //set the frame
        CGRect btnCreateFrame = CGRectMake(130, 5, 50, 40);
        btnCreate.frame = btnCreateFrame;
        [btnCreate addTarget:self
                        action:@selector(clickCreate)
              forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:btnCreate];


        //Add Profile Button

        btnProfile = [UIButton buttonWithType:UIButtonTypeRoundedRect];
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

        btnBalance = [UIButton buttonWithType:UIButtonTypeRoundedRect];
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
    [btnDiscover setTintColor:[UIColor whiteColor]];
    [btnBalance setTintColor:[UIColor whiteColor]];
    [btnCreate setTintColor: [UIColor whiteColor]];
    [btnProfile setTintColor:[UIColor whiteColor]];

    [btnHomeFeed setTintColor:[UIColor colorwithHexString:@"#72c74a" alpha:.9]];
    [self.delegate onClickHomeFeed];
}

-(void)clickDiscover
{
    NSLog(@"Click Discover");
    [btnHomeFeed setTintColor:[UIColor whiteColor]];
    [btnBalance setTintColor:[UIColor whiteColor]];
    [btnCreate setTintColor: [UIColor whiteColor]];
    [btnProfile setTintColor:[UIColor whiteColor]];

    [btnDiscover setTintColor:[UIColor colorwithHexString:@"#72c74a" alpha:.9]];
    [self.delegate onClickDiscover];
}

-(void)clickCreate
{
    NSLog(@"Click Create");
//    [btnDiscover setTintColor:[UIColor whiteColor]];
//    [btnBalance setTintColor:[UIColor whiteColor]];
//    [btnHomeFeed setTintColor: [UIColor whiteColor]];
//    [btnProfile setTintColor:[UIColor whiteColor]];

//    [btnCreate setTintColor:[UIColor colorwithHexString:@"#72c74a" alpha:.9]];
    [self.delegate onClickCreate];
}

-(void)clickProfile
{
    NSLog(@"Click Profile");
    [btnDiscover setTintColor:[UIColor whiteColor]];
    [btnBalance setTintColor:[UIColor whiteColor]];
    [btnCreate setTintColor: [UIColor whiteColor]];
    [btnHomeFeed setTintColor:[UIColor whiteColor]];

    [btnProfile setTintColor:[UIColor colorwithHexString:@"#72c74a" alpha:.9]];
    [self.delegate onClickProfile];
}

-(void)clickBalance
{
    NSLog(@"Click Balance");
    [btnDiscover setTintColor:[UIColor whiteColor]];
    [btnHomeFeed setTintColor:[UIColor whiteColor]];
    [btnCreate setTintColor: [UIColor whiteColor]];
    [btnProfile setTintColor:[UIColor whiteColor]];

    [btnBalance setTintColor:[UIColor colorwithHexString:@"#72c74a" alpha:.9]];
    [self.delegate onClickBalance];
}


@end
