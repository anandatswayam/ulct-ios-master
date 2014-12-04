//
//  HealthDepartmentViewController.m
//  ultc
//
//  Created by shallowsummer on 9/22/13.
//
//

#import "HealthDepartmentViewController.h"
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
#import "FourLineExtraListTableViewCell.h"

@interface HealthDepartmentViewController () <UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableDictionary * dict;
@property (nonatomic, strong) NSDictionary * contactDict;

@end

@implementation HealthDepartmentViewController

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
    
    // DW: configuration for extra list items
    self.extraListSqlString = [NSString stringWithFormat:@"SELECT * FROM officials JOIN health_dept_officials ON officials.id = health_dept_officials.official_id WHERE health_dept_officials.health_dept_id = %i", [self.itemId intValue]];
    self.extraListFields = @[
                             @[@"name", @"string"],
                             @[@"title", @"string"],
                             @[@"phone", @"string"],
                             @[@"email", @"string"],

                             ];
    self.extraListFieldOrder = [ @[@"name", @"title", @"phone", @"email"] mutableCopy];
    
    
    // DW: configuration for extra list items 2
    self.extraListSqlString2 = [NSString stringWithFormat:@"SELECT local_units.name, local_units.address, local_units.phone, local_units.fax FROM local_units JOIN health_depts ON local_units.health_dept_id = health_depts.id WHERE health_depts.id = %i", [self.itemId intValue]];
    self.extraListFields2 = @[
                             @[@"name", @"string"],
                             @[@"address", @"string"],
                             @[@"phone", @"string"],
                             @[@"fax", @"string"],
                             
                             ];
    self.extraListFieldOrder2 = [ @[@"name", @"address", @"phone", @"fax"] mutableCopy];
    
    [super viewDidLoad];
    
    self.fieldOrder = [[NSMutableArray alloc] init];
    
    
    FMDatabase * db = [[AppDelegate getAppDelegate] database ];
    NSString * sqlString = [NSString stringWithFormat:@"SELECT * FROM health_depts where id = %i", [self.itemId intValue]];
    FMResultSet * s = [ db executeQuery:sqlString];
    if([s next]){
        
        self.dict = [NSMutableDictionary dictionary];
        NSNumber * number = [NSNumber numberWithInt:[s intForColumn:@"id"]];
        [self.dict setObject:number forKey:@"id"];
        
        NSArray * textFields = @[@"name",
                                 @"address",
                                 @"city",
                                 @"state",
                                 @"zip",
                                 @"phone",
                                 @"fax",
                                 @"services",
                                 @"emergency_num",
                                 ];
        
        
        for(NSString * field in textFields){
            [self.dict setObject:[s stringForColumn:field] forKey:field];
        }
        
        [self.fieldOrder addObject:@"name"];
        
        if( ! [(NSString *) [self.dict objectForKey:@"address"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"map"];
            [self.fieldOrder addObject:@"address"];
        }
        
        if( ! [(NSString *) [self.dict objectForKey:@"phone"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"phone"];
        }
        if( ! [(NSString *) [self.dict objectForKey:@"fax"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"fax"];
        }
        if( ! [(NSString *) [self.dict objectForKey:@"emergency_num"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"emergency_num"];
        }
        if( ! [(NSString *) [self.dict objectForKey:@"services"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"services"];
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
        
        NSString * address = [self.dict objectForKey:@"address"];
        
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
        
        
        
    } else if([field isEqual:@"address"]){
        
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
    else if([field isEqual:@"fax"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Fax:";
        singleCell.content.text = [self.dict objectForKey:@"fax"];
        cell=singleCell;
        
    }
    
    else if([field isEqual:@"emergency_num"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Emergency Number:";
        singleCell.content.text = [self.dict objectForKey:@"emergency_num"];
        cell=singleCell;
        
    }
    
    else if( [field isEqual:@"services"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Services:";
        singleCell.content.text = @"Tap for more info";
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
        titleCell.title.text = @"Officials:";
        cell=titleCell;
        
    } else if([indexPath row] < [self.fieldOrder count] + self.extraListThreshold) {
        FourLineExtraListTableViewCell * lineCell = [WRUtilities getViewFromNib:@"FourLineExtraListTableViewCell" class:[FourLineExtraListTableViewCell class]];
        NSDictionary * dict = [self.extraListItems objectAtIndex:[indexPath row] - ([self.fieldOrder count] + 1) ];
        lineCell.line1.text = [dict objectForKey:@"name"];
        lineCell.line2.text = [dict objectForKey:@"title"];
        lineCell.line3.text = [dict objectForKey:@"phone"];
        lineCell.line4.text = [dict objectForKey:@"email"];

        cell=lineCell;
    } else if (self.extraList2Threshold > 0 &&  [indexPath row] == [self.fieldOrder count] + self.extraListThreshold ) {
        // return the title for the extra list items
        TitleExtraListTableViewCell * titleCell = [WRUtilities getViewFromNib:@"TitleExtraListTableViewCell" class:[TitleExtraListTableViewCell class]];
        titleCell.title.text = @"Local Units:";
        cell=titleCell;
        
    }  else {
        FourLineExtraListTableViewCell * lineCell = [WRUtilities getViewFromNib:@"FourLineExtraListTableViewCell" class:[FourLineExtraListTableViewCell class]];
        NSDictionary * dict = [self.extraListItems2 objectAtIndex:[indexPath row] - ([self.fieldOrder count] + self.extraListThreshold + 1) ];
        lineCell.line1.text = [dict objectForKey:@"name"];
        lineCell.line2.text = [dict objectForKey:@"address"];
        lineCell.line3.text = [dict objectForKey:@"phone"];
        lineCell.line4.text = [dict objectForKey:@"fax"];
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
        return 96;
    }
    else if (self.extraList2Threshold > 0 &&  [indexPath row] == [self.fieldOrder count] + self.extraListThreshold ){
        return 26;
   }
    
    float height = 96;
    
    int row = (int)[indexPath row];
    if(row + 1 > [self.fieldOrder count]){
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
        
    } else if([field isEqual:@"emergency_num"]){
        height = 57;
        
    } else if([field isEqual:@"services"]){
        height = 57;
    }
    
    return height;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([indexPath row] == [self.fieldOrder indexOfObject:@"services"]){
        TextBoxSubContentViewController * vc = [[TextBoxSubContentViewController alloc] init];
        vc.text = [self.dict objectForKey:@"services"];
        [self pushViewController:vc];
    }
    
    if ([indexPath row] > [self.fieldOrder count] && [indexPath row] < [self.fieldOrder count] + self.extraListThreshold){
        
        _contactDict = [self.extraListItems objectAtIndex:[indexPath row] - ([self.fieldOrder count] + 1) ];

        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Contact" message:@"Select a contact method" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Phone", @"Email", nil];
        alert.tag = 10;
        [alert show];
        
    }
    
    if ([indexPath row] > [self.fieldOrder count] + self.extraListThreshold){
        
        _contactDict = [self.extraListItems objectAtIndex:[indexPath row] - ([self.fieldOrder count] + self.extraListThreshold)];
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Contact" message:@"Select a contact method" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Phone", nil];
        alert.tag = 20;
        [alert show];
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch(buttonIndex + alertView.tag){
        case 11:
        {
            NSString * phone = [_contactDict objectForKey:@"phone"];
            [self callPhone:phone];
        }
            break;
            
        case 12:
        {
            NSString * email = [_contactDict objectForKey:@"email"];
            [self sendEmail:email];
        }
            break;
        case 21:
        {
            NSString * phone = [_contactDict objectForKey:@"phone"];
            [self callPhone:phone];
        }
            break;
            
    }
}

@end
