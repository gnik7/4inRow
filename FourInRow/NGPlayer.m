//
//  NGPlayer.m
//  FourInRow
//
//  Created by Nikita Gil' on 01.08.15.
//  Copyright (c) 2015 Nikita Gil'. All rights reserved.
//

#import "NGPlayer.h"

@implementation NGPlayer

-(NSString *)spriteName {
    static NSString * const spriteNames[] = {
        //red - 1 type, yellow - 2 type...
        @"empty",
        @"red",
        @"yellow",
    };
    
    return spriteNames[self.numberType];
}

+(NSInteger)spriteTypeByName:(NSString*)name
{
    NSArray *names = @[
        @"empty",
        @"red",
        @"yellow",
    ];
    
    for (NSInteger i = 0; i <[names count]; i++)
    {
        if([name isEqualToString:(NSString*)[names objectAtIndex:i]])
        {
            return i;
        }
    }
    return 0;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"type:%ld square:(%ld,%ld)", (long)self.numberType,
            (long)self.column, (long)self.row];
}

@end
