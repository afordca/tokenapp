//
//  Link.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 3/20/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "Link.h"

@implementation Link

-(id)initWithUrl:(NSString*)URL
{
    NSURL *url = [NSURL URLWithString:URL];

    self.urlLink = url;

    return self;
}

@end
