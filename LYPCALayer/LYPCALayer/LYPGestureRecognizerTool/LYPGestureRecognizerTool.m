//
//  LYPGestureRecognizer.m
//  GestureRecognizer
//
//  Created by 李鹏跃 on 17/1/27.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

#import "LYPGestureRecognizerTool.h"
@interface LYPGestureRecognizerTool() <UIGestureRecognizerDelegate>

//tap（点击手势）回调的block
@property (nonatomic,copy) void(^tapBlock)(UITapGestureRecognizer *tap);
//pinch（捏合手势）回调的block
@property (nonatomic,copy) void(^pinchBlock)(BOOL isEnd,UIPinchGestureRecognizer *pinch);
//pan(拖动手势)回调的block
@property (nonatomic,copy) void(^panBlock)(UIPanGestureRecognizer *pan);
//longPress（长按手势）回调的block
@property (nonatomic,copy) void(^longPressBlock)();
//rotation（旋转手势）回调的block
@property (nonatomic,copy) void(^rotationBlock)(CGFloat rotation,UIRotationGestureRecognizer *rotationGesture);
@property (nonatomic,copy) void(^swipeBlock)(UISwipeGestureRecognizer *swipe);
@end



@implementation LYPGestureRecognizerTool
#pragma mark - 单利对象
static id _instancetype;
+ (instancetype) sharedGestureRecognizerTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instancetype = [[self alloc]init];
    });
    return _instancetype;
}



#pragma mark - tap点击手势
+ (void)tapWithView: (UIView *)view andNumberOfTouches: (NSInteger)numberOfTouches andNumberOfTaps: (NSInteger)numberOfTaps andSelectorBlock:(void(^)(UITapGestureRecognizer *tap))selectorBlock {
    LYPGestureRecognizerTool *gesture = [self sharedGestureRecognizerTool];
    view.userInteractionEnabled = YES;
    //创建tap手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:gesture action:@selector(tap:)];
    tap.delegate = gesture;
    [view addGestureRecognizer:tap];
    //设置触控对象的个数（几个手指）
    [tap setNumberOfTouchesRequired:numberOfTouches];
    //点击次数
    [tap setNumberOfTapsRequired:numberOfTaps];
    gesture.tapBlock = selectorBlock;
}

- (void)tap: (UITapGestureRecognizer *)tap {
    if (self.tapBlock) self.tapBlock(tap);
}


#pragma mark - pinch捏合手势
+ (void)pinchWithView: (UIView *)view andPinchBlock: (void(^)(BOOL isGestureRecognizerStateEnded,UIPinchGestureRecognizer *pinch))pinchiBlock{
    //获取工具类
    LYPGestureRecognizerTool *gesture = [self sharedGestureRecognizerTool];
    //设置view的用户交互设置
    view.userInteractionEnabled = YES;
    //创建捏合手势
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:gesture action:@selector(pinchGesture:)];
    pinchGesture.delegate = gesture;
    //添加手势
    [view addGestureRecognizer:pinchGesture];
}

- (void)pinchGesture: (UIPinchGestureRecognizer *)pinch {
    
    //判断block 是否实现
    if (self.pinchBlock) {
        self.pinchBlock(pinch.state,pinch);
        return;
    }

    
    //1.获取手指的 缩放的大小
    CGFloat scale = pinch.scale;
    
    //归零
    pinch.scale = 1;
    
    //2.形变
    pinch.view.transform = CGAffineTransformScale(pinch.view.transform, scale, scale);
    
    NSLog(@"------------");
}


