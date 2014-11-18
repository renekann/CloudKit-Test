//
//  MasterViewController.m
//  CloudKit-Test
//
//  Created by René Kann (UCD+) on 14.11.14.
//  Copyright (c) 2014 UCDplus GmbH. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@property (nonatomic) BOOL permissionRequested;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cloudStore = [[UCDCloudStore alloc] init];
    _objects = [[NSMutableArray alloc] init];
    
    [self.cloudStore requestDiscoverabilityPermission:^(BOOL discoverable) {
        
        if (discoverable) {
            _permissionRequested = YES;
            [self reloadNotes];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"CloudKitAtlas"
                                                                           message:@"Getting your name using Discoverability requires permission."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *act) {
                                                               [self dismissViewControllerAnimated:YES completion:nil];
                                                           }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    if(_permissionRequested) {
        [self reloadNotes];
    }
}
- (IBAction)reloadNotes:(id)sender {
    [self reloadNotes];
}

- (void)reloadNotes {
    
    [SVProgressHUD show];
    
    [self.cloudStore fetchRecordsWithType:ReferenceItemRecordName completionHandler:^(NSArray *records) {
        self.objects.array = records;
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
    }];

}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    CKRecord *record = _objects[indexPath.row];
    
    cell.textLabel.text = record[@"title"];
    cell.detailTextLabel.text = record[@"desc"];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.cloudStore deleteRecord:_objects[indexPath.row]];
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"details"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CKRecord *record = _objects[indexPath.row];
        
        DetailViewController *detail = segue.destinationViewController;
        detail.record = record;
        detail.cloudStore = self.cloudStore;
    }
}

@end
