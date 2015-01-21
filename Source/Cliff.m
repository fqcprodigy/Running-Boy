//
//  Cliff.m
//  ours
//
//  Created by Dante Fan on 10/16/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Cliff.h"

@implementation Cliff
- (void)didLoadFromCCB
{
    
}

-(void) hitplayer
{
    CCAnimationManager* man=self.animationManager;
    [man runAnimationsForSequenceNamed:@"hit"];
}

- (void)destroy
{
    //[self runAction:_disappearAction];
    [self removeFromParent];
}

@end
