//
//  CountyViewController.m
//  ultc
//
//  Created by Matthew Shultz on 8/29/13.
//
//

#import "CountyViewController.h"
#import "AppDelegate.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "WRUtilities.h"
#import "TitleTableViewCell.h"
#import "MapTableViewCell.h"
#import "AddressTableViewCell.h"
#import "SingleLineTableViewCell.h"
#import "NSDate+Pretty.h"
#import "TitleExtraListTableViewCell.h"
#import "ThreeLineExtraListTableViewCell.h"
#import "TwoLineExtraListTableViewCell.h"

@interface CountyViewController ()

@property (nonatomic, strong) NSMutableDictionary * dict;
@property (nonatomic, strong) NSMutableArray * fieldOrder;


@end

@implementation CountyViewController
{
    int curindex;
}

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
    curindex = 1;
    
    self.extraListSqlString = [NSString stringWithFormat:@"SELECT * FROM officials JOIN county_officials ON officials.id = county_officials.official_id WHERE county_officials.county_id = %i", [self.itemId intValue]];
    self.extraListFields = @[
                             @[@"name", @"string"],
                             @[@"title", @"string"],
                             @[@"end_of_term", @"int"   ]
                             ];
    self.extraListFieldOrder = [ @[@"name", @"title", @"end_of_term"] mutableCopy];
    
    [super viewDidLoad];
    
    self.fieldOrder = [[NSMutableArray alloc] init];
    
    // This is probably important
    
    FMDatabase * db = [[AppDelegate getAppDelegate] database ];
    NSString * sqlString = [NSString stringWithFormat:@"SELECT * FROM counties where id = %i", [self.itemId intValue]];
    FMResultSet * s = [ db executeQuery:sqlString];
    if([s next])
    {
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
                                 @"website",
                                 @"general_emails",
                                 @"hours",
                                 @"meetings",
                                 @"population",
                                 //@"unincorp_popluation",
                                 @"aog"];
        
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
        
        if( ! [(NSString *) [self.dict objectForKey:@"website"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"website"];
        }
        
        if( ! [(NSString *) [self.dict objectForKey:@"general_emails"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"general_emails"];
        }
        
        [self.fieldOrder addObject:@"hours"];
        [self.fieldOrder addObject:@"meetings"];
        [self.fieldOrder addObject:@"population"];
        [self.fieldOrder addObject:@"aog"];
        [self.fieldOrder addObject:@"officials"];

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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // DW here's where we change the number of rows
    
    NSUInteger num = ((int)[self.fieldOrder count] + (int)[self.extraListItems count]);
    //int num = (int)[self.fieldOrder count] + 1 + (int)[self.extraListItems count];
    return num;
    //number of rows in section
}

-(UITableViewCell *) cellForField:(NSString *) field
{
    UITableViewCell * cell;
    
    if ([field isEqual:@"name"])
    {
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
                              [self.dict objectForKey:@"state"]
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
    else if([field isEqual:@"address"])
    {
        AddressTableViewCell * addressCell = [WRUtilities getViewFromNib:@"AddressTableViewCell" class:[AddressTableViewCell class]];
        addressCell.title.text = @"Courthouse Address";
        addressCell.addressLine1.text = [self.dict objectForKey:@"address"];
        addressCell.addressLine2.text = [NSString stringWithFormat:@"%@, %@ %@",
                                    [self.dict objectForKey:@"city"],
                                    [self.dict objectForKey:@"state"],
                                    [self.dict objectForKey:@"zip"]
                                    ];
        cell = addressCell;
        
    }
    
    else if([field isEqual:@"phone"])
    {
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Phone:";
        singleCell.content.text = [self.dict objectForKey:@"phone"];
        cell=singleCell;
        
    }
    else if([field isEqual:@"fax"])
    {
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Fax:";
        singleCell.content.text = [self.dict objectForKey:@"fax"];
        cell=singleCell;
        
    }
    else if([field isEqual:@"website"])
    {
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Website:";
        singleCell.content.text = [self.dict objectForKey:@"website"];
        cell=singleCell;
        
    }
    else if([field isEqual:@"general_emails"])
    {
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"General Emails:";
        singleCell.content.text = [self.dict objectForKey:@"general_emails"];
        cell=singleCell;
        
    }
    else if([field isEqual:@"hours"])
    {
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Hours:";
        singleCell.content.text = [self.dict objectForKey:@"hours"];
        cell=singleCell;
        
    }
    else if([field isEqual:@"meetings"])
    {
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Meetings:";
        singleCell.content.text = [self.dict objectForKey:@"meetings"];
        cell=singleCell;
        
    }
    else if([field isEqual:@"population"])
    {
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Population:";
        singleCell.content.text = [self.dict objectForKey:@"population"];
        cell=singleCell;
        
    }
    else if([field isEqual:@"aog"])
    {
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"AOG:";
        singleCell.content.text = [self.dict objectForKey:@"aog"];
        cell=singleCell;
        
    }
    else {
        
    }
    
    if(cell == NULL){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IDENTIFIER"];
    }
    
    [self setUserInteractionForField:field withCell:cell];

    
    return cell;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    UITableViewCell * cell;
    
    // DW: adding extra list items
    if([indexPath row] < [self.fieldOrder count])
    {
        NSString * field = [self.fieldOrder objectAtIndex:[indexPath row]];
        cell = [self cellForField:field];
    }
    else if ([indexPath row] == [self.fieldOrder count])
    {
        // return the title for the extra list items
        TitleExtraListTableViewCell * titleCell = [WRUtilities getViewFromNib:@"TitleExtraListTableViewCell" class:[TitleExtraListTableViewCell class]];
        titleCell.title.text = @"County Officials:";
        cell=titleCell;
    }
    else
    {
        ThreeLineExtraListTableViewCell * lineCell = [WRUtilities getViewFromNib:@"ThreeLineExtraListTableViewCell" class:[ThreeLineExtraListTableViewCell class]];
//        
//        TwoLineExtraListTableViewCell * lineCell1 = [WRUtilities getViewFromNib:@"TwoLineExtraListTableViewCell" class:[TwoLineExtraListTableViewCell class]];
        
        NSDictionary * dict = [self.extraListItems objectAtIndex:[indexPath row] - ([self.fieldOrder count] + 1) ];
        lineCell.line1.text = [dict objectForKey:@"name"];
        lineCell.line2.text = [dict objectForKey:@"title"];
        
        NSNumber * end_of_term = [dict objectForKey:@"end_of_term"];
        
        if([end_of_term isEqualToNumber:[NSNumber numberWithInt:0]])
        {
//            lineCell1.line1.text = [dict objectForKey:@"name"];
//            lineCell1.line2.text = [dict objectForKey:@"title"];
//            cell=lineCell1;
//            NSLog(@"title = %@", [dict objectForKey:@"name"]);
        }
        else
        {
            lineCell.line1.text = [dict objectForKey:@"name"];
            [self boldFontForLabel:lineCell.line1];
            lineCell.line2.text = [dict objectForKey:@"title"];
            
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[end_of_term intValue] ];
            // DW: Setting detail text
            NSString * dateString = [date prettyJustMonthYear];
            lineCell.line3.text = [NSString stringWithFormat:@"End of Term: %@", dateString ];
            
        }
        cell=lineCell;
        //curindex = curindex+1;
    }
    
    if(cell == NULL)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IDENTIFIER"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height=68;
    
    if ([indexPath row] == [self.fieldOrder count])
    {
        return 32;
    }
    else if([indexPath row] + 1 > [self.fieldOrder count] + [self.extraListItems count])
    {
        NSDictionary * dict = [self.extraListItems objectAtIndex:curindex-1];
        NSNumber * end_of_term = [dict objectForKey:@"end_of_term"];
        
        if([end_of_term isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            height = 48;
        }
        curindex = curindex+1;
        
        return height;
    }
    
    NSString * field = @"";
    
    if (indexPath.row < [self.fieldOrder count])
    {
        field = [self.fieldOrder objectAtIndex:[indexPath row]];
    }
    
    
    if ([field isEqual:@"name"])
    {
        height = 47;
    }
    else if([field isEqual:@"map"])
    {
        height = 212;
    }
    else if([field isEqual:@"address"])
    {
        height = 78;
    }
    else if([field isEqual:@"phone"])
    {
        height = 57;
    }
    else if([field isEqual:@"fax"])
    {
        height = 57;
    }
    else if([field isEqual:@"website"])
    {
        height = 57;
    }
    else if([field isEqual:@"general_emails"])
    {
        height = 57;
    }
    else if([field isEqual:@"hours"])
    {
        height = 57;
    }
    else if([field isEqual:@"meetings"])
    {
        height = 57;
    }
    else if([field isEqual:@"population"])
    {
        height = 57;
    }
    else if([field isEqual:@"aog"])
    {
        height = 57;
    }
    else if([field isEqual:@"officials"])
    {
        
    }
    
    return height;
}

-(void)boldFontForLabel:(UILabel *)label{
    UIFont *currentFont = label.font;
    UIFont *newFont = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold",currentFont.fontName] size:currentFont.pointSize];
    label.font = newFont;
}

@end