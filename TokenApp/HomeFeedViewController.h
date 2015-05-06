//
//  HomeFeedViewController.h
//  TokenApp
//
//  Created by Emmanuel Masangcay on 4/26/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrentUser.h"

@interface HomeFeedViewController : UIViewController

{
    CurrentUser *currentUser;
    UIActivityIndicatorView *spinner;
}


@end
