//
//  OthersProfileViewController.h
//  TokenApp
//
//  Created by Emmanuel Masangcay on 5/11/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface OthersProfileViewController : UIViewController
{
    CurrentUser *currentUser;
}

@property User *otherUser;
@property NSMutableArray *arrayOfContent;
@property NSMutableArray *arrayOfFollowers;
@property NSMutableArray *arrayOfFollowing;

@end
