//
//  MFC_SignupViewController.h
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/2/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrentUser.h"

@interface MFC_SignupViewController : UIViewController <UINavigationControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    CurrentUser *singleUser;
}


@end
