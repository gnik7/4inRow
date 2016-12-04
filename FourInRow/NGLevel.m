//
//  NGLevel.m
//  FourInRow
//
//  Created by Nikita Gil' on 01.08.15.
//  Copyright (c) 2015 Nikita Gil'. All rights reserved.
//

#import "NGLevel.h"
#import "Settings.h"

@implementation NGLevel
{
    NGPlayer *_players[NumRows][NumColumns]; //array with circle of players
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.endGame = NO;
        
        for (NSInteger row = 0; row < NumRows; row++)
        {
            for (NSInteger column = 0; column < NumColumns; column++)
            {
                NGPlayer *pl = [NGPlayer new];
                pl.numberType = 0;
                pl.row = row;
                pl.column = column;
                _players[row][column] = pl;
            }
        }
    }
    return self;
}



#pragma mark - Fill

-(NSInteger)fillColumn:(NSInteger)col withTypePlayer:(NSInteger)type
{
    for (NSInteger row = 0; row < NumRows; row++)
    {
        if(_players[row][col].numberType == 0 /*&& row != NumRows-1*/)
        {
            _players[row][col].numberType = type;
            return  row;
        }
    }
    return  NumRows-1;
}

#pragma mark - Match

//check variants to win
-(void) matches
{
    if ([self detectHorizontal] != 0 || [self detectVertical] !=0 ||
        [self detectDiagonalRtoL] !=0 || [self detectDiagonalLtoR] != 0)
    {
        self.endGame = YES;
    }
}


#pragma mark - Detect

-(NSInteger)detectHorizontal
{
    for (NSInteger row = 0; row < NumRows; row++)
    {
        for (NSInteger column = 0; column < NumColumns-3; column++)
        {
            if(_players[row][column].numberType == _players[row][column+1].numberType &&
               _players[row][column+1].numberType == _players[row][column+2].numberType &&
               _players[row][column+2].numberType == _players[row][column+3].numberType &&
               _players[row][column].numberType != 0)
               
                return _players[row][column].numberType;
        }
    }
    return 0;
}

-(NSInteger)detectVertical
{
    for (NSInteger row = 0; row < NumRows-3; row++)
    {
        for (NSInteger column = 0; column < NumColumns; column++)
        {
            if(_players[row][column].numberType == _players[row + 1][column].numberType &&
               _players[row+1][column].numberType == _players[row + 2][column].numberType &&
               _players[row+2][column].numberType == _players[row + 3][column].numberType &&
               _players[row][column].numberType != 0 )
                
                return _players[row][column].numberType;
        }
    }
    return 0;
}

-(NSInteger)detectDiagonalLtoR
{
    for (NSInteger row = 0; row < NumRows-3; row++)
    {
        for (NSInteger column = 0; column < NumColumns-3; column++)
        {
            if(_players[row][column].numberType == _players[row + 1][column+1].numberType &&
               _players[row+1][column+1].numberType == _players[row + 2][column+2].numberType &&
               _players[row+2][column+2].numberType == _players[row + 3][column+3].numberType &&
               _players[row][column].numberType != 0)
                
                return _players[row][column].numberType;
        }
    }
    return 0;
}

-(NSInteger)detectDiagonalRtoL
{
    for (NSInteger row = 0; row < NumRows-3; row++)
    {
        for (NSInteger column = NumColumns-1; column > NumColumns-4; column--)
        {
            if(_players[row][column].numberType != 0 &&
               _players[row][column].numberType == _players[row + 1][column-1].numberType &&
               _players[row+1][column-1].numberType == _players[row + 2][column-2].numberType &&
               _players[row+2][column-2].numberType == _players[row + 3][column-3].numberType)
                
                return _players[row][column].numberType;
        }
    }
    return 0;
}



#pragma mark - Restart

-(void) restartLevel
{
    self.endGame = NO;
    
    for (NSInteger row = 0; row < NumRows; row++)
    {
        for (NSInteger column = 0; column < NumColumns; column++)
        {
            _players[row][column] = nil;
            NGPlayer *pl = [[NGPlayer alloc] init];
            pl.numberType = 0;
            pl.row = row;
            pl.column = column;
            _players[row][column] = pl;
        }
    }

}

@end
