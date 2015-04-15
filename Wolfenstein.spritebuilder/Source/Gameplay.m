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
#import "WinPopUp.h"
#import "CCActionFollow+CurrentOffset.h"
#import "CCPhysics+ObjectiveChipmunk.h"
#import "CCDirector.h"

static NSString * const kFirstLevel = @"Level1";
static NSString *selectedLevel = @"Level1";


@implementation Gameplay{
    Wolfe *_wolfe;
    Fister *_fister;
    CCSprite *_powerUp;
    CCNode *_levelNode;
    Level *_loadedLevel;
    CCLabelTTF *_healthLabel;
    CCLabelTTF *_fisterHealth;
    CCLabelTTF *_winPopUpLabel;
    CCLabelTTF *_gamePoints;
    CCLabelTTF *_reqScore;
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
}


#pragma mark - Node Lifecycle

- (void)didLoadFromCCB {
    _physicsNode.collisionDelegate = self;
    _loadedLevel = (Level *) [CCBReader load:selectedLevel owner:self];
    [_levelNode addChild:_loadedLevel];
    self.userInteractionEnabled = TRUE;
    _wolfe = (Wolfe*)[CCBReader load:@"Wolfe"];
    [_physicsNode addChild:_wolfe];
    _wolfe.position = ccp(205, 110);
    rightface = TRUE;
    _fister = (Fister*)[CCBReader load:@"Fister"];
    [_physicsNode addChild:_fister];
    _fister.position = ccp(370, 110);
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
    _reqScore.string = [NSString stringWithFormat:@"Required Score: 12000"];
    _reqScore.visible = true;
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
        if (_wolfe.position.x < 70) {
            _wolfe.position = ccp(60, _wolfe.position.y);
        }
        if (_wolfe.position.x > 740) {
            _wolfe.position = ccp(740, _wolfe.position.y);
        }
        if (_fister.position.x < 60) {
            _fister.position = ccp(60, _wolfe.position.y);
        }
        if (_fister.position.x > 740) {
            _fister.position = ccp(740, _wolfe.position.y);
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
        
            if (!wolfe_attack && fabsf(_wolfe.position.x - _fister.position.x) <= 200 && !wolfe_jumped && !playerGroundHit && !enemyGroundHit && (![playerCollidedwithPowerUp isEqualToString:@"Freeze"])) {
                [self enemyAttackBegan];
            } else if (!wolfe_attack && ![playerCollidedwithPowerUp isEqualToString:@"Freeze"] && ![playerCollidedwithPowerUp isEqualToString:@"Lightening"]) {
                [self flip_handle];
                if (_fister.position.x - _wolfe.position.x > 200){
                    [self walkLeftEnemy];
                }
                if (_wolfe.position.x - _fister.position.x > 200){
                    [self walkRightEnemy];
                }
                
            } else if ([playerCollidedwithPowerUp isEqualToString:@"Lightening"]) {
                [self flip_handle];
            }
            timeelapsed = 0.0f;
        }
        
    }
}

