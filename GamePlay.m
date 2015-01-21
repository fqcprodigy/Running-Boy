//
//  GamePlay.m
//  ours
//
//  Created by Dante Fan on 10/18/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "GamePlay.h"
#import "Player.h"
#import "Gameover.h"
#import "Cliff.h"
#import "Shark.h"
#import "CCPhysics+ObjectiveChipmunk.h"
#import "commonHelper.h"

Shark* globalshark;
Player* globalplayer;
OALSimpleAudio *globalaudio;
CCButton* globalrush;
NSString* deadcause;
unsigned long int scores=0;
bool adjust=false;
bool level_change=true;
@implementation GamePlay
{
    CCPhysicsNode *_phynode;
    CCNode* _Levels,*_levelnode;
    float _velocity;
    Player* _player;
    CCNode* _bgnode;
    Shark* _gameshark;
    CCButton* _brush;
    CCSprite* lifebar;
    CCNode* Beauty;
    OALSimpleAudio *audio;
    //NSArray* _AllChildren;
    CCLabelTTF *_scoreLabel;
    
}

-(void)check_life
{
    if(_player.life<=50)
        [lifebar setSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"Sharkpics/red.png"]];
    else if(_player.life>50&&_player.life<=130)
        [lifebar setSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"Sharkpics/orange.png"]];
    else
        [lifebar setSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"Sharkpics/lifebar.png"]];
    lifebar.scaleX=_player.life;
}


- (void)didLoadFromCCB
{
    self.userInteractionEnabled = YES;
    _Levels=[CCBReader load:@"Levels/Level0"];
    _velocity=3;
    //_phynode.debugDraw = YES;
    _phynode.collisionDelegate=self;
    //lifebar.scaleX=200;
    [_levelnode addChild:_Levels];
    globalshark=_gameshark;
    globalplayer=_player;
    globalrush=_brush;
    _brush.enabled=NO;
    _gameshark.opacity=0.0;
    //audio
    audio = [OALSimpleAudio sharedInstance];
    // play background sound
    [audio playBg:@"bgMusic5.mp3" loop:TRUE];
    [audio preloadEffect:@"shark.wav"];
    [audio preloadEffect:@"jump1.wav"];
    [audio preloadEffect:@"rush.mp3"];
    [audio preloadEffect:@"Lose.mp3"];
    [audio preloadEffect:@"hitStar.wav"];
    [audio preloadEffect:@"KISS.wav"];
    globalaudio=audio;
    lifebar=[CCSprite spriteWithImageNamed:@"Sharkpics/lifebar.png"];
    [self addChild:lifebar];
    lifebar.position=ccp(240,300);
//    _lifebar.scaleX=2;
//    lifebar.scaleY=0.3;
    
}


- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if(Paused)
    {
        [_player.physicsBody applyImpulse:ccp(0,10000.f)];
        //[_player.physicsBody applyForce:ccp(180,0)];
        [_player jumpRise];
    }
}

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair Player:(CCNode *)nodeA wildcard:(CCNode *)nodeB
{
    //CGPoint now=nodeA.position;
    if((_player.Pstatus&0x01)==1)
    {
        if([nodeB.name isEqualToString:@"block"])
        {
            [nodeB removeFromParent];
            //[nodeA.physicsBody applyImpulse:ccp(1500,0)];
            nodeA.physicsBody.velocity=ccp(0,0);
        }
    }
    if([nodeB.physicsBody.collisionType isEqualToString:@"Secret"])
    {
        nodeA.physicsBody.velocity=ccp(0,0);
        [nodeB removeFromParent];
        [_Levels removeFromParent];
        _Levels=[CCBReader load:@"Levels/Level9"];
        _Levels.name=@"9";
        [_levelnode addChild:_Levels];
    }
    if([nodeB.name isEqualToString:@"ground"]&&nodeA.position.y+24>=nodeB.position.y+nodeB.parent.position.y)
    {
           nodeA.physicsBody.velocity=ccp(0,0);

    }
    if(_player.position.x<120&&!adjust)
    {
        adjust=TRUE;
        int move=120-_player.position.x;
        [_player runAction:[CCActionSequence actions:[CCActionMoveBy actionWithDuration:2 position:ccp(move,0)],[CCActionCallFunc actionWithTarget:self selector:@selector(change_adjust)],nil]];
    }
    
    if([nodeB.name isEqualToString:@"kiss"])
    {
        [nodeB removeFromParent];
        [audio playEffect:@"KISS.wav"];
        nodeA.physicsBody.velocity=ccp(0,0);
        _player.life=200;
    }

    //[nodeA.self.physicsBody applyImpulse:ccp(3,0)];
}
-(void) change_adjust
{
    adjust=!adjust;
}

