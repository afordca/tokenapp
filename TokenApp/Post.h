//
//  Post.h
//  TokenApp
//
//  Created by Emmanuel Masangcay on 3/20/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject

@property (nonatomic,strong) NSString *postMessage;
@property (nonatomic,strong) NSString *postHeader;
@property (nonatomic,strong) NSString *postID;

@property (nonatomic,strong) NSArray *arrayOfHashtags;
@property (nonatomic,strong) NSArray *arrayOfComments;

@property  NSInteger numberOfLikes;

-(id)initWithDescription:(NSString*)note header:(NSString*)header likes:(NSInteger)numberOfLikes postID:(NSString*)postID;

@end
