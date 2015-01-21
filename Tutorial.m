//
//  Tutorial.m
//  ours
//
//  Created by In Lee on 11/27/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Tutorial.h"


@implementation Tutorial

-(void)didLoadFromCCB
{
    self.userInteractionEnabled=true;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCScene *tutorialScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector]replaceScene:tutorialScene];
}

@end
