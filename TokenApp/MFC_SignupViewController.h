//
//  MFC_SignupViewController.h
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/2/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface MFC_SignupViewController : UIViewController <UINavigationControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate>


{
    User *singleUser;
}


@end