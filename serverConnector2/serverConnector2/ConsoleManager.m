//
//  ConsoleManager.m
//  serverConnector2
//
//  Created by local on 3/16/16.
//  Copyright © 2016 binaryfutures. All rights reserved.
//

#import "ConsoleManager.h"
#define NUM_STRINGS 6

@implementation ConsoleManager

+ (id)sharedManager {
    
    static ConsoleManager *sharedMyManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
   
    _array = [[NSMutableArray alloc] initWithArray:@[@"",@"",@"",@"",@"",@""]];
    return self;
}
-(void)log:(NSString*)string{
    NSLog(@"DEBUG: %@",string);
    for(int i=[_array count]-2;i>=0;i--)
    {
        [_array replaceObjectAtIndex:i+1 withObject:([_array objectAtIndex:i])];
    }
    [_array replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@" -> %@",string]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateConsole" object:nil];
}
@end
