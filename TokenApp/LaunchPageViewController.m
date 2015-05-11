//
//  LaunchPageViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/1/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "LaunchPageViewController.h"
#import "UIColor+HEX.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>



#import <TwitterKit/TwitterKit.h>


#define VALIDURL (@"http://www.google.com")

@interface LaunchPageViewController ()

@property (strong, nonatomic) IBOutlet UIButton *buttonLogin;
@property NSArray *permissions;
@property PFUser *twitterUser;


@end

@implementation LaunchPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    currentUser = [CurrentUser sharedSingleton];

    [self.navigationController.navigationBar setHidden:YES];

    self.permissions = @[@"public_profile", @"email"];

    // Setup LoginButton Appearance
    CALayer *layer = self.buttonLogin.layer;
    layer.backgroundColor = [[UIColor clearColor] CGColor];
    layer.borderColor = [[UIColor colorwithHexString:@"#72c74a" alpha:.9]CGColor];
    layer.borderWidth = 1.5f;

//    TWTRLogInButton *logInButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession *session, NSError *error) {
//        // play with Twitter session
//    }];
//    logInButton.center = self.view.center;
//    [self.view addSubview:logInButton];


}


#pragma mark - Login Methods


- (IBAction)twitterLogin:(id)sender
{
    NSURL *url = [NSURL URLWithString:VALIDURL];

    if (![self isValidURL:url])
    {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"Your network connection is weak, wait until you have a better internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
    // Objective-C
    [[Twitter sharedInstance] logInWithCompletion:^
     (TWTRSession *session, NSError *error)
        {
         // play with Twitter session
         if (session)
         {
             
             [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error)
              {
                  if (!user)
                  {
                      NSLog(@"Uh oh. The user cancelled the Twitter login.");
                      return;
                  }
                  else if (user.isNew)
                  {
                      NSLog(@"User signed up and logged in with Twitter!");

                      NSURL *verify = [NSURL URLWithString:@"https://api.twitter.com/1.1/account/verify_credentials.json"];
                      NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:verify];
                      [[PFTwitterUtils twitter] signRequest:request];
                      NSURLResponse *response = nil;
                      NSData *data = [NSURLConnection sendSynchronousRequest:request
                                                           returningResponse:&response
                                                                       error:&error];

                      NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

                      NSLog(@"Result: %@",result);

                      user.username = [result objectForKey:@"screen_name"];

                      NSURL *url = [NSURL URLWithString:[result objectForKey:@"profile_image_url"]];
                      NSData *dataForImage = [NSData dataWithContentsOfURL:url];
                      PFFile *imageFile = [PFFile fileWithName:@"image.png" data:dataForImage];
                      [user setObject:imageFile forKey:@"profileImage"];

                      [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                          if (error) {

                          } else {
                              PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                              [currentInstallation setObject:[PFUser currentUser] forKey: @"userPointer"];
                              [currentInstallation saveEventually:^(BOOL succeeded, NSError *error) {
                                  if (error) { } else {

                                      [self performSegueWithIdentifier:@"pushToFeedFromFBTwitter" sender:self ];                        }
                              }];
                          }
                      }];

                  }
                  else
                  {
                      if (error == nil)
                      {
                          NSURL *verify = [NSURL URLWithString:@"https://api.twitter.com/1.1/account/verify_credentials.json"];
                          NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:verify];
                          [[PFTwitterUtils twitter] signRequest:request];
                          NSURLResponse *response = nil;
                          NSData *data = [NSURLConnection sendSynchronousRequest:request
                                                               returningResponse:&response
                                                                           error:&error];

                          NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

                          NSLog(@"Result: %@",result);

                          user.username = [result objectForKey:@"screen_name"];

                          NSURL *url = [NSURL URLWithString:[result objectForKey:@"profile_image_url"]];
                          NSData *dataForImage = [NSData dataWithContentsOfURL:url];
                          PFFile *imageFile = [PFFile fileWithName:@"image.png" data:dataForImage];
                          [user setObject:imageFile forKey:@"profileImage"];
                          
                          [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                              if (error) {
                                  
                              } else {
                                  PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                                  [currentInstallation setObject:[PFUser currentUser] forKey: @"userPointer"];
                                  [currentInstallation saveEventually:^(BOOL succeeded, NSError *error) {
                                      if (error) { } else {
                                          
                                          [self performSegueWithIdentifier:@"pushToFeedFromFBTwitter" sender:self ];                            }
                                  }];
                              }
                          }];
                          
                      }
                  }
              }];

         }
        }];
    }
}

