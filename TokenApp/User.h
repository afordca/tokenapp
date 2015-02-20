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
    NSMutableArray *arrayOfPhotos;

}

@property (nonatomic, strong) UIImage *profileImage;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSMutableArray *arrayOfPhotos;

// This is the method to access this Singleton class
+ (User *)sharedSingleton;

-(void)loadPhotos;

@end