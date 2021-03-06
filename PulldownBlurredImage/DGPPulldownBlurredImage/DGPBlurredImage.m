//
//  DGPBlurredImage.m
//  PulldownBlurredImage
//
//  Created by 戴国平 on 16/7/21.
//  Copyright © 2016年 dgp. All rights reserved.
//

#import "DGPBlurredImage.h"
#import <Accelerate/Accelerate.h>
@implementation DGPBlurredImage

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:self.imageScrollView];
        
        UIImage *image = [UIImage imageNamed:@"header_bg"];
        //高斯的背景图片
        self.imageBackgroundView = [[UIImageView alloc] initWithFrame:self.imageScrollView.bounds];
        [self setBlurryImage:image];
        self.imageBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.imageBackgroundView.contentMode = UIViewContentModeScaleAspectFill;
        [self.imageScrollView addSubview:self.imageBackgroundView];
        
        //原图
        self.imageView = [[UIImageView alloc] initWithFrame:self.imageScrollView.bounds];
        self.imageView.image = image;
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.imageScrollView addSubview:self.imageView];
    }
    
    return self;
}

/**
 *  通过scrollview的滑动改变顶部view的大小和高斯效果
 *
 *  @param offset scrollview下滑的距离
 */
-(void)updateHeaderView:(CGPoint) offset {
    if (offset.y < 0) {
        CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        CGFloat delta = fabs(MIN(0.0f, offset.y));
        rect.origin.y -= delta;
        rect.size.height += delta;
        self.imageScrollView.frame = rect;
        self.clipsToBounds = NO;
        
        self.imageView.alpha = fabs(offset.y / (2 * CGRectGetHeight(self.bounds) / 3));
    }
}


/**
 *  高斯图片
 *
 *  @param originalImage 需要高斯的图片
 */
- (void)setBlurryImage:(UIImage *)originalImage {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *blurredImage = [self blurryImage:originalImage withBlurLevel:0.9];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.alpha = 0.0;
            self.imageBackgroundView.image = blurredImage;
        });
    });
    
}

/**
 *  加模糊效果
 *
 *  @param image    需要高斯模糊的图片
 *  @param blur     高斯模糊的值
 *
 */
- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    
    /**
     *  模糊度
     */
    if ((blur < 0.0f) || (blur > 1.0f)) {
        blur = 0.5f;
    }
    
    /**
     *  boxSize必须大于0
     */
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    
    /**
     *  图像处理
     */
    CGImageRef img = image.CGImage;
    
    /**
     *  图像缓存，输入缓存、输出缓存
     */
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    /**
     *  像素缓存
     */
    void *pixelBuffer;
    
    /**
     *  数据提供者
     */
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    /**
     *  宽，高，字节行，data
     */
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    /**
     *  像素缓存，字节行*图片高
     */
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    /**
     *  颜色空间DeviceRGB
     *
     *  @return
     */
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    /**
     *  用图片创建上下文
     *
     */
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(image.CGImage));
    
    /**
     *  根据上下文，处理过的图片，重新组件
     */
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    return returnImage;
}
@end
