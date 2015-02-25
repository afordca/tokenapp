//
//  ProfileCollectionReusableView.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/20/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "ProfileCollectionReusableView.h"

@implementation ProfileCollectionReusableView


-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        //Accessing User Singleton
        currentUser = [User sharedSingleton];

    }

    return self;
}


- (IBAction)buttonPressProfilePic:(id)sender
{

    NSLog(@"TAP");

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Profile Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Existing", nil];
    //
            [actionSheet showInView:self];
}

- (IBAction)buttonPressActivity:(id)sender
{
    [self.delegate presentActivityView];
}

- (IBAction)buttonPressFollowers:(id)sender
{
    [self.delegate presentFollowersView];
}

#pragma mark UIAction Sheet Methods

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        
        [self.delegate tapOnCamera];

    }
    else if (buttonIndex == 1)
    {

        [self.delegate tapOnLibrary];

    }
}

@end
