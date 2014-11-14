//
//  DetailViewController.m
//  CloudKit-Test
//
//  Created by René Kann (UCD+) on 14.11.14.
//  Copyright (c) 2014 UCDplus GmbH. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(!self.cloudStore) {
        self.cloudStore = [[UCDCloudStore alloc] init];
    }
    
    [self setValuesFromRecord];
}

- (void)setValuesFromRecord {
    if(self.record) {
        self.tfTitle.text = self.record[@"title"];
        self.tfDesc.text = self.record[@"desc"];
        
        NSDate *date = self.record[@"creationDate"];
        
        if(date) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd.MM.yyyy H:m:s"];
            [formatter setTimeZone:[NSTimeZone localTimeZone]];
            self.lblDate.text = [formatter stringFromDate:date];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)add:(id)sender {
    
    if (self.tfTitle.text.length < 1) {
        [self.tfTitle resignFirstResponder];
    } else {
        CKRecord *newRecord;
        
        if(self.record) {
            newRecord = self.record;
        } else {
            newRecord = [[CKRecord alloc] initWithRecordType:ReferenceItemRecordName];
        }
        
        newRecord[@"title"] = self.tfTitle.text;
        newRecord[@"desc"] = self.tfDesc.text;

        [self.tfDesc resignFirstResponder];
        
        [self.cloudStore saveRecord:newRecord completionHandler:^(NSError *error) {
            if(error) {
                
            } else {
                [self.navigationController popViewControllerAnimated:YES];

            }
        }];
    }
}

@end
