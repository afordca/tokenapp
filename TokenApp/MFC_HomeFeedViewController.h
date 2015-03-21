//
//  MFC_HomeFeedViewController.h
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/2/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFQueryTableViewController.h"
#import "CurrentUser.h"


@interface MFC_HomeFeedViewController : PFQueryTableViewController


{
    CurrentUser *singleUser;
}


@end
