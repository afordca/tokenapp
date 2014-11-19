//
//  DiscoverTableViewController.m
//  Token
//
//  Created by Dave on 10/28/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import "DiscoverTableViewController.h"
#import "DiscoverSectionsTableViewController.h"
#import "BSKeyboardControls.h"

@interface DiscoverTableViewController ()

@end

@implementation DiscoverTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    [self.navigationItem setTitle:@"DISCOVER"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0]}];
    
    // Each macro is essentially a repeat at this point
    
    if (IS_IPHONE_6_DEVICE) {
        searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width - 15, 55)];
        searchTextField.delegate = self;
        searchTextField.placeholder = @"SEARCH FOR USERNAME OR #HASHTAG";
        searchTextField.textAlignment = NSTextAlignmentCenter;
        searchTextField.font = [UIFont fontWithName:@"Helvetica" size:13];
        [searchTextField setReturnKeyType:UIReturnKeySearch];
        
        popularButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 375, 75)];
        [popularButton setBackgroundImage:[UIImage imageNamed:@"Popular"] forState:UIControlStateNormal];
        [popularButton setTitle:@"Popular" forState:UIControlStateNormal];
        [popularButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        trendingButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 375, 75)];
        [trendingButton setBackgroundImage:[UIImage imageNamed:@"Trending"] forState:UIControlStateNormal];
        [trendingButton setTitle:@"Trending" forState:UIControlStateNormal];
        [trendingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        exploreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 375, 75)];
        [exploreButton setBackgroundImage:[UIImage imageNamed:@"Explore"] forState:UIControlStateNormal];
        [exploreButton setTitle:@"Explore" forState:UIControlStateNormal];
        [exploreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        newsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2 - 2.5, 100)];
        [newsButton setBackgroundImage:[UIImage imageNamed:@"News"] forState:UIControlStateNormal];
        [newsButton setTitle:@"News" forState:UIControlStateNormal];
        [newsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        sportsButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 + 2.5, 0, self.view.frame.size.width/2 - 2.5, 100)];
        [sportsButton setBackgroundImage:[UIImage imageNamed:@"Sports"] forState:UIControlStateNormal];
        [sportsButton setTitle:@"Sports" forState:UIControlStateNormal];
        [sportsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        technologyButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2 - 2.5, 100)];
        [technologyButton setBackgroundImage:[UIImage imageNamed:@"Technology"] forState:UIControlStateNormal];
        [technologyButton setTitle:@"Technology" forState:UIControlStateNormal];
        [technologyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        businessButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 + 2.5, 0, self.view.frame.size.width/2 - 2.5, 100)];
        [businessButton setBackgroundImage:[UIImage imageNamed:@"Business"] forState:UIControlStateNormal];
        [businessButton setTitle:@"Business" forState:UIControlStateNormal];
        [businessButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    if (IS_IPHONE_5_DEVICE) {
        searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width - 15, 55)];
        searchTextField.delegate = self;
        searchTextField.placeholder = @"SEARCH FOR USERNAME OR #HASHTAG";
        searchTextField.textAlignment = NSTextAlignmentCenter;
        searchTextField.font = [UIFont fontWithName:@"Helvetica" size:13];
        [searchTextField setReturnKeyType:UIReturnKeySearch];
        
        popularButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 75)];
        [popularButton setBackgroundImage:[UIImage imageNamed:@"Popular"] forState:UIControlStateNormal];
        [popularButton setTitle:@"Popular" forState:UIControlStateNormal];
        [popularButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        trendingButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 75)];
        [trendingButton setBackgroundImage:[UIImage imageNamed:@"Trending"] forState:UIControlStateNormal];
        [trendingButton setTitle:@"Trending" forState:UIControlStateNormal];
        [trendingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        exploreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 75)];
        [exploreButton setBackgroundImage:[UIImage imageNamed:@"Explore"] forState:UIControlStateNormal];
        [exploreButton setTitle:@"Explore" forState:UIControlStateNormal];
        [exploreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        //CGRectMake(0, 3, self.view.frame.size.width/2 - 2.5, self.view.frame.size.width/2 - 2.5)];
        //[uploadedImageView02 setImage:[UIImage imageNamed:@"ProfileImages_02"]
        
        newsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2 - 2.5, 100)];
        [newsButton setBackgroundImage:[UIImage imageNamed:@"News"] forState:UIControlStateNormal];
        [newsButton setTitle:@"News" forState:UIControlStateNormal];
        [newsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        sportsButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 + 2.5, 0, self.view.frame.size.width/2 - 2.5, 100)];
        [sportsButton setBackgroundImage:[UIImage imageNamed:@"Sports"] forState:UIControlStateNormal];
        [sportsButton setTitle:@"Sports" forState:UIControlStateNormal];
        [sportsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        technologyButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2 - 2.5, 100)];
        [technologyButton setBackgroundImage:[UIImage imageNamed:@"Technology"] forState:UIControlStateNormal];
        [technologyButton setTitle:@"Technology" forState:UIControlStateNormal];
        [technologyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        businessButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 + 2.5, 0, self.view.frame.size.width/2 - 2.5, 100)];
        [businessButton setBackgroundImage:[UIImage imageNamed:@"Business"] forState:UIControlStateNormal];
        [businessButton setTitle:@"Business" forState:UIControlStateNormal];
        [businessButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    if (IS_IPHONE_4S_DEVICE) {
        searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width - 15, 55)];
        searchTextField.delegate = self;
        searchTextField.placeholder = @"SEARCH FOR USERNAME OR #HASHTAG";
        searchTextField.textAlignment = NSTextAlignmentCenter;
        searchTextField.font = [UIFont fontWithName:@"Helvetica" size:13];
        [searchTextField setReturnKeyType:UIReturnKeySearch];
        
        popularButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 75)];
        [popularButton setBackgroundImage:[UIImage imageNamed:@"Popular"] forState:UIControlStateNormal];
        [popularButton setTitle:@"Popular" forState:UIControlStateNormal];
        [popularButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        trendingButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 75)];
        [trendingButton setBackgroundImage:[UIImage imageNamed:@"Trending"] forState:UIControlStateNormal];
        [trendingButton setTitle:@"Trending" forState:UIControlStateNormal];
        [trendingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        exploreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 75)];
        [exploreButton setBackgroundImage:[UIImage imageNamed:@"Explore"] forState:UIControlStateNormal];
        [exploreButton setTitle:@"Explore" forState:UIControlStateNormal];
        [exploreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        newsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2 - 2.5, 100)];
        [newsButton setBackgroundImage:[UIImage imageNamed:@"News"] forState:UIControlStateNormal];
        [newsButton setTitle:@"News" forState:UIControlStateNormal];
        [newsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        sportsButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 + 2.5, 0, self.view.frame.size.width/2 - 2.5, 100)];
        [sportsButton setBackgroundImage:[UIImage imageNamed:@"Sports"] forState:UIControlStateNormal];
        [sportsButton setTitle:@"Sports" forState:UIControlStateNormal];
        [sportsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        technologyButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2 - 2.5, 100)];
        [technologyButton setBackgroundImage:[UIImage imageNamed:@"Technology"] forState:UIControlStateNormal];
        [technologyButton setTitle:@"Technology" forState:UIControlStateNormal];
        [technologyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        businessButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 + 2.5, 0, self.view.frame.size.width/2 - 2.5, 100)];
        [businessButton setBackgroundImage:[UIImage imageNamed:@"Business"] forState:UIControlStateNormal];
        [businessButton setTitle:@"Business" forState:UIControlStateNormal];
        [businessButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    [popularButton addTarget:self action:@selector(popularButtonTouched) forControlEvents:UIControlEventTouchDown];
    [trendingButton addTarget:self action:@selector(trendingButtonTouched) forControlEvents:UIControlEventTouchDown];
    [exploreButton addTarget:self action:@selector(exploreButtonTouched) forControlEvents:UIControlEventTouchDown];
    
    keyboardControls = [[BSKeyboardControls alloc] initWithFields:@[searchTextField]];
    [keyboardControls setDelegate:self];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)_keyboardControls
{
    [searchTextField resignFirstResponder];
}

