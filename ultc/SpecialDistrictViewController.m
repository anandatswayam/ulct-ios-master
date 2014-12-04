//
//  SpecialDistrictViewController.m
//  ultc
//
//  Created by shallowsummer on 9/22/13.
//
//

#import "SpecialDistrictViewController.h"
#import "AppDelegate.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "WRUtilities.h"
#import "TitleTableViewCell.h"
#import "MapTableViewCell.h"
#import "AddressTableViewCell.h"
#import "SingleLineTableViewCell.h"

@interface SpecialDistrictViewController ()

@property (nonatomic, strong) NSMutableDictionary * dict;
@property (nonatomic, strong) NSMutableArray * fieldOrder;

@end

@implementation SpecialDistrictViewController

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
    [super viewDidLoad];
    
    self.fieldOrder = [[NSMutableArray alloc] init];
    
    // This is probably important
    
    FMDatabase * db = [[AppDelegate getAppDelegate] database ];
    NSString * sqlString = [NSString stringWithFormat:@"SELECT * FROM special_districts where id = %i", [self.itemId intValue]];
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
                                 @"phone",
                                 @"fax",
                                 @"website",
                                 @"email",
                                 @"hours",
                                 ];
        
            
        for(NSString * field in textFields){
            [self.dict setObject:[s stringForColumn:field] forKey:field];
        }
        
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
        
        if( ! [(NSString *) [self.dict objectForKey:@"fax"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"fax"];
        }
        
        if( ! [(NSString *) [self.dict objectForKey:@"website"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"website"];
        }
        
        if( ! [(NSString *) [self.dict objectForKey:@"email"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"email"];
        }
        
        if( ! [(NSString *) [self.dict objectForKey:@"hours"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"hours"];
        }
    
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
                                  
                                  MKCoordinateRegion region;
                                  region.span.latitudeDelta = .1;
                                  region.span.longitudeDelta = .1;
                                  region.center.latitude = pm.location.coordinate.latitude ;
                                  region.center.longitude = pm.location.coordinate.longitude ;
                                  [mapCell.mapView  setRegion:region animated:YES];
                                  
                              }
                          }];

        
    } else if([field isEqual:@"contact"]){
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
        singleCell.title.text = @"Office Phone:";
        singleCell.content.text = [self.dict objectForKey:@"phone"];
        cell=singleCell;
        
    }
    
    else if([field isEqual:@"fax"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Fax:";
        singleCell.content.text = [self.dict objectForKey:@"fax"];
        cell=singleCell;
        
    }
    
    else if([field isEqual:@"website"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Website:";
        singleCell.content.text = [self.dict objectForKey:@"website"];
        cell=singleCell;
        
    }
    
    else if([field isEqual:@"email"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Email:";
        singleCell.content.text = [self.dict objectForKey:@"email"];
        cell=singleCell;
        
    }
    
    else if([field isEqual:@"hours"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Hours:";
        singleCell.content.text = [self.dict objectForKey:@"hours"];
        cell=singleCell;
        
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
    
    if ([field isEqual:@"name"]){
        height = 47;
        
    }
    
    else if([field isEqual:@"map"]){
        height = 212;
        
    } else if([field isEqual:@"contact"]){
        height = 57;
        
    }else if([field isEqual:@"address"]){
        height = 78;
        
    } else if([field isEqual:@"phone"]){
        height = 57;
        
    } else if([field isEqual:@"fax"]){
        height = 57;
        
    }
    
    else if([field isEqual:@"website"]){
        height = 57;
        
    }
    
    
    else if([field isEqual:@"hours"]){
        height = 57;
        
    }
    else if ([field isEqual:@"email"])
    {
        height = 57;
    }
    
    return height;
}



@end
