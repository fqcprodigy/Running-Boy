//
//  Shark.m
//  ours
//
//  Created by Dante Fan on 10/25/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Shark.h"
#import "CCAnimation.h"
#import "AnimationHelper.h"
#import "Player.h"
extern Player* globalplayer;
@implementation Shark
{
    CGPoint original;
    bool isBite;

}


- (void)didLoadFromCCB
{
    original=self.position;
    self.disappearAction=[CCActionFadeOut actionWithDuration:1];
    self.appearAction=[CCActionFadeIn actionWithDuration:0.5];
    id chaseup=[CCActionMoveBy actionWithDuration:0.5 position:ccp(0, 10)];
    id chasedown=[CCActionMoveBy actionWithDuration:0.5 position:ccp(0, -10)];
    id chase=[CCActionSequence actions:chaseup,chasedown, nil];
    self.chaseAction=[CCActionRepeat actionWithAction:chase times:8];
    CCAnimation *bite=[AnimationHelper animationWithPrefix:@"Sharkpics/Shark" startFrameIdx:0 frameCount:6 delay:1/6.0];
    self.biteAction=[CCActionAnimate actionWithAnimation:bite];
    isBite=false;

}

- (void)disappear
{
    [self runAction:_disappearAction];
    if(globalplayer.collision==2) globalplayer.life-=80;
    globalplayer.collision=0;
    isBite=false;
}

- (void)showup
{
    if(!isBite)
    {
        id all=[CCActionSequence actions:_appearAction,_chaseAction,[CCActionCallFunc actionWithTarget:self selector:@selector(disappear)], nil];
        [self runAction:all];
    }

}

- (void)bite
{
    isBite=TRUE;
    CGPoint CHASE=ccpAdd(globalplayer.position, ccp(0,30));
    id onbite=[CCActionMoveTo actionWithDuration:0.5 position:CHASE];
    id endbite=[CCActionMoveTo actionWithDuration:0.5 position:original];
    id allbite=[CCActionSequence actions:onbite,endbite, nil];
    id bite=[CCActionSpawn actions:_biteAction,allbite, nil];
    [self stopAllActions];
    id all=[CCActionSequence actions:bite,_chaseAction,[CCActionCallFunc actionWithTarget:self selector:@selector(disappear)], nil];
    [self runAction:all];
}

//-(void) changebite
//{
//    isBite=false;
//    globalplayer.life-=80;
//}

-(void)beaten
{
    [self stopAllActions];
    [self runAction:_beatenAction];
}

@end
