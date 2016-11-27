//
//  ViewController.m
//  ZWBarrage
//
//  Created by William Chang on 16/11/28.
//  Copyright © 2016年 William Chang. All rights reserved.
//

#import "ViewController.h"
#import "SubController.h"
#import "BarrageView.h"

@interface ViewController ()

@property (strong, nonatomic) BarrageView *moveView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //dataSource
    NSString *danmakufile = [[NSBundle mainBundle] pathForResource:@"file" ofType:nil];
    NSArray *fileArray = [NSArray arrayWithContentsOfFile:danmakufile];
    
    NSMutableArray *dataArray2 = [@[] mutableCopy];  //创建一个空数组存放弹幕
    for (NSDictionary *dic in fileArray) {
        [dataArray2 addObject:dic[@"m"]];
    }
    // 解析弹幕标准数据 255402(弹幕时间戳),1(弹幕显示模式, 默认滚动模式),12(弹幕字体大小),DBFF00(弹幕字体颜色),19416565(发弹幕的用户id)
    NSMutableArray *dataArray3 = [@[] mutableCopy];
    for (NSDictionary *dic in fileArray) {
        NSString *parameterStr = dic[@"p"];
        NSArray *parameterArr = [parameterStr componentsSeparatedByString:@","];
        [dataArray3 addObject:parameterArr];
        //        NSString *timeStr = parameterArr[0];
        //        NSString *modeStr = parameterArr[1];
        //        NSString *fontStr = parameterArr[2];
        //        NSString *colorStr = parameterArr[3];
        //        NSString *idStr = parameterArr[4];
    }

    __weak typeof(self) weakSelf = self;
    self.moveView = [[BarrageView alloc]initWithFrame:CGRectMake(0, 80, [UIScreen mainScreen].bounds.size.width, 240) dataArray:dataArray2 tapBlock:^(NSInteger index) {
        NSLog(@"点击了:%@",dataArray2[index]);
        [weakSelf.moveView pause];
        NSString *danmuStr = dataArray2[index];
        NSString *idStr = dataArray3[index][4];
        NSArray *topicDetailArr = [NSArray arrayWithObjects:danmuStr, idStr, nil];
        SubController *subVC = [[SubController alloc] init];
        [weakSelf presentViewController:subVC animated:YES completion:nil];
//        [weakSelf performSegueWithIdentifier:@"push" sender:topicDetailArr];  // 点击, 进入相应的话题页
    }];
    [self.view addSubview: self.moveView];
    
    self.moveView.layer.contents = (id)[UIImage imageNamed:@"house.jpg"].CGImage;
    
    
}
- (IBAction)touchThis:(id)sender {
    SubController *subVC = [[SubController alloc] init];
    [self presentViewController:subVC animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self.moveView resume];
    
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.moveView pause];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
