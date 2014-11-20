//
//  UserObject.h
//  Token
//
//  Created by Dave on 10/28/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserObject : NSObject
{
    NSString *username;
}

@property (nonatomic, retain) NSString *username;

+ (UserObject *)currentUser;

@end
