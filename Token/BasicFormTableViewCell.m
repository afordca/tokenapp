//
//  BasicFormTableViewCell.m
//  Token
//
//  Created by Dave on 11/5/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import "BasicFormTableViewCell.h"

@implementation BasicFormTableViewCell
@synthesize textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 55)];
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLoadedCell:(UITextField *)_textField
{
    textField = _textField;
    [self.contentView addSubview:textField];
}

@end