- (void) enemyAttackBegan {
    self.userInteractionEnabled = FALSE;
    fister_attack = TRUE;
    wolfe_hit += 1;
    playerScore -= 200;
    points -= healthPointsToDeductenemy;
    [self showScore];
    [_fister punch];
    [_wolfe performSelector:@selector(hit) withObject:nil afterDelay:0.2f];
    [self performSelector:@selector(fister_idle) withObject:nil afterDelay:0.9f];
    if (_fister.flipX == NO) {
        id moveBy = [CCActionMoveTo actionWithDuration:0.30 position:ccp(_fister.position.x + 90, _fister.position.y)];
        [_fister runAction:moveBy];
    }
    if (points == 0) {
        [_wolfe groundhit];
        playerGroundHit = TRUE;
    }
    
    [self performSelector:@selector(turnoff_fister_attack) withObject:nil afterDelay:2.f];
//    NSLog([NSString stringWithFormat:@"Wolfe x: %f", _wolfe.position.x]);
//    NSLog([NSString stringWithFormat:@"Fister x: %f", _fister.position.x]);
    if (_wolfe.position.x < _fister.position.x) {
        _fister.position = ccp(_wolfe.position.x + 170, _fister.position.y);
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
    
    _fisterHealth.string = [NSString stringWithFormat:@"Fister: %d", points_fister];
    _fisterHealth.visible = true;
    if (points_fister >= 60) {
        _fisterHealth.color = [CCColor colorWithRed:0.2 green:0.7 blue:0.1];
    } else if (points_fister < 60 && points_fister >= 25) {
        _fisterHealth.color = [CCColor colorWithRed:0.7 green:0.2 blue:0.0];
    } else if (points_fister < 25 && points_fister >= 0) {
        _fisterHealth.color = [CCColor colorWithRed:1.0 green:0.0 blue:0.0];
    }
    
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
        
        if (!fister_attack && fabsf(_wolfe.position.x - _fister.position.x) < 200 && !wolfe_jumped && !playerGroundHit && !enemyGroundHit) {
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
            [_fister performSelector:@selector(getup) withObject:nil afterDelay:2.f];
            [self performSelector:@selector(resetenemyGroundHit) withObject:nil afterDelay:1.f];
        }
        [self performSelector:@selector(turnoff_wolfe_attack) withObject:nil afterDelay:3.5f];
    } else {
        [_wolfe attack];
        [_fister hit];
        [self performSelector:@selector(updateEnemyScore) withObject:nil afterDelay:1.2f];
        [self showScore];
        if (points_fister == 0) {
            [_fister groundhit];
        }
        [self performSelector:@selector(turnoff_wolfe_attack) withObject:nil afterDelay:1.9f];
    }
    
}

- (void) updateEnemyScore {
    if ( (_wolfe.flipX == NO) || (fabsf(_fister.position.x - _wolfe.position.x) < 200)) {
        fister_hit += 1;
        playerScore += 500;
        points_fister -= healthPointsToDeducthero;
    }

}

-(void) turnoff_wolfe_attack {
    wolfe_attack = FALSE;
    self.userInteractionEnabled = TRUE;
    self.multipleTouchEnabled = TRUE;
    
//    [_wolfe idle];
    wolfeAttackEnable = false;
    if (_fister.flipX == YES) {
//        id moveTo = [CCActionMoveTo actionWithDuration:0.10 position:ccp(_fister.position.x + 40, _fister.position.y)];
//        [_fister runAction:moveTo];
    }
    
}

-(void) turnoff_fister_attack {
    fister_attack = FALSE;
    self.userInteractionEnabled = TRUE;
    self.multipleTouchEnabled = TRUE;
}


- (void)walkRightEnemy {
    _fister.flipX=YES;
    NSLog(@"Right");
    [_fister run];
    id moveRight = [CCActionMoveTo actionWithDuration:0.10 position:ccp(_wolfe.position.x - 180, _fister.position.y)];
    [_fister runAction:moveRight];
    facingeachother = false;
    [self performSelector:@selector(fister_idle) withObject:nil afterDelay:0.5f];
    
}

