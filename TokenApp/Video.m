//
//  Video.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 3/20/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "Video.h"
#import <AVFoundation/AVFoundation.h>

@implementation Video

-(id)initWithUrl:(NSURL *)URL
{
    self.videoURL = URL;

    UIImage *thumbnail = nil;
    NSURL *url = URL;
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    NSError *error = nil;
    CMTime time = CMTimeMake(0, 1); // 3/1 = 3 second(s)
    CGImageRef imgRef = [generator copyCGImageAtTime:time actualTime:nil error:&error];
    if (error != nil)
        NSLog(@"%@: %@", self, error);
    thumbnail = [[UIImage alloc] initWithCGImage:imgRef];
    self.videoThumbnail = thumbnail;
    CGImageRelease(imgRef);

    return self;
}

@end
