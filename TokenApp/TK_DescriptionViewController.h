//
//  TK_DescriptionViewController.h
//  
//
//  Created by Emmanuel Masangcay on 2/4/15.
//
//

#import <UIKit/UIKit.h>
#import "Macros.h"
#import "Constants.h"

@interface TK_DescriptionViewController : UIViewController

@property UIImage *imagePhoto;
@property NSURL *urlVideo;
@property BOOL isVideo;
@property BOOL isPost;
@property BOOL isLink;

@property NSString *stringPost;
@property NSString *stringLink;

@end
