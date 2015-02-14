//
//  EditPhotoViewController.h
//  TokenApp
//
//  Created by BASEL FARAG on 12/16/14.
//  Copyright (c) 2014 ABaselNotBasilProduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macros.h"
#import "ParseUI.h"
#import "Constants.h"

@interface EditPhotoViewController : NSObject

+(id)initWithImage:(UIImage *)aImage;
@property (nonatomic,strong) PFObject *photo;



@end
