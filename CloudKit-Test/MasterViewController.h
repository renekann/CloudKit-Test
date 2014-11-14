//
//  MasterViewController.h
//  CloudKit-Test
//
//  Created by René Kann (UCD+) on 14.11.14.
//  Copyright (c) 2014 UCDplus GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCDCloudStore.h"

@interface MasterViewController : UITableViewController

@property UCDCloudStore *cloudStore;
@property (strong, nonatomic) IBOutlet UIView *loader;

@end

