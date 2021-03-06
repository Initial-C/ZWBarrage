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
@property (nonatomic, strong) NSArray *barrageArr;

@property (nonatomic, strong) NSURL *url1;
@property (nonatomic, strong) NSURL *url2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    //dataSource
    NSString *danmakufile = [[NSBundle mainBundle] pathForResource:@"file" ofType:nil];
    NSArray *fileArray = [NSArray arrayWithContentsOfFile:danmakufile];
    
    NSMutableArray *dataArray2 = [@[] mutableCopy];  // 用于存放弹幕
    for (NSDictionary *dic in fileArray) {
        [dataArray2 addObject:dic[@"m"]];
    }
    self.barrageArr = dataArray2;
    /*
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
    _showView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Cribug" ofType:@"mp4"];
    self.url1 = [NSURL fileURLWithPath:path];
    self.url2 = [NSURL URLWithString:@"http://113.107.44.146/ws.acgvideo.com/7/f4/17328922-1.mp4?wsTime=1494581048&platform=html5&wsSecret2=e8258abbcb84e35911c2c0ef44a8df89&oi=2015985690&rate=110&wshc_tag=0&wsts_tag=59156a06&wsid_tag=7829801a&wsiphost=ipdbm"];
//    NSURL *url3 = (int)arc4random_uniform(2) == 1 ? url1 : url2;
//    ZWAVPlayer *avplayerV = [[ZWAVPlayer alloc] initWithFrame:_showView.bounds withPlayerURL:url3];
//    [_showView addSubview:avplayerV];
    [self.view addSubview:_showView];
    _manager.bindingView = _showView;
    _manager.playerURL = _url1;                                         // 设置视频弹幕器视频源, 注: 必须在bindingView后赋值
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
    int a = arc4random() % self.barrageArr.count;
//    NSString *str = [NSString stringWithFormat:@"%d年", a];     // 自定义的弹幕数据
    NSString *str = _barrageArr[a];
    UIImage *backImage = [UIImage imageNamed:@"tx_danmu"];      // 设置弹幕个性背景图
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, str.length)];
    ZWBarrageModel *m = [[ZWBarrageModel alloc] initWithNumberID:0 BarrageContent:attr Author:nil Object:nil BackImage:backImage];
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
            // 这里可以增加弹出框, 输入想要添加的弹幕, 将弹幕添加到弹幕数组barrageArr中即可
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

- (IBAction)changeSourceClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        _manager.playerURL = _url2;
    } else {
        _manager.playerURL = _url1;
    }
}

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
