//
//  ZJActionSheet.m
//  DoctorBabyVisit
//
//  Created by 周义进 on 16/7/2.
//  Copyright © 2016年 Zhouyijin. All rights reserved.
//

#import "ZJActionSheet.h"
@interface ZJActionSheet()
@property (nonatomic,strong) UIView *contentView;
@end
@implementation ZJActionSheet

- (instancetype)initWithView:(UIView *)view;
{
    self = [super init];
    if (self) {
        
        //初始化背景视图，添加手势
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tapGesture];
        
        view.frame = CGRectMake(0, self.frame.size.height, view.frame.size.width, view.frame.size.height);
        [self addSubview:view];
        
        for (id sub in view.subviews)
        {
            if ([sub isKindOfClass:[UIButton class]])
            {
                [sub addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        self.contentView = view;
        
    }
    return self;
}

- (void)buttonClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickOnButtonWithName:)])
    {
        [self.delegate didClickOnButtonWithName:sender.currentTitle];
    }
}

- (void)show
{
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.5 animations:^{
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        CGRect frame = self.contentView.frame;
        frame.origin.y -= self.contentView.frame.size.height;
        self.contentView.frame = frame;
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
    }];
}

- (void)dismiss
{
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.contentView.frame;
        frame.origin.y += self.contentView.frame.size.height;
        self.contentView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.userInteractionEnabled = YES;
    }];
 
}

@end
