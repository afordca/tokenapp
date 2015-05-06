//
//  Post.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 3/20/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "Post.h"

@implementation Post

-(id)initWithDescription:(NSString *)note header:(NSString *)header
{
    self.postMessage = note;
    self.postHeader = header;

    return self;
}

@end
