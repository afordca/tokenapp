//
//  CreateContentViewController.m
//  TokenApp
//
//  Created by BASEL FARAG on 12/17/14.
//  Copyright (c) 2014 ABaselNotBasilProduction. All rights reserved.
//

#import "CreateContentViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface CreateContentViewController ()

@end

@implementation CreateContentViewController
@synthesize photoButton;

- (void)viewDidLoad {

    // Do any additional setup after loading the view.
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0]];

    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [titleView setImage:[UIImage imageNamed:@"MarkNav"]];
    [self.navigationItem setTitleView:titleView];

    photoButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height/2 - 100, 80, 80)];
    NSLog(@"self.view.frame.size.width returns %f", self.view.frame.size.width);

    [photoButton setTitle:@"" forState:UIControlStateNormal];
    [photoButton setBackgroundImage:[UIImage imageNamed:@"Photo"] forState:UIControlStateNormal];

    videoButton = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 + 20, [UIScreen mainScreen].bounds.size.height/2 - 100, 80, 80)];
    [videoButton setTitle:@"" forState:UIControlStateNormal];
    [videoButton setBackgroundImage:[UIImage imageNamed:@"Video"] forState:UIControlStateNormal];

    linkButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 + 20, [UIScreen mainScreen].bounds.size.height/2, 80, 80)];
    [linkButton setTitle:@"" forState:UIControlStateNormal];
    [linkButton setBackgroundImage:[UIImage imageNamed:@"Link"] forState:UIControlStateNormal];

    composeButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height/2, 80, 80)];
    [composeButton setTitle:@"" forState:UIControlStateNormal];
    [composeButton setBackgroundImage:[UIImage imageNamed:@"Write"] forState:UIControlStateNormal];

    [photoButton addTarget:self action:@selector(selectPhotoFromLibrary) forControlEvents:UIControlEventTouchDown];
    [self.view setBackgroundColor:[UIColor blackColor]];

    [self.view addSubview:photoButton];
    [self.view addSubview:linkButton];
    [self.view addSubview:composeButton];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectPhotoFromLibrary
{

        NSLog(@"This is your library being brought up.");
        UIImagePickerController *imagePicker;
        imagePicker = [[UIImagePickerController alloc] init];
        [[imagePicker navigationBar] setBarTintColor:[UIColor whiteColor]];
        [[imagePicker navigationBar] setTintColor:[UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0]];
        [[imagePicker navigationBar] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];

        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }

        [self presentViewController:imagePicker animated:YES completion:nil];

}

#pragma mark - NavBarController Stuff

//-(BOOL)shouldPresentPhotoCaptureController
//{
//
//    BOOL presentedPhotoCaptureController = [self shouldStartCameraController];
//
//    if (!presentedPhotoCaptureController) {
//        presentedPhotoCaptureController = [self shouldPresentPhotoLibraryPickerController];
//    }
//
//    return presentedPhotoCaptureController;
//}



#pragma mark 

//We want a new view controller to come up and we want that viewcontroller to have access to the library in a button to the bottom right



-(void)photoCaptureButtonAction:(id)sender {
    BOOL cameraDeviceAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    BOOL photoLibraryAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];

    if (cameraDeviceAvailable && photoLibraryAvailable){
        [self shouldPresentPhotoCaptureController];
    }
}

-(BOOL)shouldStartCameraController
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO){
        return NO;
    }

    UIImagePickerController *cameraUI = [[UIImagePickerController alloc]init];

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera] containsObject:(NSString *)kUTTypeImage]){

        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;

        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]){
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        } else if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
        {
            cameraUI.sourceType = UIImagePickerControllerCameraDeviceFront;
        }

    } else {
        return NO;
    }

    cameraUI.allowsEditing = YES;
    cameraUI.showsCameraControls = YES;
    cameraUI.delegate = self;

    [self presentViewController:cameraUI animated:YES completion:nil];

    return YES;

}

-(BOOL)shouldStartPhotoLibraryPickerController {
    //No phto library and no albums? You have no business here bud.
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO && [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeSavedPhotosAlbum == NO])){
        return NO;
    }

    UIImagePickerController *cameraUI = [[UIImagePickerController alloc]init];

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary]containsObject:(NSString*)kUTTypeImage]){

        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
        cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){

        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
        cameraUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    } else {
        return NO;
    }

    cameraUI.allowsEditing;
    cameraUI.delegate = self;

    [self presentViewController:cameraUI animated:YES completion:nil];

    return YES;

}

-(void)cameraButtonAction

-(BOOL)shouldStartVideoController

-(BOOL)shouldStartVideoLibraryController






-(void)handleGesture:(UIGestureRecognizer *)gestureRecognizer {
    [self shouldPresentPhotoCaptureController];
}



@end
