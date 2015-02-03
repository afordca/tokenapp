//
//  User.m
//  
//
//  Created by BASEL FARAG on 2/3/15.
//
//

#import "User.h"
#import <Parse/Parse.h>

@implementation User
{
    User *anotherSingle;
}


@synthesize profileImage;
@synthesize userName;


+ (User *)sharedSingleton
{
    static User *single = nil;
    {
        if ( !single)
        {
            // allocate the shared instance, because it hasn't been done yet
            single = [[User alloc] init];
        }

        return single;
    }
}

@end