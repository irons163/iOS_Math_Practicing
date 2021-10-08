//
//  GameOverViewController.m
//  Easy_Dodge
//
//  Created by irons on 2015/7/3.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "GameWinViewController.h"
#import "CommonUtil.h"
#import "ViewController.h"

@interface GameWinViewController ()

@end

@implementation GameWinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gameScoreLabel.text = [CommonUtil timeFormatted:self.gameTime];
}

- (IBAction)restartClick:(id)sender {
    [self dismissViewControllerAnimated:true completion:^{
        [self.gameDelegate restartGame];
    }];
}

@end
