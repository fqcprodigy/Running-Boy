//
//  Shark.h
//  ours
//
//  Created by Dante Fan on 10/25/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"
@interface Shark : CCSprite {
    
}


//actions
@property(nonatomic, strong)id appearAction;
@property(nonatomic, strong)id chaseAction;
@property(nonatomic, strong)id biteAction;
@property(nonatomic, strong)id disappearAction;
@property(nonatomic, strong)id beatenAction;


//methods

-(void) showup;

-(void)bite;

-(void)beaten;

-(void)disappear;

@end
