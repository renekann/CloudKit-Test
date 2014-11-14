//
//  UCDCloudStore.h
//  CloudKit-Test
//
//  Created by René Kann (UCD+) on 14.11.14.
//  Copyright (c) 2014 UCDplus GmbH. All rights reserved.
//
@import UIKit;
#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>

extern NSString* const ReferenceItemRecordName;

@interface UCDCloudStore : NSObject

- (void)saveRecord:(CKRecord *)record completionHandler:(void (^)(NSError *error))theCompletionHandler;
- (void)deleteRecord:(CKRecord *)record;

- (void)requestDiscoverabilityPermission:(void (^)(BOOL discoverable)) completionHandler;
- (void)fetchRecordsWithType:(NSString *)recordType completionHandler:(void (^)(NSArray *records))completionHandler;
@end
