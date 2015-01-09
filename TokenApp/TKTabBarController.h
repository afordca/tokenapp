//
//  TKTabBarController.h
//  TokenApp
//
//  Created by BASEL FARAG on 1/8/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EditPhotoViewController.h"



@interface TKTabBarController : UITabBarController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

-(BOOL)shouldPresentPhotoCaptureController;

@end

@protocol TKTabBarControllerDelegate <NSObject>

-(void)tabBarController:(UITabBarController *)tabBarController cameraButtonTouchUpInside:(UIButton*)button;

@end
