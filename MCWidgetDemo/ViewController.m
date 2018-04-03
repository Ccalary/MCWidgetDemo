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
    
    [self saveFile];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// NSFileManager 存储数据
- (void)saveFile {
    NSError *error = nil;
    NSURL *containUrl = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.rs.testGroup"];
   containUrl = [containUrl URLByAppendingPathComponent:@"group.data"];
    NSString *text = @"打开app";
    BOOL result = [text writeToURL:containUrl atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (result){
        NSLog(@"save success");
    }else {
        NSLog(@"error:%@", error);
    }
}

@end
