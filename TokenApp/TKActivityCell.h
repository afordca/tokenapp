//
//  TKActivityCell.h
//  TokenApp
//
//  Created by BASEL FARAG on 1/10/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "TKBaseCellText.h"

@protocol TKActivityCellDelegate;

@interface TKActivityCell : TKBaseCellText

/*!Setter for the activity associated with this cell */
@property (nonatomic, strong) PFObject *activity;

/*!Set the new state. This changes the background of the cell. */
- (void)setIsNew:(BOOL)isNew;

@end


/*!
 The protocol defines methods a delegate of a TKBaseTextCell should implement.
 */
@protocol TKActivityCellDelegate <TKBaseCellTextDelegate>
@optional

/*!
 Sent to the delegate when the activity button is tapped
 @param activity the PFObject of the activity that was tapped
 */
- (void)cell:(TKActivityCell *)cellView didTapActivityButton:(PFObject *)activity;


@end
