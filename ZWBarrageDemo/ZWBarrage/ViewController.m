//
//  ViewController.m
//  ZWBarrage
//
//  Created by William Chang on 16/11/28.
//  Copyright © 2016年 William Chang. All rights reserved.
//

#import "ViewController.h"
#import "SubController.h"
#import "ZWBarrageKit.h"            // ----- step : 1

@interface ViewController () <ZWBarrageManagerDelegate>     // ----- step : 2

@property (strong, nonatomic) ZWBarrageManager *manager;    // ----- step : 3
@property (strong, nonatomic) UIView *showView;             // ----- step : 4

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /*
    //dataSource
    NSString *danmakufile = [[NSBundle mainBundle] pathForResource:@"file" ofType:nil];
    NSArray *fileArray = [NSArray arrayWithContentsOfFile:danmakufile];
    
    NSMutableArray *dataArray2 = [@[] mutableCopy];  // 用于存放弹幕
    for (NSDictionary *dic in fileArray) {
        [dataArray2 addObject:dic[@"m"]];
    }

    // 解析弹幕标准数据 255402(弹幕时间戳),1(弹幕显示模式, 默认滚动模式),12(弹幕字体大小),DBFF00(弹幕字体颜色),19416565(发弹幕的用户id)
    NSMutableArray *dataArray3 = [@[] mutableCopy];
    for (NSDictionary *dic in fileArray) {
        NSString *parameterStr = dic[@"p"];
        NSArray *parameterArr = [parameterStr componentsSeparatedByString:@","];    // 将字符串以逗号隔开保存进数组
        [dataArray3 addObject:parameterArr];
        //        NSString *timeStr = parameterArr[0];
        //        NSString *modeStr = parameterArr[1];
        //        NSString *fontStr = parameterArr[2];
        //        NSString *colorStr = parameterArr[3];
        //        NSString *idStr = parameterArr[4];
    }
    */

    [self setupBarrage];
    
}
// ----- step : 5
- (void)setupBarrage {
    self.view.backgroundColor = [UIColor whiteColor];
    
    _manager = [ZWBarrageManager manager];
    _showView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 250)];
    _showView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_showView];
    _manager.bindingView = _showView;
    _manager.delegate = self;
    _manager.scrollSpeed = 50;
    _manager.memoryMode = ZWBarrageMemoryWarningModeHalf;               // 弹幕内存管理模式
    _manager.refreshInterval = 2.0f;
    _manager.scrollDirection = ZWBarrageScrollDirectRightToLeft;        // 弹幕方向
    [_manager startScroll];
}
// ----- step : 6
#pragma mark - BarrageManagerDelegate
- (id)barrageManagerDataSource {
    int a = arc4random() % 10000;
    NSString *str = [NSString stringWithFormat:@" %d年太久, 只争朝夕", a];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, str.length)];
    
    ZWBarrageModel *m = [[ZWBarrageModel alloc] initWithBarrageContent:attr];
    m.displayLocation = _manager.displayLocation;
    m.direction       = _manager.scrollDirection;
    m.barrageType = ZWBarrageDisplayTypeBackImageView;       // 显示模式以数据源内设置为准
//    m.object = [UIImage imageNamed:[NSString stringWithFormat:@"Vote_%d",arc4random() % 10]];       // 如果为投票模式, 必须如此设置
    return m;

}
#pragma mark - Barrage interraction 
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:_manager.bindingView];
    [[_manager barrageScenes] enumerateObjectsUsingBlock:^(ZWBarrageScene * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.layer.presentationLayer hitTest:touchPoint]) {
            /* if barrage's type is ` ZWBarrageDisplayTypeVote ` or `ZWBarrageDisplayTypeImage`, add your code here*/
            [obj pause];
        }
    }];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint endPoint = [touch locationInView:_manager.bindingView];
    [[_manager barrageScenes] enumerateObjectsUsingBlock:^(ZWBarrageScene * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.layer.presentationLayer hitTest:endPoint]) {
            SubController *sub = [[SubController alloc] init];
            sub.title = obj.model.message.string;
            [self.navigationController pushViewController:sub animated:YES];
            [obj resume];
        }
    }];
}

#pragma mark - Control Barrage
- (IBAction)cleanAll:(id)sender {
    [_manager closeBarrage];
}

- (IBAction)pauseAll:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected == YES) {
        [sender setTitle:@"ReStartAll" forState:UIControlStateNormal];
    }else{
        [sender setTitle:@"pauseAll" forState:UIControlStateNormal];
    }
    // 1. On the screen the barrage is suspended, and stop acquiring new barrage
    // 2. The current barrage on the screen to start rolling, and to obtain a new barrage
    [_manager pauseScroll];
}

- (IBAction)restartClick:(id)sender {
    [_manager startScroll];
}
// ----- step : 0
#pragma mark - Must do this!
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_manager resumeScroll];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_manager pauseScroll];
    
}
- (void)dealloc {
    [_manager closeBarrage];
    [_manager toDealloc];
}

- (void)didReceiveMemoryWarning {
    [_manager didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
