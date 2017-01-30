//
//  RoundView.m
//  LYPCALayer
//
//  Created by 李鹏跃 on 17/1/30.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

#import "RoundView.h"
@interface RoundView()
@property (nonatomic,strong) UIImage *sbImage;
@end

@implementation RoundView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

//实例化方法
+ (instancetype) roundViewWithIsCut: (BOOL) isCut andCutRadius: (CGFloat)radius andImage: (UIImage *)image{
    return [[self alloc]initWithIsCut:isCut andCutRadius:radius andImage:image];
}
- (instancetype) initWithIsCut: (BOOL) isCut andCutRadius: (CGFloat)radius andImage: (UIImage *)image {
    if (self = [super init]) {
        //先走这句话，是因为现在的isCut是NO，不会切圆，如果先设置isCut那么radius是nil那么就会使View被切成圆形
        self.radius = radius;
        self.isCut = isCut;
        self.image = image;
    }
    return self;
}

//MARK: - 截图并且返回图片
- (UIImage *)snapshotImage {
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);
    
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    return result;
}

//MARK: - 裁切
- (void) drawRect:(CGRect)rect{
    //绘图
    if (!self.isCut) return;//如果不裁切，就返回
    //裁切
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (!self.radius) {//如果没有设置裁切半径，那么就默认为圆形
        self.radius = rect.size.width > rect.size.height ?
        rect.size.width / 2 :
        rect.size.height / 2;
    }
    
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
    //裁切
    CGContextClip(context);
   //CGContextDrawImage(context, rect, self.image.CGImage);
    
    [_image drawInRect:rect];
}


//MARK: setter方法
- (void)setIsCut:(BOOL)isCut {
    _isCut = isCut;
    [self setNeedsDisplay];
}

- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    [self setNeedsDisplay];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self setNeedsDisplay];
}

@end
