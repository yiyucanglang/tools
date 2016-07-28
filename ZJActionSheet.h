//
//  ZJActionSheet.h
//  DoctorBabyVisit
//
//  Created by 周义进 on 16/7/2.
//  Copyright © 2016年 Zhouyijin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZJActionSheetDelegate <NSObject>
@optional
- (void)didClickOnButtonWithName:(NSString *)name;

@end


@interface ZJActionSheet : UIView
@property (nonatomic,weak) id<ZJActionSheetDelegate> delegate;

- (instancetype)initWithView:(UIView *)view;
- (void)dismiss;
- (void)show;
@end
