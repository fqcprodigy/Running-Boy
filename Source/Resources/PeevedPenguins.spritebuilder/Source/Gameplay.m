//
//  Gameplay.m
//  PeevedPenguins
//
//  Created by Benjamin Encz on 16/01/14.
//  Copyright (c) 2014 MakeGamesWithUs Inc. Free to use for all purposes.
//

#import "Gameplay.h"
#import "Gameover.h"
#import "Penguin.h"
#import "CCPhysics+ObjectiveChipmunk.h"
#import "Cliff.h"
#import "Fish1.h"
#import "Fish2.h"

static const int MaxStarCount=100;
static const int MaxCollDis=20;

NSString* deadcause;
unsigned long int scores=0;


@implementation Gameplay {
    CCPhysicsNode *_physic;
    CCNode *_contentNode;
    Penguin *_player;
    CCButton *b_rush;
    CCNode *Shark;
    CCNode *_ground;
    CCNode *_levelNode;
    int collision;
    int coins;
    
    float velocity_back;
    float velocity_front;
    CCTime shark_time;
    
    //Eat Star
    int StarCNT;
    int StarAte;
    CCNode *Stars[MaxStarCount];
    CCAction *StarsAction[MaxStarCount];
    CCLabelTTF *label;
    
    OALSimpleAudio *audio;
    //create the lifebar which is a ccsprite
    CCSprite *lifebar;
    //create player's total life
    int life;
    
}



#pragma mark - Init

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    // nothing shall collide with our invisible nodes
    // tell this scene to accept touches
    
    
    self.userInteractionEnabled = YES;

    //<<<<<<< HEAD
    collision=0;

    Shark.visible=NO;
    b_rush.enabled=NO;
    _ground.physicsBody.collisionType=@"ground";
    //=======
    StarCNT=0;
    StarAte=0;
    
    shark_time=1;
    
    velocity_back=7;
    velocity_front=5;
    
    //>>>>>>> ZiwenCao's
    CCNode *level = [CCBReader load:@"Levels/Level5"];
    [_levelNode addChild:level];
    
    //_physic.debugDraw = YES;
    _physic.collisionDelegate = self;
    //<<<<<<< HEAD
    //=======
    SEL St=@selector(RandomCreateStar);
    [self schedule:St interval:0.17];
    
    label = [CCLabelTTF labelWithString:@"You ate 0 stars" fontName:@"Calibri"  fontSize:21];
    [self addChild:label];
    label.position = ccp(400,300);
    
    //>>>>>>> ZiwenCao's
    life=200;
    lifebar = [ CCSprite spriteWithImageNamed:@"PeevedPenguinsAssets/lifebar.png"];
    [self addChild:lifebar];
    
    lifebar.position = ccp(220,295);
    
    lifebar.scaleX = (float)life;
    
    ////////the following is to add the sound file into the game done by Haozhe Xu
    // access audio object
    audio = [OALSimpleAudio sharedInstance];
    // play background sound
    [audio playBg:@"bgMusic5.mp3" loop:TRUE];
    [audio preloadEffect:@"shark.wav"];
    [audio preloadEffect:@"jump1.wav"];
    [audio preloadEffect:@"rush.mp3"];
    [audio preloadEffect:@"Lose.mp3"];
    [audio preloadEffect:@"hitStar.wav"];
}


#pragma mark - Touch Handling

- (void)retry {
    // reload this level
    [[CCDirector sharedDirector]replaceScene:[CCBReader loadAsScene:@"Gameplay"]];
}



- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    [audio playEffect:@"jump1.wav"];
    [_player.physicsBody applyImpulse:ccp(0,240.f)];
    life-=10;
    deadcause=@"Power Exhausted";
    [self check_life];
    
    
}


- (void)rush {
    coins=0;
    [audio stopBg];
    [audio playEffect:@"rush.mp3"];
    _player->onfish=YES;
    if(collision==1)
    {
        [Shark stopAllActions];
        shark_time=0.5;
        [self SharkDisappear];
    }
    velocity_back*=2;
    velocity_front*=1.5;
    _player->onfish=TRUE;
    b_rush.enabled=NO;
    CCActionDelay *wait=[CCActionDelay actionWithDuration:5];
    CCActionCallFunc* vanish = [CCActionCallFunc actionWithTarget:self selector:@selector(rush_end)];
    CCActionSequence* rush = [CCActionSequence actions:wait,vanish, nil];
    [_player runAction:rush];
}

