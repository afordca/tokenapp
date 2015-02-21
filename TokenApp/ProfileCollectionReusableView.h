//
//  ProfileCollectionReusableView.h
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/20/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomProfileHeaderDelegate <NSObject>

-(void)onTapProfilePic;

@end


@interface ProfileCollectionReusableView : UICollectionReusableView<UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageViewProfilePic;


@property id <CustomProfileHeaderDelegate> delegate;




@end
