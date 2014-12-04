//
//  GovernorViewController.m
//  ultc
//
//  Created by shallowsummer on 9/17/13.
//
//

#import "GovernorViewController.h"
#import "AppDelegate.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "WRUtilities.h"
#import "MapTableViewCell.h"
#import "AddressTableViewCell.h"
#import "SingleLineTableViewCell.h"


@interface GovernorViewController ()

@property (nonatomic, strong) NSMutableDictionary * dict;
@property (nonatomic, strong) NSMutableArray * fieldOrder;

@end

@implementation GovernorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Governor";
 
    }
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
        
        NSArray * textFields = @[@"governor",
                                 @"governor_address",
                                 @"governor_city",
                                 @"governor_state",
                                 @"governor_zip",
                                 @"governor_phone",
                                 @"governor_fax"
                                 ];
      
        for(NSString * field in textFields){
            [self.dict setObject:[s stringForColumn:field] forKey:field];
        }
        
        [self.fieldOrder addObject:@"name"];
        
        if( ! [(NSString *) [self.dict objectForKey:@"governor_address"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"map"];
        }
                
        [self.fieldOrder addObject:@"governor"];
        
        if( ! [(NSString *) [self.dict objectForKey:@"governor_address"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"governor_address"];
        }
        
//        if( ! [(NSString *) [self.dict objectForKey:@"governor_city"] isEqual:@""] ) {
//            [self.fieldOrder addObject:@"governor_city"];
//        }
//        
//        if( ! [(NSString *) [self.dict objectForKey:@"governor_state"] isEqual:@""] ) {
//            [self.fieldOrder addObject:@"governor_state"];
//        }
//        
//        if( ! [(NSString *) [self.dict objectForKey:@"governor_zip"] isEqual:@""] ) {
//            [self.fieldOrder addObject:@"governor_zip"];
//        }
        
        if( ! [(NSString *) [self.dict objectForKey:@"governor_phone"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"governor_phone"];
        }
        
        if( ! [(NSString *) [self.dict objectForKey:@"governor_fax"] isEqual:@""] ) {
            [self.fieldOrder addObject:@"governor_fax"];
        }
       
        self.title = @"Governor";
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
    
    if([field isEqual:@"name"]){
        
        TitleTableViewCell * titleCell = [WRUtilities getViewFromNib:@"TitleTableViewCell" class:[TitleTableViewCell class]];
        titleCell.title.text = @"Governor";
        titleCell.delegate = self;
        [titleCell selectIfFavorited:self];
        
        cell=titleCell;
        
    } else if([field isEqual:@"map"]){
        MapTableViewCell * mapCell = [WRUtilities getViewFromNib:@"MapTableViewCell" class:[MapTableViewCell class]];
        cell = mapCell;
        
        //NSString * address = [self.dict objectForKey:@"governor_address"];
        NSString *address = [NSString stringWithFormat:@"%@, %@, %@, %@", [self.dict objectForKey:@"governor_address"], [self.dict objectForKey:@"governor_city"], [self.dict objectForKey:@"governor_state"], [self.dict objectForKey:@"governor_zip"]];
        
        [self.geocoder geocodeAddressString:address
                     completionHandler:^(NSArray* placemarks, NSError* error){
                         if([placemarks count] > 0) {
                             CLPlacemark * pm = [placemarks objectAtIndex:0];
                             MKPlacemark *placemark = [[MKPlacemark alloc]
                                                       initWithCoordinate:pm.location.coordinate
                                                       addressDictionary:pm.addressDictionary];
                             [mapCell.mapView addAnnotation:placemark];
                             MKMapPoint annotationPoint = MKMapPointForCoordinate(pm.location.coordinate);
                             MKMapRect zoomRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
                             [mapCell.mapView setVisibleMapRect:zoomRect animated:NO];

                         }
                     }];
        
    }
    
    else if([field isEqual:@"governor"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Name:";
        singleCell.content.text = [self.dict objectForKey:@"governor"];
        cell=singleCell;
        
    }
    
    else if([field isEqual:@"governor_address"]){
        
        AddressTableViewCell *addressCell = [WRUtilities getViewFromNib:@"AddressTableViewCell" class:[AddressTableViewCell class]];
        addressCell.title.text = @"Address:";
        addressCell.addressLine1.text = [self.dict objectForKey:@"governor_address"];
        addressCell.addressLine2.text = [NSString stringWithFormat:@"%@, %@, %@", [self.dict objectForKey:@"governor_city"], [self.dict objectForKey:@"governor_state"], [self.dict objectForKey:@"governor_zip"]];
        
        cell = addressCell;
        
    }
    
    else if([field isEqual:@"governor_phone"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Phone:";
        singleCell.content.text = [self.dict objectForKey:@"governor_phone"];
        cell=singleCell;
        
    }
    
    else if([field isEqual:@"governor_fax"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Fax:";
        singleCell.content.text = [self.dict objectForKey:@"governor_fax"];
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
    
    if ([field isEqual:@"governor"]){
        height = 58;
    } else if([field isEqual:@"map"]){
        height = 212;
        
    } else if([field isEqual:@"governor_address"]){
        height = 78;
        
    } else if([field isEqual:@"governor_phone"]){
        height = 57;
        
    } else if([field isEqual:@"governor_fax"]){
        height = 57;
        
    }
    
    return height;
}


@end
