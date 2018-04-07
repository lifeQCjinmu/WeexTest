//
//  ViewController.m
//  WeexTest
//
//  Created by mac on 2018/4/7.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ViewController.h"
#import <WeexSDK/WXSDKInstance.h>
@interface ViewController ()
@property(nonatomic,strong)WXSDKInstance *instance;////WXSDKInstance 属性
@property(nonatomic,strong)UIView *weexView;// weex 视图
@end

@implementation ViewController
#pragma mark - 懒加载

- (void)viewDidLoad {
      [super viewDidLoad];
      [self.navigationController.navigationBar setHidden:YES];
      [self inintWeexRender];
}
- (void)dealloc
{
      [_instance destroyInstance];
}
- (void)inintWeexRender{
      self.instance = [[WXSDKInstance alloc] init];

      // 设置weexInstance所在的控制器

      self.instance.viewController = self;

      // 设置weexInstance的frame

      self.instance.frame = self.view.frame;

      // 设置weexInstance用于渲染JS的url路径
      NSString *filePath = [NSString stringWithFormat:@"file://%@/JSResources/web-demo.js",[NSBundle mainBundle].bundlePath];

      NSURL *url = [NSURL URLWithString:filePath];

      [self.instance renderWithURL:url options:@{@"bundleUrl":url} data:nil];

      // 为避免循环引用 声明一个弱指针 self

      __weak typeof(self) weakSelf = self;

      // 设置weexInstance创建完的回调

      self.instance.onCreate = ^(UIView *view) {

            [weakSelf.weexView removeFromSuperview];
            weakSelf.weexView = view;
            [weakSelf.view addSubview:weakSelf.weexView];
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, weakSelf.weexView);

      };

      _instance.onFailed = ^(NSError *error) {
            NSLog(@"failed %@",error);
      };

      _instance.renderFinish = ^(UIView *view) {
            NSLog(@"render finish");
      };

      _instance.updateFinish = ^(UIView *view) {
            NSLog(@"update Finish");
      };
}

- (void)didReceiveMemoryWarning {
      [super didReceiveMemoryWarning];
      // Dispose of any resources that can be recreated.
}


@end
