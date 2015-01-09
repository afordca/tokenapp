//
//  TKHomeViewController.h
//  TokenApp
//
//  Created by BASEL FARAG on 12/24/14.
//  Copyright (c) 2014 ABaselNotBasilProduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKContentTimelineViewController.h"


@interface TKHomeViewController : TKContentTimelineViewController

@property (nonatomic, assign, getter = isFirstLaunch) BOOL firstLaunch;

@end
