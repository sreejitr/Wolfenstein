//
//  Gameplay.m
//  Wolfenstein
//
//  Created by Sreejita Ray on 3/19/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "Level.h"
#import "Wolfe.h"
#import "Fister.h"
#import "Gaso.h"
#import "Hencher.h"
#import "WinPopUp.h"
#import "CCActionFollow+CurrentOffset.h"
#import "CCPhysics+ObjectiveChipmunk.h"
#import "CCDirector.h"

static NSString * const kFirstLevel = @"Level4";
static NSString *selectedLevel = @"Level1";


@implementation Gameplay{
    Wolfe *_wolfe;
    Fister *_fister;
    Gaso *_gaso;
    Hencher *_hencher;
    CCSprite *_powerUp;
    CCNode *_levelNode;
    Level *_loadedLevel;
    CCLabelTTF *_healthLabel;
    CCLabelTTF *_fisterHealth;
    CCLabelTTF *_winPopUpLabel;
    CCLabelTTF *_gamePoints;
    double_t timeelapsed;
    double_t totaltimeelapsed;
    int wolfe_hit;
    int fister_hit;
    BOOL wolfe_attack;
    BOOL fister_attack;
    WinPopUp *popup;
    int points;
    int points_fister;
    BOOL _gameOver;
    BOOL rightface;
    CCAction *_followWolfe;
    CGPoint touchBeganLocation;
    CGPoint touchMovedLocation;
    BOOL powerupavailable;
    BOOL powerupsactivated;
    BOOL wolfe_jumped;
    CCParticleSystem *effect;
    NSArray *powerupArray;
    BOOL playerGroundHit;
    BOOL enemyGroundHit;
    NSInteger countSpecialComboUse;
    NSInteger healthPointsToDeducthero;
    NSInteger healthPointsToDeductenemy;
    BOOL facingeachother;
    NSString *currentPowerUp;
    int playerScore;
    BOOL wolfeAttackEnable;
    BOOL crouchCombo;
    NSString *playerCollidedwithPowerUp;
    NSDictionary *enemy;
    NSDictionary *fister_v;
    NSDictionary *gaso_v;
    NSDictionary *hencher_v;
}


#pragma mark - Node Lifecycle

- (void)didLoadFromCCB {
    _physicsNode.collisionDelegate = self;
    _loadedLevel = (Level *) [CCBReader load:selectedLevel owner:self];
    [_levelNode addChild:_loadedLevel];
    self.userInteractionEnabled = TRUE;
    _wolfe = (Wolfe*)[CCBReader load:@"Wolfe"];
    [_physicsNode addChild:_wolfe];
    CGPoint offsetFromParentCenter = CGPointMake(180, 120);
    _wolfe.position = CGPointMake(self.contentSize.width * self.anchorPoint.x + offsetFromParentCenter.x,
                                  self.contentSize.height * self.anchorPoint.y + offsetFromParentCenter.y);
//    _wolfe.position = ccp(205, 130);
//    [_wolfe setPosition:[_physicsNode convertToNodeSpace:[self convertToWorldSpace:ccp(self.contentSizeInPoints.width/2, self.contentSizeInPoints.height* 0.1f)]]];
    rightface = TRUE;
    offsetFromParentCenter = CGPointMake(330, 140);
    fister_v = @{
              @"offsetFromParentCenterX": [NSNumber numberWithFloat:offsetFromParentCenter.x],
              @"offsetFromParentCenterY": [NSNumber numberWithFloat:offsetFromParentCenter.y],
              @"maintainDistanceFromWolfe" : @170,
              @"moveToAfterPunchAttack" : @120,
              @"walkRightTo" : @155,
              @"walkLeftTo" : @170,
              @"wolfeDistBeforeAttack" : @150
              };
    offsetFromParentCenter = CGPointMake(290, 120);
    gaso_v = @{
                 @"offsetFromParentCenterX": [NSNumber numberWithFloat:offsetFromParentCenter.x],
                 @"offsetFromParentCenterY": [NSNumber numberWithFloat:offsetFromParentCenter.y],
                 @"maintainDistanceFromWolfe" : @150,
                 @"moveToAfterPunchAttack" : @105,
                 @"walkRightTo" : @155,
                 @"walkLeftTo" : @110,
                 @"wolfeDistBeforeAttack" : @120
                 };
    hencher_v = @{
                 @"offsetFromParentCenterX": [NSNumber numberWithFloat:offsetFromParentCenter.x],
                 @"offsetFromParentCenterY": [NSNumber numberWithFloat:offsetFromParentCenter.y],
                 @"maintainDistanceFromWolfe" : @160,
                 @"moveToAfterPunchAttack" : @120,
                 @"walkRightTo" : @145,
                 @"walkLeftTo" : @160,
                 @"wolfeDistBeforeAttack" : @150
                 };
    if ([_loadedLevel.nextLevelName isEqualToString:@"Level2"]) {
        enemy = gaso_v;
        _gaso = (Gaso*)[CCBReader load:@"Gaso"];
        [_physicsNode addChild:_gaso];
        _gaso.position = CGPointMake(self.contentSize.width * self.anchorPoint.x + [enemy[@"offsetFromParentCenterX"] floatValue],
                                     self.contentSize.height * self.anchorPoint.y + [enemy[@"offsetFromParentCenterY"] floatValue]);

    }
    else if ([_loadedLevel.nextLevelName isEqualToString:@"Level3"]) {
        enemy = hencher_v;
        _hencher = (Hencher*)[CCBReader load:@"Hencher"];
        _hencher.scale = 0.5f;
        [_physicsNode addChild:_hencher];
        _hencher.position = CGPointMake(self.contentSize.width * self.anchorPoint.x + [enemy[@"offsetFromParentCenterX"] floatValue],
                                     self.contentSize.height * self.anchorPoint.y + [enemy[@"offsetFromParentCenterY"] floatValue]);

    }
    else {
        _fister = (Fister*)[CCBReader load:@"Fister"];
        enemy = fister_v;
        if ([_loadedLevel.nextLevelName isEqualToString:@"Level4"]) {
            _fister.color = [CCColor colorWithRed:0.3 green:1.0 blue:1.0];
        }
        [_physicsNode addChild:_fister];
        _fister.position = CGPointMake(self.contentSize.width * self.anchorPoint.x + [enemy[@"offsetFromParentCenterX"] floatValue],
                                       self.contentSize.height * self.anchorPoint.y + [enemy[@"offsetFromParentCenterY"] floatValue]);
    }
    
//    _fister.position = ccp(370, 150);
    wolfe_attack = FALSE;
    fister_attack = FALSE;
    wolfe_hit = 0;
    fister_hit = 0;
    timeelapsed = 0.0f;
    _healthLabel.visible = TRUE;
    _fisterHealth.visible = TRUE;
    _gamePoints.visible = TRUE;
    points = 100;
    points_fister = 100;
    [self showScore];
    _gameOver = FALSE;
    powerupavailable = false;
    powerupsactivated = false;
//    powerupArray = @[@"Health", @"TwoX", @"Star", @"Fire", @"Shield", @"Lightening", @"Freeze"];
    powerupArray = @[@"Health", @"TwoX", @"Star", @"Shield", @"Lightening", @"Freeze"];
    wolfe_jumped = false;
    playerGroundHit = FALSE;
    countSpecialComboUse = 0;
//    _physicsNode.debugDraw = TRUE;
    facingeachother = true;
    healthPointsToDeducthero = 4;
    healthPointsToDeductenemy = 4;
    playerScore = 0;
    
}

