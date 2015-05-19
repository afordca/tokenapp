//
//  ContentWebViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 5/19/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "ContentWebViewController.h"

@interface ContentWebViewController () <UIWebViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,UIScrollViewDelegate>

@property IBOutlet UIWebView *myWebView;

@property CGFloat currentPosition;

@end

@implementation ContentWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myWebView.scrollView.delegate = self;
    [self checkingURL];
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

//    self.myURLTextField.text = [webView.request.URL absoluteString];

//    self.navigationBar.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];

}

-(void)webViewDidStartLoad:(UIWebView *)webView{

    NSLog(@"Started Loading");
}

@end