-(void) rush_end {
    velocity_front=5;
    velocity_back=7;
    [audio stopEverything];
    [audio playBg];
    if(_player->onfish)
    {
        _player->onfish=false;
        [_ground removeAllChildren];
    }
}


#pragma mark - Update

- (void)update:(CCTime)delta {
    if (_contentNode.position.x<=-350) {
        _contentNode.position=ccp(0, 0);
    }
    //    if(_levelNode.position.x<=-600)
    //    {
    //        [self change_level];
    //    }
    if(life>0)
    {
        id con=[CCActionMoveBy actionWithDuration:delta position:ccp(-velocity_back,0)];
        id con2=[CCActionMoveBy actionWithDuration:delta position:ccp(-velocity_front,0)];
        [_contentNode runAction:con];
        [_levelNode runAction:con2];
        scores+=1;
        
        [self CheckStar];
        [self CheckCollision];
        [self CheckCollisionWithShark];
    }
    return;
    
}

- (void)SharkAppear
{
    collision++;
    Shark.visible=YES;
    id chaseup=[CCActionMoveBy actionWithDuration:0.5 position:ccp(0, 10)];
    id chasedown=[CCActionMoveBy actionWithDuration:0.5 position:ccp(0, -10)];
    id chase=[CCActionSequence actions:chaseup,chasedown, nil];
    id repeat=[CCActionRepeat actionWithAction:chase times:10];
    id disappear=[CCActionCallFunc actionWithTarget:self selector:@selector(SharkDisappear)];
    id sequence=[CCActionSequence actions:repeat, disappear,nil];
    [Shark runAction:sequence];
    [audio playEffect:@"shark.wav"];
    
}

#pragma mark - Game Actions




- (void)change_level
{
    NSArray *child=[_levelNode children];
    for (CCNode *childs in child) {
        [_levelNode removeChild:childs];
    }
    CCNode *new_level=[CCBReader load:@"Levels/Level5"];
    [_levelNode addChild:new_level];
    _levelNode.position=ccp(470, 48);
}


- (void)SharkDisappear
{
    collision=0;
    CCNode *realshark=[Shark children][0];
    id moveout=[CCActionMoveBy actionWithDuration:shark_time position:ccp(-15,realshark.position.y)];
    id fadeout=[CCActionFadeOut actionWithDuration:shark_time];
    id disappear=[CCActionSpawn actions:moveout,fadeout, nil];
    [realshark runAction:disappear];
    realshark.position=ccpAdd(realshark.position,ccp(15,0));
    shark_time=7;
}

- (void) check_life
{
    lifebar.scaleX = (float)life;
    if(life<=0)
    {
        lifebar.scaleX=0;
        [audio stopBg];
        self.userInteractionEnabled = NO;
        [audio playEffect:@"Lose.mp3"];
        id end=[CCActionDelay actionWithDuration:1.5];
        id over=[CCActionCallFunc actionWithTarget:self selector:@selector(Gameover)];
        id finish=[CCActionSequence actions:end,over, nil];
        [_player runAction:finish];
    }
}

- (int)Gameover
{
    [audio stopEverything];
    Gameover *gameplayScene =(Gameover*)[CCBReader loadAsScene:@"Gameover"];
    [[CCDirector sharedDirector]replaceScene:(CCScene*)gameplayScene];
    scores/=50;
    return 0;
    
}


- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair penguin:(CCNode *)nodeA Pig:(CCNode *)nodeB
{
    nodeB.physicsBody.sensor=TRUE;
    if(_player->onfish)
        [nodeB removeFromParent];
    else
    {
        if(collision<1)
            [self SharkAppear];
        else
            [self SharkChase];
    }
    
}

- (void) SharkChase
{
    life-=80;
    deadcause=@"Eaten by Shark";
    id Chase=[CCActionMoveBy actionWithDuration:0.5 position:ccp(20,0)];
    id Back=[CCActionMoveBy actionWithDuration:0.5 position:ccp(-20,0)];
    id callback=[CCActionCallFunc actionWithTarget:self selector:@selector(check_life)];
    id finish=[CCActionSequence actions:Chase,Back, callback,nil];
    [Shark runAction:finish];
    
}

- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair penguin:(CCNode *)nodeA Fish1:(CCNode *)nodeB
{
    [[_physic space] addPostStepBlock:^{
        nodeB.physicsBody.sensor = TRUE;
    } key:nodeB];
    CGPoint p_fish=ccpAdd(nodeB.position, nodeB.parent.position);
    [nodeB removeFromParent];
    //CCLOG(@"%f+%f\n",nodeA.position.y,p_fish.y);
    if(nodeA.position.x<p_fish.x&&nodeA.position.y<p_fish.y)
    {
        life-=100;
        deadcause=@"Hit by swordfish";
        [self check_life];
        return;
    }
    if(nodeA.position.y>p_fish.y+8&&!_player->onfish)
    {
        //[nodeB removeFromParent];
        CCNode *_fish=[CCBReader load:@"Fish2"];
        _player.position=ccp(136,61);
        _fish.position=ccp(136,63);
        [_ground addChild:_fish];
        [self rush];
    }
}




- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair penguin:(CCNode *)nodeA Cliff:(CCNode *)nodeB
{
    [[_physic space] addPostStepBlock:^{
        nodeB.physicsBody.sensor = TRUE;
    } key:nodeB];
    //nodeB.physicsBody.sensor=TRUE;
    if(_player->onfish)
        [nodeB removeFromParent];
    else if(collision<1)
    {
        [self SharkAppear];
        life-=50;
        deadcause=@"Hit on Cliff";
        [self check_life];
    }
    else
        [self SharkChase];
}

int StarType=0;
int StarLeft=0;
int LastHeight=0;



- (void) RandomCreateStar
{
    CCNode *_star=[CCBReader load:@"Star"];
    if( StarLeft==0)
    {
        StarType=(int)(CCRANDOM_0_1()*10)+1;
        if(StarType==1)
        {
            StarLeft=5;
            LastHeight=70+CCRANDOM_0_1()*130;
        }
        if(StarType==2)
        {
            StarLeft=3;
            LastHeight=100+CCRANDOM_0_1()*130;
            
        }
        if(StarType==3)
        {
            StarLeft=3;
            LastHeight=70+CCRANDOM_0_1()*100;
            
        }
        if(StarType>=4)
        {
            StarLeft=3;
            
        }
        
    }
    
    StarLeft--;
    if(StarType==1)
    {
    }
    if(StarType==2)
    {
        LastHeight-=15;
    }
    if(StarType==3)
    {
        LastHeight+=15;
    }
    if(StarType>=4)
    {
        return;
    }
    
    
    
    _star.position=ccp(600,LastHeight);
    [self addChild:_star];
    Stars[++StarCNT]=_star;
    StarsAction[StarCNT]=[CCActionMoveBy actionWithDuration:3.00 position:ccp(-600, 0)];
    [_star runAction:StarsAction[StarCNT]];
}

-(int) sqr:(int)x
{
    return x*x;
}

-(void)CheckCollision
{
    int i=1;
    while(i<=StarCNT)
    {
        if([self sqr:Stars[i].position.x-_player.position.x] +[self sqr:Stars[i].position.y-_player.position.y]<=[self sqr:MaxCollDis])
        {
            [audio playEffect:@"hitStar.wav"];
            scores+=10;
            life+=10;
            lifebar.scaleX = (float)life;
            [self removeChild:Stars[i]];
            //[Stars[i] dealloc];
            Stars[i]=Stars[StarCNT--];
            StarAte++;
            coins++;
            [label setString: [NSString stringWithFormat:@"You ate %i stars", StarAte]];
            if(coins==10)
                b_rush.enabled=YES;
        }
        else
            i++;
    }
}

int StopCNT=0;

-(void)CheckCollisionWithShark
{
    int i=1;
    while(i<=StarCNT)
    {
        if([self sqr:Stars[i].position.x-Shark.position.x] +[self sqr:Stars[i].position.y-Shark.position.y]<=[self sqr:MaxCollDis])
        {
            [self removeChild:Stars[i]];
            //[Stars[i] dealloc];
            Stars[i]=Stars[StarCNT--];
            StopCNT++;
            if(StopCNT>=3)
            {
                shark_time=0.3;
                if(collision == 1) [self SharkDisappear];
                StopCNT=0;
            }
        }
        i++;
    }
}


-(void) CheckStar
{
    int i=1;
    while(i<=StarCNT)
    {
        if(Stars[i].position.x<Shark.position.x-50)
        {
            [self removeChild:Stars[i]];
            //[Stars[i] dealloc];
            Stars[i]=Stars[StarCNT--];
        }
        else
            i++;
    }
    
    
}


//>>>>>>> ZiwenCao's


@end
