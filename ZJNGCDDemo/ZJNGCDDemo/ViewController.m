//
//  ViewController.m
//  ZJNGCDDemo
//
//  Created by 朱佳男 on 2017/12/21.
//  Copyright © 2017年 ShangYuKeJi. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((ScreenWidth-100)/2.0, 100, 100, 44);
    button.backgroundColor = [UIColor lightGrayColor];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitle:@"获取验证码" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    unsigned int count;
    Ivar *ivarList = class_copyIvarList([UITextView class], &count);
    for (unsigned int i =0; i <count; i ++) {
        Ivar textViewIvar = ivarList[i];
        const char *ivarName = ivar_getName(textViewIvar);
        NSLog(@"textViewIvar++++%@",[NSString stringWithUTF8String:ivarName]);
    }
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 200, ScreenWidth-20, 100)];
    textView.textColor = [UIColor darkTextColor];
    textView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:textView];
    
    UILabel *placeHolderLabel = [[UILabel alloc]init];
    placeHolderLabel.text = @"请输入内容";
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    [placeHolderLabel sizeToFit];
    [textView addSubview:placeHolderLabel];
    
    textView.font = [UIFont systemFontOfSize:15];
    [textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)getCode:(UIButton *)button{
    __block UIButton *kButton = button;
    __block NSInteger time = 59;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if (time <=0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [kButton setTitle:@"重新发送" forState:UIControlStateNormal];
            });
            kButton.userInteractionEnabled = YES;
        }else{
            int second = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                [kButton setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", second] forState:UIControlStateNormal];
                button.userInteractionEnabled = NO;
            });
            time --;
        }
    });
    dispatch_resume(_timer);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
