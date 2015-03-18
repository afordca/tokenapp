//
//  ProfileCollectionReusableView.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/20/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "ProfileCollectionReusableView.h"
#import "UIColor+HEX.h"

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
    [self buttonPressAnimation:sender];

    [self.delegate presentFollowersView];
}

- (IBAction)buttonPressFollowing:(id)sender
{
    [self buttonPressAnimation:sender];
    
    [self.delegate presentFollowingView];
}


- (IBAction)buttonPressNotifications:(id)sender
{
    [self.delegate presentNotificationsView];
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

#pragma mark Helper Methods

-(void)buttonPressAnimation:(UIButton*)button
{
    [UIView animateWithDuration:0.1
                          delay:0 options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         CGAffineTransform transform =
                         CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
                         button.transform = transform;
                     }
                     completion:^(BOOL finished)
     {
         CGAffineTransform transform =
         CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
         button.transform = transform;

     }];
}

@end
