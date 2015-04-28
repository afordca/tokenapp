//
//  Photo.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 3/20/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "Photo.h"

@implementation Photo

-(id)initWithImage:(UIImage *)picture name:(NSString *)username time:(NSString *)time
{
    self.picture = picture;
    self.time = time;
    self.userName = username;

    return self;
}

@end
