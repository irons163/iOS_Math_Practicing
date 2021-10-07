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
    // Do any additional setup after loading the view.
    self.gameScoreLabel.text = [CommonUtil timeFormatted:self.gameTime];
//    self.gameScoreLabel.text = [NSString stringWithFormat:@"%d", self.gameTime];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)restartClick:(id)sender {
    [self dismissViewControllerAnimated:true completion:^{
        [self.gameDelegate restartGame];
    }];
}
@end