- (void)loadNextLevel {
    selectedLevel = _loadedLevel.nextLevelName;
    
    CCScene *nextScene = nil;
    
    if (selectedLevel) {
        nextScene = [CCBReader loadAsScene:@"Gameplay"];
    } else {
        selectedLevel = kFirstLevel;
        nextScene = [CCBReader loadAsScene:@"MainScene"];
    }
    
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:nextScene withTransition:transition];
}


- (void)onEnter {
    [super onEnter];
    
    CCActionFollow *follow = [CCActionFollow actionWithTarget:_wolfe worldBoundary:[_loadedLevel boundingBox]];
    _physicsNode.position = [follow currentOffset];
    [_physicsNode runAction:follow];
//    CCSprite *sprite = [CCSprite spriteWithImageNamed:@"healthbar.png"];
//    sprite.position = ccp(self.contentSizeInPoints.width/2, 10.f);
//    sprite.scaleX = 200;
//    [_physicsNode addChild:sprite];
}

-(void)update:(CCTime)delta
{
    [self showScore];
    if (points_fister <= 0) {
        [self winScreen];
    }
    if (points <= 0) {
        [self loseScreen];
    }
    
//    _fister.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _fister.contentSize} cornerRadius:0];
    if (!_gameOver) {
        [_wolfe correctPositionOnScreenAtPosition:_loadedLevel.positionInPoints withWidth:_loadedLevel.contentSizeInPoints];
        if (_fister) {
            [_fister correctPositionOnScreenAtPosition:_loadedLevel.positionInPoints withWidth:_loadedLevel.contentSizeInPoints];
        } else if (_gaso) {
            [_gaso correctPositionOnScreenAtPosition:_loadedLevel.positionInPoints withWidth:_loadedLevel.contentSizeInPoints];
        } else if (_hencher) {
            [_hencher correctPositionOnScreenAtPosition:_loadedLevel.positionInPoints withWidth:_loadedLevel.contentSizeInPoints];
        }
        
        timeelapsed += delta;
        totaltimeelapsed += delta;
        if (totaltimeelapsed >= 30.f && !powerupsactivated) {
            [self loadpowerups];
            powerupsactivated = TRUE;
        }
        else if (totaltimeelapsed > 25.f && powerupsactivated) {
            [self loadpowerups];
            totaltimeelapsed = 0.0f;
        }
        
        if (playerGroundHit) {
            [_wolfe performSelector:@selector(getup) withObject:nil afterDelay:2.f];
            [self performSelector:@selector(resetplayerGroundHit) withObject:nil afterDelay:2.2f];
        }
        if (timeelapsed > 1.2f) {
//            id moveBy = [CCActionMoveTo actionWithDuration:0.01 position:ccp(_wolfe.position.x, 120)];
//            [_wolfe runAction:moveBy];
            NSNumber *maintainDistanceFromWolfe = enemy[@"maintainDistanceFromWolfe"];
            NSNumber *moveToAfterAttack = enemy[@"moveToAfterPunchAttack"];
            if (_fister) {
                id moveBy = [CCActionMoveTo actionWithDuration:0.01 position:ccp(_fister.position.x, 140)];
                [_fister runAction:moveBy];
                if (!wolfe_attack && fabs(_wolfe.position.x - _fister.position.x) <= [maintainDistanceFromWolfe intValue] && !wolfe_jumped && !playerGroundHit && !enemyGroundHit && (![playerCollidedwithPowerUp isEqualToString:@"Freeze"])) {
                    [self enemyAttackBegan:[moveToAfterAttack intValue] withDistanceFromWolfe:[maintainDistanceFromWolfe intValue]];
                } else if (!wolfe_attack && ![playerCollidedwithPowerUp isEqualToString:@"Freeze"] && ![playerCollidedwithPowerUp isEqualToString:@"Lightening"]) {
                    [self flip_handle];
                    if (_fister.position.x - _wolfe.position.x > [maintainDistanceFromWolfe intValue]){
                        [self walkLeftEnemy];
                    }
                    if (_wolfe.position.x - _fister.position.x > [maintainDistanceFromWolfe intValue]){
                        [self walkRightEnemy];
                    }
                }
                
            } else if (_gaso) {
                id moveBy = [CCActionMoveTo actionWithDuration:0.01 position:ccp(_gaso.position.x, 120)];
                [_gaso runAction:moveBy];
                if (!wolfe_attack && fabs(_wolfe.position.x - _gaso.position.x) <= [maintainDistanceFromWolfe intValue] && !wolfe_jumped && !playerGroundHit && !enemyGroundHit && (![playerCollidedwithPowerUp isEqualToString:@"Freeze"])) {
                    [self enemyAttackBegan:[moveToAfterAttack intValue] withDistanceFromWolfe:[maintainDistanceFromWolfe intValue]];
                } else if (!wolfe_attack && ![playerCollidedwithPowerUp isEqualToString:@"Freeze"] && ![playerCollidedwithPowerUp isEqualToString:@"Lightening"]) {
                    [self flip_handle];
                    if (_gaso.position.x - _wolfe.position.x > [maintainDistanceFromWolfe intValue]){
                        [self walkLeftEnemy];
                    }
                    if (_wolfe.position.x - _gaso.position.x > [maintainDistanceFromWolfe intValue]){
                        [self walkRightEnemy];
                    }
                }
            } else if (_hencher) {
                id moveBy = [CCActionMoveTo actionWithDuration:0.01 position:ccp(_hencher.position.x, 120)];
                [_hencher runAction:moveBy];
                if (!wolfe_attack && fabs(_wolfe.position.x - _hencher.position.x) <= [maintainDistanceFromWolfe intValue] && !wolfe_jumped && !playerGroundHit && !enemyGroundHit && (![playerCollidedwithPowerUp isEqualToString:@"Freeze"])) {
                    [self enemyAttackBegan:[moveToAfterAttack intValue] withDistanceFromWolfe:[maintainDistanceFromWolfe intValue]];
                } else if (!wolfe_attack && ![playerCollidedwithPowerUp isEqualToString:@"Freeze"] && ![playerCollidedwithPowerUp isEqualToString:@"Lightening"]) {
                    [self flip_handle];
                    if (_hencher.position.x - _wolfe.position.x > [maintainDistanceFromWolfe intValue]){
                        [self walkLeftEnemy];
                    }
                    if (_wolfe.position.x - _hencher.position.x > [maintainDistanceFromWolfe intValue]){
                        [self walkRightEnemy];
                    }
                }
            } else if ([playerCollidedwithPowerUp isEqualToString:@"Lightening"]) {
                [self flip_handle];
            }
            timeelapsed = 0.0f;
        }
        
    }
}

