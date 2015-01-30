//
//  TKLoadMoreCell.m
//  TokenApp
//
//  Created by BASEL FARAG on 1/10/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "TKLoadMoreCell.h"

#import "TKUtility.h"

@implementation TKLoadMoreCell

@synthesize cellInsetWidth;
@synthesize mainView;
@synthesize separatorImageTop;
@synthesize separatorImageBottom;
@synthesize loadMoreImageView;
@synthesize hideSeparatorTop;
@synthesize hideSeparatorBottom;


#pragma mark - NSObject

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        // Initialization code
        self.cellInsetWidth = 0.0f;
        hideSeparatorTop = NO;
        hideSeparatorBottom = NO;

        self.opaque = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = [UIColor clearColor];

        mainView = [[UIView alloc] initWithFrame:self.contentView.frame];
        if ([reuseIdentifier isEqualToString:@"NextPageDetails"]) {
            [mainView setBackgroundColor:[UIColor whiteColor]];
        } else {
            [mainView setBackgroundColor:[UIColor blackColor]];
        }



        self.loadMoreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellLoadMore.png"]];
        [mainView addSubview:self.loadMoreImageView];

        [self.contentView addSubview:mainView];
    }

    return self;
}


#pragma mark - UIView

- (void)layoutSubviews {
    [mainView setFrame:CGRectMake( self.cellInsetWidth, self.contentView.frame.origin.y, self.contentView.frame.size.width-2*self.cellInsetWidth, self.contentView.frame.size.height)];

    // Layout load more text
    [self.loadMoreImageView setFrame:CGRectMake( 105.0f, 15.0f, 111.0f, 18.0f)];

    // Layout separator
    [self.separatorImageBottom setFrame:CGRectMake( 0.0f, self.frame.size.height - 2.0f, self.frame.size.width-self.cellInsetWidth * 2.0f, 2.0f)];
    [self.separatorImageBottom setHidden:hideSeparatorBottom];

    [self.separatorImageTop setFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width - self.cellInsetWidth * 2.0f, 2.0f)];
    [self.separatorImageTop setHidden:hideSeparatorTop];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.cellInsetWidth != 0.0f) {
        [TKUtility drawSideDropShadowForRect:mainView.frame inContext:UIGraphicsGetCurrentContext()];
    }
}


#pragma mark - TKLoadMoreCell

- (void)setCellInsetWidth:(CGFloat)insetWidth {
    cellInsetWidth = insetWidth;
    [mainView setFrame:CGRectMake( insetWidth, mainView.frame.origin.y, mainView.frame.size.width - 2.0f * insetWidth, mainView.frame.size.height)];
    [self setNeedsDisplay];
}

@end
