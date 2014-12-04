//
//  TableViewContentViewController.h
//  ultc
//
//  Created by Matthew Shultz on 8/29/13.
//
//

#import "ContentViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface TableViewContentViewController : ContentViewController
<UITableViewDataSource, UITableViewDelegate>



@property (nonatomic, weak) IBOutlet UITableView * tableView;

@property (nonatomic, strong) CLGeocoder * geocoder;

@property (nonatomic, strong) NSMutableArray * fieldOrder;
@property (nonatomic, strong) NSMutableDictionary * dict;


@property (nonatomic, strong) NSMutableArray * extraListItems;
@property (nonatomic, strong) NSString * extraListSqlString;
@property (nonatomic, strong) NSArray * extraListFields;
@property (nonatomic, strong) NSMutableArray * extraListFieldOrder;
@property (nonatomic) int extraListThreshold;


@property (nonatomic, strong) NSMutableArray * extraListItems2;
@property (nonatomic, strong) NSString * extraListSqlString2;
@property (nonatomic, strong) NSArray * extraListFields2;
@property (nonatomic, strong) NSMutableArray * extraListFieldOrder2;
@property (nonatomic) int extraList2Threshold;

- (void) setUserInteractionForField: (NSString*) field withCell:(UITableViewCell * ) cell;

@end
