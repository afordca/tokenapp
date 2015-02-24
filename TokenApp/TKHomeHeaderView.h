//
//  TKHomeHeaderView.h
//  TokenApp
//
//  Created by BASEL FARAG on 2/23/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


typedef enum {
    TKHomeHeaderButtonsNone = 0,
    TKHomeHeaderButtonsUser = 1 << 2,

    TKHomeHeaderButtonsDefault =  TKHomeHeaderButtonsUser
} TKHomeHeaderButtons;

@protocol TKHomeHeaderViewDelegate;

@interface TKHomeHeaderView : UITableViewCell

- (id)initWithFrame:(CGRect)frame buttons:(TKHomeHeaderButtons)otherButtons;

/// The photo associated with this view
@property (nonatomic,strong) PFObject *photo;


@end