- (void)walkRight {
    if ((_wolfe.position.x + _wolfe.contentSizeInPoints.width/2 + 20) < (_fister.position.x - _fister.contentSizeInPoints.width/2 + 5) || (_wolfe.position.x > _fister.position.x)) {
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
    [_fister run];
    id moveLeft = [CCActionMoveTo actionWithDuration:0.10 position:ccp(_wolfe.position.x + 170, _fister.position.y)];
    [_fister runAction:moveLeft];
    facingeachother = FALSE;
    [self performSelector:@selector(fister_idle) withObject:nil afterDelay:0.5f];
    
}

- (void)walkLeft {
    if (((_wolfe.position.x - _wolfe.contentSizeInPoints.width/2 - 20) > (_fister.position.x + _fister.contentSizeInPoints.width/2 - 5)) || (_wolfe.position.x < _fister.position.x)) {
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
        [_fister hit];
        [_fister performSelector:@selector(groundhit) withObject:nil afterDelay:0.7f];
        enemyGroundHit = TRUE;
        fister_hit += 1;
        playerScore += 1000;
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
    float wolfeXcoordRight = _wolfe.boundingBox.origin.x + _wolfe.boundingBox.size.width;
    float wolfeXcoordLeft = _wolfe.boundingBox.origin.x;
    float fisterXcoordRight = _fister.boundingBox.origin.x + _fister.boundingBox.size.width;
    float fisterXcoordLeft = _fister.boundingBox.origin.x;
    if (wolfeXcoordRight < fisterXcoordLeft) {
        rightface = TRUE;
        _wolfe.flipX=NO;
        _fister.flipX=NO;
    }
    else if (wolfeXcoordLeft > fisterXcoordRight) {
        rightface = FALSE;
        _wolfe.flipX=YES;
        _fister.flipX=YES;
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

- (void)loadpowerups {
    NSUInteger size = [powerupArray count];
    NSInteger index = arc4random_uniform((u_int32_t )size);
    currentPowerUp = [powerupArray objectAtIndex:index];
    _powerUp = (CCSprite*)[CCBReader load:currentPowerUp];
    _powerUp.name = @"PowerUp";
    [_powerUpPosition setPosition:[_physicsNode convertToNodeSpace:[self convertToWorldSpace:ccp(self.contentSizeInPoints.width/2, self.contentSizeInPoints.height* 0.8f)]]];
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
    } else if ([playerCollidedwithPowerUp isEqualToString:@"TwoX"]) {
        effect = (CCParticleSystem *)[CCBReader load:@"TwoXEffect"];
        effect.autoRemoveOnFinish = TRUE;
        effect.position = _wolfe.position;
        [_wolfe.parent addChild:effect];
        healthPointsToDeducthero = 8;
        playerScore += 100;
        [self performSelector:@selector(resetplayerCollidedwithPowerUp) withObject:nil afterDelay:5.f];
    } else if ([playerCollidedwithPowerUp isEqualToString:@"Star"]) {
        playerScore += 1000;
    } else if ([playerCollidedwithPowerUp isEqualToString:@"Shield"]) {
        effect = (CCParticleSystem *)[CCBReader load:@"ShieldEffect"];
        effect.autoRemoveOnFinish = TRUE;
        effect.position = _wolfe.position;
        [_wolfe.parent addChild:effect];
        healthPointsToDeductenemy = 0;
        playerScore += 200;
        [self performSelector:@selector(resetplayerCollidedwithPowerUp) withObject:nil afterDelay:10.f];
    } else if ([playerCollidedwithPowerUp isEqualToString:@"Lightening"]) {
        effect = (CCParticleSystem *)[CCBReader load:@"LighteningEffect"];
        effect.autoRemoveOnFinish = TRUE;
        effect.position = _fister.position;
        [_fister.parent addChild:effect];
        healthPointsToDeducthero = 10;
        [self performSelector:@selector(resetplayerCollidedwithPowerUp) withObject:nil afterDelay:10.f];
    } else if ([playerCollidedwithPowerUp isEqualToString:@"Freeze"]) {
        effect = (CCParticleSystem *)[CCBReader load:@"FreezeEffect"];
        effect.autoRemoveOnFinish = TRUE;
        effect.position = _fister.position;
        [_fister.parent addChild:effect];
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
    popup = (WinPopUp *)[CCBReader load:@"WinPopUp" owner:self];
    popup.positionType = CCPositionTypeNormalized;
    popup.position = ccp(0.5, 0.5);
    [_wolfe stopAllActions];
    [_fister stopAllActions];
    [self addChild:popup];
    _gameOver = TRUE;
}

- (void)loseScreen {
    popup = (WinPopUp *)[CCBReader load:@"WinPopUp" owner:self];
    popup.positionType = CCPositionTypeNormalized;
    popup._winPopUpLabel.string = [NSString stringWithFormat:@"You Lose!!"];
    popup.position = ccp(0.5, 0.5);
    [_wolfe stopAllActions];
    [_fister stopAllActions];
    [self addChild:popup];
    _gameOver = TRUE;
}

@end
