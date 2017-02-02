//
//  RoundView.h
//  LYPCALayer
//
//  Created by 李鹏跃 on 17/1/30.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundView : UIView




//-------------------初始化----------------------------------
#pragma mark - 初始化
/**
 *isCut     是否裁切,默认为NO；
 *radius    半径
 */
+ (instancetype) roundViewWithIsCut: (BOOL) isCut andCutRadius: (CGFloat)radius andImage: (UIImage *)image;

/**
 *isCut     是否裁切,默认为NO；
 *radius    半径
 *image     view中的image内容
 */
- (instancetype) initWithIsCut: (BOOL) isCut andCutRadius: (CGFloat)radius andImage: (UIImage *)image;








//-------------------截图的相关数据---------------------------
#pragma mark - 截图的方法
/**
 * 截图并且返回图片
 * IsTransparent: 裁切部分是否透明（默认是NO：不透明）
 * CGBlendMode: 绘图模式
 * snapshotRect: 图片裁切的相对Rect（当不设置时，默认采用self.bouns数据）
 *  imageAlpha: 图片透明度（设置小于等于1时，默认启用self.alpha的值）
 */
- (UIImage *)snapshotImageWithImageIsTransparent:(BOOL)isTransparent
                                    andBlendMode: (CGBlendMode)blendMode
                                 andSnapshotRect:(CGRect)snapshotRect
                                   andImageAlpha:(CGFloat)imageAlpha;









//-------------------裁切的相关数据---------------------------
#pragma mark - 裁切的相关数据
/**填充的image*/
@property (nonatomic,strong) UIImage *image;

/**裁切后的image*/
@property (nonatomic,strong) UIImage *cutImage;

/**是否裁切，默认NO*/
@property (nonatomic,assign) BOOL isCut;

/**裁切的位置及范围*/
@property (nonatomic,assign) CGRect cutRect;

/**圆形的半径*/
@property (nonatomic,assign) CGFloat radius;

/**四个角的半径控制接口*/
@property (nonatomic,assign) CGFloat leftTopRadiu;
@property (nonatomic,assign) CGFloat leftBottomRadiu;
@property (nonatomic,assign) CGFloat rightTopRadiu;
@property (nonatomic,assign) CGFloat rightBottonRadiu;

/**图片的透明度*/
@property (nonatomic,assign) CGFloat alpha;
/**
 *  综合的改变渲染参数（如果改变多个参数后渲染，建议用此方法）
 */
- (void) imageChengeLeftTopRadiu: (CGFloat)leftTopRadiu andLeftBottomRadiu: (CGFloat)leftBottomRadiu andRightTopRadiu: (CGFloat)rightTopRadiu andRightBottomRadiu: (CGFloat)rightBottomRadiu andCutRect: (CGRect) cutRect andImageAlpha: (CGFloat)alpha;

- (void) drawRect1:(CGRect)rect;
@end
