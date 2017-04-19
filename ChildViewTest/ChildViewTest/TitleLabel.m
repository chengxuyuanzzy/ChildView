//
//  TitleLabel.m
//  ChildViewTest
//
//  Created by 朱忠阳 on 2017/4/18.
//  Copyright © 2017年 朱忠阳. All rights reserved.
//

#import "TitleLabel.h"

@implementation TitleLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:18.f];
        
        self.scale = 0.0;
    }
    return self;
}

- (void)setScale:(CGFloat)scale {
    _scale = scale;
    
    self.textColor = [UIColor colorWithRed:scale green:0.0 blue:0.0 alpha:1];
    CGFloat minScale = 0.7;
    CGFloat trueScale = minScale + (1-minScale)*scale;
    self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
