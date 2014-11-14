//
//  UCDCloudStore.m
//  CloudKit-Test
//
//  Created by René Kann (UCD+) on 14.11.14.
//  Copyright (c) 2014 UCDplus GmbH. All rights reserved.
//

#import "UCDCloudStore.h"

NSString* const ReferenceItemRecordName = @"NotesItems";

@interface UCDCloudStore()
@property (strong, nonatomic) CKDatabase *privateDB;
@property (readonly) CKContainer *container;
@end

@implementation UCDCloudStore


- (id)init {
    self = [super init];
    if (self) {
        _container = [CKContainer defaultContainer];
        _privateDB = [_container privateCloudDatabase];
    }
    
    return self;
}

- (void)requestDiscoverabilityPermission:(void (^)(BOOL discoverable)) completionHandler {
    
    [self.container requestApplicationPermission:CKApplicationPermissionUserDiscoverability
                               completionHandler:^(CKApplicationPermissionStatus applicationPermissionStatus, NSError *error) {
                                   if (error) {
                                       // In your app, handle this error really beautifully.
                                       NSLog(@"An error occured in %@: %@", NSStringFromSelector(_cmd), error);
                                       abort();
                                   } else {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           completionHandler(applicationPermissionStatus == CKApplicationPermissionStatusGranted);
                                       });
                                   }
                               }];
}


- (void)discoverUserInfo:(void (^)(CKDiscoveredUserInfo *user))completionHandler {
    
    [self.container fetchUserRecordIDWithCompletionHandler:^(CKRecordID *recordID, NSError *error) {
        
        if (error) {
            // In your app, handle this error in an awe-inspiring way.
            NSLog(@"An error occured in %@: %@", NSStringFromSelector(_cmd), error);
            abort();
        } else {
            [self.container discoverUserInfoWithUserRecordID:recordID
                                           completionHandler:^(CKDiscoveredUserInfo *user, NSError *error) {
                                               if (error) {
                                                   // In your app, handle this error deftly.
                                                   NSLog(@"An error occured in %@: %@", NSStringFromSelector(_cmd), error);
                                                   abort();
                                               } else {
                                                   dispatch_async(dispatch_get_main_queue(), ^(void){
                                                       completionHandler(user);
                                                   });
                                               }
                                           }];
        }
    }];
}

#pragma mark -
#pragma mark Edit records

- (void)saveRecord:(CKRecord *)record completionHandler:(void (^)(NSError *error))theCompletionHandler {
    
    [self.privateDB saveRecord:record completionHandler:^(CKRecord *record, NSError *error) {
        if (error) {
            // In your app, handle this error awesomely.
            NSLog(@"An error occured in %@: %@", NSStringFromSelector(_cmd), error);
            abort();
        } else {
            NSLog(@"Successfully saved record");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            theCompletionHandler(error);
        });
    }];
}

- (void)deleteRecord:(CKRecord *)record {
    [self.privateDB deleteRecordWithID:record.recordID completionHandler:^(CKRecordID *recordID, NSError *error) {
        if (error) {
            // In your app, handle this error. Please.
            NSLog(@"An error occured in %@: %@", NSStringFromSelector(_cmd), error);
            abort();
        } else {
            NSLog(@"Successfully deleted record");
        }
    }];
}

#pragma mark -
#pragma mark Query records

- (void)fetchRecordsWithType:(NSString *)recordType completionHandler:(void (^)(NSArray *records))completionHandler {
    
    NSPredicate *truePredicate = [NSPredicate predicateWithValue:YES];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:recordType predicate:truePredicate];
    query.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    
    CKQueryOperation *queryOperation = [[CKQueryOperation alloc] initWithQuery:query];
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    queryOperation.recordFetchedBlock = ^(CKRecord *record) {
        [results addObject:record];
    };
    
    queryOperation.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error) {
        if (error) {
            // In your app, this error needs love and care.
            NSLog(@"An error occured in %@: %@", NSStringFromSelector(_cmd), error);
            //abort();
        } else {
            
            NSLog(@"fetchRecordsWithType Finished!");
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                completionHandler(results);
            });
        }
    };
    
    [self.privateDB addOperation:queryOperation];
}

@end
