//
//  ProfileViewController.m
//  TokenApp
//
//  Created by Basel Farag on 12/3/14.
//  Copyright (c) 2014 ABaselNotBasilProduction. All rights reserved.
//

#import "ProfilePersonalViewController.h"
#import "Macros.h"

@interface ProfilePersonalViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIButton *addFollowerButton;
@property (weak, nonatomic) IBOutlet UIButton *Tokens;

@end

@implementation ProfilePersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getPhotoFromParse
{
    //Remember to define '6' as numofphotoallowed at top
    for (int i = 0; i< kNoOfPhotoAllow; i++) {
        PFFile *file = [self.shoe objectForKey:[NSString stringWithFormat:@"Photo%d",i]];
        if (file) {
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:data];
                    [self.shoePhotos addObject:image];
                    self.pageControl.numberOfPages =  self.shoePhotos.count;

                    [self.collectionView reloadData];
                }
            }];
        } else {
            break;
        }
    }

}



 

@end
