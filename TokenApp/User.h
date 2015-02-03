//
//  User.h
//  
//
//  Created by BASEL FARAG on 2/3/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface User : NSObject
{
    UIImage *profileImage;
    NSString *userName;

}

@property (nonatomic, strong) UIImage *profileImage;
@property (nonatomic,strong) NSString *userName;

// This is the method to access this Singleton class
+ (User *)sharedSingleton;

@end