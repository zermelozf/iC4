//
//  iC4Model.m
//  iC4
//
//  Created by zermelo on 15/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "iC4Model.h"
#define NB_ROWS 6
#define NB_COL 7


@implementation iC4Model
@synthesize player, gameFinished, firstPlayer, nTilesOnBoard, difficulty;

-(iC4Model *) init {
    self = [super init];
    player = 1;
    nTilesOnBoard = 0;
    firstPlayer = @"Human";
    difficulty = 2;
    return self;
}

-(void) setBoardAtRow:(int)i AndColumn:(int)j toValue:(int)v {
    board[i][j] = v;
}

-(int) getBoardAtRow:(int)i AndColumn:(int)j {
    return board[i][j];
}

-(void) playAtColumn:(int)col {
    [self updateBoard: board AtColumn:col];
    player = -player;
    nTilesOnBoard++;
}

-(void) updateBoard:(int [6][7]) b AtColumn:(NSInteger)col {
    int row = [self firstEmptyRowAtCol:col];
    if (row != -1) {
        b[row][col] = player;
        //[self setBoardAtRow:row AndColumn:col toValue:player];
    }
}

-(void) unplayAtColumn:(int)col {
    int row = [self lastFilledRowAtCol:col];
    board[row][col] = 0;
    player = -player;
    nTilesOnBoard--;
}

-(int *) possible {
    int *pMoves = malloc(NB_COL*sizeof(int));
    for (int j=0; j<NB_COL; j++) {
        pMoves[j] = -1;
        if ([self firstEmptyRowAtCol:j] != -1) {
            pMoves[j] = 1;
        }
    }
    return pMoves;
}

-(int) firstEmptyRowAtCol:(int) col {
    for (int i=0; i<NB_ROWS; i++) {
        if ([self getBoardAtRow:i AndColumn:col] == 0) {
            return i;
        }
    }
    return -1;
}
-(int) lastFilledRowAtCol:(int)col {
    int last = 0;
    for (int i=0; i<NB_ROWS; i++) {
        if ([self getBoardAtRow:i AndColumn:col] != 0) {
            last = i;
        }
    }
    return last;
}

-(int) tileNumber:(int)row :(int)col{
    return (5-row)*7+col;
}

-(void) computerPlay {
    long int score, bestMove, bestScore;
    int nply = difficulty;
    int *pMoves = [self possible];
    /*
    int nMoves = 0;
    for (int m=0; m<NB_COL; m++) {
        if (pMoves[m] == -1) {
            nMoves++;
        }
    }
    if (nMoves == 1) {nply = nply+1;}
    if (nMoves == 2) {nply = nply + 2;}
    if (nMoves == 3) {nply = 11;}
    if (nMoves >= 4) {nply = 25;}
 
    nply = (int) MIN((nply + 0.1*nTilesOnBoard),NB_COL*NB_ROWS-nTilesOnBoard);*/
    printf("nply: %d \nScores :", nply);
    if (player == 1) {
        bestScore = -1000000000; 
        for (int k=0; k<NB_COL; k++) {
            if (pMoves[k]==1) {
                [self playAtColumn:k];
                //score = [self minimax:6];
                score = [self abPruning: 1000000000 :-1000000000 :nply];
                printf("%ld ", score);
                if ( score > bestScore) {
                    bestScore = score;
                    bestMove = k;
                }
                [self unplayAtColumn:k];
            }
        }
        printf("\n");
    }
    if (player == -1) {
        bestScore = 1000000000;
        for (int k=0; k<NB_COL; k++) {
            if (pMoves[k]==1) {
                [self playAtColumn:k];
                //score = [self minimax:6];
                score = [self abPruning: 1000000000 :-1000000000 :nply];
                printf("%ld ", score);
                if ( score < bestScore) {
                    bestScore = score;
                    bestMove = k;
                }
                [self unplayAtColumn:k];
            }
        }
        printf("\n");
    }
    [self playAtColumn:bestMove];
}

-(long int) minimax:(int)depht {
    if (depht == 1 || [self evalBoard] == 1 || [self evalBoard] == -1) {
        return [self staticEvalBoard];
    }
    long int bestScore;
    int *pMoves = [self possible];
    if (player == -1) {
        bestScore = 1000000000;
        for (int k=0; k<NB_COL; k++) {
            if (pMoves[k] == 1) {
                [self playAtColumn:k];
                bestScore = MIN(bestScore, [self minimax:depht-1]);
                [self unplayAtColumn:k];
            }
        }
    }
    if (player == 1) {
        bestScore = -1000000000;
        for (int k=0; k<NB_COL; k++) {
            if (pMoves[k] == 1) {
                [self playAtColumn:k];
                bestScore = MAX(bestScore, [self minimax:depht-1]);
                [self unplayAtColumn:k];
            }
        }
    }
    return bestScore;
}


-(long int) abPruning:(long int)alpha :(long int)beta :(int)depht {
    if (depht == 1 || [self evalBoard] == 1 || [self evalBoard] == -1) {
        return [self staticEvalBoard];
    }
    int *pMoves = [self possible];
    if (player == -1) {
        for (int k=0; k<NB_COL; k++) {
            if (pMoves[k] == 1) {
                [self playAtColumn:k];
                alpha = MIN(alpha, [self abPruning:alpha :beta :depht-1]);
                [self unplayAtColumn:k];
                if (alpha <= beta) {break;}
            }
        }
        return alpha;
    }
    else {
        for (int k=0; k<NB_COL; k++) {
            if (pMoves[k] == 1) {
                [self playAtColumn:k];
                beta = MAX(beta, [self abPruning:alpha :beta :depht-1]);
                [self unplayAtColumn:k];
                if (alpha <= beta) {break;}
            }
        }
        return beta;
    }
}

