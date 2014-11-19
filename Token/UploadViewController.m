//
//  UploadViewController.m
//  Token
//
//  Created by Dave on 10/28/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import "UploadViewController.h"
#import "CreatePostTableViewController.h"
#import "CreateLinkTableViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface UploadViewController ()

@end

@implementation UploadViewController
@synthesize photoButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0]];
    
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [titleView setImage:[UIImage imageNamed:@"MarkNav"]];
    [self.navigationItem setTitleView:titleView];
    
    photoButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height/2 - 100, 80, 80)];
    NSLog(@"self.view.frame.size.width returns %f", self.view.frame.size.width);
    
    [photoButton setTitle:@"" forState:UIControlStateNormal];
    [photoButton setBackgroundImage:[UIImage imageNamed:@"Photo"] forState:UIControlStateNormal];
    
    videoButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 + 20, [UIScreen mainScreen].bounds.size.height/2 - 100, 80, 80)];
    [videoButton setTitle:@"" forState:UIControlStateNormal];
    [videoButton setBackgroundImage:[UIImage imageNamed:@"Video"] forState:UIControlStateNormal];
    
    composeButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height/2, 80, 80)];
    [composeButton setTitle:@"" forState:UIControlStateNormal];
    [composeButton setBackgroundImage:[UIImage imageNamed:@"Write"] forState:UIControlStateNormal];
    
    
    linkButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 + 20, [UIScreen mainScreen].bounds.size.height/2, 80, 80)];
    [linkButton setTitle:@"" forState:UIControlStateNormal];
    [linkButton setBackgroundImage:[UIImage imageNamed:@"Link"] forState:UIControlStateNormal];
    
    [photoButton addTarget:self action:@selector(selectPhotoFromLibrary) forControlEvents:UIControlEventTouchDown];
    [videoButton addTarget:self action:@selector(selectVideoFromLibrary) forControlEvents:UIControlEventTouchDown];
    [composeButton addTarget:self action:@selector(presentPostView) forControlEvents:UIControlEventTouchDown];
    [linkButton addTarget:self action:@selector(presentLinkView) forControlEvents:UIControlEventTouchDown];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:photoButton];
    [self.view addSubview:videoButton];
    [self.view addSubview:composeButton];
    [self.view addSubview:linkButton];
    
}

- (void)selectPhotoFromLibrary
{
    NSLog(@"This is your library being brought up.");
    UIImagePickerController *imagePicker;
    imagePicker = [[UIImagePickerController alloc] init];
    [[imagePicker navigationBar] setBarTintColor:[UIColor whiteColor]];
    [[imagePicker navigationBar] setTintColor:[UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0]];
    [[imagePicker navigationBar] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)selectVideoFromLibrary
{
    UIImagePickerController *imagePicker;
    imagePicker = [[UIImagePickerController alloc] init];
    [[imagePicker navigationBar] setBarTintColor:[UIColor whiteColor]];
    [[imagePicker navigationBar] setTintColor:[UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0]];
    [[imagePicker navigationBar] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        [imagePicker setMediaTypes:[[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil]];
    }
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)presentPostView
{
    CreatePostTableViewController *postVC = [[CreatePostTableViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:postVC];
    // TintColor colors the text of UINavigation items
    // [[navController navigationBar] setTintColor:[UIColor colorWithRed:0.0 green:0.80392 blue:0.58823 alpha:1.0]];
    // BarTintColor colors the actual UINavigation bar
    // [[navController navigationBar] setBarTintColor:[UIColor whiteColor]];
    // [[navController navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
    
    [self presentViewController:navController animated:YES completion:nil];
    // [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
}

- (void)presentLinkView
{
    CreateLinkTableViewController *postVC = [[CreateLinkTableViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:postVC];
    // TintColor colors the text of UINavigation items
    // [[navController navigationBar] setTintColor:[UIColor colorWithRed:0.0 green:0.80392 blue:0.58823 alpha:1.0]];
    // BarTintColor colors the actual UINavigation bar
    // [[navController navigationBar] setBarTintColor:[UIColor whiteColor]];
    // [[navController navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
    
    [self presentViewController:navController animated:YES completion:nil];
    // [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
