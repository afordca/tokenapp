//
//  Notifications.h
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/26/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface Notifications : NSObject

@property UIImage *imageProfilePic;
@property NSString *stringUsername;
@property NSString *stringType;
@property NSString *stringMediaType;

-(NSString*)createNotification:(NSString*)username type:(NSString*)type mediatype:(NSString*)media;

@end