-(void) rush
{
    if(Paused)
        [_player Rushnofish];
}

- (void)retry {
    // reload this level
    if(!Paused)
        [self pause];
    [audio stopAllEffects];
    [[CCDirector sharedDirector]replaceScene:[CCBReader loadAsScene:@"Scences/GamePlay"]];
}

-(void)change_level
{
    NSArray *child=[_levelnode children];
    level_change=true;
    for(CCNode *childs in child)
    {
        [_levelnode removeChild:childs];
    }
    int levelnum=arc4random()%7;
    _Levels=[CCBReader load:[NSString stringWithFormat:@"Levels/Level%d",levelnum]];
    _Levels.name=[NSString stringWithFormat:@"%d",levelnum];
    _Levels.position=ccp(0,0);
    _player.original*=1.2;
    [_levelnode addChild:_Levels];
}


bool Paused=true;

-(void)pause{
    
    //CCScene * pauseScene = [CCBReader loadAsScene:@"PauseScene"];
    Paused=!Paused;
    if(Paused)
        [[CCDirector sharedDirector] startAnimation];
    else
        [[CCDirector sharedDirector] stopAnimation];
    //[[CCDirector sharedDirector] pushScene:pauseScene];
}

- (void)beautykiss
{
    Beauty=[CCBReader load:@"Characters/BeautyFish"];
    Beauty.position=ccp(500,180);
    Beauty.scale=0.25;
    [_phynode addChild:Beauty];
    [Beauty.animationManager runAnimationsForSequenceNamed:@"kiss"];
    
}

-(void)kissend
{
    [Beauty removeFromParent];
}



- (int)Gameover
{
    scores=_player.score;
    self.userInteractionEnabled=NO;
    [_player die:self withSelector:@selector(finish)];
    return 0;
    
}

-(void)finish
{
    GameOver *gameplayScene =(GameOver*)[CCBReader loadAsScene:@"Scences/GameOver"];
    [[CCDirector sharedDirector]replaceScene:(CCScene*)gameplayScene];

}



- (void)update:(CCTime)delta
{
    if(_player.position.x<-10||_player.position.y<-10)
    {
         _player.life-=200;
        deadcause=@"You got stuck!";
    }
    if(_Levels.position.x<-15000&&level_change)
    {
        level_change=false;
        [self beautykiss];
    }
    if(_player.life>0)
    {
        int end=-15500;
        if([_Levels.name isEqualToString:@"9"])
        {
            end=-4500;
        }
        if(_Levels.position.x<end)
            [self change_level];
        id con2=[CCActionMoveBy actionWithDuration:delta position:ccp(-_player.velocity,0)];
        //id con=[CCActionMoveBy actionWithDuration:delta position:ccp(-_velocity,0)];
        //[_bgnode runAction:con];
        [_Levels runAction:con2];
        //[_lvlhlp check_stars:_player Level:_levels];
        [self check_life];
        [commonHelper CheckCollision:_Levels Player:_player];
        [commonHelper CheckMagnet:_Levels Player:_player Time:delta];
        _player.score++;
    }
    else
    {
        lifebar.scaleX=0;
        _player.position=ccp(125,100);
        [self Gameover];
    }
    [_scoreLabel setString:[NSString stringWithFormat:@"Score: %d Stars: %d",_player.score,_player.eatenstar]];
    return;
}

@end


