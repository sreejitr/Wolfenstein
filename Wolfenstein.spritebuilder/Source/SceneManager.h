//
//  SceneManager.h
//  Wolfenstein
//
//  Created by Sreejita Ray on 4/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SceneManager : NSObject
+(void) presentMainMenu;
+(void) presentGameplayScene;
+(void) presentGameplaySceneNoTransition;
+(void) presentTrainingScene;
@end
