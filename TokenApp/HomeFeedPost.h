//
//  HomeFeedPost.h
//  TokenApp
//
//  Created by Emmanuel Masangcay on 4/28/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HomeFeedPost : NSObject

@property (nonatomic,strong) UIImage *userProfilePic;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *timePosted;
@property (nonatomic,strong) NSString *mediaType;
@property (nonatomic,strong) UIImage *contentImage;
@property (nonatomic,strong) NSString *postMessage;
@property (nonatomic,strong) NSURL *videoURL;
@property (nonatomic,strong) NSURL *linkURL;

-(id)initWithUsername:(NSString*)name profilePic:(UIImage*)profilepic timePosted:(NSString*)time contentImage:(UIImage*)contentImage postMessage:(NSString*)message videoURL:(NSURL*)video linkURL:(NSURL*)link mediaType:(NSString*)mediatype;

@end
