//
//  AppDelegate.h
//  StarAnimation
//
//  Created by 李鹏跃 on 17/1/24.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//
#import "DrawRectView.h"

@implementation DrawRectView

- (void)drawRect:(CGRect)rect {
    
    //1.获取当前上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //2.创建色彩空间
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    //3.创建渐变对象
    CGGradientRef gradientRef = CGGradientCreateWithColorComponents(colorSpaceRef, (CGFloat[]) {
        1.0f,0.8f,0.5f,1.0f,//第一个颜色RGB 和透明度
        0.6f,0.5f,0.6f,1.0f,//第二个颜色RGB 和透明度
        0.3f,0.2f,0.f,1.0f,//第三个颜色RGB 和透明度
        .0f,0.0f,0.3f,1.0f
    }, (CGFloat []) {
        0.0f,0.3f,.6f,1//四个颜色的比例
    }, 4);//颜色的个数
    
    //释放色彩空间
    CGColorSpaceRelease(colorSpaceRef);
    
    //绘制
    CGContextDrawLinearGradient(context, gradientRef, CGPointMake(0.0f, 0.0f), CGPointMake(rect.size.width,rect.size.height), 0);
    
    //释放变色对象
    CGGradientRelease(gradientRef);
}


@end
