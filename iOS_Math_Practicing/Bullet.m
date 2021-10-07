//
//  Bullet.m
//  Try_Cat_Shoot
//
//  Created by irons on 2015/3/26.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "Bullet.h"

@implementation Bullet

- (id)init {
    if (self=[super init]) {
        self.hitPower = 1;
    }
    return self;
}

- (instancetype)initWithImageNamed:(NSString *)name{
    return [super initWithImageNamed:name];
}

- (instancetype)initWithTexture:(SKTexture *)texture{
    return [super initWithTexture:texture];
}

- (instancetype)initWithTexture:(SKTexture *)texture color:(UIColor *)color size:(CGSize)size{
    self.hitPower = 1;
    return [super initWithTexture:texture color:color size:size];
}

@end
