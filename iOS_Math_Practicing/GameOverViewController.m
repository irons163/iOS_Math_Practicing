//
//  GameOverViewController.m
//  Easy_Dodge
//
//  Created by irons on 2015/7/3.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "GameOverViewController.h"
#import "CommonUtil.h"
#import "ViewController.h"

@interface GameOverViewController ()

@end

@implementation GameOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gameScoreLabel.text = [NSString stringWithFormat:@"%d", self.gameTime];
}

- (IBAction)restartClick:(id)sender {
    [self dismissViewControllerAnimated:true completion:^{
        [self.gameDelegate restartGame];
    }];
}

@end
