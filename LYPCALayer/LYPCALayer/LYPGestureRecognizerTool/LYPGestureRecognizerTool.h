//
//  LYPGestureRecognizer.h
//  GestureRecognizer
//
//  Created by 李鹏跃 on 17/1/27.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYPGestureRecognizerTool : NSObject

/** isSupportMoreGesture 表示是否支持多手势*/
@property (nonatomic,assign) BOOL isSupportMoreGesture;

/**
 * 传入View 给view添加捏合手势
 * view：            手势将被添加到这个view上
 * isSupportMoreGesture 表示是否支持多手势
 * pinchiBlock：     点击事件的回调
 * isGestureRecognizerStateEnded： 手势是否结束
 * pinch：           手势对象
 */
+ (void)pinchWithView: (UIView *)view
        andPinchBlock: (void(^)
                        (BOOL isGestureRecognizerStateEnded,
                         UIPinchGestureRecognizer *pinch)
                        )pinchiBlock;


/**
 * 传入view，给View，添加点击手势
 * view：            手势将被添加到这个view上
 * numberOfTouches： 设置触控对象的个数（几个手指）
 * numberOfTaps：    点击次数
 * selectorBlock:   点击事件的回调
 */
+ (void)tapWithView: (UIView *)view andNumberOfTouches: (NSInteger)numberOfTouches andNumberOfTaps: (NSInteger)numberOfTaps andSelectorBlock:(void(^)(UITapGestureRecognizer *tap))selectorBlock;


/**
 * 传入View 给view添加捏合手势
 * view：            手势将被添加到这个view上
 * pinchiBlock：     点击事件的回调
 * isGestureRecognizerStateEnded： 手势是否结束
 * pinch：           手势对象
 */
+ (void)pinchWithView: (UIView *)view
        andPinchBlock: (void(^)
                        (BOOL isGestureRecognizerStateEnded,
                         UIPinchGestureRecognizer *pinch)
                        )pinchiBlock;


/**
 * 传入view，给View，添加拖动手势
 * view：            手势将被添加到这个view上
 * panGesture:   点击事件的回调
 */
+ (void)panWithView: (UIView *)view andPanBlock: (void(^)(UIPanGestureRecognizer *panGesture))panBlock;

/**
 * 传入view，给View，添加长按手势
 * view：          手势将被添加到这个view上
 * swipeBlock:     事件的回调
 */

+ (void)longPressWithView: (UIView *)view andLongPressBlock: (void(^)())longPressBlock;

/**
 * 传入view，给View，添加旋转手势
 * view：            手势将被添加到这个view上
 * rotationGesture:   点击事件的回调
 */
+ (void)rotationWithView: (UIView *)view andRotationBlock: (void(^)(CGFloat rotation,UIRotationGestureRecognizer *rotationGesture))rotationBlock;

/**
 * 传入view，给View，添加轻扫手势
 * view：          手势将被添加到这个view上
 * direction：     轻扫的方向
 * swipeBlock:     事件的回调
 */
+ (void)swipeWithView: (UIView *)view andSwipeGrestureDirection: (UISwipeGestureRecognizerDirection)direction andSwipeBlock: (void(^)(UISwipeGestureRecognizer *swipe))swipeBlock;


@end

