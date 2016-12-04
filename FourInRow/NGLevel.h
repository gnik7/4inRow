//
//  NGLevel.h
//  FourInRow
//
//  Created by Nikita Gil' on 01.08.15.
//  Copyright (c) 2015 Nikita Gil'. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NGPlayer.h"

static const NSInteger NumColumns = 7;
static const NSInteger NumRows = 6;

@interface NGLevel : NSObject

@property (assign, nonatomic) BOOL endGame;


-(NSInteger)fillColumn:(NSInteger)column withTypePlayer:(NSInteger)type;
-(void) matches;
-(void) restartLevel;

@end
