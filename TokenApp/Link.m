//
//  Link.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 3/20/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "Link.h"

@implementation Link

-(id)initWithUrl:(NSString *)URL linkImage:(UIImage *)linkImage linkDescription:(NSString *)description linkTitle:(NSString *)title
{
    NSURL *url = [NSURL URLWithString:URL];

    self.urlLink = url;
    self.linkImage = linkImage;
    self.linkDescription = description;
    self.linkTitle = title;

    return self;
}

@end
