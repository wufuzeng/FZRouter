//
//  FZTestThreeViewController.m
//  FZRouter_Example
//
//  Created by 吴福增 on 2019/7/10.
//  Copyright © 2019 wufuzeng. All rights reserved.
//

#import "FZTestThreeViewController.h"

@interface FZTestThreeViewController ()

@end

@implementation FZTestThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"第三个";
    self.view.backgroundColor = [UIColor yellowColor];
    
    UIButton * button = [UIButton new];
    button.backgroundColor = [UIColor blueColor];
    button.frame = CGRectMake(0, 0, 60, 30);
    button.center = self.view.center;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)buttonAction:(UIButton *)sender{
    
    [FZRouter open:@"local://key4"];
}

@end
