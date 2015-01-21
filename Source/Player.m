//
//  Player.m
//  ours
//
//  Created by Dante Fan on 10/16/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Player.h"
#import "CCAnimation.h"
#import "AnimationHelper.h"
#import "Shark.h"

extern NSString* deadcause;
extern OALSimpleAudio* globalaudio;
extern Shark* globalshark;
extern CCButton* globalrush;
extern bool adjust;
@implementation Player
{
}

- (void)didLoadFromCCB
{
    self.physicsBody.collisionType=@"Player";
    //tripped over
    CCAnimation *trippedover=[AnimationHelper animationWithPrefix:@"playerpics/boy" startFrameIdx:1 frameCount:2 delay:0.1];
    id tripped=[CCActionAnimate actionWithAnimation:trippedover];
    id tripover=[CCActionRepeat actionWithAction:tripped times:4];
    self.trippedoverAction=[CCActionSequence actions:tripover,[CCActionCallFunc actionWithTarget:self selector:@selector(idle)], nil];
    //
    self.dieAction=[CCActionMoveBy actionWithDuration:1 position:ccp(1,1)];
    
    //bitenbyshark
    id inandout=[CCActionSequence actions:[CCActionFadeOut actionWithDuration:0.08],[CCActionFadeIn actionWithDuration:0.08],nil];
    id bite=[CCActionRepeat actionWithAction:inandout times:3];
    id biten=[CCActionSpawn actions:tripover,bite, nil];
    self.bitenbysharkAction=[CCActionSequence actions:biten,[CCActionCallFunc actionWithTarget:self selector:@selector(idle)],nil];
    
    //self.crushoverAction=[CCActionMoveBy actionWithDuration:1 position:ccp(1,1)];
    //self.recoverAction=[CCActionMoveBy actionWithDuration:1 position:ccp(1,1)];
    //self.rushAction=[CCActionMoveBy actionWithDuration:1 position:ccp(1,1)];
    
    //jump
    CCAnimation *onjump=[AnimationHelper animationWithPrefix:@"playerpics/boy" startFrameIdx:6 frameCount:3 delay:0.33];
    self.jumpRiseAction=[CCActionSequence actions:[CCActionAnimate actionWithAnimation:onjump],[CCActionCallFunc actionWithTarget:self selector:@selector(idle)], nil];
    
    //onfish
    CCAnimation *onfish=[AnimationHelper animationWithPrefix:@"playerpics/boy" startFrameIdx:4 frameCount:2 delay:0.5];
    id rushfish=[CCActionRepeat actionWithAction:[CCActionAnimate actionWithAnimation:onfish] times:6];
    self.onfishAction=[CCActionSequence actions:rushfish,[CCActionCallFunc actionWithTarget:self selector:@selector(idle)], nil];
    self.eatstarAction=[CCActionMoveBy actionWithDuration:1 position:ccp(1,1)];
    
    
    //die
    self.dieAction=[CCActionDelay actionWithDuration:2];
    
    //sound

    _life=200;
    _original=5;
    _velocity=5;
    _score=0;
    _eatenstar=0;
    _can_rush=0;

}

- (void)die:(id) obj withSelector:(SEL)selector
{
    if (_Pstatus != Dead)
    {
        [self stopAllActions];
        [globalaudio stopEverything];
        self.opacity=0;
        [globalaudio playEffect:@"Lose.mp3"];
        [self runAction:[CCActionSequence actions:_dieAction,[CCActionCallFunc actionWithTarget:obj selector:selector], nil]];
        _velocity = 0;
        _Pstatus=Dead;
    }

}

- (void)idle
{
        [self stopAllActions];
    self.scale=0.25;
        [globalaudio stopAllEffects];
        [globalaudio setBgPaused:false];
        CCAnimationManager *ma=self.animationManager;
        [ma setPaused:FALSE];
        _velocity = _original;//need to ajust;
        if(self.can_rush==10)
            globalrush.enabled=true;
        if(_Pstatus!=Regular)
            [ma runAnimationsForSequenceNamed:@"idle"];
        if(self.collision==1)
        {
            _life-=10;
            
        }
        _Pstatus=Regular;
    
        self.opacity=1;
}

