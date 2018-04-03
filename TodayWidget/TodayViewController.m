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
        // 折叠后的大小是固定的，目前测试的更改无效，默认高度应该是110
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

- (void)initView {
    // 和主应用的数据共享，获取主应用里的数据
    NSUserDefaults *sharedData = [[NSUserDefaults alloc] initWithSuiteName:@"group.rs.testGroup"];
    NSString *name = [sharedData objectForKey:@"name"];
    // 官方建议使用自动布局创建控件，这里是写的固定的
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2.0, 50)];
    label.text = [NSString stringWithFormat:@"姓名：%@",name];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blueColor];
    [self.view addSubview:label];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.0, 0, self.view.frame.size.width/2.0, 50)];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:[self readByFileManager] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    // 添加计时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 50)];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.textColor = [UIColor redColor];
    [self.view addSubview:_timeLabel];
    _count = 100;
}

// NSFileManager 读取数据
- (NSString *)readByFileManager {
    NSError *error = nil;
    NSURL *containUrl = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.rs.testGroup"];
    containUrl = [containUrl URLByAppendingPathComponent:@"group.data"];
    NSString *text = [NSString stringWithContentsOfURL:containUrl encoding:NSUTF8StringEncoding error:&error];
    return text;
}

- (void)timerAction {
    if (_count > 0){
        _count -= 1;
    }else {
        _count = 100;
    }
    _timeLabel.text = [NSString stringWithFormat:@"倒计时：%ds",_count];
}

// 点击按钮打开主app
- (void)btnAction {
    [self.extensionContext openURL:[NSURL URLWithString:@"TodayWidget://"] completionHandler:^(BOOL success) {
        
    }];
}

@end
