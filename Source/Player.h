//
//  Player.h
//  ours
//
//  Created by Dante Fan on 10/16/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum _status
{
    Regular=0x0,
    Dead=0x04,
    Rush_nofish=0x01,
    Rush_fish=0x03,
    //CollideWithCliff,
    //BitenByShark,
    //KissByBeauty,
    
} Status;
@interface Player : CCSprite {
    //Status _Pstatus;
    CCTime _RushTime;
    //JumpAnimation
    
}

//attributes
@property(atomic,assign) int life;
@property(atomic,assign) Status Pstatus;
@property(nonatomic,assign) float velocity;
@property(nonatomic,assign) float original;
@property(atomic,assign) int collision;
@property(atomic,assign) int eatenstar;
@property(nonatomic,assign) int score;
@property(nonatomic,assign) int can_rush;



//actions
//@property(nonatomic, strong)id idleAction;
@property(nonatomic, strong)id bitenbysharkAction;
@property(nonatomic, strong)id trippedoverAction;
//@property(nonatomic, strong)id crushoverAction;
//@property(nonatomic, strong)id recoverAction;
//@property(nonatomic, strong)id rushAction;
//@property(nonatomic, strong)id hitbyMonsterAction;
@property(nonatomic, strong)id jumpRiseAction;
//@property(nonatomic, strong)id jumpFallAction;
@property(nonatomic, strong)id onfishAction;
@property(nonatomic, strong)id dieAction;
@property(nonatomic, strong)id eatstarAction;



//methods
//-(int)check_life;
-(void)idle;
//-(void)hitbymonster;
-(BOOL)hitbyfish;
-(void)jumpRise;
//-(void)jumpFall;
-(void)Rushnofish;
-(void)Rushfish;
-(void)die:(id) obj withSelector:(SEL)selector;
-(void)biten;
-(void)eatstars;
-(void)recover;
-(int)knockout;



@end
