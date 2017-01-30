//
//  RoundView.h
//  LYPCALayer
//
//  Created by 李鹏跃 on 17/1/30.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundView : UIView

/**
 *isCut     是否裁切,默认为NO；
 *radius    半径
 */
+ (instancetype) roundViewWithIsCut: (BOOL) isCut andCutRadius: (CGFloat)radius andImage: (UIImage *)image;

/**
 *isCut     是否裁切,默认为NO；
 *radius    半径
 */
- (instancetype) initWithIsCut: (BOOL) isCut andCutRadius: (CGFloat)radius andImage: (UIImage *)image;


/**截图并且返回图片*/
- (UIImage *)snapshotImage;


/**圆形的半径*/
@property (nonatomic,assign) CGFloat radius;
/**填充的View*/
@property (nonatomic,strong) UIImage *image;
/**是否裁切，默认NO*/
@property (nonatomic,assign) BOOL isCut;
@end
