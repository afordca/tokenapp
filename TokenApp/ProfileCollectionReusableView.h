//
//  ProfileCollectionReusableView.h
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/20/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import "User.h"

@protocol CustomProfileDelegate <NSObject>

-(void)tapOnCamera;
-(void)tapOnLibrary;
-(void)presentActivityView;
-(void)presentFollowersView;

@end

@interface ProfileCollectionReusableView : UICollectionReusableView <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
    User *currentUser;
}


@property id<CustomProfileDelegate>delegate;

@property ProfileCollectionReusableView *profileCollectionView;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewProfilePic;

@property UIImagePickerController *imagePickerProfile;




@end
