#import "MainScene.h"

@implementation MainScene
- (void)play {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

//- (void)play {
//    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
//    [[CCDirector sharedDirector] presentScene:firstLevel withTransition:transition];
//    CCScene *firstLevel = [CCBReader loadAsScene:@"Gameplay"];
//}
@end
