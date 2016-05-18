//
//  WImageView.m
//  YunJiaHui
//
//  Created by Zhibo Wang on 16/5/17.
//  Copyright © 2016年 Zhibo Wang. All rights reserved.
//

#import "WImageView.h"

IB_DESIGNABLE
@implementation WImageView

-(void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius  = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}
-(void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}

-(void)setBorderWidth:(CGFloat)borderWidth{
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}

-(void)awakeFromNib{
    // [--
    [self setContentScaleFactor:[[UIScreen mainScreen] scale]];
    self.contentMode =  UIViewContentModeScaleAspectFill;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.clipsToBounds  = YES;    // --]
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