- (void) enemyAttackBegan:(NSInteger) moveToVal withDistanceFromWolfe:(NSInteger) distanceFromWolfe{
    self.userInteractionEnabled = FALSE;
    fister_attack = TRUE;
    wolfe_hit += 1;
    playerScore -= 950;
    points -= healthPointsToDeductenemy;
    [self showScore];
    
//    [self performSelector:@selector(fister_idle) withObject:nil afterDelay:0.9f];
    if (_fister) {
        if (_fister.flipX == NO) {
            id moveBy = [CCActionMoveTo actionWithDuration:0.30 position:ccp(_fister.position.x + moveToVal, _fister.position.y)];
            [_fister runAction:moveBy];
        }
        [_fister punch];
    } else if (_gaso) {
        if (_gaso.flipX == NO) {
            id moveBy = [CCActionMoveTo actionWithDuration:0.30 position:ccp(_wolfe.position.x + moveToVal, _gaso.position.y)];
            [_gaso runAction:moveBy];
        }
        [_gaso punch:_wolfe.position];
    } else if (_hencher) {
        if (_hencher.flipX == NO) {
            id moveBy = [CCActionMoveTo actionWithDuration:0.30 position:ccp(_hencher.position.x + moveToVal, _hencher.position.y)];
            [_hencher runAction:moveBy];
        }
        [_hencher punch];
    }
    [_wolfe performSelector:@selector(hit) withObject:nil afterDelay:0.2f];
    if (points == 0) {
        [_wolfe groundhit];
        playerGroundHit = TRUE;
    }
    
    [self performSelector:@selector(turnoff_fister_attack) withObject:nil afterDelay:2.f];
//    NSLog([NSString stringWithFormat:@"Wolfe x: %f", _wolfe.position.x]);
//    NSLog([NSString stringWithFormat:@"Fister x: %f", _fister.position.x]);
    if (_fister) {
        if (_wolfe.position.x < _fister.position.x) {
            _fister.position = ccp(_wolfe.position.x + distanceFromWolfe, _fister.position.y);
        }
    } else if (_gaso) {
//        if (_wolfe.position.x < _gaso.position.x) {
//            _gaso.position = ccp(_wolfe.position.x + distanceFromWolfe, _gaso.position.y);
//        }
    } else if (_hencher) {
        if (_wolfe.position.x < _hencher.position.x) {
            _hencher.position = ccp(_wolfe.position.x + distanceFromWolfe, _hencher.position.y);
        }
    }
    

}

