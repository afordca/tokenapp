//
//  Link.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 3/20/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "Link.h"

@implementation Link

-(id)initWithUrl:(NSString*)URL urlID:(NSString *)urlID description:(NSString *)description likes:(NSInteger)numberOfLikes
{
    NSURL *url = [NSURL URLWithString:URL];

    self.urlLink = url;
    self.urlID = urlID;
    self.urlDescription = description;
    self.numberOfLikes = numberOfLikes;

    return self;
}

@end
