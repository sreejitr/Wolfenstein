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

static NSString * const kFirstLevel = @"Level1";
static NSString *selectedLevel = @"Level1";
static NSString *powerupArray[1];


@implementation Gameplay{
    Wolfe *_wolfe;
    Fister *_fister;
    CCSprite *_powerUp;
//    CCPhysicsNode *_physicsNode;
//    CCNode *_contentNode;
    CCNode *_levelNode;
    Level *_loadedLevel;
    CCLabelTTF *_healthLabel;
    CCLabelTTF *_fisterHealth;
    CCLabelTTF *_winPopUpLabel;
    BOOL _jumped;
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
//    CCButton *_leftButton;
//    CCButton *_rightButton;
//    CCButton *_punch;
//    CCButton *_jump;
    BOOL rightface;
    CCAction *_followWolfe;
    CGPoint touchBeganLocation;
    CGPoint touchMovedLocation;
    BOOL powerupavailable;
    BOOL powerupsactivated;
    CCParticleSystem *effect;
    
}


#pragma mark - Node Lifecycle

- (void)didLoadFromCCB {
    _physicsNode.collisionDelegate = self;
    _loadedLevel = (Level *) [CCBReader load:selectedLevel owner:self];
    [_levelNode addChild:_loadedLevel];
    self.userInteractionEnabled = TRUE;
    _wolfe = (Wolfe*)[CCBReader load:@"Wolfe"];
    [_physicsNode addChild:_wolfe];
//    [_physicsNode addChild:_powerup];
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
    
}

- (void)onEnter {
    [super onEnter];
    
    CCActionFollow *follow = [CCActionFollow actionWithTarget:_wolfe worldBoundary:[_loadedLevel boundingBox]];
    _physicsNode.position = [follow currentOffset];
    [_physicsNode runAction:follow];
}

