
//
//  FollowersTableViewCell.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/24/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "FollowersTableViewCell.h"

@implementation FollowersTableViewCell


-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        self.labelUsername = [[NIAttributedLabel alloc] initWithFrame:CGRectZero];
        [self addSubview:self.labelUsername];

    }
    return self;
}

- (IBAction)buttonPressFollowFollowing:(id)sender
{

    [self.delegate followerFollowingPressed:self.userFollower row:self.row];
    
}



@end
