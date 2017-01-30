//
//  LYPRoundView.h
//  LYPCALayer
//
//  Created by 李鹏跃 on 17/1/30.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYPRoundView : UIView
/**圆形的半径*/
@property (nonatomic,assign) CGFloat radius;
/**填充的View*/
@property (nonatomic,weak) UIView *sbView;
/**是否裁切，默认NO*/
@property (nonatomic,assign) BOOL isCut;

@end