- (void)showScore
{
    if (points < 0) {
        points = 0;
    }
    if (points_fister < 0) {
        points_fister = 0;
    }
    if (points >= 60) {
        _healthLabel.color = [CCColor colorWithRed:0.2 green:0.7 blue:0.1];
    } else if (points < 60 && points >= 25) {
        _healthLabel.color = [CCColor colorWithRed:0.7 green:0.28 blue:0.0];
    } else if (points < 25 && points >= 0) {
        _healthLabel.color = [CCColor colorWithRed:1.0 green:0.0 blue:0.0];
    }
    
    _healthLabel.string = [NSString stringWithFormat:@"Wolfe: %d", points];
    _healthLabel.visible = true;
    
    
    if (points_fister >= 60) {
        _fisterHealth.fontColor = [CCColor colorWithRed:0.2 green:0.7 blue:0.1];
    } else if (points_fister < 60 && points_fister >= 25) {
        _fisterHealth.fontColor = [CCColor colorWithRed:0.7 green:0.28 blue:0.0];
    } else if (points_fister < 25 && points_fister >= 0) {
        _fisterHealth.fontColor = [CCColor colorWithRed:1.0 green:0.0 blue:0.0];
    }
    _fisterHealth.string = [NSString stringWithFormat:@"Fister: %d", points_fister];
    _fisterHealth.visible = true;
    
    _gamePoints.string = [NSString stringWithFormat:@"Score: %d", playerScore];
    _gamePoints.visible = true;
}

-(void) touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
//    NSLog([NSString stringWithFormat:@"Wolfe width: %f", _wolfe.boundingBox.size.width]);
//    NSLog([NSString stringWithFormat:@"Wolfe physicsbody: %f", _wolfe.physicsBody.]);
//    NSLog([NSString stringWithFormat:@"Fister width: %f", _fister.boundingBox.size.width]);
//    NSLog([NSString stringWithFormat:@"Level width: %f", _loadedLevel.boundingBox.size.width]);
    
//     _progressNode.percentage += 10.0f;
    
    touchBeganLocation = [touch locationInNode:self.parent];
    wolfeAttackEnable = TRUE;
    crouchCombo = FALSE;
    
}

- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    self.userInteractionEnabled = TRUE;
//    [_fister idle];
    
    touchMovedLocation = [touch locationInNode:self.parent];
//    NSLog([NSString stringWithFormat:@"touchbegan x: %f", touchBeganLocation.x]);
//    NSLog([NSString stringWithFormat:@"touchbegan y: %f", touchBeganLocation.y]);
//    NSLog([NSString stringWithFormat:@"touchMovedLocation x: %f", touchMovedLocation.x]);
//    NSLog([NSString stringWithFormat:@"touchMovedLocation y: %f", touchMovedLocation.y]);
    if (!_gameOver) {
        if ((touchMovedLocation.y - touchBeganLocation.y > 50) && (touchBeganLocation.x - touchMovedLocation.x > 50) && !wolfe_jumped) {
            [self jumpLeft];
        } else if ((touchBeganLocation.x - touchMovedLocation.x > 50) && (_wolfe.position.x - 20 > _loadedLevel.boundingBox.origin.x + 90) && !wolfe_jumped) {
            [self walkLeft];
        }
        
        if ((touchMovedLocation.y - touchBeganLocation.y > 50) && (touchMovedLocation.x - touchBeganLocation.x > 50) && ((_wolfe.position.x + 200) < (_loadedLevel.boundingBox.size.width - _wolfe.boundingBox.size.width)) && !wolfe_jumped) {
            [self jumpRight];
        } else if ((touchMovedLocation.x - touchBeganLocation.x > 50) && (_wolfe.position.x + 20 < (_loadedLevel.boundingBox.size.width - 90)) && !wolfe_jumped) {
            [self walkRight];
        }
        
        if ((touchMovedLocation.y - touchBeganLocation.y > 50) && !wolfe_jumped) {
            [self jumpUp];
        }
        
        if (touchBeganLocation.y - touchMovedLocation.y > 50) {
            wolfeAttackEnable = TRUE;
            crouchCombo = TRUE;
        } else {
            wolfeAttackEnable = false;
        }
        _followWolfe = [CCActionFollow actionWithTarget:_wolfe worldBoundary:self.boundingBox];
        [_levelNode runAction:_followWolfe];
    }
}

