//
//  PhotoTableViewController.m
//  Token
//
//  Created by Dave on 11/1/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import "PhotoTableViewController.h"
#import "CommentTableViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface PhotoTableViewController ()

@end

@implementation PhotoTableViewController
@synthesize postedPhoto, navTitle;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        postedPhoto = [[UIImage alloc] init];
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:navTitle];
    self.navigationController.navigationBar.topItem.title = @"";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    postedPhotoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height * 0.55)];
    tokenLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 7, 60, 16)];
    tokenLabel.text = @"Token#";
    
    likesLabel = [[UILabel alloc] initWithFrame:CGRectMake(71, 7, 60, 16)];
    likesLabel.text = @"Likes#";
    
    descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, 100, 18)];
    descriptionLabel.text = @"Description";
    
    hashtagesLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 100, 18)];
    hashtagesLabel.text = @"#Hashtages";
    
    userNameCommentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 55, 175, 18)];
    userNameCommentLabel.text = @"Username: Comment";
    
    commentButton = [[UIButton alloc] initWithFrame:CGRectMake(125, 5, 70, 20)];
    commentButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
    [commentButton setTitleColor:[UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0] forState:UIControlStateNormal];
    
    commentButton.layer.borderWidth = 1.0;
    commentButton.layer.cornerRadius = 2.0;
    commentButton.layer.borderColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0].CGColor;
    
    [commentButton setTitle:@"COMMENT" forState:UIControlStateNormal];
    [commentButton addTarget:self action:@selector(presentCommentView) forControlEvents:UIControlEventTouchDown];
    
    
    likeButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 5, 50, 20)];
    likeButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
    [likeButton setTitleColor:[UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0] forState:UIControlStateNormal];
    
    likeButton.layer.borderWidth = 1.0;
    likeButton.layer.cornerRadius = 2.0;
    likeButton.layer.borderColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0].CGColor;
    
    [likeButton setTitle:@"LIKE" forState:UIControlStateNormal];
    
   shareButton = [[UIButton alloc] initWithFrame:CGRectMake(255, 5, 50, 20)];
    shareButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
    [shareButton setTitleColor:[UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0] forState:UIControlStateNormal];
    
    shareButton.layer.borderWidth = 1.0;
    shareButton.layer.cornerRadius = 2.0;
    shareButton.layer.borderColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0].CGColor;
    
    [shareButton setTitle:@"SHARE" forState:UIControlStateNormal];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [postedPhotoView setImage:postedPhoto];
}

- (void)presentCommentView
{
    CommentTableViewController *commentVC = [[CommentTableViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:commentVC];
    // TintColor colors the text of UINavigation items
    // [[navController navigationBar] setTintColor:[UIColor colorWithRed:0.0 green:0.80392 blue:0.58823 alpha:1.0]];
    // BarTintColor colors the actual UINavigation bar
    // [[navController navigationBar] setBarTintColor:[UIColor whiteColor]];
    // [[navController navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
    
    [self presentViewController:navController animated:YES completion:nil];
    // [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.row==0) {
        [cell addSubview:postedPhotoView];
    }
    
    if (indexPath.row==2) {
        [cell addSubview:tokenLabel];
        [cell addSubview:likesLabel];
        [cell addSubview:commentButton];
        [cell addSubview:likeButton];
        [cell addSubview:shareButton];
        [cell addSubview:descriptionLabel];
        [cell addSubview:hashtagesLabel];
        [cell addSubview:userNameCommentLabel];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        return self.view.frame.size.height * 0.55;
    }
    
    else if (indexPath.row==1)
    {
        return 60;
    }
    
    else {
        return 140;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
