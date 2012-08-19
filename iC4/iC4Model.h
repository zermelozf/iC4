//
//  iC4Model.h
//  iC4
//
//  Created by zermelo on 15/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface iC4Model : NSObject {

    int board[6][7];
    int player;
    int gameFinished;
    int nTileOnBoard;
    NSString *firstPlayers;
    NSInteger difficulty;
    
    
}

@property int player;
@property int gameFinished;
@property int nTilesOnBoard;
@property NSInteger difficulty;
@property(nonatomic,retain) NSString *firstPlayer;

-(int) getBoardAtRow:(int)i AndColumn:(int)j;
-(void) setBoardAtRow:(int)i AndColumn:(int)j toValue:(int)v;
-(void) playAtColumn:(int) col;
-(void) updateBoard:(int [6][7])b AtColumn:(NSInteger) columnTouched;
-(void) unplayAtColumn:(int) col;
-(int) firstEmptyRowAtCol:(int) col;
-(int) lastFilledRowAtCol:(int) col;
-(int) tileNumber:(int)row :(int)col;
-(void) computerPlay;
-(int *) possible;
-(int) evalBoard;
-(long int) minimax: (int) depht;
-(long int) abPruning:(long int) alpha :(long int)beta :(int)depht;
-(long int) staticEvalBoard;
-(void) restartGame;
-(int) op:(int) x;
-(void) Threat:(int)s1 :(int)s2 OfType :(int*)t11 :(int*)t12 :(int*)t13 :(int*)t14 :(int*)t21 :(int*)t22 :(int*)t23 :(int*)t24;
-(void) setDifficulty:(NSInteger) dif;

@end
