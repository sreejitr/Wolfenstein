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
static NSInteger maxSpecialComboUse = 5;


@implementation Gameplay{
    Wolfe *_wolfe;
    Fister *_fister;
    CCSprite *_powerUp;
    CCNode *_levelNode;
    Level *_loadedLevel;
    CCLabelTTF *_healthLabel;
    CCLabelTTF *_fisterHealth;
    CCLabelTTF *_winPopUpLabel;
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
    NSInteger countSpecialComboUse;
    
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
    points = 100;
    points_fister = 100;
    [self showScore];
    _gameOver = FALSE;
    powerupavailable = false;
    powerupsactivated = false;
    powerupArray = @[@"Health", @"TwoX", @"Star", @"Fire", @"Shield", @"Lightening", @"Freeze"];
    wolfe_jumped = false;
    playerGroundHit = FALSE;
    countSpecialComboUse = 0;
    //_physicsNode.debugDraw = TRUE;
    
}

- (void)onEnter {
    [super onEnter];
    
    CCActionFollow *follow = [CCActionFollow actionWithTarget:_wolfe worldBoundary:[_loadedLevel boundingBox]];
    _physicsNode.position = [follow currentOffset];
    [_physicsNode runAction:follow];
}

-(void)update:(CCTime)delta
{
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
    if (!_gameOver) {
        timeelapsed += delta;
        totaltimeelapsed += delta;
        if (totaltimeelapsed >= 2.f && !powerupsactivated) {
            [self loadpowerups];
            powerupsactivated = TRUE;
        }
        else if (totaltimeelapsed > 10.f && !powerupavailable && powerupsactivated && !wolfe_jumped) {
            [self loadpowerups];
            totaltimeelapsed = 0.0f;
        }
        if (timeelapsed > 2.f) {
        
            if (!wolfe_attack && fabsf(_wolfe.position.x - _fister.position.x) <= 200 && !wolfe_jumped && !playerGroundHit) {
//                self.userInteractionEnabled = FALSE;
                fister_attack = TRUE;
                wolfe_hit += 1;
//                points -= 5;
                [self showScore];
                [_fister punch];
                if (_wolfe.position.x < _fister.position.x) {
                    _fister.position = ccp(_wolfe.position.x + 190, _fister.position.y);
                } else if (_wolfe.position.x > _fister.position.x) {
                    _fister.position = ccp(_wolfe.position.x - 200, _fister.position.y);
                }
                
                if (points == 0) {
                    [_wolfe hit];
                    [_wolfe groundhit];
                    playerGroundHit = TRUE;
                }
                else {
                    [_wolfe hit];
                }
                [self performSelector:@selector(turnoff_fister_attack) withObject:nil afterDelay:2.f];
                
            }
            else if (!wolfe_attack) {
                if (_fister.position.x - _wolfe.position.x > 200){
                    [self walkLeftEnemy];
                }
                if ((_wolfe.position.x - _fister.position.x > 200) && (_wolfe.position.x - 200 <= (_loadedLevel.boundingBox.size.width - 190))) {
                    [self walkRightEnemy];
                }
                
            }
            timeelapsed = 0.0f;
        }
        if (points_fister == 0) {
            [self winScreen];
        }
        if (points == 0) {
            [self loseScreen];
        }
    }
}

//- (void)

- (void)showScore
{
    _healthLabel.string = [NSString stringWithFormat:@"Wolfe: %d", points];
    _healthLabel.visible = true;
    _fisterHealth.string = [NSString stringWithFormat:@"Fister: %d", points_fister];
    _fisterHealth.visible = true;
}

-(void) touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    NSLog([NSString stringWithFormat:@"Wolfe width: %f", _wolfe.boundingBox.size.width]);
//    NSLog([NSString stringWithFormat:@"Wolfe physicsbody: %f", _wolfe.physicsBody.]);
    NSLog([NSString stringWithFormat:@"Fister width: %f", _fister.boundingBox.size.width]);
    NSLog([NSString stringWithFormat:@"Wolfe x: %f", _wolfe.position.x]);
    NSLog([NSString stringWithFormat:@"Fister x: %f", _fister.position.x]);
    NSLog([NSString stringWithFormat:@"Level width: %f", _loadedLevel.boundingBox.size.width]);
    touchBeganLocation = [touch locationInNode:self.parent];

    if (!_gameOver) {
        
        if (!fister_attack && fabsf(_wolfe.position.x - _fister.position.x) <= 200 && !wolfe_jumped && !playerGroundHit) {
            [self wolfeAttackBegan];
        }
        else if (fister_attack) {
//            [_wolfe block];
        }
        
    }
    
}

- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    self.userInteractionEnabled = TRUE;
    [_fister idle];
    
    touchMovedLocation = [touch locationInNode:self.parent];
    NSLog([NSString stringWithFormat:@"touchbegan x: %f", touchBeganLocation.x]);
    NSLog([NSString stringWithFormat:@"touchbegan y: %f", touchBeganLocation.y]);
    NSLog([NSString stringWithFormat:@"touchMovedLocation x: %f", touchMovedLocation.x]);
    NSLog([NSString stringWithFormat:@"touchMovedLocation y: %f", touchMovedLocation.y]);
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
    if ((touchBeganLocation.y - touchMovedLocation.y > 50) && !wolfe_jumped && countSpecialComboUse <= maxSpecialComboUse)
    {
        [self crouchComboAttack];
    }
    
    _followWolfe = [CCActionFollow actionWithTarget:_wolfe worldBoundary:self.boundingBox];
    [_levelNode runAction:_followWolfe];
}

-(void) wolfeAttackBegan {
    self.userInteractionEnabled = FALSE;
    wolfe_attack = TRUE;
    [_wolfe attack];
    fister_hit += 1;
    points_fister -= 2;
    [self showScore];
    if (points_fister == 0) {
        [_fister hit];
        [_fister groundhit];
    }
    else {
        [_fister hit];
    }
    
    [self performSelector:@selector(turnoff_wolfe_attack) withObject:nil afterDelay:2.f];
}

-(void) turnoff_wolfe_attack {
    wolfe_attack = FALSE;
    self.userInteractionEnabled = TRUE;
    self.multipleTouchEnabled = TRUE;
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
    id moveRight = [CCActionMoveTo actionWithDuration:0.10 position:ccp(_wolfe.position.x - 200, _fister.position.y)];
    [_fister runAction:moveRight];
    [self performSelector:@selector(fister_idle) withObject:nil afterDelay:0.5f];
    
}

- (void)walkRight {
    _wolfe.flipX=NO;
    [_wolfe walk];
    id moveRight = [CCActionMoveBy actionWithDuration:0.10 position:ccp(20, 0)];
    [_wolfe runAction:moveRight];
    [self performSelector:@selector(wolfe_idle) withObject:nil afterDelay:0.5f];
    
}

- (void)walkLeftEnemy {
    //NSLog([NSString stringWithFormat:@"Wolfe x: %f", _wolfe.position.x]);
    //NSLog([NSString stringWithFormat:@"box origin x: %f", _loadedLevel.boundingBox.origin.x]);
    //NSLog([NSString stringWithFormat:@"Fister x: %f", _fister.position.x]);
    //NSLog([NSString stringWithFormat:@"level width: %f", _loadedLevel.boundingBox.size.width]);
    [_fister run];
    id moveLeft = [CCActionMoveTo actionWithDuration:0.10 position:ccp(_wolfe.position.x + 200, _fister.position.y)];
    [_fister runAction:moveLeft];
    [self performSelector:@selector(fister_idle) withObject:nil afterDelay:0.5f];
    
}

- (void)walkLeft {
    _wolfe.flipX=YES;
    [_wolfe walk];
    id moveLeft = [CCActionMoveBy actionWithDuration:0.10 position:ccp(-20, 0)];
    [_wolfe runAction:moveLeft];
    [self performSelector:@selector(wolfe_idle) withObject:nil afterDelay:0.5f];
    
}

