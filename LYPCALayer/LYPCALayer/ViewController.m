//
//  ViewController.m
//  LYPCALayer
//
//  Created by 李鹏跃 on 17/1/30.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

#import "ViewController.h"
#import "RoundView.h"//裁切的view类
#import "LYPGestureRecognizerTool.h"//手势工具类
#import "DrawRectView.h"//ViewController的底色类

@interface ViewController ()

@property (nonatomic,weak) RoundView *roundView;//截图的view
@property (nonatomic,strong) CADisplayLink *displayLink;//计时器
@property (nonatomic,assign) BOOL isLittle;//是否小于0.3或者大于0.7
@property (nonatomic,strong) UIImageView *cutImageView;//显示截图的image

@end


@implementation ViewController

//改变跟视图（啦啦啦~ 我只是喜欢那个渐变的颜色）
- (void)loadView {
    self.view = [[DrawRectView alloc]initWithFrame:[UIScreen mainScreen].bounds];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubView];
}

- (void)setupSubView {
    //创建RoundView
    RoundView*view = [[RoundView alloc]initWithIsCut:YES andCutRadius:30 andImage:nil];
    view.frame = CGRectMake(30, 100, 300, 310);
    
    //添加图片
    UIImage *image = [UIImage imageNamed:@"1.1"];
    view.image = image;
    self.roundView = view;
    [self.view addSubview:view];
    
    //添加手势
    [LYPGestureRecognizerTool pinchWithView:self.roundView andPinchBlock:nil];
    [LYPGestureRecognizerTool panWithView:self.roundView andPanBlock:nil];
    [LYPGestureRecognizerTool rotationWithView:view andRotationBlock:nil];
    
    //设置切割的范围
    [view imageChengeLeftTopRadiu:100 andLeftBottomRadiu:50 andRightTopRadiu:23 andRightBottomRadiu:150 andCutRect:CGRectMake(0, 0, 300, 300) andImageAlpha:.8];
    
    //添加截图View
    self.cutImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.view addSubview: self.cutImageView];
    
    //2017新年快乐~
    UILabel *happyNewYearlable = [[UILabel alloc]init];
    happyNewYearlable.text = @"2017新年快乐~";
    happyNewYearlable.font = [UIFont systemFontOfSize:25];
    happyNewYearlable.textColor = [UIColor redColor];
    happyNewYearlable.alpha = .8;
    happyNewYearlable.frame = CGRectMake(self.view.frame.size.width - 200, self.view.frame.size.height - 100, 250, 50);
    [self.view addSubview:happyNewYearlable];
    
}


//MARK: - 点击屏幕截图并且开始动画
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //额只是为了使用到懒加载
    self.displayLink;
    self.cutImageView.image = [self.roundView snapshotImage];
}


//MARK: 懒加载displayLink
- (CADisplayLink *)displayLink {
    if (!_displayLink) {
        [_displayLink invalidate];
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkSelector)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _displayLink;
}

-(void)displayLinkSelector {
    
    //这里判断是是否大于0.7 （小于0.3）并做相应的调整
    if ( self.roundView.alpha > .7) {
        self.isLittle = NO;
    }
    if (self.roundView.alpha < .3) {
        self.isLittle = YES;
    }
    
    //下面的代码只是改变了roundView的属性的值，不用细看
    if (self.isLittle) {
        
        [self.roundView imageChengeLeftTopRadiu:self.roundView.leftTopRadiu += 1
                             andLeftBottomRadiu:self.roundView.leftBottomRadiu+= 1
                               andRightTopRadiu:self.roundView.rightTopRadiu += 1
                            andRightBottomRadiu:self.roundView.rightBottonRadiu += 1
                                     andCutRect:CGRectMake(0, 0, self.roundView.frame.size.width + self.roundView.rightTopRadiu, self.roundView.frame.size.height + self.roundView.rightTopRadiu)
                                  andImageAlpha:self.roundView.alpha += .01];
        
    }else {
        
        [self.roundView imageChengeLeftTopRadiu:self.roundView.leftTopRadiu -= 1
                             andLeftBottomRadiu:self.roundView.leftBottomRadiu -= 1
                               andRightTopRadiu:self.roundView.rightTopRadiu -= 1
                            andRightBottomRadiu:self.roundView.rightBottonRadiu -= 1
                                     andCutRect:CGRectMake(0, 0, self.roundView.frame.size.width + self.roundView.rightTopRadiu, self.roundView.frame.size.height + self.roundView.rightTopRadiu)
                                  andImageAlpha:self.roundView.alpha -= .01];
    }
    
}
@end
