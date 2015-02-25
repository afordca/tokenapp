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
    NSMutableArray *arrayOfUserActivity;
    NSMutableArray *arrayOfFollowers;

}

@property (nonatomic, strong) UIImage *profileImage;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSMutableArray *arrayOfPhotos;
@property (nonatomic,strong) NSMutableArray *arrayOfUserActivity;
@property (nonatomic,strong) NSMutableArray *arrayOfFollowers;

// This is the method to access this Singleton class
+ (User *)sharedSingleton;

-(void)loadPhotos;

@end