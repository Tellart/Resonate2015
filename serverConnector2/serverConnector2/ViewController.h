//
//  ViewController.h
//  serverConnector2
//
//  Created by local on 3/16/16.
//  Copyright © 2016 binaryfutures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardsManager.h"

@interface ViewController : UIViewController

@property (nonatomic,strong)IBOutlet UILabel*                       ipLabel;
@property (nonatomic,strong)IBOutletCollection(UILabel) NSArray*    labels;
@property (nonatomic,strong)IBOutlet UILabel*                       boardsConnectedLabel;

@end

