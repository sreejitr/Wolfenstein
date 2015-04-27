//
//  MenuLayer.h
//  Wolfenstein
//
//  Created by Sreejita Ray on 4/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@class Gameplay;
@class MainScene;

@interface MenuLayer : CCNode
@property (weak) Gameplay* gamePlay;
@property (weak) MainScene* mainscene;
@property (nonatomic, copy) NSString *nextLevelStart;
@property (nonatomic, copy) NSString *currentLevel;
@end