- (IBAction)faceBookLogin:(id)sender
{
    NSURL *url = [NSURL URLWithString:VALIDURL];


    if (![self isValidURL:url]) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"Your network connection is weak, wait until you have a better internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    } else {


        [PFFacebookUtils logInInBackgroundWithReadPermissions:self.permissions block:^(PFUser *user, NSError *error) {
            if (!user) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else if (user.isNew) {
                NSLog(@"User signed up and logged in through Facebook!");
                // Here we'll create the user with all the stuff.

                FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
                [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                    if (!error) {
                        // result is a dictionary with the user's Facebook data
                        NSDictionary *userData = (NSDictionary *)result;

                        NSString *facebookID = userData[@"id"];
                        NSString *name = userData[@"name"];
//                        NSString *location = userData[@"location"][@"name"];
//                        NSString *gender = userData[@"gender"];
//                        NSString *birthday = userData[@"birthday"];
//                        NSString *relationship = userData[@"relationship_status"];
                        NSString *email = userData[@"email"];

                        user.username = name;
                        user.email = email;
                        [user setObject:facebookID forKey:@"facebookID"];

                        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                        [currentInstallation setObject:user forKey:@"user"];
                        [currentInstallation saveInBackground];

                        // URL should point to https://graph.facebook.com/{facebookId}/picture?type=large&return_ssl_resources=1
                        NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];

                        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];

                        // Run network request asynchronously
                        [NSURLConnection sendAsynchronousRequest:urlRequest
                                                           queue:[NSOperationQueue mainQueue]
                                               completionHandler:
                         ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                             if (connectionError == nil && data != nil) {
                                 // Set the image in the imageView
                                 PFFile *imageFile = [PFFile fileWithName:@"profile.png" data:data];
                                 [user setObject:imageFile forKey:@"profileImage"];

                                 // We use save eventually because, if you don't have internet connection, it's going to save it later.
                                 [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                     if (error) {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oooops!" message:[NSString stringWithFormat:@"There's an error: %@", [error userInfo]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                         [alertView show];
                                     } else {
                                         [self performSegueWithIdentifier:@"pushToFeedFromFBTwitter" sender:nil];
                                     }
                                 }];
                             }
                         }];



                    }
                }];

            } else
            {
                FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
                [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                    if (!error) {
                        // result is a dictionary with the user's Facebook data
                        NSDictionary *userData = (NSDictionary *)result;

                        NSString *facebookID = userData[@"id"];
                        NSString *name = userData[@"name"];
                        //                        NSString *location = userData[@"location"][@"name"];
                        //                        NSString *gender = userData[@"gender"];
                        //                        NSString *birthday = userData[@"birthday"];
                        //                        NSString *relationship = userData[@"relationship_status"];
                        NSString *email = userData[@"email"];

                        user.username = name;
                        user.email = email;
                        [user setObject:facebookID forKey:@"facebookID"];

                        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                        [currentInstallation setObject:user forKey:@"user"];
                        [currentInstallation saveInBackground];

                        // URL should point to https://graph.facebook.com/{facebookId}/picture?type=large&return_ssl_resources=1
                        NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];

                        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];

                        // Run network request asynchronously
                        [NSURLConnection sendAsynchronousRequest:urlRequest
                                                           queue:[NSOperationQueue mainQueue]
                                               completionHandler:
                         ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                             if (connectionError == nil && data != nil) {
                                 // Set the image in the imageView
                                 PFFile *imageFile = [PFFile fileWithName:@"profile.png" data:data];
                                 [user setObject:imageFile forKey:@"profileImage"];

                                 // We use save eventually because, if you don't have internet connection, it's going to save it later.
                                 [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                     if (error) {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oooops!" message:[NSString stringWithFormat:@"There's an error: %@", [error userInfo]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                         [alertView show];
                                     } else {
                                         [self performSegueWithIdentifier:@"pushToFeedFromFBTwitter" sender:nil];
                                     }
                                 }];
                             }
                         }];
                        
                        
                        
                    }
                }];
            }
        }];
    }
}

#pragma mark - Helper Methods

- (BOOL)isValidURL:(NSURL *)url
{
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSHTTPURLResponse *res = nil;
    NSError *err = nil;
    [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
    if (err || res.statusCode == 404) {
        return false;
    }
    else
    {
        return true;
    }
}


#pragma mark - Segue methods

- (IBAction)unwindToLoginViewControllerFromPassword:(UIStoryboardPopoverSegue *)sender { }


@end
