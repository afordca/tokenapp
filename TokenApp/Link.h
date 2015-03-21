//
//  Link.h
//  TokenApp
//
//  Created by Emmanuel Masangcay on 3/20/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Link : NSObject

@property (nonatomic,strong) NSURL *urlLink;
@property (nonatomic,strong) NSArray *arrayOfHashtags;
@property (nonatomic,strong) NSArray *arrayOfComments;

@property  NSInteger *numberOfLikes;

@end
