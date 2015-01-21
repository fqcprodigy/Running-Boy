//
//  AnimationHelper.m
//  ours
//
//  Created by Dante Fan on 11/3/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "AnimationHelper.h"
@implementation AnimationHelper

+(CCAnimation *)animationWithPrefix:(NSString *)prefix startFrameIdx:(unsigned int)startFrameIdx frameCount:(unsigned int)frameCount delay:(float)delay
{
    NSUInteger idxCount = frameCount + startFrameIdx;
    NSMutableArray *frames=[[NSMutableArray alloc] init];
    int i;
    CCSpriteFrame *frame;
    for (i = startFrameIdx; i < idxCount; i++)
    {
        frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@_%02d.png", prefix, i]];
        [frames addObject:frame];
    }
    
    return [CCAnimation animationWithSpriteFrames:frames delay:delay];
}

@end
