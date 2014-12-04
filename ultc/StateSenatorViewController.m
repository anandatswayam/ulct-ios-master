//
//  StateSenatorViewController.m
//  ultc
//
//  Created by shallowsummer on 9/17/13.
//
//

#import "StateSenatorViewController.h"
#import "AppDelegate.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "WRUtilities.h"
#import "TitleTableViewCell.h"
#import "MapTableViewCell.h"
#import "AddressTableViewCell.h"
#import "SingleLineTableViewCell.h"

#import "OneLineExtraListTableViewCell.h"
#import "TitleExtraListTableViewCell.h"

#import "CityViewController.h"

@interface StateSenatorViewController ()

@property (nonatomic, strong) NSMutableDictionary * dict;
@property (nonatomic, strong) NSMutableArray * fieldOrder;

@end

@implementation StateSenatorViewController

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
    NSString * sqlString = [NSString stringWithFormat:@"SELECT * FROM congressmen where id = %i", [self.itemId intValue]];
    FMResultSet * s = [ db executeQuery:sqlString];
    if([s next]){
        
        self.dict = [NSMutableDictionary dictionary];
        
        //get district
        NSString * district_sqlString = [NSString stringWithFormat:@"SELECT * FROM legislative_districts where congressmen_id = %i", [self.itemId intValue]];
        FMResultSet * district_s = [ db executeQuery:district_sqlString];
        NSString * district = @"";
        NSNumber * district_id;
        if([district_s next]){
            
            district=[district_s stringForColumn:@"name"];
            district_id=[NSNumber numberWithInt:[district_s intForColumn:@"id"]];
            
            [self.dict setObject:district forKey:@"district_name"];
        }

        NSMutableArray * municipalities=[[NSMutableArray alloc] init];
        //get municipalities for this district
        if(![district isEqualToString:@""])
        {
           // self.extraListSqlString = [NSString stringWithFormat:@"SELECT * FROM officials JOIN association_officials ON officials.id = association_officials.official_id WHERE association_officials.association_id = %i", [self.itemId intValue]];
            
            NSString * municipalities_sqlString = [NSString stringWithFormat:@"SELECT municipalities.* FROM municipalities JOIN legislative_district_municipalities ON municipalities.id = legislative_district_municipalities.municipality_id WHERE  legislative_district_municipalities.legislative_district_id = %i", [district_id intValue]];

//            NSString * municipalities_sqlString = [NSString stringWithFormat:@"SELECT * FROM legislative_district_municipalities JOIN municipalities ON legislative_district_municipalities.municipality_id = municipalities.id where legislative_district_municipalities.legislative_district_id = %i", [district_id intValue]];

//            NSString * municipalities_sqlString = [NSString stringWithFormat:@"SELECT * FROM legislative_district_municipalities where legislative_district_id = %i", [district_id intValue]];
            FMResultSet * municipalities_s = [ db executeQuery:municipalities_sqlString];
            while([municipalities_s next]){
                
                NSDictionary * entry =@{@"name" : [municipalities_s stringForColumn:@"name"],
                                        @"id" : [NSNumber numberWithInt:[municipalities_s intForColumn:@"id"]],
                                         // etc.
                                         };
                
                [municipalities addObject:entry];
                
                NSLog(@"name: %@",[entry objectForKey:@"name"]);
                NSLog(@"id: %@",[entry objectForKey:@"id"]);
                //add to array
                //[self.dict setObject:district forKey:@"district_name"];
            }

        }
        
        NSNumber * number = [NSNumber numberWithInt:[s intForColumn:@"id"]];
        [self.dict setObject:number forKey:@"id"];
        
        NSArray * textFields = @[@"name",
                                 @"state_address",
                                 @"state_city",
                                 @"state_state",
                                 @"state_zip",
                                 @"state_phone",
                                 @"state_fax",
                                 @"party",
                                 @"committees",
                                 ];
        
        for(NSString * field in textFields){
            [self.dict setObject:[s stringForColumn:field] forKey:field];
        }
        
        [self.fieldOrder addObject:@"name"];
        
        if( ! [(NSString *) [self.dict objectForKey:@"state_address"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"map"];
            [self.fieldOrder addObject:@"state_address"];
        }
        
        if( ! [(NSString *) [self.dict objectForKey:@"state_phone"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"state_phone"];
        }
        
        if( ! [(NSString *) [self.dict objectForKey:@"state_fax"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"state_fax"];
        }
              
        [self.fieldOrder addObject:@"party"];
        [self.fieldOrder addObject:@"committees"];
        
        //don't add district if the entry hasn't been added to the table yet
        if(![district isEqualToString:@""])
            [self.fieldOrder addObject:@"district"];
        
        //add cities label only if there is at least one city
        if([municipalities count]>0)
        {
            [self.fieldOrder addObject:@"municipalities"];
            [self.dict setObject:municipalities forKey:@"municipalities"];

        }
        self.title = [self.dict objectForKey:@"name"];
        
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
    

    if([self.dict objectForKey:@"municipalities"])
        return [self.fieldOrder count] + [[self.dict objectForKey:@"municipalities"] count];
    else
        return [self.fieldOrder count];
    
    //number of rows in section
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell;
    
    if([indexPath row] < [self.fieldOrder count])
    {
        
        
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
                                  [self.dict objectForKey:@"state_address"],
                                  [self.dict objectForKey:@"state_city"],
                                  [self.dict objectForKey:@"state_state"],
                                  [self.dict objectForKey:@"state_zip"]
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
            
            
        } else if([field isEqual:@"state_address"]){
            
            AddressTableViewCell * addressCell = [WRUtilities getViewFromNib:@"AddressTableViewCell" class:[AddressTableViewCell class]];
            addressCell.title.text = @"State Address";
            addressCell.addressLine1.text = [self.dict objectForKey:@"state_address"];
            addressCell.addressLine2.text = [NSString stringWithFormat:@"%@, %@ %@",
                                             [self.dict objectForKey:@"state_city"],
                                             [self.dict objectForKey:@"state_state"],
                                             [self.dict objectForKey:@"state_zip"]
                                             ];
            cell = addressCell;
            
        }
        
        else if([field isEqual:@"state_phone"]){
            SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
            singleCell.title.text = @"Phone:";
            singleCell.content.text = [self.dict objectForKey:@"state_phone"];
            cell=singleCell;
            
        } else if([field isEqual:@"state_fax"]){
            SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
            singleCell.title.text = @"Fax:";
            singleCell.content.text = [self.dict objectForKey:@"state_fax"];
            cell=singleCell;
            
        } else if([field isEqual:@"party"]){
            SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
            singleCell.title.text = @"Party:";
            singleCell.content.text = [self.dict objectForKey:@"party"];
            cell=singleCell;
            
        } else if([field isEqual:@"committees"]){
            SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
            singleCell.title.text = @"Committees:";
            singleCell.content.text = [self.dict objectForKey:@"committees"];
            cell=singleCell;
            
        } else if([field isEqual:@"district"]){
            SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
            singleCell.title.text = @"District:";
            singleCell.content.text = [self.dict objectForKey:@"district_name"];
            cell=singleCell;
            
        }
        else if([field isEqual:@"municipalities"]){
            
            
            TitleExtraListTableViewCell * titleCell = [WRUtilities getViewFromNib:@"TitleExtraListTableViewCell" class:[TitleExtraListTableViewCell class]];
            titleCell.title.text = @"Municipalities in District:";
            cell=titleCell;

            
        }
        else {
            
        }
        

    } else
    {
    
        
        
        OneLineExtraListTableViewCell * lineCell = [WRUtilities getViewFromNib:@"OneLineExtraListTableViewCell" class:[OneLineExtraListTableViewCell class]];
//        NSDictionary * dict = [self.extraListItems objectAtIndex:[indexPath row] - ([self.fieldOrder count] + 1) ];
       lineCell.line1.text = [[[self.dict objectForKey:@"municipalities"] objectAtIndex:[indexPath row] - [self.fieldOrder count]] objectForKey:@"name"];
  //      lineCell.line1.text = @"Extra";
        
        cell=lineCell;
        
    }
    
    if(cell == NULL){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IDENTIFIER"];
    }
    
    if([indexPath row] < [self.fieldOrder count])
    {

        [self setUserInteractionForField:[self.fieldOrder objectAtIndex:[indexPath row]] withCell:cell];
        //NSLog(@"oi %@",[self.fieldOrder objectAtIndex:[indexPath row]]);
    }
    else
    {
        cell.userInteractionEnabled = YES;

    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    float height = 40;
    
    
    if([indexPath row] < [self.fieldOrder count])
    {
        
        
        NSString * field = [self.fieldOrder objectAtIndex:[indexPath row]];
        
        if ([field isEqual:@"name"]){
            height = 47;
     
        }
        
        else if([field isEqual:@"map"]){
            height = 212;
            
        } else if([field isEqual:@"state_address"]){
            height = 78;
            
        } else if([field isEqual:@"state_phone"]){
            height = 57;
            
        } else if([field isEqual:@"state_fax"]){
            height = 57;
            
        } else if([field isEqual:@"party"]){
            height = 57;
            
        } else if([field isEqual:@"committees"]){
            height = 57;
            
        } else if([field isEqual:@"district"]){
            height = 57;
            
        } else if([field isEqual:@"municipalities"]){
            height = 30;
            
        }  else {
            
        }
    }
    else
    {
        height=24;
    }
    
    
    return height;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    
    if([indexPath row] >= [self.fieldOrder count])
    {
        
        CityViewController * vc = [[CityViewController alloc] init];
        vc.itemId = [[[self.dict objectForKey:@"municipalities"] objectAtIndex:[indexPath row] - [self.fieldOrder count]] objectForKey:@"id"];
        [self pushViewController:vc];
        
    }
}
@end
