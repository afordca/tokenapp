//
//  ContentWebViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 5/19/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "ContentWebViewController.h"
#import "CurrentUser.h"
#import <Parse/Parse.h>

@interface ContentWebViewController () <UIWebViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,UIScrollViewDelegate>

@property IBOutlet UIWebView *myWebView;
@property (strong, nonatomic) IBOutlet UILabel *labelLinkTitle;

@property CGFloat currentPosition;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewLike;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewComment;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewShare;

@property (strong, nonatomic) IBOutlet UILabel *labelNumberOfTokens;

@property (strong, nonatomic) IBOutlet UILabel *labelNumberOfLikes;

@property (strong, nonatomic) IBOutlet UILabel *labelContentDescription;

@property (strong, nonatomic) IBOutlet UILabel *labelComment1;


@property PFUser *currentUser;
@property CurrentUser *singleUser;

@property NSInteger likes;
@property BOOL liked;
@end

@implementation ContentWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentUser = [PFUser currentUser];
    self.singleUser = [CurrentUser sharedSingleton];
    self.myWebView.scrollView.delegate = self;
    self.myWebView.delegate = self;

    [self checkingURL];

    NSString *contentID = self.linkContent.linkID;

    self.labelContentDescription.text = self.linkContent.linkDescription;
    self.labelLinkTitle.text = self.linkContent.linkTitle;

    //Check if User likes content already
    UITapGestureRecognizer *tapGestureRecognizerLike = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTapped:)];

    [self checkUserLike:@"Link" contentID:contentID completion:^(BOOL result)
     {
         if (self.liked)
         {
             self.imageViewLike.image = [UIImage imageNamed:@"LikeFill"];
             [self.imageViewLike removeGestureRecognizer:tapGestureRecognizerLike];
             self.imageViewLike.userInteractionEnabled = NO;

         }
         else
         {
             tapGestureRecognizerLike.numberOfTapsRequired = 1;
             [self.imageViewLike addGestureRecognizer:tapGestureRecognizerLike];
             self.imageViewLike.userInteractionEnabled = YES;
         }

     }];

}

#pragma mark - Scroll Delegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{


    //Top Scroll
    if (scrollView.contentOffset.y < self.currentPosition) {


    }
    //Bottom Scroll
    else if (scrollView.contentOffset.y > self.currentPosition) {


    }
    //Setting the current position of the WebView scroll
    self.currentPosition = scrollView.contentOffset.y;

}

#pragma mark - Helper Methods

- (IBAction)buttonCancel:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


// This method checks for valid URL prefix
-(void)checkingURL{

    if ([self.stringWebURL hasPrefix:@"http://"])
    {
        NSURL *url = [NSURL URLWithString:self.stringWebURL];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        [self.myWebView loadRequest:urlRequest];
    }

    else{

        NSString * urlString = [NSString stringWithFormat:@"http://www.%@",self.stringWebURL];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        [self.myWebView loadRequest:urlRequest];

    }

}

#pragma mark - WebView Loading


-(void)webViewDidFinishLoad:(UIWebView *)webView{

    NSLog(@"Done loading");
}

-(void)webViewDidStartLoad:(UIWebView *)webView{

    NSLog(@"Started Loading");
}

#pragma mark - UITapGesture Methods

-(void)likeTapped:(UITapGestureRecognizer*)sender
{
    NSLog(@"Like Tapped");

    NSString *className = @"Link";
    NSString *contentID = self.linkContent.linkID;;
    NSString *contentType = @"link";


    PFQuery *queryContent = [PFQuery queryWithClassName:className];
    [queryContent whereKey:@"objectId" equalTo:contentID];

    PFObject *updatedContent = [queryContent getFirstObject];
    [updatedContent incrementKey:@"numberOfLikes" byAmount:[NSNumber numberWithInt:1]];

    PFRelation *relation = [updatedContent relationForKey:@"Likers"];
    [relation addObject:self.currentUser];

    [updatedContent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         NSLog( @"Content Updated");

         PFObject *activity = [PFObject objectWithClassName:@"Activity"];


         [activity setObject:@"like" forKey:@"type"];
         [activity setObject:contentType forKey:@"mediaType"];
         [activity setObject:self.currentUser forKey:@"fromUser"];
         [activity setObject:updatedContent forKey:contentType];
         [activity setObject:self.currentUser.objectId forKey:@"fromUserID"];
         [activity setValue:self.currentUser.username forKey:@"username"];

         [activity saveInBackgroundWithBlock:^(BOOL success, NSError* error)
          {
              if (error) {
                  NSLog(@"%@",[error userInfo]);
              }
              else
              {
                  NSLog(@"Like Activity Saved");
                  self.likes = self.likes + 1;
              }
          }];

     }];
}

#pragma mark - Helper Methods

-(void)checkUserLike:(NSString*)type contentID:(NSString*)contentID completion:(void (^)(BOOL))completionHandler
{
    PFQuery *queryPhoto = [PFQuery queryWithClassName:type];
    [queryPhoto whereKey:@"objectId" equalTo:contentID];

    // Using PFQuery
    [queryPhoto whereKey:@"Likers" equalTo:[PFObject objectWithoutDataWithClassName:@"User" objectId:self.currentUser.objectId]];

    //[queryPhoto whereKey:@"Likers" equalTo:self.currentUser];
    [queryPhoto findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error) {
             NSLog(@"%@",[error userInfo]);
         }
         else
         {
             if (!objects.count==0)
             {
                 self.liked = YES;
                 completionHandler(YES);
             }
             else
             {
                 self.liked = NO;
                 completionHandler(YES);
             }
         }
         
         
     }];
    
}


@end