-(int) evalBoard {
    for (int i=0; i<6; i++) {
        for (int j=0; j<7; j++) {
            if (j+3<7) {
                if (board[i][j] == board[i][j+1] && board[i][j+1] == board[i][j+2] && board[i][j+2] == board[i][j+3] && board[i][j] != 0) 
                {return board[i][j];}
            }
            if (j+3<7 && i+3<6) {
                if (board[i][j] == board[i+1][j+1] && board[i+1][j+1] == board[i+2][j+2] && board[i+2][j+2] == board[i+3][j+3] && board[i][j] != 0) {return board[i][j];}
            }
            if (i+3<6) {
                if (board[i][j] == board[i+1][j] && board[i+1][j] == board[i+2][j] && board[i+2][j] == board[i+3][j] && board[i][j] != 0) 
                    {return board[i][j];}
            }
            if (j>=3 && i+3<6) {
                if (board[i][j] == board[i+1][j-1] && board[i+1][j-1] == board[i+2][j-2] && board[i+2][j-2] == board[i+3][j-3] && board[i][j] != 0) {return board[i][j];}
            }
        }
    }
    if (nTilesOnBoard == 42) {
        return 3;
    }
    else { return 0; }
    
}

-(long int) staticEvalBoard {
    int s1, s2;
    int t11 = 0, t12 = 0, t13 = 0, t14 = 0;
    int t21 = 0, t22 = 0, t23 = 0, t24 = 0;
    for (int i=0; i<NB_ROWS; i++) {
        for (int j=0; j<NB_COL; j++) {
            if (j+3<NB_COL) {
                s1 = [self op:board[i][j]]+[self op:board[i][j+1]]+[self op:board[i][j+2]]+[self op:board[i][j+3]];
                s2 = [self op:-board[i][j]]+[self op:-board[i][j+1]]+[self op:-board[i][j+2]]+[self op:-board[i][j+3]];
                [self Threat:s1 :s2 OfType:&t11 :&t12 :&t13 :&t14 :&t21 :&t22 :&t23 :&t24];
            }
            if (j+3<NB_COL && i+3<NB_ROWS) {
                s1 = [self op:board[i][j]]+[self op:board[i+1][j+1]]+[self op:board[i+2][j+2]]+[self op:board[i+3][j+3]];
                s2 = [self op:-board[i][j]]+[self op:-board[i+1][j+1]]+[self op:-board[i+2][j+2]]+[self op:-board[i+3][j+3]];
                [self Threat:s1 :s2 OfType:&t11 :&t12 :&t13 :&t14 :&t21 :&t22 :&t23 :&t24];
            }
            if (i+3<NB_ROWS) {
                s1 = [self op:board[i][j]]+[self op:board[i+1][j]]+[self op:board[i+2][j]]+[self op:board[i+3][j]];
                s2 = [self op:-board[i][j]]+[self op:-board[i+1][j]]+[self op:-board[i+2][j]]+[self op:-board[i+3][j]];
                [self Threat:s1 :s2 OfType:&t11 :&t12 :&t13 :&t14 :&t21 :&t22 :&t23 :&t24];
            }
            if (j>=3 && i+3<NB_ROWS) {
                s1 = [self op:board[i][j]]+[self op:board[i+1][j-1]]+[self op:board[i+2][j-2]]+[self op:board[i+3][j-3]];
                s2 = [self op:-board[i][j]]+[self op:-board[i+1][j-1]]+[self op:-board[i+2][j-2]]+[self op:-board[i+3][j-3]];
                [self Threat:s1 :s2 OfType:&t11 :&t12 :&t13 :&t14 :&t21 :&t22 :&t23 :&t24];
            }
        }
    }
    long int v1 = 15000*t14 + 2500*t13 + 50*t12 + t11;
    long int v2 = 15000*t24 + 2500*t23 + 50*t22 + t21;
    return v1-v2;
}

-(void) Threat:(int)s1 :(int)s2 OfType:(int *)t11 :(int *)t12 :(int *)t13 :(int *)t14 :(int *)t21 :(int *)t22 :(int *)t23 :(int *)t24 {
    if (s1==1 && s2 ==0) {(*t11)++;}
    if (s1==2 && s2 ==0) {(*t12)++;}
    if (s1==3 && s2 ==0) {(*t13)++;}
    if (s1==4 && s2 ==0) {(*t14)++;}
    if (s1==0 && s2 ==1) {(*t21)++;}
    if (s1==0 && s2 ==2) {(*t22)++;}
    if (s1==0 && s2 ==3) {(*t23)++;}
    if (s1==0 && s2 ==4) {(*t24)++;}
}

-(int) op:(int) x {
    if (x>0) {
        return x;
    }
    else {
        return 0;
    }
}

-(void) restartGame {
    for (int i=0; i<6; i++) {
        for (int j=0; j<7; j++) {
            board[i][j] = 0;
        }
    }
    player = 1;
    gameFinished = 0;
    nTilesOnBoard = 0;
}
@end
