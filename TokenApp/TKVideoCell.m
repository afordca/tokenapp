//
//  TKVideoCell.m
//  TokenApp
//
//  Created by BASEL FARAG on 2/20/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//


@implementation TKVideoCell


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    if (self)
//    {
//        self.opaque = NO;
//        self.selectionStyle = UITableViewCellStyleDefault;
//
//        self.accessoryType = UITableViewCellAccessoryNone;
//        self.clipsToBounds = NO;
//
//        self.backgroundColor = [UIColor clearColor];
//
//        self.movie = [[MPMoviePlayerController alloc]init];
//        self.imageView.backgroundColor = [UIColor clearColor];
//        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
//
//    }
//    return self;
//}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.movie.frame = CGRectMake(10, 0, self.bounds.size.width - 20, self.bounds.size.height);
}

@end
