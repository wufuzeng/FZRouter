//
//  FZViewController.m
//  FZRouter
//
//  Created by wufuzeng on 07/10/2019.
//  Copyright (c) 2019 wufuzeng. All rights reserved.
//

#import "FZViewController.h"

@interface FZViewController ()

@end

@implementation FZViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"Zero";
    
    
    UIButton * button = [UIButton new];
    button.backgroundColor = [UIColor blueColor];
    button.frame = CGRectMake(0, 0, 60, 30);
    button.center = self.view.center;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
}

-(void)buttonAction:(UIButton *)sender{
    
    [FZRouter open:@"local://key1"];
}

@end
