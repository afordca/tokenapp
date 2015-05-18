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
@property (nonatomic,strong) NSString *urlDescription;
@property (nonatomic,strong) NSString *urlID;
@property (nonatomic,strong) NSArray *arrayOfHashtags;
@property (nonatomic,strong) NSArray *arrayOfComments;

@property  NSInteger numberOfLikes;

-(id)initWithUrl:(NSString*)URL urlID:(NSString*)urlID description:(NSString*)description likes:(NSInteger)numberOfLikes;

@end
