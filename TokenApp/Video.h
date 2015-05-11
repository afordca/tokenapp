//
//  Video.h
//  TokenApp
//
//  Created by Emmanuel Masangcay on 3/20/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Video : NSObject

@property (nonatomic,strong) NSURL *videoURL;
@property (nonatomic,strong) UIImage *videoThumbnail;
@property (nonatomic,strong) NSString *photoDescription;
@property (nonatomic,strong) NSArray *arrayOfHashtags;
@property (nonatomic,strong) NSArray *arrayOfComments;

@property  NSInteger *numberOfLikes;


-(id)initWithUrl:(NSURL*)URL;

@end
