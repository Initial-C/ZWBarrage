//
//  SubController.m
//  ZWBarrage
//
//  Created by William Chang on 16/11/28.
//  Copyright © 2016年 William Chang. All rights reserved.
//

#import "SubController.h"

@interface SubController ()

@end

@implementation SubController

//- (instancetype)init {
//    if (self = [super init]) {
//        self.restorationIdentifier = @"push";
//    }
//    return self;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissBtn setTitle:@"Dismiss" forState:UIControlStateNormal];
    [dismissBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    dismissBtn.frame = CGRectMake(160, 200, 80, 30);
    [dismissBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    dismissBtn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:dismissBtn];
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(160, 80, 66, 30)];
    title.text = self.topicName;
    [self.view addSubview:title];
    
}
- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
