//
//  TodayViewController.m
//  TodayWidget
//
//  Created by chh on 2018/3/30.
//  Copyright © 2018年 chh. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, assign) int count;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated {
    // 设置折叠还是展开
    // 设置展开才会展示，设置折叠无效，左上角不会出现按钮， ❓
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
}

// 展开／折叠监听
- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize{
    
    if (activeDisplayMode == NCWidgetDisplayModeCompact) { //折叠
        // 折叠后的大小是固定的，目前测试的更改无效
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 100);
    }else { // 展开
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 300);
    }
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
}

- (void)initView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    label.text = @"点我打开App";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    label.textColor = [UIColor blueColor];
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aTapAction)];
    [label addGestureRecognizer:aTap];
    
    NSUserDefaults *sharedData = [[NSUserDefaults alloc] initWithSuiteName:@"group.rs.testGroup"];
    NSString *name = [sharedData objectForKey:@"name"];
    label.text = name;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 50)];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.textColor = [UIColor redColor];
    [self.view addSubview:_timeLabel];
    _count = 100;
}

- (void)timerAction {
    if (_count > 0){
        _count -= 1;
    }else {
        _count = 100;
    }
    _timeLabel.text = [NSString stringWithFormat:@"倒计时：%ds",_count];
}

- (void)aTapAction {
    [self.extensionContext openURL:[NSURL URLWithString:@"TodayWidget://"] completionHandler:^(BOOL success) {
        
    }];
}

@end
