//
//  UserObject.m
//  Token
//
//  Created by Dave on 10/28/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import "UserObject.h"

static UserObject *currentUser;

@implementation UserObject
@synthesize username;

+ (UserObject *)currentUser
{
    if (!currentUser) {
        currentUser = [[UserObject alloc] init];
    }
    return currentUser;
}

@end
