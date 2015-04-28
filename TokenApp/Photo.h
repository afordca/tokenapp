//
//  Photo.h
//  TokenApp
//
//  Created by Emmanuel Masangcay on 3/20/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Photo : NSObject

@property (nonatomic,strong) UIImage *picture;
@property (nonatomic,strong) NSString *photoDescription;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSArray *arrayOfHashtags;
@property (nonatomic,strong) NSArray *arrayOfComments;

@property  NSInteger *numberOfLikes;

#warning Still need to add description, hashtags, and comments

-(id)initWithImage:(UIImage*)picture name:(NSString*)username time:(NSString*)time;

@end
