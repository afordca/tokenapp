//
//  TKFindFriendsCell.h
//  TokenApp
//
//  Created by BASEL FARAG on 1/15/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macros.h"

@class TKProfileImageView;
@protocol TKFindFriendsCellDelegate;

@interface TKFindFriendsCell : UITableViewCell{
    id _delegate;
}

@property (nonatomic, strong) id<TKFindFriendsCellDelegate> delegate;

/*! The user represented in the cell */
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) UILabel *photoLabel;
@property (nonatomic, strong) UIButton *followButton;

/*! Setters for the cell's content */
- (void)setUser:(PFUser *)user;

- (void)didTapUserButtonAction:(id)sender;
- (void)didTapFollowButtonAction:(id)sender;

/*! Static Helper methods */
+ (CGFloat)heightForCell;

@end

/*!
 The protocol defines methods a delegate of a TKFindFriendsCell should implement.
 */
@protocol TKFindFriendsCellDelegate <NSObject>
@optional

/*!
 Sent to the delegate when a user button is tapped
 @param aUser the PFUser of the user that was tapped
 */
- (void)cell:(TKFindFriendsCell *)cellView didTapUserButton:(PFUser *)aUser;
- (void)cell:(TKFindFriendsCell *)cellView didTapFollowButton:(PFUser *)aUser;

@end
