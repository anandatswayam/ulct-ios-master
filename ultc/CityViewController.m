//
//  CityFormsOfGovernmentViewController.m
//  ultc
//
//  Created by shallowsummer on 9/12/13.
//
//

#import "CityViewController.h"
#import "AppDelegate.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "WRUtilities.h"
#import "TitleTableViewCell.h"
#import "MapTableViewCell.h"
#import "AddressTableViewCell.h"
#import "SingleLineTableViewCell.h"
#import "TextBoxSubContentViewController.h"
#import "NSDate+Pretty.h"
#import "TitleExtraListTableViewCell.h"
#import "ThreeLineExtraListTableViewCell.h"
#import "ParagraphTableViewCell.h"

#import "StateSenatorViewController.h"

@interface CityViewController ()

@property (nonatomic, strong) NSMutableDictionary * dict;
@property (nonatomic, strong) NSMutableArray * fieldOrder;

@end

@implementation CityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    self.extraListSqlString = [NSString stringWithFormat:@"SELECT * FROM officials JOIN municipality_officials ON officials.id = municipality_officials.official_id WHERE municipality_officials.municipality_id = %i", [self.itemId intValue]];
    self.extraListFields = @[
                             @[@"name", @"string"],
                             @[@"title", @"string"],
                             @[@"end_of_term", @"int"   ]
                             ];
    self.extraListFieldOrder = [ @[@"name", @"title", @"end_of_term"] mutableCopy];
    
    
    
    [super viewDidLoad];
    
    self.fieldOrder = [[NSMutableArray alloc] init];
    
    FMDatabase * db = [[AppDelegate getAppDelegate] database ];
    NSString * sqlString = [NSString stringWithFormat:@"SELECT * FROM municipalities where id = %i", [self.itemId intValue]];
    FMResultSet * s = [ db executeQuery:sqlString];
    if([s next]){
        
        self.dict = [NSMutableDictionary dictionary];
        
        
        
        NSLog(@"itemId: %i",[self.itemId intValue]);
        //get district
        NSString * district_sqlString = [NSString stringWithFormat:@"SELECT * FROM legislative_districts JOIN legislative_district_municipalities ON legislative_districts.id = legislative_district_municipalities.legislative_district_id WHERE legislative_district_municipalities.municipality_id = %i", [self.itemId intValue]];
        FMResultSet * district_s = [ db executeQuery:district_sqlString];
        NSString * district = @"";
        NSNumber * district_id;
        if([district_s next]){
            
            NSLog(@"district name: %@",[district_s stringForColumn:@"name"]);
            district=[district_s stringForColumn:@"name"];
            district_id=[NSNumber numberWithInt:[district_s intForColumn:@"congressmen_id"]];
            
            [self.dict setObject:district forKey:@"district_name"];
            [self.dict setObject:district_id forKey:@"district_id"];
        }

        
        
        NSNumber * number = [NSNumber numberWithInt:[s intForColumn:@"id"]];
        [self.dict setObject:number forKey:@"id"];
        
        NSArray * textFields = @[@"name",
                                 @"address",
                                 @"city",
                                 @"state",
                                 @"zip",
                                 @"phone",
                                 @"fax",
                                 @"website",
                                 @"general_emails",
                                 @"office_hours",
                                 @"meeting_dates",
                                 @"population",
                                 @"classification",
                                 @"forms_of_gov",
                                 @"incorporation_date",
                                 @"aog",
                                 @"about",
                                 
                                 ];
        
        
        for(NSString * field in textFields)
        {
            NSString * value = [s stringForColumn:field];
            if (value == nil)
            {
                value = @"";
            }
            [self.dict setObject:value forKey:field];
        }
        
        [self.fieldOrder addObject:@"name"];
        
        if( ! [(NSString *) [self.dict objectForKey:@"address"] isEqual:@""] )
        {
            [self.fieldOrder addObject:@"map"];
            [self.fieldOrder addObject:@"address"];
        }
        
        if( ! [(NSString *) [self.dict objectForKey:@"phone"] isEqual:@""] )
        {
            [self.fieldOrder addObject:@"phone"];
        }
        
        if( ! [(NSString *) [self.dict objectForKey:@"fax"] isEqual:@""] )
        {
            [self.fieldOrder addObject:@"fax"];
        }
        
        if( ! [(NSString *) [self.dict objectForKey:@"website"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"website"];
        }
        
        if( ! [(NSString *) [self.dict objectForKey:@"general_emails"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"general_emails"];
        }
        
        if( ! [(NSString *) [self.dict objectForKey:@"office_hours"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"office_hours"];
        }
        
        if( ! [(NSString *) [self.dict objectForKey:@"meeting_dates"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"meeting_dates"];
        }
        
        if( ! [(NSString *) [self.dict objectForKey:@"population"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"population"];
        }
        
        if( ! [(NSString *) [self.dict objectForKey:@"classification"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"classification"];
        }
        
        if( ! [(NSString *) [self.dict objectForKey:@"forms_of_gov"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"forms_of_gov"];
        }
        
        if( ! [(NSString *) [self.dict objectForKey:@"incorporation_date"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"incorporation_date"];
        }
        
        if( ! [(NSString *) [self.dict objectForKey:@"aog"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"aog"];
        }
        
        if( ! [(NSString *) [self.dict objectForKey:@"about"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"about"];
        }
        
        self.title = [self.dict objectForKey:@"name"];
        
        //don't add district if the entry hasn't been added to the table yet
        if(![district isEqualToString:@""])
            [self.fieldOrder addObject:@"district"];

    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

#pragma mark UITableView Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    int num = (int)[self.fieldOrder count] + 1 + (int)[self.extraListItems count];
    return num;
}


-(UITableViewCell *) cellForField:(NSString *) field {
    
    UITableViewCell * cell;
    
    if ([field isEqual:@"name"]){
        TitleTableViewCell * titleCell = [WRUtilities getViewFromNib:@"TitleTableViewCell" class:[TitleTableViewCell class]];
        titleCell.title.text = [self.dict objectForKey:@"name"];
        titleCell.delegate = self;
        [titleCell selectIfFavorited:self];
        cell=titleCell;
        
    }
    else if([field isEqual:@"map"])
    {
        
        MapTableViewCell * mapCell = [WRUtilities getViewFromNib:@"MapTableViewCell" class:[MapTableViewCell class]];
        cell = mapCell;
        
        NSString * address = [NSString stringWithFormat:@"%@, %@, %@",
                              [self.dict objectForKey:@"address"],
                              [self.dict objectForKey:@"city"],
                              [self.dict objectForKey:@"state"]];
        
        
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
    else if([field isEqual:@"address"])
    {
        
        AddressTableViewCell * addressCell = [WRUtilities getViewFromNib:@"AddressTableViewCell" class:[AddressTableViewCell class]];
        addressCell.title.text = @"Courthouse Address";
        addressCell.addressLine1.text = [self.dict objectForKey:@"address"];
        addressCell.addressLine2.text =  [NSString stringWithFormat:@"%@, %@ %@",
                                          [self.dict objectForKey:@"city"],
                                          [self.dict objectForKey:@"state"],
                                          [self.dict objectForKey:@"zip"]
                                          ];
        cell = addressCell;
        
    } else if([field isEqual:@"phone"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Phone:";
        singleCell.content.text = [self.dict objectForKey:@"phone"];
        cell=singleCell;
        
    } else if([field isEqual:@"fax"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Fax:";
        singleCell.content.text = [self.dict objectForKey:@"fax"];
        cell=singleCell;
        
    } else if([field isEqual:@"website"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Website:";
        NSLog(@"website = %@", [self.dict objectForKey:@"website"]);
        singleCell.content.text = [self.dict objectForKey:@"website"];
        cell=singleCell;
        
    } else if([field isEqual:@"general_emails"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"General Emails:";
        NSLog(@"email = %@", [self.dict objectForKey:@"general_emails"]);
        singleCell.content.text = [self.dict objectForKey:@"general_emails"];
        cell=singleCell;
        
    } else if([field isEqual:@"office_hours"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Office Hours:";
        singleCell.content.text = [self.dict objectForKey:@"office_hours"];
        cell=singleCell;
        
    } else if([field isEqual:@"meeting_dates"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Meeting Dates:";
        singleCell.content.text = [self.dict objectForKey:@"meeting_dates"];
        cell=singleCell;
        
    } else if([field isEqual:@"population"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Population:";
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
        
        NSString *formatted_number = [formatter stringFromNumber:[formatter numberFromString:[self.dict objectForKey:@"population"]]];
        
        NSString * detailString = [NSString stringWithFormat:@"Population: %@",formatted_number];
        //singleCell.content.text = [self.dict objectForKey:@"population"];
        singleCell.content.text = detailString;
        cell=singleCell;
        
    } else if([field isEqual:@"classification"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Classification:";
        singleCell.content.text = [self.dict objectForKey:@"classification"];
        cell=singleCell;
        
    } else if([field isEqual:@"forms_of_gov"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Forms Of Government:";
        singleCell.content.text = [self.dict objectForKey:@"forms_of_gov"];
        cell=singleCell;
        
    } else if ([field isEqual:@"incorporation_date"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Incorporation Date:";
        singleCell.content.text = [self.dict objectForKey:@"incorporation_date"];
        cell=singleCell;
        
    } else if ([field isEqual:@"aog"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"AOG:";
        singleCell.content.text = [self.dict objectForKey:@"aog"];
        cell=singleCell;
    }
    
    else if( [field isEqual:@"about"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"About:";
        singleCell.content.text = @"Tap for more info";
        cell=singleCell;
        
    }
    else if( [field isEqual:@"district"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Legislative District:";
        singleCell.content.text = [self.dict objectForKey:@"district_name"];
        cell=singleCell;
        
    }
    
    [self setUserInteractionForField:field withCell:cell];

    
    return cell;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell;
    
    
    // DW: adding extra list items
    if([indexPath row] < [self.fieldOrder count])
    {
        NSString * field = [self.fieldOrder objectAtIndex:[indexPath row]];
        cell = [self cellForField:field];
    }
    else if ([indexPath row] == [self.fieldOrder count])
    {
        TitleExtraListTableViewCell * titleCell = [WRUtilities getViewFromNib:@"TitleExtraListTableViewCell" class:[TitleExtraListTableViewCell class]];
        titleCell.title.text = @"City Officials:";
        cell=titleCell;
    }
    
    else
    {
        ThreeLineExtraListTableViewCell * lineCell = [WRUtilities getViewFromNib:@"ThreeLineExtraListTableViewCell" class:[ThreeLineExtraListTableViewCell class]];
        NSDictionary * dict = [self.extraListItems objectAtIndex:[indexPath row] - ([self.fieldOrder count] + 1) ];
        lineCell.line1.text = [dict objectForKey:@"name"];
        [self boldFontForLabel:lineCell.line1];
        lineCell.line2.text = [dict objectForKey:@"title"];
        
        NSNumber * end_of_term = [dict objectForKey:@"end_of_term"];
        
        if([end_of_term isEqualToNumber:[NSNumber numberWithInt:0]]){
            
            
        }
        else {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[end_of_term intValue] ];
            // DW: Setting detail text
            NSString * dateString = [date prettyJustMonthYear];
            lineCell.line3.text = [NSString stringWithFormat:@"End of Term: %@", dateString ];
        }
        cell=lineCell;
    }
    
    if(cell == NULL){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IDENTIFIER"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    float height = 68;
    
    if ([indexPath row] == [self.fieldOrder count]){
        return 32;
    }
    
    else if([indexPath row] + 1 > [self.fieldOrder count]){
        
        return height;
    }
    
    NSString * field = [self.fieldOrder objectAtIndex:[indexPath row]];
    
    if ([field isEqual:@"name"]){
        height = 47;
        
    }
    
    else if([field isEqual:@"map"]){
        height = 212;
        
    } else if([field isEqual:@"address"]){
        height = 78;
        
    } else if([field isEqual:@"phone"]){
        height = 57;
        
    } else if([field isEqual:@"fax"]){
        height = 57;
        
    } else if([field isEqual:@"website"]){
        height = 57;
        
    } else if([field isEqual:@"general_emails"]){
        height = 57;
        
    } else if([field isEqual:@"office_hours"]){
        height = 57;
        
    } else if([field isEqual:@"meeting_dates"]){
        height = 57;
        
    } else if([field isEqual:@"population"]){
        height = 57;
        
    } else if([field isEqual:@"classification"]){
        height = 57;
        
    } else if([field isEqual:@"forms_of_gov"]){
        height = 57;
        
    } else if ([field isEqual:@"incorporation_date"]){
        height = 57;
        
    } else if ([field isEqual:@"aog"]){
        height = 57;
        
    } else if ([field isEqual:@"about"]){
        height = 57;
        
    }
    else if ([field isEqual:@"district"]){
        height = 57;
        
    }
    
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    if([indexPath row] == [self.fieldOrder indexOfObject:@"about"]){
        TextBoxSubContentViewController * vc = [[TextBoxSubContentViewController alloc] init];
        vc.text = [self.dict objectForKey:@"about"];
        [self pushViewController:vc];
    }
    else if([indexPath row] == [self.fieldOrder indexOfObject:@"district"]){
        StateSenatorViewController * vc = [[StateSenatorViewController alloc] init];
        vc.itemId = [self.dict objectForKey:@"district_id"];
        [self pushViewController:vc];
    }
}

-(void)boldFontForLabel:(UILabel *)label{
    UIFont *currentFont = label.font;
    UIFont *newFont = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold",currentFont.fontName] size:currentFont.pointSize];
    label.font = newFont;
}

@end
