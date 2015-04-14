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
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <FacebookSDK/FacebookSDK.h>
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

            


//             NSLog(@"Twitter signed in as -> name = %@ id = %@ ", [session userName],[session userID]);
//
//             /* Get user info */
//             [[[Twitter sharedInstance] APIClient] loadUserWithID:[session userID]
//                                                       completion:^(TWTRUser *user,
//                                                                    NSError *error)
//              {
//                  // handle the response or error
//                  if (![error isEqual:nil])
//                  {
//
//                      
//
////                      NSLog(@"Twitter info   -> user = %@ ",user);
////
////                      self.twitterUser = [PFUser objectWithClassName:@"User"];
////
////                      NSURL *url = [NSURL URLWithString:user.profileImageURL];
////                      NSData *dataForImage = [NSData dataWithContentsOfURL:url];
////                      PFFile *imageFile = [PFFile fileWithName:@"image.png" data:dataForImage];
////                      [self.twitterUser setObject:user.name forKey:@"username"];
////                      [self.twitterUser setObject:imageFile forKey:@"profileImage"];
////                      [self.twitterUser setObject:user.userID forKey:@"twitterID"];
////                      [self.twitterUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
////                      {
////                          if (error)
////                          {
////                              NSLog(@"Error: %@",[error userInfo]);
////                          }
////                          else
////                          {
////                          self.twitterUser = [PFUser currentUser];
////                          [self performSegueWithIdentifier:@"pushToFeedFromFBTwitter" sender:self ];
////                          }
////                      }];
//
//
//
//                  }
//                  else
//                  {
//                      NSLog(@"Twitter error getting profile : %@", [error localizedDescription]);
//                  }
//
//
              }];
//
//
//
         }
        }];
//
    }
}

- (IBAction)faceBookLogin:(id)sender
{
    NSURL *url = [NSURL URLWithString:VALIDURL];


    if (![self isValidURL:url]) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"Your network connection is weak, wait until you have a better internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        [PFFacebookUtils logInWithPermissions:self.permissions block:^(PFUser *user, NSError *error) {
            if (!user) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else if (user.isNew) {
                NSLog(@"User signed up and logged in through Facebook!");
                // Here we'll create the user with all the stuff.

                [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    if (!error) {
                        // I save the ID because it's unique in terms of our app, if you save the name or last name, it's not.

                        NSLog(@"%@",result);
                        user.username = [result objectForKey:@"name"];
                        user.email = [result objectForKey:@"email"];


                        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                        [currentInstallation setObject:user forKey:@"user"];
                        [currentInstallation saveInBackground];

                        NSString *stringWithFacebookURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [result objectForKey:@"id"]];
                        NSURL *url = [NSURL URLWithString:stringWithFacebookURL];
                        NSData *dataForImage = [NSData dataWithContentsOfURL:url];
                        PFFile *imageFile = [PFFile fileWithName:@"profile.png" data:dataForImage];
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
            } else {
                NSLog(@"User logged in through Facebook!");
                [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    if (!error) {
                        // I save the ID because it's unique in terms of our app, if you save the name or last name, it's not.

                        NSLog(@"%@",result);
                        user.username = [result objectForKey:@"name"];
                        user.email = [result objectForKey:@"email"];

                        NSString *stringWithFacebookURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [result objectForKey:@"id"]];
                        NSURL *url = [NSURL URLWithString:stringWithFacebookURL];
                        NSData *dataForImage = [NSData dataWithContentsOfURL:url];
                        PFFile *imageFile = [PFFile fileWithName:@"profile.png" data:dataForImage];
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
