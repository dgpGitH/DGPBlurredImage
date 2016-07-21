//
//  DGPBlurredImage.h
//  PulldownBlurredImage
//
//  Created by 戴国平 on 16/7/21.
//  Copyright © 2016年 dgp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DGPBlurredImage : UIView

@property(nonatomic, strong) UIScrollView *imageScrollView;
@property(nonatomic, strong) UIImageView *imageView;                //背景图片
@property(nonatomic, strong) UIImageView *imageBackgroundView;      //要改变的背景图片

/**
 *  改变顶部view的大小和高斯效果
 *
 *  @param offset scrollview滑动的记录
 */

-(void)updateHeaderView:(CGPoint) offset;
@end
