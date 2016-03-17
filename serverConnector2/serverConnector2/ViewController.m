//
//  ViewController.m
//  serverConnector2
//
//  Created by local on 3/16/16.
//  Copyright © 2016 binaryfutures. All rights reserved.
//

#import "ViewController.h"
#import "NetworkManager.h"
#import "ConsoleManager.h"
#import <ifaddrs.h>
#import <arpa/inet.h>




@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [NetworkManager sharedManager];
    
    _ipLabel.text=[self getIPAddress];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateConsole) name:@"updateConsole" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBoardsConnected) name:@"updateBoardsConnected" object:nil];
    
    
    [BoardsManager sharedManager];
    [self updateBoardsConnected];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[ConsoleManager sharedManager] log:@"init"];
        
    
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UTILS
// Get IP Address
- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}
-(void)updateConsole{
    for (int i=0; i<[_labels count]; i++) {
        [((UILabel*)[_labels objectAtIndex:i]) setText:[[[ConsoleManager sharedManager] array] objectAtIndex: i ]];
    }
}
-(void)updateBoardsConnected{
    [_boardsConnectedLabel setText:[NSString stringWithFormat:@"%d",[[BoardsManager sharedManager] numBoardsConnected]]];
}


@end
