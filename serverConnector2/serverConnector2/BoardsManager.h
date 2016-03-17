//
//  BoardsManager.h
//  serverConnector2
//
//  Created by local on 3/16/16.
//  Copyright © 2016 binaryfutures. All rights reserved.
//

#import <Foundation/Foundation.h>
#define MAX_NUM_OF_DEVICES 3

@interface BoardsManager : NSObject

@property (nonatomic,strong)NSMutableArray*                         bleModules;
@property (nonatomic,strong)NSArray*                                deviceUUIDS;

+ (id)sharedManager;
-(id)init;
-(int)numBoardsConnected;

@end
