//
//  Activity.h
//  TokenApp
//
//  Created by Emmanuel Masangcay on 3/21/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "User.h"

@interface Activity : NSObject

@property (nonatomic,strong) User *user;
@property (nonatomic,strong) NSString *activityType;
@property  NSInteger *mediaContentCount;
@property (nonatomic,strong) NSString *typeOfMedia;

@end
