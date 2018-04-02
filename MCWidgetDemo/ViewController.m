//
//  ViewController.m
//  MCWidgetDemo
//
//  Created by chh on 2018/3/30.
//  Copyright © 2018年 chh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *sharedData = [[NSUserDefaults alloc] initWithSuiteName:@"group.rs.testGroup"];
    [sharedData setValue:@"Mr Right" forKey:@"name"];
    [sharedData synchronize];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
