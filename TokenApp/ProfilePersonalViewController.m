//
//  ProfileViewController.m
//  TokenApp
//
//  Created by Basel Farag on 12/3/14.
//  Copyright (c) 2014 ABaselNotBasilProduction. All rights reserved.
//

#import "ProfilePersonalViewController.h"
#import "Macros.h"

@interface ProfilePersonalViewController () <UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIButton *addFollowerButton;
@property (weak, nonatomic) IBOutlet UIButton *Tokens;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;



@property NSMutableArray* arrayOfImages;

@end

@implementation ProfilePersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getUserProfilePictureFromParse];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getPhotosFromParse
{
    //Remember to define '6' as numofphotoallowed at top
    for (int i = 0; i< kNoOfPhotoAllow; i++) {
        PFFile *file = [self.user objectForKey:[NSString stringWithFormat:@"Photo%d",i]];
        if (file) {
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:data];
                    [self.arrayOfImages addObject:image];
                    self.pageControl.numberOfPages =  self.arrayOfImages.count;

                    [self.collectionView reloadData];
                }
            }];
        } else {
            break;
        }
    }

}

- (IBAction)cameraButtonTapped:(id)sender
{
    // Check for camera
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES) {
        // Create image picker controller
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];

        // Set source to the camera
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;

        // Delegate is self


        // Show image picker
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else{
        // Device has no camera
        UIImage *image;
        int r = arc4random() % 5;
        switch (r) {
            case 0:
                image = [UIImage imageNamed:@"Default@3x.png"];
                break;
            default:
                break;
        }

        // Resize image
        UIGraphicsBeginImageContext(CGSizeMake(640, 960));
        [image drawInRect: CGRectMake(0, 0, 640, 960)];
        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        NSData *imageData = UIImageJPEGRepresentation(smallImage, 0.05f);
        [self uploadImage:imageData];
    }
}

-(void)uploadImage:(NSData *)imageData
{
    //Query an image
    PFFile *imageFile = [PFFile fileWithName:@"Default@3x.png" data:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error){
            //Create a PFObject around a PFFile and associate it with the current user
            PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
            [userPhoto setObject:imageFile forKey:@"imageFile"];

            PFUser *user = [PFUser currentUser];
            [userPhoto setObject:user forKey:@"user"];

            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error){
                    NSLog(@"Succes");
                }
                else{
                    //Log the details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                    
                }
            }];
            
            
        }
    }];


}

-(void)getUserProfilePictureFromParse
{
    PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            for (PFObject *object in objects){
                PFFile *userImageFile = object[@"imageFile"];
                [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if (!error){
                                UIImage *image = [UIImage imageWithData:imageData];
                                self.userImage.image = image;
                }

            }];
            }
        }
        else{
            NSLog(@"Error");
        }
//        PFObject *anotherPhoto = [PFObject objectWithClassName:@"UserPhoto"];
//        PFFile *userImageFile = [anotherPhoto objectForKey:@"imageFile"];
//        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
//            if (!error){
//                UIImage *image = [UIImage imageWithData:imageData];
//                self.userImage.image = image;
//            }
//            else if (error){
//                NSLog(@"Error retreiving photo");
//            }
        }];

}



 

@end
