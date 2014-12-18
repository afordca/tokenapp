//
//  EditPhotoViewController.m
//  TokenApp
//
//  Created by BASEL FARAG on 12/16/14.
//  Copyright (c) 2014 ABaselNotBasilProduction. All rights reserved.
//

#import "EditPhotoViewController.h"
#import "UIImage+ResizeAdditions.h"
#import "Macros.h"


@interface EditPhotoViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImage *image;
@property PFFile *photoFile;
@property PFFile *thumbnailFile;
@property UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;
@property UIBackgroundTaskIdentifier photoPostBackgroundTaskId;

@end

@implementation EditPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (id)initWithImage:(UIImage *)aImage {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        if (!aImage) {
            return nil;
        }

        self.image = aImage;
        self.fileUploadBackgroundTaskId = UIBackgroundTaskInvalid;
        self.photoPostBackgroundTaskId = UIBackgroundTaskInvalid;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIViewController 

//The goal here is to store two versions of the photo in order to boost the performance of the UITableViews. 

-(BOOL)shouldUploadImage:(UIImage *)anImage {
    //Resize the image to be square (or what's show in the image preview)
    UIImage *resizedImage = [anImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(560.0f, 560.0f) interpolationQuality:kCGInterpolationDefault];
    //Create a thumbnail and add a corner radius to it so it can more easily be used in tableview
    UIImage *thumbnailImage = [anImage thumbnailImage:86.0f transparentBorder:0.0f cornerRadius:10.0f interpolationQuality:kCGInterpolationDefault];
    //Get an NSData rep of the images. JPEG for the large image. PNG for the thumbnail to keep corner
    //radius transparency
    //JPEG to decrease the file size and enable faster uploads & downloads
    NSData *imageData = UIImageJPEGRepresentation(resizedImage, 0.8f);
    NSData *thumbnailImageData = UIImagePNGRepresentation(thumbnailImage);

    if (!imageData || !thumbnailImageData){
        return NO;
    }
    //Create the PFFiles and store them in propertues since we'll use them later
    self.photoFile = [PFFile fileWithData:imageData];
    self.thumbnailFile = [PFFile fileWithData:thumbnailImageData];

    //Request a background Execution task to allow app to finish uploading the photo even if the app is backgrounded
    self.fileUploadBackgroundTaskId = [[UIApplication sharedApplication]beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
    }];

    [self.photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded){
            [self.thumbnailFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"Thumbnail uploaded successfully");
                }
                [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
            }];

        }
    }];

    return YES;
}







@end
