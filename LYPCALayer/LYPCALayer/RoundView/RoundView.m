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
        _alpha = 1;//默认为1；
    }
    return self;
}

//MARK: - 实例化方法
+ (instancetype) roundViewWithIsCut: (BOOL)isCut andCutRadius:(CGFloat)radius andImage:(UIImage *)image{
    return [[self alloc]initWithIsCut:isCut andCutRadius:radius andImage:image];
}
- (instancetype) initWithIsCut: (BOOL)isCut andCutRadius:(CGFloat)radius andImage: (UIImage *)image {
    if (self = [super init]) {
        //先走这句话，是因为现在的isCut是NO，不会切圆，如果先设置isCut那么radius是nil那么就会使View被切成圆形
        self.radius = radius;
        self.isCut = isCut;
        self.image = image;
    }
    return self;
}

#pragma mark  - 截图并且返回图片
- (UIImage *)snapshotImageWithImageIsTransparent:(BOOL)isTransparent
                                    andBlendMode: (CGBlendMode)blendMode
                                 andSnapshotRect:(CGRect)snapshotRect
                                   andImageAlpha:(CGFloat)imageAlpha{
    
    //MARK: - 默认值设置
    //切图值设置
    if (!snapshotRect.size.width || !snapshotRect.size.height) snapshotRect = self.bounds;
    //图片透明度设置
    if (imageAlpha <= 1) imageAlpha = self.alpha;

    
    //MARK: - 正式开始截图
    /**
     *下面方法，
     * 第一个参数表示区域大小。
     * 第二个参数表示裁切掉的部分是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。
     * 第三个参数就是屏幕密度了
     */
    UIGraphicsBeginImageContextWithOptions(self.bounds.size,
                                           isTransparent,
                                           [UIScreen mainScreen].scale);
    
    //获取Context
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    //搭建裁切路径
    [self contextRefWithcontext:context];

    
    [_image drawInRect:snapshotRect blendMode:kCGBlendModeNormal alpha:imageAlpha];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;

    
    //----------------------------用UIBezierPath的写法--------------------------------
    //    UIGraphicsBeginImageContext(size);
    //
    //    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    //
    //    CGContextAddPath(UIGraphicsGetCurrentContext(), path.CGPath);
    //
    //    CGContextClip(UIGraphicsGetCurrentContext());
    //
    //    [self drawInRect:rect];
    //
    //    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathStroke);
    //    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    
    
//--------------------------------Swift的写法------------------------------------
//    func kt_drawRectWithRoundedCorner(radius radius: CGFloat,
//                                      borderWidth: CGFloat,
//                                      backgroundColor: UIColor,
//                                      borderColor: UIColor) -> UIImage {
//        UIGraphicsBeginImageContextWithOptions(sizeToFit, false, UIScreen.mainScreen().scale)
//        let context = UIGraphicsGetCurrentContext()
//        
//        CGContextMoveToPoint(context, 开始位置);  // 开始坐标右边开始
//        CGContextAddArcToPoint(context, x1, y1, x2, y2, radius);  // 这种类型的代码重复四次
//        
//        CGContextDrawPath(UIGraphicsGetCurrentContext(), .FillStroke)
//        let output = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        return output
//    }
}


//MARK: - 裁切
- (void) drawRect:(CGRect)rect{
    
    if (!self.isCut) return;//如果不裁切，就返回
    if (!self.cutRect.size.height && !self.cutRect.size.width){
        self.cutRect = rect;
    };
    
    //裁切
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (!self.radius){//如果没有设置裁切半径，那么就默认为圆形
        self.radius = self.cutRect.size.width > self.cutRect.size.height ?
        self.cutRect.size.width / 2 :
        self.cutRect.size.height / 2;
    }
    
    [self contextRefWithcontext:context];
    
    [_image drawInRect:rect blendMode:kCGBlendModeLighten alpha:self.alpha];
    
    //其他的画图方法
    //CGContextDrawImage(context, self.cutRect, self.image.CGImage);
    //[_image drawAtPoint:CGPointMake(0, 0)];
    //[_image drawInRect: rect];
    //[_image drawAsPatternInRect:CGRectMake(20, 100, 300, 300)];
}

//MARK: - 在上下文中创建切圆路径并且裁切
- (void)contextRefWithcontext:(CGContextRef)context {
    CGFloat
    minx = CGRectGetMinX(self.cutRect),//矩形中最小的x
    midx = CGRectGetMidX(self.cutRect),//矩形中最大x值的一半
    maxx = CGRectGetMaxX(self.cutRect);//矩形中最大的x值
    
    CGFloat
    miny = CGRectGetMinY(self.cutRect),//矩形中最小的Y值
    midy = CGRectGetMidY(self.cutRect),//矩形中最大Y值的一半
    maxy = CGRectGetMaxY(self.cutRect);//矩形中最大的Y值
    
    
    CGContextMoveToPoint(context, minx, midy);//从点A 开始
    //从点A到点B再从点B到点C形成夹角进行切圆
    CGContextAddArcToPoint(context, minx, miny, midx, miny, self.radius + self.leftTopRadiu);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, self.radius + self.rightTopRadiu);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, self.radius + self.rightBottonRadiu);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, self.radius + self.leftBottomRadiu);
    CGContextClosePath(context);
    //裁切
    CGContextClip(context);
}



//MARK: setter方法 bing
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

- (void)setRightTopRadiu:(CGFloat)rightTopRadiu {
    _rightTopRadiu = rightTopRadiu;
    [self setNeedsDisplay];
}

- (void)setRightBottonRadiu:(CGFloat)rightBottonRadiu {
    _rightBottonRadiu = rightBottonRadiu;
    [self setNeedsDisplay];
}

- (void)setLeftTopRadiu:(CGFloat)leftTopRadiu {
    _leftTopRadiu = leftTopRadiu;
    [self setNeedsDisplay];
}

- (void)setLeftBottomRadiu:(CGFloat)leftBottomRadiu {
    _leftBottomRadiu = leftBottomRadiu;
    [self setNeedsDisplay];
}

- (void)setAlpha:(CGFloat)alpha {
    _alpha = alpha;
    [self setNeedsDisplay];
}

//MARK: - 改变参数的方法
- (void)imageChengeLeftTopRadiu:(CGFloat)leftTopRadiu
             andLeftBottomRadiu:(CGFloat)leftBottomRadiu
               andRightTopRadiu:(CGFloat)rightTopRadiu
            andRightBottomRadiu:(CGFloat)rightBottonRadiu
                     andCutRect:(CGRect)cutRect
                  andImageAlpha:(CGFloat)alpha{
    
    //赋值，不能用self.因为self.默认会调用setter方法（造成多次没必要的setNeedsDisplay）
    _leftTopRadiu = leftTopRadiu;
    _leftBottomRadiu = leftBottomRadiu;
    _rightTopRadiu = rightTopRadiu;
    _rightBottonRadiu = rightBottonRadiu;
    _cutRect = cutRect;
    //赋值并刷新
    _alpha = alpha;
    [self setNeedsDisplay];
}
@end