#pragma mark - Pan拖动
+ (void)panWithView: (UIView *)view andPanBlock: (void(^)(UIPanGestureRecognizer *panGesture))panBlock {
    LYPGestureRecognizerTool *gestureTool = [self sharedGestureRecognizerTool];
    view.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:gestureTool action:@selector(pan:)];
    pan.delegate = gestureTool;
    gestureTool.panBlock = panBlock;
    [view addGestureRecognizer:pan];
}
- (void)pan: (UIPanGestureRecognizer *)pan {
    //视图前置操作
    [pan.view.superview bringSubviewToFront:pan.view];
    if (self.panBlock) {
        self.panBlock(pan);
        return;
    }
    CGPoint center = pan.view.center;
    CGFloat cornerRadius = pan.view.frame.size.width / 2;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //位置获取偏移点的位置
    CGPoint translation = [pan translationInView:window];
    //NSLog(@"%@",[NSValue valueWithCGPoint:translation]);
    //NSLog(@"%--------@",[NSValue valueWithCGPoint:center]);
    
    pan.view.center = CGPointMake(center.x + translation.x, center.y + translation.y);
      
    CGPoint velocity = [pan velocityInView:window];
    NSLog(@"------%@",[NSValue valueWithCGPoint:velocity]);
    
    //重设偏移量
    [pan setTranslation:CGPointZero inView:window];
    
}

#pragma mark - longPress （长按手势）
+ (void)longPressWithView: (UIView *)view andLongPressBlock: (void(^)())longPressBlock{
    LYPGestureRecognizerTool *gestureTool = [self sharedGestureRecognizerTool];
    view.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:gestureTool action:@selector(longPress:)];
    longPress.delegate = gestureTool;
    gestureTool.longPressBlock = longPressBlock;
    [view addGestureRecognizer:longPress];
}
- (void)longPress: (UILongPressGestureRecognizer *)longPress {
    if (self.longPressBlock) {
        self.longPressBlock();
        return;
    }
}


#pragma mark - rotation(旋转手势)
+ (void)rotationWithView: (UIView *)view andRotationBlock: (void(^)(CGFloat rotation,UIRotationGestureRecognizer *rotationGesture))rotationBlock {
    
    LYPGestureRecognizerTool *gestureTool = [self sharedGestureRecognizerTool];
    view.userInteractionEnabled = YES;
   
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc]initWithTarget:gestureTool action:@selector(rotationFunction:)];
    [view addGestureRecognizer:rotationGesture];
    
    gestureTool.rotationBlock = rotationBlock;
}
- (void)rotationFunction: (UIRotationGestureRecognizer *)rotationGestrue{
    
    if (self.rotationBlock) {
        self.rotationBlock(rotationGestrue.rotation,rotationGestrue);
        return;
    }

    //1.获取手指的 旋转角度
    CGFloat angle = rotationGestrue.rotation;
    
    //清零
    rotationGestrue.rotation = 0;
    //2.形变
    rotationGestrue.view.transform = CGAffineTransformRotate(rotationGestrue.view.transform, angle);

    NSLog(@"=====%f",rotationGestrue.rotation);
    NSLog(@"=====------%f",rotationGestrue.velocity);
  
}

+ (void)swipeWithView: (UIView *)view andSwipeGrestureDirection: (UISwipeGestureRecognizerDirection)direction andSwipeBlock: (void(^)(UISwipeGestureRecognizer *swipe))swipeBlock{
   
    LYPGestureRecognizerTool *gestureTool = [self sharedGestureRecognizerTool];
    view.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:gestureTool action:@selector(swipe:)];
    gestureTool.swipeBlock = swipeBlock;
    swipe.delegate = gestureTool;
    swipe.direction = direction;
    [view addGestureRecognizer:swipe];
}

- (void)swipe: (UISwipeGestureRecognizer *)swipe {
    if(self.swipeBlock){
        self.swipeBlock(swipe);
        return;
    }
   /*
    switch (swipe.direction) {
        case UISwipeGestureRecognizerDirectionRight:
            NSLog(@"UISwipeGestureRecognizerDirectionRight----1");
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            NSLog(@"UISwipeGestureRecognizerDirectionLeft----2");
            break;
        case UISwipeGestureRecognizerDirectionUp:
            NSLog(@"UISwipeGestureRecognizerDirectionUp----3");
            break;
        case UISwipeGestureRecognizerDirectionDown:
            NSLog(@"UISwipeGestureRecognizerDirectionDown----4");
            break;
        default:
            break;
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight ) {
        NSLog(@"UISwipeGestureRecognizerDirectionRight----1");
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"UISwipeGestureRecognizerDirectionLeft----2");
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"UISwipeGestureRecognizerDirectionUp----3");
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"UISwipeGestureRecognizerDirectionDown----4");
    }
    */
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end
