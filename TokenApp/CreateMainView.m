//
//  CreateMainView.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/15/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "CreateMainView.h"
#import "CamerOverlay.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

@implementation CreateMainView 

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {

    }
    return self;
}



- (IBAction)onbuttonPhoto:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"TakePhoto" object:self];
}

- (IBAction)onButtonVideo:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"TakeVideo" object:self];
}

- (IBAction)onButtonPost:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PostNote" object:self];
}

- (IBAction)onButtonLink:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PostLink" object:self];
}

- (IBAction)onButtonCancel:(id)sender
{
    // Notification setup
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SendCancel" object:self];

}


@end
