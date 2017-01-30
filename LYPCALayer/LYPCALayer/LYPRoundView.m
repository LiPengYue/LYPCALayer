//
//  LYPRoundView.m
//  LYPCALayer
//
//  Created by 李鹏跃 on 17/1/30.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

#import "LYPRoundView.h"

@implementation LYPRoundView

//MARK: - 裁切
- (void) drawRect:(CGRect)rect{
    if (!self.isCut) ;//如果不裁切，就返回
    //裁切
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (!self.radius) {//如果没有设置裁切半径，那么就默认为圆形
        self.radius = rect.size.width > rect.size.height ?
        rect.size.width / 2 :
        rect.size.height / 2;
    }
    
    
    UIImage *image = [UIImage imageNamed:@"1.1"];
    
    CGFloat
    minx = CGRectGetMinX(rect),//矩形中最小的x
    midx = CGRectGetMidX(rect),//矩形中最大x值的一半
    maxx = CGRectGetMaxX(rect);//矩形中最大的x值
    
    CGFloat
    miny = CGRectGetMinY(rect),//矩形中最小的Y值
    midy = CGRectGetMidY(rect),//矩形中最大Y值的一半
    maxy = CGRectGetMaxY(rect);//矩形中最大的Y值
    
    
    CGContextMoveToPoint(context, minx, midy);//从点A 开始
    //从点A到点B再从点B到点C形成夹角进行切圆
    CGContextAddArcToPoint(context, minx, miny, midx, miny, self.radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, self.radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, self.radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, self.radius);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextFillPath(context);
    CGContextDrawImage(context, rect, image.CGImage);
    
}

- (void)drawRect1:(CGRect)rect {
    // 1.加载要裁剪的图片
    UIImage*image = [UIImage imageNamed:@"1.1"];
    
    // 2.获取上下文
    
    CGContextRef ctx =UIGraphicsGetCurrentContext();
    
    // 3.在上下文中绘制一个要裁剪的图形
    
//    UIBezierPath*pathCircle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,100,100)];
//    CGContextAddPath(ctx, pathCircle.CGPath);

    
    
    // 4.执行裁剪
    CGContextClip(ctx);
    
    // 5.把图片绘制到上下文中
    
    [image drawAtPoint:CGPointZero];
}

@end