-(void) touchEnded:(CCTouch*)touch withEvent:(CCTouchEvent *)event{
    if (wolfeAttackEnable) {
        
    if (!_gameOver) {
        float xpos;
        if (_fister) {
            xpos = _fister.position.x;
        } else if (_gaso) {
            xpos = _gaso.position.x;
        } else if (_hencher) {
            xpos = _hencher.position.x;
        }
        if (!fister_attack && fabsf(_wolfe.position.x - xpos) < [enemy[@"maintainDistanceFromWolfe"] intValue] && !wolfe_jumped && !playerGroundHit && !enemyGroundHit) {
            [self wolfeAttackBegan];
        }
        else if (fister_attack && ([playerCollidedwithPowerUp isEqualToString:@"Shield"])) {
            [_wolfe block];
        }
        
    }
    }
}

-(void) wolfeAttackBegan {
    self.userInteractionEnabled = FALSE;
    wolfe_attack = TRUE;
    if (crouchCombo) {
        [self crouchComboAttack];
        if (enemyGroundHit && !_gameOver) {
            if (_fister) {
                [_fister performSelector:@selector(getup) withObject:nil afterDelay:2.f];
                [self performSelector:@selector(resetenemyGroundHit) withObject:nil afterDelay:1.f];
            }
        }
        [self performSelector:@selector(turnoff_wolfe_attack) withObject:nil afterDelay:3.5f];
    } else {
        if (_fister) {
            [_wolfe attack:_fister.position withDistance:[enemy[@"wolfeDistBeforeAttack"] intValue]];
            [_fister hit:_wolfe.position];
        } else if (_gaso) {
            [_wolfe attack:_gaso.position withDistance:[enemy[@"wolfeDistBeforeAttack"] intValue]];
            [_gaso hit:_wolfe.position];
        } else if (_hencher) {
            [_wolfe attack:_hencher.position withDistance:[enemy[@"wolfeDistBeforeAttack"] intValue]];
            [_hencher hit];
        }
        
        [self performSelector:@selector(updateEnemyHealth) withObject:nil afterDelay:1.2f];
        [self showScore];

        [self performSelector:@selector(turnoff_wolfe_attack) withObject:nil afterDelay:1.9f];
    }
    
}

- (void) updateEnemyHealth {
    float xPos;
    if (_fister) {
        xPos = _fister.position.x;
    } else if (_gaso) {
        xPos = _gaso.position.x;
    } else if (_hencher) {
        xPos = _hencher.position.x;
    }
    if ( (_wolfe.flipX == NO) || (fabsf(xPos - _wolfe.position.x) < [enemy[@"maintainDistanceFromWolfe"] intValue])) {
        fister_hit += 1;
        playerScore += 1000;
        points_fister -= healthPointsToDeducthero;
    }

}

-(void) turnoff_wolfe_attack {
    wolfe_attack = FALSE;
    self.userInteractionEnabled = TRUE;
    self.multipleTouchEnabled = TRUE;
    
//    [_wolfe idle];
    wolfeAttackEnable = false;
//    if (_fister.flipX == YES) {
////        id moveTo = [CCActionMoveTo actionWithDuration:0.10 position:ccp(_fister.position.x + 40, _fister.position.y)];
////        [_fister runAction:moveTo];
//    }
    
}

-(void) turnoff_fister_attack {
    fister_attack = FALSE;
    self.userInteractionEnabled = TRUE;
    self.multipleTouchEnabled = TRUE;
}


- (void)walkRightEnemy {
    if (_fister) {
        _fister.flipX=YES;
        NSLog(@"Right");
        [_fister run];
        id moveRight = [CCActionMoveTo actionWithDuration:0.10 position:ccp(_wolfe.position.x - [enemy[@"walkRightTo"] intValue], _fister.position.y)];
        [_fister runAction:moveRight];
        [self performSelector:@selector(fister_idle) withObject:nil afterDelay:0.5f];

    } else if (_gaso) {
        _gaso.flipX=YES;
        NSLog(@"Right");
        [_gaso run];
        id moveRight = [CCActionMoveTo actionWithDuration:0.10 position:ccp(_wolfe.position.x - [enemy[@"walkRightTo"] intValue], _gaso.position.y)];
        [_gaso runAction:moveRight];
        [self performSelector:@selector(gaso_idle) withObject:nil afterDelay:0.5f];
    } else if (_hencher) {
        _hencher.flipX=YES;
        NSLog(@"Right");
        [_hencher run];
        id moveRight = [CCActionMoveTo actionWithDuration:0.10 position:ccp(_wolfe.position.x - [enemy[@"walkRightTo"] intValue], _hencher.position.y)];
        [_hencher runAction:moveRight];
        [self performSelector:@selector(hencher_idle) withObject:nil afterDelay:0.5f];
    }
    facingeachother = false;
    
    
}

