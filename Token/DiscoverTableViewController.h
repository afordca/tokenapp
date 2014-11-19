//
//  DiscoverTableViewController.h
//  Token
//
//  Created by Dave on 10/28/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSKeyboardControls.h"

@interface DiscoverTableViewController : UITableViewController
<UITextFieldDelegate, BSKeyboardControlsDelegate>
{
    UITextField *searchTextField;
    UIButton *popularButton;
    UIButton *trendingButton;
    UIButton *exploreButton;
    UIButton *newsButton;
    UIButton *sportsButton;
    UIButton *technologyButton;
    UIButton *businessButton;
    BSKeyboardControls *keyboardControls;
}

- (void)popularButtonTouched;
- (void)trendingButtonTouched;
- (void)exploreButtonTouched;
@end
