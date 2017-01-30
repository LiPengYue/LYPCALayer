//
//  ViewController.m
//  LYPCALayer
//
//  Created by 李鹏跃 on 17/1/30.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

#import "ViewController.h"
#import "RoundView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     RoundView*view = [[RoundView alloc]initWithIsCut:YES andCutRadius:0 andImage:nil];
    view.frame = CGRectMake(100, 100, 100, 100);
    view.backgroundColor = [UIColor redColor];
    
    
    UIImage *image = [UIImage imageNamed:@"2.2"];
    view.image = image;
    
    [self.view addSubview:view];
    [view setNeedsDisplay];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
