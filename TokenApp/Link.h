//
//  Link.h
//  TokenApp
//
//  Created by Emmanuel Masangcay on 3/20/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Link : NSObject

@property (nonatomic,strong) NSURL *urlLink;
@property (nonatomic,strong) NSString *linkDescription;
@property (nonatomic,strong) NSString *linkTitle;
@property (nonatomic,strong) UIImage *linkImage;
@property (nonatomic,strong) NSArray *arrayOfHashtags;
@property (nonatomic,strong) NSArray *arrayOfComments;

@property  NSInteger *numberOfLikes;

-(id)initWithUrl:(NSString*)URL linkImage:(UIImage*)linkImage linkDescription:(NSString*)description linkTitle:(NSString*)title;

@end