-(void)jumpUp {
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
    _wolfe.flipX=YES;
    [_wolfe jumpflip];
    id jumpUp = [CCActionJumpBy actionWithDuration:0.7f position:ccp(-1*_wolfe.position.x, 200)
                                            height:50 jumps:1];
    id jumpDown = [CCActionJumpBy actionWithDuration:0.7f position:ccp(-1*_wolfe.position.x,-80)
                                              height:50 jumps:1];
    
    id seq = [CCActionSequence actions:jumpUp, jumpDown, nil];
    
    [_wolfe runAction:seq];
    [self performSelector:@selector(wolfe_idle) withObject:nil afterDelay:2.f];
    wolfe_jumped = TRUE;
    [self performSelector:@selector(resetJump) withObject:nil afterDelay:2.f];
    _wolfe.physicsBody.velocity = CGPointMake(0, 0);
}

-(void)jumpRight {
    [_wolfe jumpflip];
    id jumpUp = [CCActionJumpBy actionWithDuration:0.7f position:ccp(200, 200)
                                            height:50 jumps:1];
    id jumpDown = [CCActionJumpBy actionWithDuration:0.7f position:ccp(200,-80)
                                              height:50 jumps:1];
    
    id seq = [CCActionSequence actions:jumpUp, jumpDown, nil];
    
    [_wolfe runAction:seq];
    [self performSelector:@selector(wolfe_idle) withObject:nil afterDelay:2.f];
    wolfe_jumped = TRUE;
    [self performSelector:@selector(resetJump) withObject:nil afterDelay:2.f];
    _wolfe.physicsBody.velocity = CGPointMake(0, 0);
    
}

- (void) crouchComboAttack {
    if (wolfe_attack) {
//        countSpecialComboUse += 1;
        [_wolfe crouchcombo];
        [_fister hit];
        playerGroundHit = TRUE;
        [_fister performSelector:@selector(groundhit) withObject:nil afterDelay:1.f];
        if (!_gameOver) {
            [_fister performSelector:@selector(getup) withObject:nil afterDelay:2.f];
            [self performSelector:@selector(resetplayerGroundHit) withObject:nil afterDelay:2.2f];
        }
    }
    
}

- (void) resetplayerGroundHit {
    playerGroundHit = FALSE;
}

- (void)resetJump {
    wolfe_jumped = FALSE;
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
}

- (void)fister_idle {
    [_fister idle];
    [self flip_handle];
}

- (void)loadpowerups {
    NSUInteger size = [powerupArray count];
    NSInteger index = arc4random_uniform((u_int32_t )size);
    NSString *str = [powerupArray objectAtIndex:index];
    _powerUp = (CCSprite*)[CCBReader load:str];
    _powerUp.name = @"PowerUp";
//    CGSize winSize = [[CCDirector sharedDirector] ];
//    CGPoint centerPoint = ccpSub(ccp(winSize.width/2, winSize.height - 50), [self position]);
//    [_powerUp setPosition:centerPoint];
    [_powerUpPosition setPosition:[_physicsNode convertToNodeSpace:[self convertToWorldSpace:ccp(self.contentSizeInPoints.width/2, self.contentSizeInPoints.height* 0.8f)]]];
    [_powerUpPosition addChild:_powerUp];
    NSLog([NSString stringWithFormat:@"_powerUpPosition x: %f", _powerUpPosition.position.x]);
    NSLog([NSString stringWithFormat:@"_powerUpPosition y: %f", _powerUpPosition.position.y]);
//    _powerUp.position = _powerUpPosition.position; //convertToWorldSpace:ccp(0, 0)]; //ccp(283, 264);
    effect = (CCParticleSystem *)[CCBReader load:@"PowerupEffect"];
    effect.position = _powerUp.position;
    [_powerUp.parent addChild:effect];
    powerupavailable = TRUE;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero powerUpcol:(CCNode *)powerUpcol {
    CCSprite *powerup = [_powerUpPosition getChildByName:@"PowerUp" recursively:NO];
    [_powerUpPosition removeChild:powerup];
    [effect removeFromParent];
    points += 5;
    powerupavailable = false;
    
    return TRUE;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair enemy:(CCNode *)enemy powerUpcol:(CCNode *)powerUpcol {
    CCSprite *powerup = [_powerUpPosition getChildByName:@"PowerUp" recursively:NO];
    [_powerUpPosition removeChild:powerup];
    points_fister += 5;
    powerupavailable = false;
    
    return TRUE;
}

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