- (void)walkRight {
    float xPos;
    float size;
    if (_fister) {
        xPos = _fister.position.x;
        size = _fister.contentSizeInPoints.width;
    } else if (_gaso) {
        xPos = _gaso.position.x;
        size = _gaso.contentSizeInPoints.width;
    } else if (_hencher) {
        xPos = _hencher.position.x;
        size = _hencher.contentSizeInPoints.width;
    }
    if ((_wolfe.position.x + _wolfe.contentSizeInPoints.width/2 + 20) < (xPos - size/2 + 5) || (_wolfe.position.x > xPos)) {
        _wolfe.flipX=NO;
        [_wolfe walk];
        id moveRight = [CCActionMoveBy actionWithDuration:0.10 position:ccp(20, 0)];
        [_wolfe runAction:moveRight];
        facingeachother = FALSE;
        [self performSelector:@selector(wolfe_idle) withObject:nil afterDelay:0.5f];
    }
}

- (void)walkLeftEnemy {
    //NSLog([NSString stringWithFormat:@"Wolfe x: %f", _wolfe.position.x]);
    //NSLog([NSString stringWithFormat:@"box origin x: %f", _loadedLevel.boundingBox.origin.x]);
    //NSLog([NSString stringWithFormat:@"Fister x: %f", _fister.position.x]);
    //NSLog([NSString stringWithFormat:@"level width: %f", _loadedLevel.boundingBox.size.width]);
    if (_fister) {
        [_fister run];
        id moveLeft = [CCActionMoveTo actionWithDuration:0.10 position:ccp(_wolfe.position.x + [enemy[@"walkLeftTo"] intValue], _fister.position.y)];
        [_fister runAction:moveLeft];
        facingeachother = FALSE;
        [self performSelector:@selector(fister_idle) withObject:nil afterDelay:0.5f];
    } else if (_gaso) {
        [_gaso run];
        id moveLeft = [CCActionMoveTo actionWithDuration:0.10 position:ccp(_wolfe.position.x + [enemy[@"walkLeftTo"] intValue], _gaso.position.y)];
        [_gaso runAction:moveLeft];
        facingeachother = FALSE;
        [self performSelector:@selector(gaso_idle) withObject:nil afterDelay:0.5f];
    } else if (_hencher) {
        [_hencher run];
        id moveLeft = [CCActionMoveTo actionWithDuration:0.10 position:ccp(_wolfe.position.x + [enemy[@"walkLeftTo"] intValue], _hencher.position.y)];
        [_hencher runAction:moveLeft];
        facingeachother = FALSE;
        [self performSelector:@selector(hencher_idle) withObject:nil afterDelay:0.5f];
    }
    
    
}

- (void)walkLeft {
    float xPos;
    float size;
    if (_fister) {
        xPos = _fister.position.x;
        size = _fister.contentSizeInPoints.width;
    } else if (_gaso) {
        xPos = _gaso.position.x;
        size = _gaso.contentSizeInPoints.width;
    } else if (_hencher) {
        xPos = _hencher.position.x;
        size = _hencher.contentSizeInPoints.width;
    }
    if (((_wolfe.position.x - _wolfe.contentSizeInPoints.width/2 - 20) > (xPos + size/2 - 5)) || (_wolfe.position.x < xPos)) {
    _wolfe.flipX=YES;
    [_wolfe walk];
    id moveLeft = [CCActionMoveBy actionWithDuration:0.10 position:ccp(-20, 0)];
    [_wolfe runAction:moveLeft];
    facingeachother = FALSE;
    [self performSelector:@selector(wolfe_idle) withObject:nil afterDelay:0.5f];
    }
}

-(void)jumpUp {
    self.userInteractionEnabled = FALSE;
    [_wolfe jumpflip];
    id jumpUp = [CCActionJumpBy actionWithDuration:0.7f position:ccp(0, 200)
                                            height:50 jumps:1];
    id jumpDown = [CCActionJumpBy actionWithDuration:0.7f position:ccp(0,-80)
                                              height:50 jumps:1];
    
    id seq = [CCActionSequence actions:jumpUp, jumpDown, nil];
    
    [_wolfe runAction:seq];
    [self performSelector:@selector(wolfe_idle) withObject:nil afterDelay:0.5f];
    wolfe_jumped = TRUE;
    [self performSelector:@selector(resetJump) withObject:nil afterDelay:2.f];
    _wolfe.physicsBody.velocity = CGPointMake(0, 0);
}

-(void)jumpLeft {
    self.userInteractionEnabled = FALSE;
    _wolfe.flipX=YES;
    [_wolfe jumpflip];
    id jumpUp = [CCActionJumpBy actionWithDuration:0.7f position:ccp(-1*_wolfe.position.x, 200)
                                            height:50 jumps:1];
    id jumpDown = [CCActionJumpBy actionWithDuration:0.7f position:ccp(-1*_wolfe.position.x,-80)
                                              height:50 jumps:1];
    
    id seq = [CCActionSequence actions:jumpUp, jumpDown, nil];
    
    [_wolfe runAction:seq];
    facingeachother = FALSE;
    [self performSelector:@selector(wolfe_idle) withObject:nil afterDelay:2.f];
    wolfe_jumped = TRUE;
    [self performSelector:@selector(resetJump) withObject:nil afterDelay:2.5f];
    _wolfe.physicsBody.velocity = CGPointMake(0, 0);
}

