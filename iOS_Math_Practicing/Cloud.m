//
//  Cloud.m
//  Try_Shoot_learning
//
//  Created by irons on 2015/7/21.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "Cloud.h"

@implementation Cloud

- (void)setNum:(int)num {
    _num = num;
    self.numNode = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%d", num]];
    self.numNode.fontColor = [UIColor greenColor];
    self.numNode.fontName = @"Blod";
    self.numNode.fontSize = 27;
    self.numNode.position = CGPointMake(self.numNode.position.x, self.numNode.position.y - self.numNode.frame.size.height/2.0f);
    [self addChild:self.numNode];
}


@end
