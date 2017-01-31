# LYPCALayer
关于CALayer的学习
![Uploading 2017年总结动画_437483.gif . . .]

![2017年总结动画.gif](http://upload-images.jianshu.io/upload_images/4185621-43df752431272c88.gif?imageMogr2/auto-orient/strip)

首先介绍这里面一共有两个比较重要的类

#一 、手势工具类LYPGestureRecognizerTool.h
**大体思路**
1 . 由于是手势工具类，所以在以后用的时候，可能回多次创建，所以索性就弄了一个单利类。

```
static id _instancetype;
+(instancetype) sharedGestureRecognizerTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instancetype = [[self alloc]init];
    });
    return _instancetype;
}
```

2 . 每个手势的添加都是利用类方法，向外部暴露了一个UIView接口
```
//
/**
 * 传入View 给view添加捏合手势
 * view：            手势将被添加到这个view上
 * isSupportMoreGesture 表示是否支持多手势
 * pinchiBlock：     点击事件的回调
 * isGestureRecognizerStateEnded： 手势是否结束
 * pinch：           手势对象
 */
+(void)pinchWithView: (UIView *)view andPinchBlock: (void(^)(BOOL isGestureRecognizerStateEnded,UIPinchGestureRecognizer *pinch))pinchiBlock;
/**
 * 传入view，给View，添加点击手势
 * view：            手势将被添加到这个view上
 * isSupportMoreGesture 表示是否支持多手势
 * numberOfTouches： 设置触控对象的个数（几个手指）
 * numberOfTaps：    点击次数
 * selectorBlock:   点击事件的回调
 */
+(void)tapWithView: (UIView *)view andNumberOfTouches: (NSInteger)numberOfTouches andNumberOfTaps: (NSInteger)numberOfTaps andSelectorBlock:(void(^)(UITapGestureRecognizer *tap))selectorBlock;
/**
 * 传入view，给View，添加拖动手势
 * view：            手势将被添加到这个view上
 * isSupportMoreGesture 表示是否支持多手势
 * panGesture:   点击事件的回调
 */
+(void)panWithView: (UIView *)view andPanBlock: (void(^)(UIPanGestureRecognizer *panGesture))panBlock;
/**
 * 传入view，给View，添加旋转手势
 * view：            手势将被添加到这个view上
 * isSupportMoreGesture 表示是否支持多手势
 * rotationGesture:   点击事件的回调
 */
+(void)rotationWithView: (UIView *)view andRotationBlock: (void(^)(CGFloat rotation,UIRotationGestureRecognizer *rotationGesture))rotationBlock;
/**
 * 传入view，给View，添加轻扫手势
 * view：          手势将被添加到这个view上
 * isSupportMoreGesture 表示是否支持多手势
 * direction：     轻扫的方向
 * swipeBlock:     事件的回调
 */
+(void)swipeWithView: (UIView *)view andSwipeGrestureDirection: (UISwipeGestureRecognizerDirection)direction andSwipeBlock: (void(^)(UISwipeGestureRecognizer *swipe))swipeBlock;
````
3 . 手势事件的回调都是利用了block，如果外部没有对block进行赋值，那么将执行相应的手势事件相应
.  每个手势事件都对应着声明了一个纯私有block属性，从而保证了事件的传递
````
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
//swipe (清扫手势) 回调的block
@property (nonatomic,copy) void(^swipeBlock)(UISwipeGestureRecognizer *swipe);
@end
```
4 . 默认手势事件的相应举例： 
1. pinch的创建
 1. 首先创建（获取）了一个手势工具类，然后在设置代理，（这里的代理设置主要是因为解决手势冲突）
 2. 给View添加手势
 3. self.panBlock = panBlock;(储存外部传过来的block代码块)
实现pan手势事件
2. pinch手势事件的实现
1.判断，外部的panBlock有没有实现，有就执行，没有就执行默认的相应事件；


```
+(void)panWithView: (UIView *)view andPanBlock: (void(^)(UIPanGestureRecognizer *panGesture))panBlock {
    LYPGestureRecognizerTool *gestureTool = [self sharedGestureRecognizerTool];
    view.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:gestureTool action:@selector(pan:)];
    pan.delegate = gestureTool;
    gestureTool.panBlock = panBlock;
    [view addGestureRecognizer:pan];
}
//拖动事件的相应事件
-(void)pan: (UIPanGestureRecognizer *)pan {
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
    //NSLog(@"------%@",[NSValue valueWithCGPoint:velocity]);
    //重设偏移量
    [pan setTranslation:CGPointZero inView:window];
}
```

#二、 RoundView View裁切类

他可以控制每个角的切圆半径，从而更加灵活，并且可以传入image，进行切割，并且读取切割后的image；

**大体思路**
1.提供两个构造方法（类构造方法，对象构造方法）
```
//MARK: - 实例化方法
+(instancetype) roundViewWithIsCut: (BOOL)isCut andCutRadius: (CGFloat)radius andImage: (UIImage *)image{
    return [[self alloc]initWithIsCut:isCut andCutRadius:radius andImage:image];
}
-(instancetype) initWithIsCut: (BOOL)isCut andCutRadius: (CGFloat)radius andImage: (UIImage *)image {
    if (self = [super init]) {
        //先走这句话，是因为现在的isCut是NO，不会切圆，如果先设置isCut那么radius是nil那么就会使View被切成圆形
        self.radius = radius;
        self.isCut = isCut;
        self.image = image;
    }
    return self;
}
```

2.传入简单的几个属性参数，并对自己的属性赋值，而每个属性赋值的时候都会调用 [self setNeedsDisplay]; 从而重绘图形

1. 属性：
```
//
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
```
2. 方法
```
//
/**截图并且返回图片*/
-(UIImage *)snapshotImage;
/**
 *  综合的改变渲染参数（如果改变多个参数后渲染，建议用此方法）
 */
-(void) imageChengeLeftTopRadiu: (CGFloat)leftTopRadiu andLeftBottomRadiu: (CGFloat)leftBottomRadiu andRightTopRadiu: (CGFloat)rightTopRadiu andRightBottomRadiu: (CGFloat)rightBottomRadiu andCutRect: (CGRect) cutRect andImageAlpha: (CGFloat)alpha;
```
3. 这个方法可以好好看看，规定了上下文中创建切圆的路径并且进行裁切
```
-(void)contextRefWithcontext: (CGContextRef)context {
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
```

#三动画的实现
**大体思路**
利用了displayLink 计时器
还有别忘了调用
`[displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes]; `把它加入到Runloop的common标记的modes中
对于[(Runloop的学习总结请看这里)]()

[好了暂时就这么多了，一切请看github源码](https://github.com/LiPengYue/LYPCALayer)


