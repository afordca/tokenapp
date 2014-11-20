//
//  MarketplaceClaimTableViewController.m
//  Token
//
//  Created by Dave on 11/5/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import "MarketplaceClaimTableViewController.h"
#import "MarketplaceTableViewCell.h"
#import "BasicFormTableViewCell.h"
#import "MarketplaceConfirmClaimTableViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MarketplaceClaimTableViewController ()

@end

@implementation MarketplaceClaimTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title = @"";
    [self.tableView registerClass:[BasicFormTableViewCell class] forCellReuseIdentifier:@"BasicFormCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MarketplaceTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"MarketplaceCell"];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, -15, 0, 0)];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 200)];
    
    UILabel *footerLabel;
    UIButton *redeemButton;
    UILabel *agreementLabel;
    
    if (IS_IPHONE_6_DEVICE) {
        footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(62.5, 6, 250, 22)];
        footerLabel.text = @"TOTAL TOKENS USED#";
        
        redeemButton = [[UIButton alloc] initWithFrame:CGRectMake(62.5, 38, 250, 34)];
        agreementLabel = [[UILabel alloc] initWithFrame:CGRectMake(62.5, 75, 200, 34)];
    }
    
    if (IS_IPHONE_5_DEVICE || IS_IPHONE_4S_DEVICE) {
        footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 6, 200, 22)];
        footerLabel.text = @"TOTAL TOKENS USED#";
        
        redeemButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 38, 200, 34)];
        agreementLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 75, 200, 34)];
    }
    
    [redeemButton setTitle:@"Redeem" forState:UIControlStateNormal];
    redeemButton.layer.cornerRadius = 2.0;
    redeemButton.layer.borderWidth = 1.0;
    redeemButton.layer.borderColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0].CGColor;
    [redeemButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [redeemButton addTarget:self action:@selector(redeemGiftCard) forControlEvents:UIControlEventTouchDown];
    
    agreementLabel.text = @"By clicking here I agree to the terms and agreements of TOKEN, LLC.";
    agreementLabel.numberOfLines = 2;
    agreementLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    [agreementLabel setTextAlignment:NSTextAlignmentCenter];
    
    footerLabel.font = [UIFont boldSystemFontOfSize:16];
    [footerLabel setTextAlignment:NSTextAlignmentCenter];
    
    [footerView addSubview:footerLabel];
    [footerView addSubview:redeemButton];
    [footerView addSubview:agreementLabel];
    self.tableView.tableFooterView = footerView;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)redeemGiftCard
{
    MarketplaceConfirmClaimTableViewController *marketplaceconfirmclaimTVC = [[MarketplaceConfirmClaimTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:marketplaceconfirmclaimTVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section==0) {
        return 1;
    } else {
        return 6;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        MarketplaceTableViewCell *marketplaceCell = [tableView dequeueReusableCellWithIdentifier:@"MarketplaceCell" forIndexPath:indexPath];
        
        [marketplaceCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if ([self.navigationItem.title isEqual:@"$25 Gift Card"]) {
            [marketplaceCell.giftCardValue setText:@"$25 Gift Card"];
            [marketplaceCell.cardImageView setImage:[UIImage imageNamed:@"Card_25"]];
        }
        
        if ([self.navigationItem.title isEqual:@"$50 Gift Card"]) {
            [marketplaceCell.giftCardValue setText:@"$50 Gift Card"];
            [marketplaceCell.cardImageView setImage:[UIImage imageNamed:@"Card_50"]];
        }
        
        if ([self.navigationItem.title isEqual:@"$100 Gift Card"]) {
            [marketplaceCell.giftCardValue setText:@"$100 Gift Card"];
            [marketplaceCell.cardImageView setImage:[UIImage imageNamed:@"Card_100"]];
        }
        
        [marketplaceCell.redeemPointsRequired removeFromSuperview];
        [marketplaceCell.redeemButton setTitle:@"TOKEN#" forState:UIControlStateNormal];
        return marketplaceCell;
        // [marketplaceCell.redeemButton addTarget:self action:@selector(redeem25ButtonPressed) forControlEvents:UIControlEventTouchDown];
    }
    
    if (indexPath.section==1) {
        BasicFormTableViewCell *basicFormCell = (BasicFormTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"BasicFormCell" forIndexPath:indexPath];
        [basicFormCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if ([[[basicFormCell contentView] subviews] count] > 0) {
            return basicFormCell;
        }
        
        if (indexPath.row==0) {
            UITextField *firstName = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width - 10, 55)];
            [firstName setDelegate:self];
            firstName.placeholder = @"First Name";
               [basicFormCell setLoadedCell:firstName];
            
                return basicFormCell;
        }
        
        if (indexPath.row==1) {
            UITextField *lastName = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width - 10, 55)];
            [lastName setDelegate:self];
            lastName.placeholder = @"Last Name";
                [basicFormCell setLoadedCell:lastName];
                return basicFormCell;
        }
        
        if (indexPath.row==2) {
            UITextField *address = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width - 10, 55)];
            [address setDelegate:self];
            address.placeholder = @"Address";
            [basicFormCell setLoadedCell:address];
            return basicFormCell;
        }
        
        if (indexPath.row==3) {
            UITextField *city = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width - 10, 55)];
            [city setDelegate:self];
            city.placeholder = @"City";
            [basicFormCell setLoadedCell:city];
            return basicFormCell;
        }
        
        if (indexPath.row==4) {
            UITextField *zipcode = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width - 10, 55)];
            [zipcode setDelegate:self];
            zipcode.placeholder = @"Zip Code";
            [basicFormCell setLoadedCell:zipcode];
            return basicFormCell;
        }
        
        if (indexPath.row==5) {
            UITextField *phone = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width - 10, 55)];
            [phone setDelegate:self];
            phone.placeholder = @"Phone";
            [basicFormCell setLoadedCell:phone];
            return basicFormCell;
        }
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 220;
    } else {
        return 55;
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
