//
//  NetworkManager.h
//  serverConnector2
//
//  Created by local on 3/16/16.
//  Copyright © 2016 binaryfutures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PSWebSocketServer.h>

@interface NetworkManager : NSObject<PSWebSocketServerDelegate>

@property (nonatomic, strong) PSWebSocketServer *server;

+(id)sharedManager;

@end
