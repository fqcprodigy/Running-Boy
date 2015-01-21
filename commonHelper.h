//
//  commonHelper.h
//  ours
//
//  Created by Cao Ziwen on 10/22/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCNode.h"
#import "Player.h"

@interface commonHelper : NSObject

+(bool) Collision:(CCNode *) A B:(CCNode *)B;
+(void) CheckCollision:(CCNode*) _Levels Player:(Player*) _Player;
+(void) CheckMagnet:(CCNode*) _Levels Player:(Player*) _Player Time:(double) delta;

//+(bool) ISAONB:(CCNode *) A B:(CCNode *)B;

@end