-(void)jumpRight {
    self.userInteractionEnabled = FALSE;
    [_wolfe jumpflip];
    id jumpUp = [CCActionJumpBy actionWithDuration:0.7f position:ccp(400, 200)
                                            height:50 jumps:1];
    id jumpDown = [CCActionJumpBy actionWithDuration:0.3f position:ccp(300,-80)
                                              height:50 jumps:1];
    
    id seq = [CCActionSequence actions:jumpUp, jumpDown, nil];
    
    [_wolfe runAction:seq];
    facingeachother = FALSE;
    [self performSelector:@selector(wolfe_idle) withObject:nil afterDelay:1.5f];
    wolfe_jumped = TRUE;
    [self performSelector:@selector(resetJump) withObject:nil afterDelay:2.5f];
    _wolfe.physicsBody.velocity = CGPointMake(0, 0);
    
}

- (void) crouchComboAttack {
    if (wolfe_attack) {
//        countSpecialComboUse += 1;
        [_wolfe crouchcombo];
        if (_fister) {
            [_fister hit:_wolfe.position];
            [_fister performSelector:@selector(groundhit) withObject:nil afterDelay:0.7f];
            enemyGroundHit = TRUE;
        } else if (_gaso) {
            [_gaso hit:_wolfe.position];
        } else if (_hencher) {
            [_hencher hit];
        }
        fister_hit += 1;
        playerScore += 2000;
        points_fister -= healthPointsToDeducthero;
        [self showScore];
    }
    
}

- (void) resetplayerGroundHit {
    playerGroundHit = FALSE;
}

- (void) resetenemyGroundHit {
    enemyGroundHit = FALSE;
}

- (void)resetJump {
    wolfe_jumped = FALSE;
    self.userInteractionEnabled = TRUE;
    [self flip_handle];
}

- (void)flip_handle {
    float enemyXcoordRight;
    float enemyXcoordLeft;
    float wolfeXcoordRight = _wolfe.boundingBox.origin.x + _wolfe.boundingBox.size.width;
    float wolfeXcoordLeft = _wolfe.boundingBox.origin.x;
    if (_fister) {
        enemyXcoordRight = _fister.boundingBox.origin.x + _fister.boundingBox.size.width;
        enemyXcoordLeft = _fister.boundingBox.origin.x;
    } else if (_gaso) {
        enemyXcoordRight = _gaso.boundingBox.origin.x + _gaso.boundingBox.size.width;
        enemyXcoordLeft = _gaso.boundingBox.origin.x;
    } else {
        enemyXcoordRight = _hencher.boundingBox.origin.x + _hencher.boundingBox.size.width;
        enemyXcoordLeft = _hencher.boundingBox.origin.x;
    }
    
    if (wolfeXcoordRight < enemyXcoordLeft) {
        rightface = TRUE;
        _wolfe.flipX=NO;
        if (_fister) {
            _fister.flipX=NO;
        } else if (_gaso) {
            _gaso.flipX=NO;
        } else if (_hencher) {
            _hencher.flipX=NO;
        }
    }
    else if (wolfeXcoordLeft > enemyXcoordRight) {
        rightface = FALSE;
        _wolfe.flipX=YES;
        if (_fister) {
            _fister.flipX=YES;
        } else if (_gaso) {
            _gaso.flipX=YES;
        } else if (_hencher) {
            _hencher.flipX=YES;
        }

    }
}

- (void)wolfe_idle {
    [_wolfe idle];
    [self flip_handle];
    facingeachother = TRUE;
}

- (void)fister_idle {
    [_fister idle];
    [self flip_handle];
    facingeachother = TRUE;
}

- (void)gaso_idle {
    [_gaso idle];
    [self flip_handle];
    facingeachother = TRUE;
}

- (void)hencher_idle {
    [_hencher idle];
    [self flip_handle];
    facingeachother = TRUE;
}

