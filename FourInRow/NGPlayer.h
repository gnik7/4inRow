//
//  NGPlayer.h
//  FourInRow
//
//  Created by Nikita Gil' on 01.08.15.
//  Copyright (c) 2015 Nikita Gil'. All rights reserved.
//

#import <Foundation/Foundation.h>
@import SpriteKit;

@interface NGPlayer : NSObject

@property (assign, nonatomic) NSInteger numberType;
@property (assign, nonatomic) NSInteger column;
@property (assign, nonatomic) NSInteger row;
@property (strong, nonatomic) SKSpriteNode *sprite;

- (NSString *)spriteName;
+(NSInteger)spriteTypeByName:(NSString*)name;

@end
