//
//  TK_DescriptionViewController.h
//  
//
//  Created by Emmanuel Masangcay on 2/4/15.
//
//

#import <UIKit/UIKit.h>
#import "Macros.h"
#import "ParseUI.h"
#import "Constants.h"

@interface TK_DescriptionViewController : UIViewController

- (id)initWithImage:(UIImage *)aImage;
@property (nonatomic,strong) PFObject *photo;
@property UIImage *image;

@end
