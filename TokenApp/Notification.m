//
//  Notifications.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/26/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "Notification.h"

@implementation Notification

-(NSString *)createNotification:(NSString *)username type:(NSString *)type mediatype:(NSString *)media
{
    if ([type isEqualToString:@"tagged"])
    {
        return [NSString stringWithFormat:@"%@ %@ you in a %@",username,type,media];
    }
    else
    {
        return [NSString stringWithFormat:@"%@ %@ your %@",username,type,media];
    }

    return @"ERROR";

}



@end