-(void)update:(CCTime)delta
{
    if (_wolfe.position.x < 60) {
        _wolfe.position = ccp(60, _wolfe.position.y);
    }
    if (!_gameOver) {
        timeelapsed += delta;
        totaltimeelapsed += delta;
        if (totaltimeelapsed >= 2.f && !powerupsactivated) {
            [self loadpowerups];
            powerupsactivated = TRUE;
        }
        else if (totaltimeelapsed > 10.f && !powerupavailable && powerupsactivated) {
            [self loadpowerups];
            totaltimeelapsed = 0.0f;
        }
        if (timeelapsed > 2.f) {
        
            if (!wolfe_attack && fabsf(_wolfe.position.x - _fister.position.x) <= 200) {
//                self.userInteractionEnabled = FALSE;
                fister_attack = TRUE;
                wolfe_hit += 1;
//                points -= 5;
                [self showScore];
                [_fister punch];
                if (_wolfe.flipX == NO) {
                    _fister.position = ccp(_wolfe.position.x + 200, _fister.position.y);
                } else {
                    _fister.position = ccp(_wolfe.position.x - 200, _fister.position.y);
                }
                
                if (points == 0) {
                    [_wolfe hit];
                    [_wolfe groundhit];
                }
                else {
                    [_wolfe hit];
                }
                [self performSelector:@selector(turnoff_fister_attack) withObject:nil afterDelay:2.f];
//                [_wolfe performSelector:@selector(idle) withObject:nil afterDelay:6.f];
//                [_fister performSelector:@selector(idle) withObject:nil afterDelay:6.f];
//                _wolfe.position = ccp(225, 110);
                
            }
            else if (!wolfe_attack) {
                if (_fister.position.x - _wolfe.position.x > 200){
                    NSLog(@"Left");
//                    NSLog([NSString stringWithFormat:@"Wolfe x: %f", _wolfe.position.x]);
//                    NSLog([NSString stringWithFormat:@"box origin x: %f", _loadedLevel.boundingBox.origin.x]);
//                    NSLog([NSString stringWithFormat:@"Fister x: %f", _fister.position.x]);
//                    NSLog([NSString stringWithFormat:@"level width: %f", _loadedLevel.boundingBox.size.width]);
                    [_fister run];
                    id moveLeft = [CCActionMoveTo actionWithDuration:0.10 position:ccp(_wolfe.position.x + 200, _fister.position.y)];
                    [_fister runAction:moveLeft];
                    [self performSelector:@selector(fister_idle) withObject:nil afterDelay:0.5f];
                    
                }
                if ((_wolfe.position.x - _fister.position.x > 200) && (_wolfe.position.x - 200 <= (_loadedLevel.boundingBox.size.width - 190))) {
                    NSLog(@"Right");
//                    NSLog([NSString stringWithFormat:@"Wolfe x: %f", _wolfe.position.x]);
//                    NSLog([NSString stringWithFormat:@"Fister x: %f", _fister.position.x]);
//                    NSLog([NSString stringWithFormat:@"level width: %f", _loadedLevel.boundingBox.size.width]);
                    [_fister run];
                    id moveRight = [CCActionMoveTo actionWithDuration:0.10 position:ccp(_wolfe.position.x - 100, _fister.position.y)];
                    [_fister runAction:moveRight];
                    [self performSelector:@selector(fister_idle) withObject:nil afterDelay:0.5f];
                }
                
            }
            
            timeelapsed = 0.0f;
            
            
        }
        if (points_fister == 0) {
            
            popup = (WinPopUp *)[CCBReader load:@"WinPopUp" owner:self];
            popup.positionType = CCPositionTypeNormalized;
            popup.position = ccp(0.5, 0.5);
            [_wolfe stopAllActions];
            [_fister stopAllActions];
            [self addChild:popup];
            _gameOver = TRUE;

        }
        if (points == 0) {
            popup = (WinPopUp *)[CCBReader load:@"WinPopUp" owner:self];
            popup.positionType = CCPositionTypeNormalized;
            popup._winPopUpLabel.string = [NSString stringWithFormat:@"You Lose!!"];
            popup.position = ccp(0.5, 0.5);
            [_wolfe stopAllActions];
            [_fister stopAllActions];
            [self addChild:popup];
            _gameOver = TRUE;
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
//    NSLog(@"touch received");
    touchBeganLocation = [touch locationInNode:self.parent];
//    NSLog([NSString stringWithFormat:@"touchbegan x: %f", touchBeganLocation.x]);
//    NSLog([NSString stringWithFormat:@"touchbegan y: %f", touchBeganLocation.y]);

    if (!_gameOver) {
        
        if (!fister_attack && fabsf(_wolfe.position.x - _fister.position.x) <= 200) {
            self.userInteractionEnabled = FALSE;
            wolfe_attack = TRUE;
            [_wolfe attack];
            fister_hit += 1;
            points_fister -= 5;
            [self showScore];
            if (points_fister == 0) {
                [_fister hit];
                [_fister groundhit];
            }
            else {
                [_fister hit];
            }
            
            [self performSelector:@selector(turnoff_wolfe_attack) withObject:nil afterDelay:2.f];
//            self.userInteractionEnabled = TRUE;
        }
        else if (fister_attack) {
            [_wolfe block];
        }
        
    }
    
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

- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{

    self.userInteractionEnabled = TRUE;
    [_fister idle];
    
    touchMovedLocation = [touch locationInNode:self.parent];
//    if(!CGRectIntersectsRect(_wolfe.boundingBox, _fister.boundingBox)){
    
        if ((touchBeganLocation.x - touchMovedLocation.x > 50) && (_wolfe.position.x - 20 > _loadedLevel.boundingBox.origin.x + 90)) {
//            NSLog(@"Left");
            _wolfe.flipX=YES;
            _fister.flipX=YES;
            [_wolfe walk];
            id moveLeft = [CCActionMoveBy actionWithDuration:0.10 position:ccp(-20, 0)];
            [_wolfe runAction:moveLeft];
            [self performSelector:@selector(wolfe_idle) withObject:nil afterDelay:0.5f];
            
        }
        if ((touchMovedLocation.x - touchBeganLocation.x > 50) && (_wolfe.position.x + 20 < (_loadedLevel.boundingBox.size.width - 90))) {
//            NSLog(@"Right");
            _wolfe.flipX=NO;
            _fister.flipX=NO;
            [_wolfe walk];
            id moveRight = [CCActionMoveBy actionWithDuration:0.10 position:ccp(20, 0)];
            [_wolfe runAction:moveRight];
            [self performSelector:@selector(wolfe_idle) withObject:nil afterDelay:0.5f];
        }
            
        if ((touchMovedLocation.y - touchBeganLocation.y > 50) && (_wolfe.position.y + 20 < (_loadedLevel.boundingBox.size.height - 50))) {
            //            NSLog(@"Right");
//            _wolfe.flipX=NO;
//            _fister.flipX=NO;
//            [_wolfe jumpflip];
            id moveUp = [CCActionMoveBy actionWithDuration:0.01 position:ccp(0, 30)];
            [_wolfe runAction:moveUp];
//            [_wolfe.physicsBody applyImpulse:ccp(0, 1000)];
            [_wolfe.physicsBody applyImpulse:ccp(0, -1 * _wolfe.physicsBody.velocity.y)];
            [self performSelector:@selector(wolfe_idle) withObject:nil afterDelay:0.5f];
        }
        _followWolfe = [CCActionFollow actionWithTarget:_wolfe worldBoundary:self.boundingBox];
        [_levelNode runAction:_followWolfe];
//    }
    
}


- (void)wolfe_idle {
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

    [_wolfe idle];
}

- (void)fister_idle {
    [_fister idle];
}

- (void)loadpowerups {
    NSString *str = @"Lightening";
    _powerUp = (CCSprite*)[CCBReader load:str];
    _powerUp.name = @"PowerUp";
    [_physicsNode addChild:_powerUp];
    _powerUp.position = ccp(283, 264);
    // load particle effect
    effect = (CCParticleSystem *)[CCBReader load:@"PowerupEffect"];
//    effect.autoRemoveOnFinish = TRUE;
    effect.position = _powerUp.position;
    [_powerUp.parent addChild:effect];
    powerupavailable = TRUE;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero powerUpcol:(CCNode *)powerUpcol {
    CCSprite *powerup = [_physicsNode getChildByName:@"PowerUp" recursively:NO];
    [_physicsNode removeChild:powerup];
    [effect removeFromParent];
    points += 5;
    powerupavailable = false;
    
    return TRUE;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair enemy:(CCNode *)enemy powerUpcol:(CCNode *)powerUpcol {
    [_physicsNode removeChild: _powerUp];
    points_fister += 5;
    powerupavailable = false;
    
    return TRUE;
}

@end
