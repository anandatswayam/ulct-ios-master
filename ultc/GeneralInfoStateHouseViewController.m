//
//  GeneralInfoStateHouseViewController.m
//  ultc
//
//  Created by shallowsummer on 9/17/13.
//
//

#import "GeneralInfoStateHouseViewController.h"
#import "AppDelegate.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "WRUtilities.h"
#import "TitleSingleLineTableViewCell.h"
#import "MapTableViewCell.h"
#import "AddressTableViewCell.h"
#import "SingleLineTableViewCell.h"

@interface GeneralInfoStateHouseViewController ()


@property (nonatomic, strong) NSMutableDictionary * dict;
@property (nonatomic, strong) NSMutableArray * fieldOrder;

@end

@implementation GeneralInfoStateHouseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"General Information";    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.fieldOrder = [[NSMutableArray alloc] init];
    
    // This is probably important
    
    FMDatabase * db = [[AppDelegate getAppDelegate] database ];
    NSString * sqlString = [NSString stringWithFormat:@"SELECT * FROM info"];
    FMResultSet * s = [ db executeQuery:sqlString];
    if([s next]){
        
        self.dict = [NSMutableDictionary dictionary];
        NSNumber * number = [NSNumber numberWithInt:[s intForColumn:@"id"]];
        [self.dict setObject:number forKey:@"id"];
        
        NSArray * textFields = @[@"state_house_address",
                                 @"state_house_city",
                                 @"state_house_state",
                                 @"state_house_zip",
                                 @"state_house_phone",
                                 @"state_house_fax"
                                 ];
        
        for(NSString * field in textFields){
            [self.dict setObject:[s stringForColumn:field] forKey:field];
        }
        
        
        if( ! [(NSString *) [self.dict objectForKey:@"state_house_address"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"map"];
            [self.fieldOrder addObject:@"state_house_address"];
        }
        
        if( ! [(NSString *) [self.dict objectForKey:@"state_house_phone"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"state_house_phone"];
        }
        
        if( ! [(NSString *) [self.dict objectForKey:@"state_house_fax"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"state_house_fax"];
        }
        
        //self.title = [self.dict objectForKey:@"name"];
        
    }
    
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.fieldOrder count];
    
    //number of rows in section
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell;
    
    NSString * field = [self.fieldOrder objectAtIndex:[indexPath row]];
    
    if([field isEqual:@"map"]){
        MapTableViewCell * mapCell = [WRUtilities getViewFromNib:@"MapTableViewCell" class:[MapTableViewCell class]];
        cell = mapCell;
        
        
        NSString * address = [NSString stringWithFormat:@"%@, %@, %@ %@",
                              [self.dict objectForKey:@"state_house_address"],
                              [self.dict objectForKey:@"state_house_city"],
                              [self.dict objectForKey:@"state_house_state"],
                              [self.dict objectForKey:@"state_house_zip"]
                              ];
        [self.geocoder geocodeAddressString:address
                          completionHandler:^(NSArray* placemarks, NSError* error){
                              if([placemarks count] > 0) {
                                  CLPlacemark * pm = [placemarks objectAtIndex:0];
                                  MKPlacemark *placemark = [[MKPlacemark alloc]
                                                            initWithCoordinate:pm.location.coordinate
                                                            addressDictionary:pm.addressDictionary];
                                  [mapCell.mapView addAnnotation:placemark];
                                  
                                  MKCoordinateRegion region;
                                  region.span.latitudeDelta = .1;
                                  region.span.longitudeDelta = .1;
                                  region.center.latitude = pm.location.coordinate.latitude ;
                                  region.center.longitude = pm.location.coordinate.longitude ;
                                  [mapCell.mapView  setRegion:region animated:YES];
                                  
                              }
                          }];

        
        
    } else if([field isEqual:@"state_house_address"]){
        
        AddressTableViewCell * addressCell = [WRUtilities getViewFromNib:@"AddressTableViewCell" class:[AddressTableViewCell class]];
        addressCell.title.text = @"Address";
        addressCell.addressLine1.text = [self.dict objectForKey:@"state_house_address"];
        addressCell.addressLine2.text = [NSString stringWithFormat:@"%@, %@ %@",
                                         [self.dict objectForKey:@"state_house_city"],
                                         [self.dict objectForKey:@"state_house_state"],
                                         [self.dict objectForKey:@"state_house_zip"]
                                         ];
        cell = addressCell;
        
    }
    
    else if([field isEqual:@"state_house_phone"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Phone:";
        singleCell.content.text = [self.dict objectForKey:@"state_house_phone"];
        cell=singleCell;
        
    } else if([field isEqual:@"state_house_fax"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Fax:";
        singleCell.content.text = [self.dict objectForKey:@"state_house_fax"];
        cell=singleCell;
        
    }   else {
        
    }
    
    if(cell == NULL){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IDENTIFIER"];
    }
    
    
    [self setUserInteractionForField:field withCell:cell];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    float height = 40;
    
    NSString * field = [self.fieldOrder objectAtIndex:[indexPath row]];
    
    if([field isEqual:@"map"]){
        height = 212;
        
    } else if([field isEqual:@"state_house_address"]){
        height = 78;
        
    } else if([field isEqual:@"state_house_phone"]){
        height = 57;
        
    } else if([field isEqual:@"state_house_fax"]){
        height = 57;
        
    } else {
        
    }
    
    
    return height;
}

@end
