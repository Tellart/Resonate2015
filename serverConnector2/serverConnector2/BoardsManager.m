//
//  BoardsManager.m
//  serverConnector2
//
//  Created by local on 3/16/16.
//  Copyright © 2016 binaryfutures. All rights reserved.
//

#import "BoardsManager.h"
#import <MetaWear/MetaWear.h>

@implementation BoardsManager
+ (id)sharedManager {
    
    static BoardsManager *sharedMyManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}
-(id)init{
    self = [super init];
    _deviceUUIDS=[NSArray arrayWithObjects:@"CADD0E85-70A5-C31F-434C-9899987DA446",@"C48030C3-AE8E-1E19-7D19-2597E78D4F56",@"FD8EC4DA-04F4-92F5-4553-97B79C748785",nil];
    _bleModules = [NSMutableArray array];
    for (int i=0; i<MAX_NUM_OF_DEVICES; i++) {
        [_bleModules addObject:@""];
    }
    
    [[MBLMetaWearManager sharedManager] startScanForMetaWearsAllowDuplicates:NO handler:^(NSArray *array) {
        for (MBLMetaWear *device in array) {
            NSLog(@"Found MetaWear: %@", device.identifier);
            for(int i=0;i<MAX_NUM_OF_DEVICES;i++)
            {
                if([device.identifier.UUIDString isEqualToString:[_deviceUUIDS objectAtIndex:i]])
                {
                    //connect
                    [device connectWithHandler:^(NSError *error) {
                        if (!error) {
                            
                            // Hooray! We connected to a MetaWear board, so flash its LED!
                            [device.led flashLEDColorAsync:[UIColor greenColor] withIntensity:1.0 numberOfFlashes:2];
                            [_bleModules replaceObjectAtIndex:i withObject:device];
                            
                            
                            [device addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];

                            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBoardsConnected" object:nil];
                            
                            //[device forgetDevice];
                            /*
                             bleDeviceMap[idNumberReference[device.identifier.UUIDString.UTF8String]]=device;
                             numOfConnectedDevices=0;
                             accessGranted[idNumberReference[device.identifier.UUIDString.UTF8String]] = false;
                             
                             // device.accelerometer.sampleFrequency = MBLAccelerometerSampleFrequency1_56Hz;
                             
                             for (int k=0; k<MAX_NUM_OF_DEVICES; k++) {
                             if(bleDeviceMap[k]!=nil)
                             {
                             numOfConnectedDevices++;
                             }
                             }*/
                        }
                    }];
                }
            }
        }
    }];
    return self;
}
-(int)numBoardsConnected{
    int count =0;
    for (int i=0; i<[_bleModules count]; i++) {
        if([[_bleModules objectAtIndex:i] isKindOfClass:[MBLMetaWear class]])
        {
            if(((MBLMetaWear*)[_bleModules objectAtIndex:i]).state!=CBPeripheralStateDisconnected)
            {
                count++;
            }
            else
            {
                [_bleModules replaceObjectAtIndex:i withObject:@""];
            }
        }
    }
    return count;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBoardsConnected" object:nil];
}
@end
