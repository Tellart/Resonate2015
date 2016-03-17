//
//  ConsoleManager.h
//  serverConnector2
//
//  Created by local on 3/16/16.
//  Copyright © 2016 binaryfutures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ConsoleManager : NSObject

@property (strong,nonatomic)NSMutableArray* array;

+(id)sharedManager;
-(void)log:(NSString*)string;

@end
