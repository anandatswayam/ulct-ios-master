//
//  FestivalViewController.m
//  ultc
//
//  Created by shallowsummer on 9/23/13.
//
//

#import "FestivalViewController.h"
#import "AppDelegate.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "WRUtilities.h"
#import "AddressTableViewCell.h"
#import "MapTableViewCell.h"
#import "SingleLineTableViewCell.h"
#import "TitleTableViewCell.h"
#import "NSDate+Pretty.h"

@interface FestivalViewController ()

@property (nonatomic, strong) NSMutableDictionary * dict;

@end

@implementation FestivalViewController

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
    // %i = if i have a number
    
    FMDatabase * db = [[AppDelegate getAppDelegate] database ];
    NSString * sqlString = [NSString stringWithFormat:@"SELECT * FROM events where id = %i", [self.itemId intValue]];
    FMResultSet * s = [ db executeQuery:sqlString];
    if([s next]){
        
        self.dict = [NSMutableDictionary dictionary];
        NSNumber * number = [NSNumber numberWithInt:[s intForColumn:@"id"]];
        [self.dict setObject:number forKey:@"id"];
        
        NSArray * textFields = @[@"name",
                                 @"description",
                                 @"location",
                                 @"contact",
                                 @"phone",
                                 @"type",
                                 @"city",
                                 @"state",
                                 @"zip"];
        
        NSArray * intFields = @[
                                @"date_from",
                                @"date_to"
                            ];
         
        
        for(NSString * field in textFields){
            if([s stringForColumn:field] == nil){
                
                [self.dict setObject:@"" forKey:field];
                
            } else {
            
                [self.dict setObject:[s stringForColumn:field] forKey:field];
                
            }
        }
        
        
        for(NSString * field in intFields){
            NSNumber * number = [NSNumber numberWithInt:[s intForColumn:field]];
            [self.dict setObject:number forKey:field];
            
        }
        
        
        [self.fieldOrder addObject:@"name"];
        
        if( ! [(NSString *) [self.dict objectForKey:@"city"] isEqual:@""] ) {
            
            [self.fieldOrder addObject:@"map"];

            
            [self.fieldOrder addObject:@"city"];

            
        }
        [self.fieldOrder addObject:@"date_from"];
        
        
        if( ! [(NSString *) [self.dict objectForKey:@"contact"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"contact"];
        }
        
        if( ! [(NSString *) [self.dict objectForKey:@"phone"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"phone"];
        }
        
        
        
//        if( ! [(NSString *) [self.dict objectForKey:@"zip"] isEqual:@""] ) {
//            [self.fieldOrder addObject:@"zip"];
//        }
        
        if( ! [(NSString *) [self.dict objectForKey:@"description"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"description"];
        }
        
        [self.fieldOrder addObject:@"type"];
        self.title = [self.dict objectForKey:@"name"];
    }
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
        
        
        NSString * address = [NSString stringWithFormat:@"%@, %@",
                              [self.dict objectForKey:@"city"],
                              @"UT"
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
        
    }
    else if ([field isEqual:@"date_from"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Event Date:";
        
        NSNumber * date_from = [self.dict objectForKey:@"date_from"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[date_from intValue] ];
        
        // DW: Setting detail text
        NSString * dateString = [date prettyJustDate];

        singleCell.content.text = dateString;
        cell=singleCell;
    }
    
    
    else if([field isEqual:@"city"]){
        
        AddressTableViewCell * addressCell = [WRUtilities getViewFromNib:@"AddressTableViewCell" class:[AddressTableViewCell class]];
        addressCell.title.text = @"Location:";
        
        NSString * location = @"";
        
        if( ![[self.dict objectForKey:@"location"] isEqualToString:@""] ){
            addressCell.addressLine1.text = [NSString stringWithFormat:@"%@", [self.dict objectForKey:@"location"]];
        }
        
        if( ![[self.dict objectForKey:@"city"] isEqualToString:@""] ){
            location = [self.dict objectForKey:@"city"];
        }
        
        if( ![(NSString *) [self.dict objectForKey:@"state"] isEqual:@""] && ![(NSString *) location isEqual:@""] ){
           location = [NSString stringWithFormat:@"%@, %@ ", location, [self.dict objectForKey:@"state"] ];
        }
        
        if( ![(NSString *) [self.dict objectForKey:@"zip"] isEqual:@""]){
            location = [NSString stringWithFormat:@"%@%@", location, [self.dict objectForKey:@"zip"] ];
        }
        
        addressCell.addressLine2.text = location;
        
        cell = addressCell;
        
    }
    
    else if([field isEqual:@"contact"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Contact:";
        singleCell.content.text = [self.dict objectForKey:@"contact"];
        cell=singleCell;
        
    }
    
    else if([field isEqual:@"phone"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Phone:";
        singleCell.content.text = [self.dict objectForKey:@"phone"];
        cell=singleCell;
        
    }
    
//    else if([field isEqual:@"zip"] && ![[NSString stringWithFormat:@"%@",[self.dict objectForKey:@"zip"]] isEqualToString:@"(null)"] ){
//        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
//        singleCell.title.text = @"Zip:";
//        singleCell.content.text = [self.dict objectForKey:@"zip"];
//        cell=singleCell;
//        
//    }
    
    else if([field isEqual:@"description"] && ![[NSString stringWithFormat:@"%@",[self.dict objectForKey:@"description"]] isEqualToString:@"(null)"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Description:";
        singleCell.content.text = [self.dict objectForKey:@"description"];
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
    if ([field isEqual:@"name"]) {
        height = 44;
    }
    
    else if([field isEqual:@"date_from"]){
        height = 57;
    }
    
    else if([field isEqual:@"map"]){
        height = 212;
        
    }
    
    else if([field isEqual:@"city"]){
        height = 82;
        
    } else if([field isEqual:@"contact"]){
        height = 57;
        
    }
    
    else if([field isEqual:@"phone"]){
        height = 57;
        
    }/*else if([field isEqual:@"zip"]){
        height = 57;
        
    }*/else if([field isEqual:@"description"]){
        height = 57;
        
    }
       
    else {
        
    }
    
    
    return height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
