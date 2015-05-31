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

        // Observer for when Post Note button is pressed.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receivedNotification:)
                                                     name:@"tabNav"
                                                   object:nil];

        // Observer for when Post Note button is pressed.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receivedNotification:)
                                                     name:@"Cancel"
                                                   object:nil];

        self.backgroundColor = [UIColor blackColor];

        //Add Home Feed Button

        btnHomeFeed = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnHomeFeed setImage:[UIImage imageNamed:@"Feed"] forState:UIControlStateNormal];
        [btnHomeFeed setTintColor:[UIColor colorwithHexString:@"#72c74a" alpha:.9]];

        //set the frame
        CGRect btnHomeFrame = CGRectMake(10, 5, 50, 40);

        btnHomeFeed.frame = btnHomeFrame;

        btnHomeFeed.translatesAutoresizingMaskIntoConstraints = NO;
        btnHomeFeed.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        btnHomeFeed.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;

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

        btnDiscover.translatesAutoresizingMaskIntoConstraints = NO;
        btnDiscover.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        btnDiscover.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;

        [btnDiscover addTarget:self
                        action:@selector(clickDiscover)
              forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:btnDiscover];

        //Add Create Button

        btnCreate = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnCreate setImage:[UIImage imageNamed:@"Upload"] forState:UIControlStateNormal];
        [btnCreate setBackgroundColor:[UIColor clearColor]];
        [btnCreate setTintColor:[UIColor whiteColor]];

        //set the frame
        CGRect btnCreateFrame = CGRectMake(130, 5, 50, 40);

        btnCreate.frame = btnCreateFrame;

        btnCreate.translatesAutoresizingMaskIntoConstraints = NO;
        btnCreate.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        btnCreate.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;

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

        btnProfile.translatesAutoresizingMaskIntoConstraints = NO;
        btnProfile.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        btnProfile.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;

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

        btnBalance.translatesAutoresizingMaskIntoConstraints = NO;
        btnBalance.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        btnBalance.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;

        [btnBalance addTarget:self
                       action:@selector(clickBalance)
             forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:btnBalance];

        [self layoutConstraints];

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
    [btnCreate setEnabled:NO];
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

-(void)layoutConstraints
{
    [self removeConstraints:self.constraints];

    UIButton *balance = btnBalance;
    UIButton *profile = btnProfile;
    UIButton *create = btnCreate;
    UIButton *discover = btnDiscover;
    UIButton *home = btnHomeFeed;

    NSDictionary *views = NSDictionaryOfVariableBindings(balance,profile,create,discover,home);

//    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[home]|" options:0 metrics:nil views:views];
//
//    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[home]-(>=30)-[discover]" options:0 metrics:nil views:views]];

    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[home]-(>=30@1000)-[discover]" options:0 metrics:nil views:views];

    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[discover]-(>=30@900)-[create]" options:0 metrics:nil views:views]];
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[create]-(>=30@800)-[profile]" options:0 metrics:nil views:views]];
     constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[profile]-(>=30@700)-[balance]" options:0 metrics:nil views:views]];

    NSDictionary *metrics = @{@"balance":@(100),@"profile":@(200),@"create":@(300),@"discover":@(400),@"home":@(500),};
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5@home-[home]-5@home-|" options:0 metrics:metrics views:views]];
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5@discover-[discover]-5@discover-|" options:0 metrics:metrics views:views]];
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5@create-[create]-5@create-|" options:0 metrics:metrics views:views]];
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5@profile-[profile]-5@profile-|" options:0 metrics:metrics views:views]];
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5@balance-[balance]-5@balance-|" options:0 metrics:metrics views:views]];

    NSLayoutConstraint *a = [NSLayoutConstraint constraintWithItem:create attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.f];

    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:home attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.1f constant:0.f];
    NSLayoutConstraint *d = [NSLayoutConstraint constraintWithItem:home attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.7f constant:0.f];

    [self addConstraint:c];
    [self addConstraint:d];
    [self addConstraint:a];

    NSLayoutConstraint *e = [NSLayoutConstraint constraintWithItem:discover attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.1f constant:0.f];
    NSLayoutConstraint *f = [NSLayoutConstraint constraintWithItem:discover attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.7f constant:0.f];
    [self addConstraint:e];
    [self addConstraint:f];

    NSLayoutConstraint *g = [NSLayoutConstraint constraintWithItem:create attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.1f constant:0.f];
    NSLayoutConstraint *h = [NSLayoutConstraint constraintWithItem:create attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.7f constant:0.f];
    [self addConstraint:g];
    [self addConstraint:h];

    NSLayoutConstraint *i = [NSLayoutConstraint constraintWithItem:profile attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.1f constant:0.f];
    NSLayoutConstraint *j = [NSLayoutConstraint constraintWithItem:profile attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.7f constant:0.f];
    [self addConstraint:i];
    [self addConstraint:j];

    NSLayoutConstraint *k = [NSLayoutConstraint constraintWithItem:balance attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.1f constant:0.f];
    NSLayoutConstraint *l = [NSLayoutConstraint constraintWithItem:balance attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.7f constant:0.f];
    [self addConstraint:k];
    [self addConstraint:l];
//    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[discover]-|" options:0 metrics:nil views:views]];
//
//    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[create]-|" options:0 metrics:nil views:views]];


    //

    //    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-250-[balance]|" options:0 metrics:nil views:views]];

    //

    //    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[balance]-|" options:0 metrics:nil views:views]];

    //

    //    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[discover]-125-|" options:0 metrics:nil views:views]];

    //

    //    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[discover]-|" options:0 metrics:nil views:views]];

    //

    //    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[home]-250-|" options:0 metrics:nil views:views]];

    //

    //    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[home]-|" options:0 metrics:nil views:views]];
    

    [self addConstraints:constraints];

    
}

- (void)receivedNotification:(NSNotification *) notification {

    if ([[notification name] isEqualToString:@"tabNav"])
    {
        [self clickHome];
    }
    else if([[notification name] isEqualToString:@"Cancel"])
    {
        [btnCreate setEnabled:YES];
    }
    
}



@end
