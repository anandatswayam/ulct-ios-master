//
//  DrillDownViewController.h
//  ultc
//
//  Created by Matthew Shultz on 5/23/13.
//
//

#import <UIKit/UIKit.h>
#import "EntityBrowseController.h"

#define kIdentifier @"SingleLineTableViewCell"

@class SplitFinalTierViewController;

@interface DrillDownViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView * tableView;

@property (nonatomic, strong) NSString * datatype;
@property (nonatomic, strong) EntityBrowseController * entityBrowseController;

@property (nonatomic) BOOL isPenultimate;
@property (nonatomic, strong) SplitFinalTierViewController * splitFinalTierViewController;


- (void) openAddressInMap:(NSString *) address;
- (void) callPhoneNumber:(NSString *) phoneNumber;
- (void) composeEmail:(NSString *) emailAddress;
- (void) pushViewController: (UIViewController *) vc;

@end
