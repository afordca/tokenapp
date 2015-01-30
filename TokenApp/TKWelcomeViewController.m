//
//  TKWelcomeViewController.m
//  TokenApp
//
//  Created by BASEL FARAG on 12/24/14.
//  Copyright (c) 2014 ABaselNotBasilProduction. All rights reserved.
//

#import "TKWelcomeViewController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "Macros.h"
#import "LoginViewController.h"
#import "TKUtility.h"
#import "TKCache.h"


@interface TKWelcomeViewController () {
    BOOL _presentedLoginViewController;
    int _facebookResponseCount;
    int _expectedFaceBookResponseCount;
    NSMutableData *_profilePicData;
}

@end

@implementation TKWelcomeViewController


#pragma mark - UIViewController 
-(void)loadView {
    NSLog(@"Loadinghere");
    UIImageView *backgroundImageView = [[UIImageView alloc]initWithFrame:[[UIScreen mainScreen]applicationFrame]];
    [backgroundImageView setImage:[UIImage imageNamed:@"Splash-iphone6plus@3x.png"]];
    NSLog(@"Load image here");
    self.view = backgroundImageView;

    // Creating image view that will hold token logo
    logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(37.5, 140, 300, 76)];
    [logoImageView setImage:[UIImage imageNamed:@"Logo"]];

    // Creating login button
    loginButton = [[UIButton alloc] initWithFrame:CGRectMake(37.5, 585, 300, 40)];

    // Creating sign up button
    signUpButton = [[UIButton alloc] initWithFrame:CGRectMake(37.5, 535, 300, 40)];

    // Setting the button title to SIGN UP
    [signUpButton setTitle:@"SIGN UP" forState:UIControlStateNormal];

    // Setting the button title to LOGIN
    [loginButton setTitle:@"LOGIN" forState:UIControlStateNormal];


    signUpButton.layer.cornerRadius = 2;
    signUpButton.layer.borderWidth = 1;
    signUpButton.layer.borderColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0].CGColor;
    signUpButton.backgroundColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0];

    loginButton.layer.cornerRadius = 2;
    loginButton.layer.borderWidth = 1;
    loginButton.layer.borderColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0].CGColor;
    loginButton.backgroundColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0];


    // Adding Views to launch View Controller
    [self.view addSubview:logoImageView];
    [self.view addSubview:signUpButton];
    [self.view addSubview:loginButton];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (![PFUser currentUser]){
        [self presentLoginViewController:NO];
        return;

    }

    //Present the UI

    [(AppDelegate *)[[UIApplication sharedApplication] delegate] presentTabBarViewController];

    //Refresh the current user with server side data == checks if user is still valid and so on
    _facebookResponseCount = 0;
    [[PFUser currentUser] fetchInBackgroundWithTarget:self selector:@selector(refreshCurrentUserCallbackWithResult:error:)];

    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Default@3x.png"]];

    // Creating image view that will hold mark Image
    // MarkImageView is on hold for time being
    // markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(147.5, 35, 80, 80)];
    // [markImageView setImage:[UIImage imageNamed:@"Mark"]];

    // Creating image view that will hold token logo
    logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(37.5, 140, 300, 76)];
    [logoImageView setImage:[UIImage imageNamed:@"Logo"]];

    // Creating login button
    loginButton = [[UIButton alloc] initWithFrame:CGRectMake(37.5, 585, 300, 40)];

    // Creating sign up button
    signUpButton = [[UIButton alloc] initWithFrame:CGRectMake(37.5, 535, 300, 40)];

    // Setting the button title to SIGN UP
    [signUpButton setTitle:@"SIGN UP" forState:UIControlStateNormal];

    // Setting the button title to LOGIN
    [loginButton setTitle:@"LOGIN" forState:UIControlStateNormal];

}

#pragma mark - TKWelcomeViewController

-(void)presentLoginViewController:(BOOL)animated{
    if (_presentedLoginViewController){
        return;
    }

    _presentedLoginViewController = YES;
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    loginVC.delegate = self;
    [self presentViewController:loginVC animated:animated completion:nil];
}

#pragma mark - LoginViewControllerDelegate

-(void)logInViewControllerDidLogUserIn:(LoginViewController *)logInViewController {
    if (_presentedLoginViewController){
        _presentedLoginViewController = NO;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - () 

-(void)processedFacebookResponse {
    @synchronized (self) {
        _facebookResponseCount++;
        if (_facebookResponseCount != _expectedFaceBookResponseCount) {
            return;
        }
    }
    _facebookResponseCount = 0;
    NSLog(@"Done processing FB requests");


    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!succeeded) {
            NSLog(@"Failed save in background of user, %@", error);
        } else {
            NSLog(@"saved current parse user");
        }
    }];

}

