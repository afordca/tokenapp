//
//  TKContentDetailFooter.h
//  TokenApp
//
//  Created by BASEL FARAG on 4/14/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  "Parse.h"

@protocol TKContentDetailFooterViewDelegate;

@interface TKContentDetailFooter : UIView

@property (nonatomic, strong, readonly) PFObject *photo;

@property (nonatomic, strong) NSArray *likeUsers;

//Heart-shaped like button
@property (nonatomic, strong, readonly) UIButton *likeButton;

@property (nonatomic, strong, readonly) UIButton *commentButton;

@property (nonatomic, strong, readonly) UIButton *shareButton;

@property (nonatomic, strong, readonly) UIButton *tokenButton;

@property (nonatomic, strong) UITextField *commentField;

@property (nonatomic, strong) id<TKContentDetailFooterViewDelegate>delegate;

+ (CGRect)rectForView;

- (void)setLikeButtonState:(BOOL)selected;
- (void)reloadLikeBar;
@end

/*!

*!
 Protocol defines a methods a delegate of TKContentDetailFooterView should implement
 */

@protocol TKContentDetailFooterViewDelegate <NSObject>
@optional
-(void)didTapLikePhotoButtonAction:(UIButton *)button;
//
//
@end