- (void)popularButtonTouched
{
    DiscoverSectionsTableViewController *discoverSecTVC = [[DiscoverSectionsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *discoverNav = [[UINavigationController alloc] initWithRootViewController:discoverSecTVC];
    [discoverSecTVC setTitle:@"Popular"];
    [self.navigationController presentViewController:discoverNav animated:YES completion:nil];
}
- (void)trendingButtonTouched
{
    DiscoverSectionsTableViewController *discoverSecTVC = [[DiscoverSectionsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *discoverNav = [[UINavigationController alloc] initWithRootViewController:discoverSecTVC];
    [discoverSecTVC setTitle:@"Trending"];
    [self.navigationController presentViewController:discoverNav animated:YES completion:nil];
}

- (void)exploreButtonTouched
{
    DiscoverSectionsTableViewController *discoverSecTVC = [[DiscoverSectionsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *discoverNav = [[UINavigationController alloc] initWithRootViewController:discoverSecTVC];
    [discoverSecTVC setTitle:@"Explore"];
    [self.navigationController presentViewController:discoverNav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (!textField.text.length>0) {
        [textField resignFirstResponder];
        return YES;
    }
   
  
    NSString *string = [[NSString alloc] init];
    string = [textField.text substringToIndex:1];
    
    if ([string isEqual:@" "]) {
        [textField setText:@""];
        [textField resignFirstResponder];
        YES;
    }
    
    if ([string isEqual:@"#"]) {
        DiscoverSectionsTableViewController *discoverSecTVC = [[DiscoverSectionsTableViewController alloc] initWithStyle:UITableViewStylePlain];
        UINavigationController *discoverNav = [[UINavigationController alloc] initWithRootViewController:discoverSecTVC];
        [discoverSecTVC setTitle:textField.text];
        [textField resignFirstResponder];
        [self.navigationController presentViewController:discoverNav animated:YES completion:nil];
        [textField setText:@""];
    } else {
        DiscoverSectionsTableViewController *discoverSecTVC = [[DiscoverSectionsTableViewController alloc] initWithStyle:UITableViewStylePlain];
        UINavigationController *discoverNav = [[UINavigationController alloc] initWithRootViewController:discoverSecTVC];
        [discoverSecTVC setTitle:textField.text];
        [textField resignFirstResponder];
        [self.navigationController presentViewController:discoverNav animated:YES completion:nil];
        [textField setText:@""];
    }
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.section== 0 && indexPath.row==0)  {
        [cell addSubview:searchTextField];
        return cell;
    }
    
    else if (indexPath.section==1 && indexPath.row==0) {
        [cell addSubview:popularButton];
        return cell;
    }
    
    else if (indexPath.section==2 && indexPath.row==0) {
        [cell addSubview:trendingButton];
        return cell;
    }
    
    else if (indexPath.section==3 && indexPath.row==0) {
        [cell addSubview:exploreButton];
        return cell;
    }
    
    else if (indexPath.section==4 && indexPath.row==0) {
        [cell addSubview:newsButton];
        [cell addSubview:sportsButton];
        return cell;
    }
    
    else if (indexPath.section==5 && indexPath.row==0) {
        [cell addSubview:technologyButton];
        [cell addSubview:businessButton];
        return cell;
    }
    
    else  {
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section <= 3) {
        return 75;
    } else {
        return 100;
    }
   
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    } else if (section==4) {
        return 20;
    } else {
        return 10;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Section clicked was :%ldl", (long)indexPath.section);
    if (indexPath.section==1) {
        
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