- (void)refreshCurrentUserCallbackWithResult:(PFObject *)refreshedObject error:(NSError *)error {
    // This fetches the most recent data from FB, and syncs up all data with the server including profile pic and friends list from FB.

    // A kPFErrorObjectNotFound error on currentUser refresh signals a deleted user
    if (error && error.code == kPFErrorObjectNotFound) {
        NSLog(@"User does not exist.");
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] logOut];
        return;
    }

    FBSession *session = [PFFacebookUtils session];
    if (!session.isOpen) {
        NSLog(@"FB Session does not exist, logout");
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] logOut];
        return;
    }

    if (!session.accessTokenData.userID) {
        NSLog(@"userID on FB Session does not exist, logout");
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] logOut];
        return;
    }

    PFUser *currentParseUser = [PFUser currentUser];
    if (!currentParseUser) {
        NSLog(@"Current Parse user does not exist, logout");
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] logOut];
        return;
    }

    NSString *facebookId = [currentParseUser objectForKey:kPTKUserFacebookIDKey];
    if (!facebookId || ![facebookId length]) {
        // set the parse user's FBID
        [currentParseUser setObject:session.accessTokenData.userID forKey:kPTKUserFacebookIDKey];
    }

    if (![TKUtility userHasValidFacebookData:currentParseUser]) {
        NSLog(@"User does not have valid facebook ID. PFUser's FBID: %@, FBSessions FBID: %@. logout", [currentParseUser objectForKey:kPTKUserFacebookIDKey], session.accessTokenData.userID);
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] logOut];
        return;
    }

    // Finished checking for invalid stuff
    // Refresh FB Session (When we link up the FB access token with the parse user, information other than the access token string is dropped
    // By going through a refresh, we populate useful parameters on FBAccessTokenData such as permissions.
    [[PFFacebookUtils session] refreshPermissionsWithCompletionHandler:^(FBSession *session, NSError *error) {
        if (error) {
            NSLog(@"Failed refresh of FB Session, logging out: %@", error);
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] logOut];
            return;
        }
        // refreshed
        NSLog(@"refreshed permissions: %@", session);


        _expectedFaceBookResponseCount = 0;
        NSArray *permissions = [[session accessTokenData] permissions];
        if ([permissions containsObject:@"public_profile"]) {
            // Logged in with FB
            // Create batch request for all the stuff
            FBRequestConnection *connection = [[FBRequestConnection alloc] init];
            _expectedFaceBookResponseCount++;
            [connection addRequest:[FBRequest requestForMe] completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (error) {
                    // Failed to fetch me data.. logout to be safe
                    NSLog(@"couldn't fetch facebook /me data: %@, logout", error);
                    [(AppDelegate *)[[UIApplication sharedApplication] delegate] logOut];
                    return;
                }

                NSString *facebookName = result[@"name"];
                if (facebookName && [facebookName length] != 0) {
                    [currentParseUser setObject:facebookName forKey:kTKUserDisplayNameKey];
                }

                [self processedFacebookResponse];
            }];

            // profile pic request
            _expectedFaceBookResponseCount++;
            [connection addRequest:[FBRequest requestWithGraphPath:@"me" parameters:@{@"fields": @"picture.width(500).height(500)"} HTTPMethod:@"GET"] completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    // result is a dictionary with the user's Facebook data
                    NSDictionary *userData = (NSDictionary *)result;

                    NSURL *profilePictureURL = [NSURL URLWithString: userData[@"picture"][@"data"][@"url"]];

                    // Now add the data to the UI elements
                    NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f]; // Facebook profile picture cache policy: Expires in 2 weeks
                    [NSURLConnection connectionWithRequest:profilePictureURLRequest delegate:self];
                } else {
                    NSLog(@"Error getting profile pic url, setting as default avatar: %@", error);
                    NSData *profilePictureData = UIImagePNGRepresentation([UIImage imageNamed:@"AvatarPlaceholder.png"]);
                    [TKUtility processFacebookProfilePictureData:profilePictureData];
                }
                [self processedFacebookResponse];
            }];
            if ([permissions containsObject:@"user_friends"]) {
                // Fetch FB Friends + me
                _expectedFaceBookResponseCount++;
                [connection addRequest:[FBRequest requestForMyFriends] completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    NSLog(@"processing Facebook friends");
                    if (error) {
                        // just clear the FB friend cache
                        [[TKCache sharedCache] clear];
                    } else {
                        NSArray *data = [result objectForKey:@"data"];
                        NSMutableArray *facebookIds = [[NSMutableArray alloc] initWithCapacity:[data count]];
                        for (NSDictionary *friendData in data) {
                            if (friendData[@"id"]) {
                                [facebookIds addObject:friendData[@"id"]];
                            }
                        }
                        // cache friend data
                        [[TKCache sharedCache] setFacebookFriends:facebookIds];

                        if ([currentParseUser objectForKey:kPTKUserFacebookFriendsKey]) {
                            [currentParseUser removeObjectForKey:kPTKUserFacebookFriendsKey];
                        }
                        if ([currentParseUser objectForKey:kPTKUserAlreadyAutoFollowedFacebookFriendsKey]) {
                            [(AppDelegate *)[[UIApplication sharedApplication] delegate] autoFollowUsers];
                        }
                    }
                    [self processedFacebookResponse];
                }];
            }
            [connection start];

        } else {
            NSData *profilePictureData = UIImagePNGRepresentation([UIImage imageNamed:@"AvatarPlaceholder.png"]);
            [TKUtility processFacebookProfilePictureData:profilePictureData];

            [[TKCache sharedCache] clear];
            [currentParseUser setObject:@"Someone" forKey:kTKUserDisplayNameKey];
            _expectedFaceBookResponseCount++;
            [self processedFacebookResponse];
        }


    }];

}


#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _profilePicData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_profilePicData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [TKUtility processFacebookProfilePictureData:_profilePicData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection error downloading profile pic data: %@", error);
}




@end
