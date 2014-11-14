//
//  DetailViewController.h
//  CloudKit-Test
//
//  Created by René Kann (UCD+) on 14.11.14.
//  Copyright (c) 2014 UCDplus GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCDCloudStore.h"

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *tfTitle;
@property (weak, nonatomic) IBOutlet UITextView *tfDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property UCDCloudStore *cloudStore;
@property CKRecord *record;
@end