//- (void)hitbymonster
//{
//    [self stopAllActions];
//    deadcause=@"Hit by a Monster!";
//    [self knockout];
//}

- (BOOL)hitbyfish
{
    if(_Pstatus==Regular)
    {
        [self stopAction:_bitenbysharkAction];
        [self runAction:_bitenbysharkAction];
        deadcause=@"Hit by SwordFish!";
        return true;
    }
    return false;

}

//-(int)check_life
//{
//    if(_life>200) _life=200;
//    if(_life<=0)
//    {
//        [self die];
//    }
//    if(_Pstatus==Regular) [self idle];
//    return _life;
//}

- (void) jumpRise
{
    adjust=false;
    [self stopAction:_jumpRiseAction];
    [globalaudio playEffect:@"jump1.wav"];
    if(_Pstatus==Regular)
        [self.animationManager setPaused:true];
    if (_Pstatus != Rush_fish&&_Pstatus!=Rush_nofish)
    {
        [self runAction:_jumpRiseAction];
    }
    _life-=10;
    deadcause=@"Energy Exhausted";
}

//-(void) jumpFall
//{
//    [self runAction:_jumpFallAction];
//}

-(void) Rushnofish
{
    [globalaudio setBgPaused:true];
    self.can_rush=0;
    globalrush.enabled=NO;
    //self.physicsBody.density=1;// original weight.
    if(self.collision>0)
    {
        [globalshark stopAllActions];
        [globalshark disappear];
    }
    if(_Pstatus==Rush_fish)
    {
        //[self runAction:_rushAction];
        _velocity *=1.5 ;//need to ajust;
        return;
    }
    else if(_Pstatus!=Rush_nofish)
    {
        _velocity *=1.8 ;//need to ajust;
        [self stopAllActions];
        [globalaudio playEffect:@"rush.mp3"];
        _Pstatus=Rush_nofish;
        [self.animationManager runAnimationsForSequenceNamed:@"rush"];
    }
    
    self.opacity=1;

    
}

-(void)Rushfish
{
    [globalaudio setBgPaused:true];
    [self stopAllActions];
    self.scale=0.4;
    [self.animationManager setPaused:true];
    if(self.collision>0)
    {
        [globalshark stopAllActions];
        [globalshark disappear];
    }
    if(_Pstatus==Rush_nofish)
    {
        //[self runAction:_rushAction];
        _Pstatus=Rush_fish;
        _velocity *=1.5 ;//need to ajust;
        [self runAction:_onfishAction];
    }
    else if(_Pstatus!=Rush_fish)
    {
        
        [globalaudio playEffect:@"rush.mp3"];
        _Pstatus=Rush_fish;
        _velocity *=1.8 ;
        [self runAction:_onfishAction];
        //need to ajust;
    }
    self.opacity=1;
}

-(void) biten
{
    [self runAction:_bitenbysharkAction];
    deadcause=@"Biten by Shark!";
}

-(void) recover
{
    //[self runAction:_recoverAction];
    _life+=80;
    if(_life>200) _life=200;
    //[self check_life];
}

-(int)knockout
{
    CCAnimationManager *ma=self.animationManager;
    
    if(_Pstatus==Rush_nofish||_Pstatus==Rush_fish)
    {
        //[self runAction:_crushoverAction];
        return 0;
    }
    [self stopAllActions];
    self.collision++;
    if(self.collision>=2)
    {
        [self biten];
        return 2;
    }
    [ma setPaused:TRUE];
    [globalaudio playEffect:@"shark.wav"];
    [self runAction:_trippedoverAction];
    return 1;

    
}

-(void) eatstars
{
    self.eatenstar++;
    //[audio playEffect:@"hitStar.wav"];
    //self.physicsBody.density+=100;
    if(self.can_rush<10&&self.Pstatus==Regular)
        self.can_rush++;
    if(self.can_rush==10&&_Pstatus!=Rush_nofish)
        globalrush.enabled=YES;
    _life+=10;
    if(_life>200) _life=200;
    [self stopAction:_eatstarAction];
    [self runAction:_eatstarAction];
}

@end
