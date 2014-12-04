//
//  UsRepresentativeViewController.m
//  ultc
//
//  Created by shallowsummer on 9/20/13.
//
//

#import "UsRepresentativeViewController.h"
#import "AppDelegate.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "WRUtilities.h"
#import "TitleTableViewCell.h"
#import "MapTableViewCell.h"
#import "AddressTableViewCell.h"
#import "SingleLineTableViewCell.h"

@interface UsRepresentativeViewController ()

@property (nonatomic, strong) NSMutableDictionary * dict;
@property (nonatomic, strong) NSMutableArray * fieldOrder;

@end

@implementation UsRepresentativeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
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
    if([s next])
    {
        self.dict = [NSMutableDictionary dictionary];
        NSNumber * number = [NSNumber numberWithInt:[s intForColumn:@"id"]];
        [self.dict setObject:number forKey:@"id"];
        
        NSArray * textFields = @[@"name",
                                 @"dc_address",
                                 @"dc_city",
                                 @"dc_state",
                                 @"dc_zip",
                                 @"dc_phone",
                                 @"dc_fax",
                                 @"party",
                                 @"committees",
                                 ];
        
        for(NSString * field in textFields)
        {
            [self.dict setObject:[s stringForColumn:field] forKey:field];
        }
        
        [self.fieldOrder addObject:@"name"];
        
        if( ! [(NSString *) [self.dict objectForKey:@"dc_address"] isEqual:@""] )
        {
            [self.fieldOrder addObject:@"map"];
            [self.fieldOrder addObject:@"dc_address"];
        }
        
        if( ! [(NSString *) [self.dict objectForKey:@"dc_phone"] isEqual:@""] )
        {
            [self.fieldOrder addObject:@"dc_phone"];
        }
        
        if( ! [(NSString *) [self.dict objectForKey:@"dc_fax"] isEqual:@""] )
        {
            [self.fieldOrder addObject:@"dc_fax"];
        }
        
        [self.fieldOrder addObject:@"party"];
        [self.fieldOrder addObject:@"committees"];
        
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
    
    return [self.fieldOrder count];
    
    //number of rows in section
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell;
    
    NSString * field = [self.fieldOrder objectAtIndex:[indexPath row]];
    
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
        
        NSString * address = [NSString stringWithFormat:@"%@, %@, %@ %@",
                              [self.dict objectForKey:@"dc_address"],
                              [self.dict objectForKey:@"dc_city"],
                              [self.dict objectForKey:@"dc_state"],
                              [self.dict objectForKey:@"dc_zip"]
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
    else if([field isEqual:@"dc_address"])
    {
        AddressTableViewCell * addressCell = [WRUtilities getViewFromNib:@"AddressTableViewCell" class:[AddressTableViewCell class]];
        addressCell.title.text = @"US Address";
        addressCell.addressLine1.text = [self.dict objectForKey:@"dc_address"];
        addressCell.addressLine2.text = [NSString stringWithFormat:@"%@, %@ %@",
                                         [self.dict objectForKey:@"dc_city"],
                                         [self.dict objectForKey:@"dc_state"],
                                         [self.dict objectForKey:@"dc_zip"]
                                         ];

        cell = addressCell;
        
    }
    else if([field isEqual:@"dc_phone"])
    {
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Phone:";
        singleCell.content.text = [self.dict objectForKey:@"dc_phone"];
        cell=singleCell;
        
    }
    else if([field isEqual:@"dc_fax"])
    {
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Fax:";
        singleCell.content.text = [self.dict objectForKey:@"dc_fax"];
        cell=singleCell;
        
    }
    else if([field isEqual:@"party"])
    {
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Party:";
        singleCell.content.text = [self.dict objectForKey:@"party"];
        cell=singleCell;
    }
    else if([field isEqual:@"committees"])
    {
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Committees:";
        singleCell.content.text = [self.dict objectForKey:@"committees"];
        cell=singleCell;
    }
    else
    {
        
    }
    
    if(cell == NULL)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IDENTIFIER"];
    }
    
    [self setUserInteractionForField:field withCell:cell];

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 40;
    
    NSString * field = [self.fieldOrder objectAtIndex:[indexPath row]];
    
    if ([field isEqual:@"name"])
    {
        height = 47;
        
    }
    
    else if([field isEqual:@"map"])
    {
        height = 212;
        
    }
    else if([field isEqual:@"dc_address"])
    {
        height = 78;
        
    }
    else if([field isEqual:@"dc_phone"])
    {
        height = 57;
        
    }
    else if([field isEqual:@"dc_fax"])
    {
        height = 57;
        
    }
    else if([field isEqual:@"party"])
    {
        height = 57;
        
    }
    else if([field isEqual:@"committees"])
    {
        height = 57;
        
    }
    else
    {
        
    }
    
    
    return height;
}

@end