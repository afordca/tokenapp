//
//  DetailedPhotoViewController.h
//  TokenApp
//
//  Created by Emmanuel Masangcay on 4/9/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"
#import "Video.h"

@interface DetailedPhotoVideoViewController : UIViewController

@property (nonatomic,strong)Photo *detailPhoto;
@property (nonatomic,strong)Video *detailVideo;
@property(nonatomic,retain) UITableView *tableView;


@end
