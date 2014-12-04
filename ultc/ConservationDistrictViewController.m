//
//  ConservationDistrictViewController.m
//  ultc
//
//  Created by shallowsummer on 9/22/13.
//
//

#import "ConservationDistrictViewController.h"
#import "AppDelegate.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "WRUtilities.h"
#import "TitleTableViewCell.h"
#import "MapTableViewCell.h"
#import "AddressTableViewCell.h"
#import "TitleExtraListTableViewCell.h"
#import "SevenLineExtraListTableViewCell.h"
#import "SingleLineTableViewCell.h"

@interface ConservationDistrictViewController ()

@property (nonatomic, strong) NSMutableDictionary * dict;
@property (nonatomic, strong) NSMutableArray * fieldOrder;

@end

@implementation ConservationDistrictViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    
    self.fieldOrder = [[NSMutableArray alloc] init];
    
    int zone;
    FMDatabase * db = [[AppDelegate getAppDelegate] database ];
    NSString * sqlString = [NSString stringWithFormat:@"SELECT * FROM conservation_districts where id = %i", [self.itemId intValue]];
    FMResultSet * s = [ db executeQuery:sqlString];
    if([s next]){
        
        self.dict = [NSMutableDictionary dictionary];
        NSNumber * number = [NSNumber numberWithInt:[s intForColumn:@"id"]];
        [self.dict setObject:number forKey:@"id"];
        
        NSArray * textFields = @[@"name",
                                 @"contact",
                                 @"address",
                                 @"city",
                                 @"state",
                                 @"zip",
                                 @"phone"
                                 ];
        
        
        for(NSString * field in textFields){
            [self.dict setObject:[s stringForColumn:field] forKey:field];
        }
        zone = [s intForColumn:@"zone_id"];
        
        [self.fieldOrder addObject:@"name"];
        
        
        if( ! [(NSString *) [self.dict objectForKey:@"address"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"map"];
        }
        
        if( ! [(NSString *) [self.dict objectForKey:@"contact"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"contact"];
        }
        
        if( ! [(NSString *) [self.dict objectForKey:@"address"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"address"];
        }
        
        if( ! [(NSString *) [self.dict objectForKey:@"phone"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"phone"];
        }
        
        self.title = [self.dict objectForKey:@"name"];
        
        
        
        // DW: configuration for extra list items
        self.extraListSqlString = [NSString stringWithFormat:@"SELECT * FROM zones where id = %i",  zone];
        self.extraListFields = @[
                                 @[@"name", @"string"],
                                 @[@"coordinator", @"string"],
                                 @[@"address", @"string"],
                                 @[@"city", @"string"],
                                 @[@"state", @"string"],
                                 @[@"zip", @"string"],
                                 @[@"phone", @"string"],
                                 @[@"fax", @"string"],
                                 @[@"email", @"string"]
                                 ];
        self.extraListFieldOrder = [ @[@"name",
                                       @"coordinator",
                                       @"address",
                                       @"city",
                                       @"state",
                                       @"zip",
                                       @"phone",
                                       @"fax",
                                       @"email"
                                       ] mutableCopy];
        
        
        
    }
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

#pragma mark UITableView Delegate Methods


- (UITableViewCell*) cellForField: (NSString*) field {
    
    UITableViewCell * cell;
    
    
    if ([field isEqual:@"name"]){
        TitleTableViewCell * titleCell = [WRUtilities getViewFromNib:@"TitleTableViewCell" class:[TitleTableViewCell class]];
        titleCell.title.text = [self.dict objectForKey:@"name"];
        titleCell.delegate = self;
        [titleCell selectIfFavorited:self];
        cell=titleCell;
    }
    
    else if([field isEqual:@"map"]){
        MapTableViewCell * mapCell = [WRUtilities getViewFromNib:@"MapTableViewCell" class:[MapTableViewCell class]];
        cell = mapCell;
        
        NSString * address = [NSString stringWithFormat:@"%@, %@, %@ %@",
                              [self.dict objectForKey:@"address"],
                              [self.dict objectForKey:@"city"],
                              [self.dict objectForKey:@"state"],
                              [self.dict objectForKey:@"zip"]
                              ];
        
        [self.geocoder geocodeAddressString:address
                          completionHandler:^(NSArray* placemarks, NSError* error){
                              if([placemarks count] > 0) {
                                  CLPlacemark * pm = [placemarks objectAtIndex:0];
                                  MKPlacemark *placemark = [[MKPlacemark alloc]
                                                            initWithCoordinate:pm.location.coordinate
                                                            addressDictionary:pm.addressDictionary];
                                  [mapCell.mapView addAnnotation:placemark];
                                  //MKMapPoint annotationPoint = MKMapPointForCoordinate(pm.location.coordinate);
                                  //MKMapRect zoomRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 10, 10);
                                  //[mapCell.mapView setVisibleMapRect:zoomRect animated:NO];
                                  
                                  
                                  MKCoordinateRegion region;
                                  region.span.latitudeDelta = .1;
                                  region.span.longitudeDelta = .1;
                                  region.center.latitude = pm.location.coordinate.latitude ;
                                  region.center.longitude = pm.location.coordinate.longitude ;
                                  [mapCell.mapView  setRegion:region animated:YES];
                                  
                              }
                          }];
        
    }
    else if([field isEqual:@"contact"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Contact:";
        singleCell.content.text = [self.dict objectForKey:@"contact"];
        cell=singleCell;
        
    }
    
    else if([field isEqual:@"address"]){
        
        AddressTableViewCell * addressCell = [WRUtilities getViewFromNib:@"AddressTableViewCell" class:[AddressTableViewCell class]];
        addressCell.title.text = @"Address:";
        addressCell.addressLine1.text = [self.dict objectForKey:@"address"];
        addressCell.addressLine2.text = [NSString stringWithFormat:@"%@, %@ %@",
                                         [self.dict objectForKey:@"city"],
                                         [self.dict objectForKey:@"state"],
                                         [self.dict objectForKey:@"zip"]
                                         ];
        cell = addressCell;
        
    }
    
    else if([field isEqual:@"phone"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Phone:";
        singleCell.content.text = [self.dict objectForKey:@"phone"];
        cell=singleCell;
        
    }
    
    [self setUserInteractionForField:field withCell:cell];

    
    return cell;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell;
    
    if([indexPath row] < [self.fieldOrder count]){
        NSString * field = [self.fieldOrder objectAtIndex:[indexPath row]];
        cell = [self cellForField:field];
    } else if ([indexPath row] == [self.fieldOrder count]){
        // return the title for the extra list items
        TitleExtraListTableViewCell * titleCell = [WRUtilities getViewFromNib:@"TitleExtraListTableViewCell" class:[TitleExtraListTableViewCell class]];
        titleCell.title.text = @"Zone:";
        cell=titleCell;
        
    } else if([indexPath row] < [self.fieldOrder count] + self.extraListThreshold) {
        SevenLineExtraListTableViewCell * lineCell = [WRUtilities getViewFromNib:@"SevenLineExtraListTableViewCell" class:[SevenLineExtraListTableViewCell class]];
        NSDictionary * dict = [self.extraListItems objectAtIndex:[indexPath row] - ([self.fieldOrder count] + 1) ];
        lineCell.line1.text = [dict objectForKey:@"name"];
        lineCell.line2.text = [dict objectForKey:@"coordinator"];
        lineCell.line3.text = [dict objectForKey:@"address"];
        lineCell.line4.text = [NSString stringWithFormat:@"%@, %@, %@", [dict objectForKey:@"city"], [dict objectForKey:@"state"], [dict objectForKey:@"zip"]];
        lineCell.line5.text = [dict objectForKey:@"phone"];
        lineCell.line6.text = [dict objectForKey:@"fax"];
        lineCell.line7.text = [dict objectForKey:@"email"];

        cell=lineCell;
    }
    
    if(cell == NULL){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IDENTIFIER"];
    }
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath row] == [self.fieldOrder count]){
        return 26;
    }
    else if ([indexPath row] > [self.fieldOrder count] && [indexPath row] < [self.fieldOrder count] + self.extraListThreshold){
        return 213;
    }
    
    float height = 40;
    
    NSString * field = [self.fieldOrder objectAtIndex:[indexPath row]];
    
    if ([field isEqual:@"name"]){
        height = 47;
        
    }
    
    else if([field isEqual:@"map"]){
        height = 212;
        
    }
    else if([field isEqual:@"contact"]){
        height = 57;
        
    }
    
    else if([field isEqual:@"address"]){
        height = 78;
        
    } else if([field isEqual:@"phone"]){
        height = 57;
        
    }
    
    return height;
}
@end