- (void)loadpowerups {
    NSUInteger size = [powerupArray count];
    NSInteger index = arc4random_uniform((u_int32_t )size);
    currentPowerUp = [powerupArray objectAtIndex:index];
    _powerUp = (CCSprite*)[CCBReader load:currentPowerUp];
    _powerUp.name = @"PowerUp";
    [_powerUpPosition setPosition:[_physicsNode convertToNodeSpace:[self convertToWorldSpace:ccp(self.contentSizeInPoints.width/2, self.contentSizeInPoints.height* 0.9f)]]];
    [_powerUpPosition addChild:_powerUp];
    effect = (CCParticleSystem *)[CCBReader load:@"PowerupEffect"];
    effect.autoRemoveOnFinish = TRUE;
    effect.position = _powerUp.position;
    [_powerUp.parent addChild:effect];
    powerupavailable = TRUE;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero powerUpcol:(CCNode *)powerUpcol {
    playerCollidedwithPowerUp = currentPowerUp;
    CCSprite *powerup = [_powerUpPosition getChildByName:@"PowerUp" recursively:NO];
    [effect removeFromParent];
    [_powerUpPosition removeChild:powerup];
    [self handlePowerUp];
//    points += 5;
    powerupavailable = false;
    
    return TRUE;
}

// @"Health", @"TwoX", @"Star", @"Fire", @"Shield", @"Lightening", @"Freeze"
- (void) handlePowerUp {
    if ([playerCollidedwithPowerUp isEqualToString:@"Health"]) {
        points += 5;
        playerScore += 1000;
    } else if ([playerCollidedwithPowerUp isEqualToString:@"TwoX"]) {
        effect = (CCParticleSystem *)[CCBReader load:@"TwoXEffect"];
        effect.autoRemoveOnFinish = TRUE;
        effect.position = _wolfe.position;
        [_wolfe.parent addChild:effect];
        healthPointsToDeducthero = 8;
        playerScore += 2000;
        [self performSelector:@selector(resetplayerCollidedwithPowerUp) withObject:nil afterDelay:5.f];
    } else if ([playerCollidedwithPowerUp isEqualToString:@"Star"]) {
        playerScore += 5000;
    } else if ([playerCollidedwithPowerUp isEqualToString:@"Shield"]) {
        effect = (CCParticleSystem *)[CCBReader load:@"ShieldEffect"];
        effect.autoRemoveOnFinish = TRUE;
        effect.position = _wolfe.position;
        [_wolfe.parent addChild:effect];
        healthPointsToDeductenemy = 0;
        playerScore += 3000;
        [self performSelector:@selector(resetplayerCollidedwithPowerUp) withObject:nil afterDelay:10.f];
    } else if ([playerCollidedwithPowerUp isEqualToString:@"Lightening"]) {
        effect = (CCParticleSystem *)[CCBReader load:@"LighteningEffect"];
        effect.autoRemoveOnFinish = TRUE;
        playerScore += 3000;
        if (_fister) {
            effect.position = _fister.position;
            [_fister.parent addChild:effect];
        } else if (_gaso) {
            effect.position = _gaso.position;
            [_gaso.parent addChild:effect];
        } else if (_hencher) {
            effect.position = _hencher.position;
            [_hencher.parent addChild:effect];
        }
        
        healthPointsToDeducthero = 10;
        [self performSelector:@selector(resetplayerCollidedwithPowerUp) withObject:nil afterDelay:10.f];
    } else if ([playerCollidedwithPowerUp isEqualToString:@"Freeze"]) {
        effect = (CCParticleSystem *)[CCBReader load:@"FreezeEffect"];
        effect.autoRemoveOnFinish = TRUE;
        if (_fister) {
            effect.position = _fister.position;
            [_fister.parent addChild:effect];
        } else if (_gaso) {
            effect.position = _gaso.position;
            [_gaso.parent addChild:effect];
        } else if (_hencher) {
            effect.position = _hencher.position;
            [_hencher.parent addChild:effect];
        }
        [self performSelector:@selector(resetplayerCollidedwithPowerUp) withObject:nil afterDelay:10.f];
    }
}

- (void) resetplayerCollidedwithPowerUp {
    healthPointsToDeducthero = 4;
    healthPointsToDeductenemy = 4;
    playerCollidedwithPowerUp = @"";
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair enemy:(CCNode *)enemy powerUpcol:(CCNode *)powerUpcol {
    CCSprite *powerup = [_powerUpPosition getChildByName:@"PowerUp" recursively:NO];
    [effect removeFromParent];
    [_powerUpPosition removeChild:powerup];
//    points_fister += 5;
    powerupavailable = false;
     
    return TRUE;
}

//- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair enemy:(CCNode *)enemy hero:(CCNode *)hero {
////    if (wolfe_jumped && (_wolfe.position.x < _fister.position.x) && (_wolfe.position.x + _wolfe.contentSizeInPoints.width/2 > (_fister.position.x - _fister.contentSizeInPoints.width/2 + 5))) {
////        [_wolfe performSelector:@selector(stopAllActions) withObject:nil afterDelay:0.5f];
////        [_wolfe jumpflip];
////        [_wolfe performSelector:@selector(groundhit) withObject:nil afterDelay:0.9f];
////        id moveTo = [CCActionMoveTo actionWithDuration:0.50 position:ccp(_wolfe.position.x, _fister.position.y)];
////        [_wolfe runAction:moveTo];
////        playerGroundHit = TRUE;
////    }
//    
//    return TRUE;
//}

- (void)winScreen {
    if (playerScore >= 35000) {
        popup = (WinPopUp *)[CCBReader load:@"WinPopUp3star" owner:self];
    } else if (playerScore >= 22000 && playerScore < 35000) {
        popup = (WinPopUp *)[CCBReader load:@"WinPopUp2star" owner:self];
    } else if (playerScore < 22000) {
        popup = (WinPopUp *)[CCBReader load:@"WinPopUp1star" owner:self];
    }
    popup._scoreLabel.string = [NSString stringWithFormat:@"%d", playerScore];
    popup.positionType = CCPositionTypeNormalized;
    popup.position = ccp(0.5, 0.5);
    [_wolfe stopAllActions];
    [_fister stopAllActions];
    [self addChild:popup];
    _gameOver = TRUE;
}

- (void)loseScreen {
    popup = (WinPopUp *)[CCBReader load:@"LosePopUp" owner:self];
    popup.positionType = CCPositionTypeNormalized;
//    popup._winPopUpLabel.string = [NSString stringWithFormat:@"You Lose!!"];
    popup.position = ccp(0.5, 0.5);
    [_wolfe stopAllActions];
    [_fister stopAllActions];
    [self addChild:popup];
    _gameOver = TRUE;
}

@end
