//
//  SettingsButtonItem.m
//  TokenApp
//
//  Created by BASEL FARAG on 12/19/14.
//  Copyright (c) 2014 ABaselNotBasilProduction. All rights reserved.
//

#import "SettingsButtonItem.h"

@implementation SettingsButtonItem

#pragma mark - Initialization

- (id)initWithTarget:(id)target action:(SEL)action {
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];

    self = [super initWithCustomView:settingsButton];
    if (self) {
        //        [settingsButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [settingsButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [settingsButton setFrame:CGRectMake(0.0f, 0.0f, 35.0f, 32.0f)];
        [settingsButton setImage:[UIImage imageNamed:@"Settings@3x.png"] forState:UIControlStateNormal];
        [settingsButton setImage:[UIImage imageNamed:@"Settings@2x.png"] forState:UIControlStateHighlighted];
    }

    return self;
}


@end
