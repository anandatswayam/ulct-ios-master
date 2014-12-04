//
//  TableViewContentViewController.m
//  ultc
//

#import "TableViewContentViewController.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface TableViewContentViewController ()


@end

@implementation TableViewContentViewController

@synthesize tableView;
@synthesize extraListSqlString;
@synthesize extraListFields;
@synthesize extraListFieldOrder;
@synthesize extraListThreshold;

@synthesize extraListSqlString2;
@synthesize extraListFields2;
@synthesize extraListFieldOrder2;
@synthesize extraList2Threshold;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    if(nibNameOrNil != nil){
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    } else {
        self = [super initWithNibName:@"TableViewContentViewController" bundle:nibBundleOrNil];
    }
    
    if (self) {
        self.extraListItems = [NSMutableArray array];
        self.extraListSqlString = nil;
        self.extraListFieldOrder = [NSMutableArray array];
        self.extraListThreshold = 0;
        self.extraListItems2 = [NSMutableArray array];
        self.extraListSqlString2 = nil;
        self.extraListFieldOrder2 = [NSMutableArray array];
        self.extraList2Threshold = 0;
        self.geocoder = [[CLGeocoder alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    FMDatabase * db = [[AppDelegate getAppDelegate] database ];
    
    if(self.extraListSqlString != nil) {
        FMResultSet * s2 = [ db executeQuery:extraListSqlString];
        while([s2 next]){
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            NSNumber * number = [NSNumber numberWithInt:[s2 intForColumn:@"id"]];
            [dict setObject:number forKey:@"id"];
            for(NSArray * field in extraListFields) {
                
                NSString * column = [field objectAtIndex:0];
                if( [(NSString*) [field objectAtIndex:1] isEqualToString:@"string"]){
                    
                    NSString * value = [s2 stringForColumn:column];
                    if(value == nil){
                        value = @"";
                    }
                    [dict setObject:value forKey:column];
                    
                } else if( [(NSString*) [field objectAtIndex:1] isEqualToString:@"int"]){
                    
                    NSNumber * number = [NSNumber numberWithInt:[s2 intForColumn:column]];
                    [dict setObject:number forKey:column];
                    
                }
            }
            
            [self.extraListItems addObject:dict];
            
        }
        
        if([self.extraListItems count]  > 0){
            self.extraListThreshold = (int)[self.extraListItems count] + 1;
        }
        
    }
    
    if(self.extraListSqlString2 != nil) {
        FMDatabase * db = [[AppDelegate getAppDelegate] database ];
        FMResultSet * s2 = [ db executeQuery:extraListSqlString2];
        while([s2 next]){
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            NSNumber * number = [NSNumber numberWithInt:[s2 intForColumn:@"id"]];
            [dict setObject:number forKey:@"id"];
            for(NSArray * field in extraListFields2) {
                
                NSString * column = [field objectAtIndex:0];
                if( [(NSString*) [field objectAtIndex:1] isEqualToString:@"string"]){
                    
                    [dict setObject:[s2 stringForColumn:column] forKey:column];
                    
                } else if( [(NSString*) [field objectAtIndex:1] isEqualToString:@"int"]){
                    
                    NSNumber * number = [NSNumber numberWithInt:[s2 intForColumn:column]];
                    [dict setObject:number forKey:column];
                    
                }
            }
            
            [self.extraListItems2 addObject:dict];
            
        }
        
        if([self.extraListItems2 count]  > 0){
            self.extraList2Threshold = (int)[self.extraListItems2 count] + 1;
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    int num = (int)[self.fieldOrder count] + self.extraListThreshold + self.extraList2Threshold;
    return num;
    //number of rows in section
}

-(UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"1"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"1"];
    }
    int index = (int)[indexPath row];
    NSDictionary * dict = [_fieldOrder objectAtIndex:index];
    cell.textLabel.text = [dict objectForKey:@"name"];
    return cell;
    
}


- (void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int row = (int)[indexPath row];
    if(row < [_fieldOrder count]){
        NSString * field = [_fieldOrder objectAtIndex:row];
        
        if([field isEqualToString:@"name"])
        {
            TitleTableViewCell *titleCell = (TitleTableViewCell *)[tableView1 cellForRowAtIndexPath:indexPath];
            [titleCell toggleFavorite];
            
            [self didToggleFavorite:YES];
            return;
        }
        
        
        NSArray * emailFields = @[@"email", @"state_email", @"work_email"];
        if([emailFields containsObject:field])
        {
            NSLog(@"%@",self.dict);
            
            [self sendEmail:[self.dict objectForKey:field]];
            return;
        }
        
        NSArray * multiEmailFields =  @[@"general_emails"];
        // show a picker or something
        if([multiEmailFields containsObject:field])
        {
            NSString * emails = [self.dict objectForKey:field];
            [self sendEmail:emails];
            return;
        }
        
        NSArray * phoneFields = @[  @"state_phone",
                                    @"dc_phone",   @"other_phones",  @"phone",
                                    @"governor_phone",  @"lt_governor_phone",  @"state_house_phone",  @"state_senate_phone",  @"us_house_phone"];
        if([phoneFields containsObject:field]){
            [self callPhone:[self.dict objectForKey:field]];
            return;
        }
        
        // NSArray * multiPhoneFields =  @[@"other_phones"];
        // Show a picker or something
        
        NSArray * urlFields = @[@"dc_website", @"website", @"us_senate_website", @"us_house_website"];
        if([urlFields containsObject:field]){
            [self openUrl:[self.dict objectForKey:field]];
            return;
        }
        
        
        NSArray * addressFields = @[@"state_address",
                                    @"dc_address",
                                    @"governor_address",
                                    @"lt_governor_address",
                                    @"state_house_address",
                                    @"state_senate_address",
                                    @"us_house_address",
                                    @"us_senate_address",
                                    @"work_address"
                                    ];
        
        
        if([field isEqualToString:@"map"]){
            NSArray * keys = [self.dict allKeys];
            if([keys containsObject:@"address"]){
          
                NSString * address =  [NSString stringWithFormat:@"%@, %@, %@",
                                       [self.dict objectForKey:@"address"],
                                       [self.dict objectForKey:@"city"],
                                       [self.dict objectForKey:@"state"]
                                       
                                       ];
                [self openMapAtAddress:address];
                return;
            }
        
            for( NSString * addrField in addressFields){
                if([keys containsObject:addrField]){
                    NSString * address = [self.dict objectForKey:addrField];
                    [self openMapAtAddress:address];
                    return;
                }
            }
            
            
        }
        
        if([field isEqualToString:@"address"]){
            
            NSString * address =  [NSString stringWithFormat:@"%@, %@, %@",
                                   [self.dict objectForKey:@"address"],
                                   [self.dict objectForKey:@"city"],
                                   [self.dict objectForKey:@"state"]
                                   
                                   ];
            [self openMapAtAddress:address];
            return;
            
        }
        

        if([addressFields containsObject:field]){
            [self openMapAtAddress:[self.dict objectForKey:field]];
            return;
        }
        
    }
    
}

- (void) setUserInteractionForField: (NSString*) field withCell:(UITableViewCell * ) cell {
    
    
    NSArray * fields = @[
                         @"district",
                         @"about",
                         @"name",
                         @"map",
                         @"dc_website",
                         @"website",
                         @"us_senate_website",
                         @"us_house_website",
                         @"email",
                         @"state_email",
                         @"work_email",
                         @"general_emails",
                         @"address",
                         @"state_address",
                         @"dc_address",
                         @"governor_address",
                         @"lt_governor_address",
                         @"state_house_address",
                         @"state_senate_address",
                         @"us_house_address",
                         @"us_senate_address",
                         @"work_address",
                         @"state_phone",
                         @"dc_phone",
                         @"other_phones",
                         @"phone",
                         @"governor_phone",
                         @"lt_governor_phone",
                         @"state_house_phone",
                         @"state_senate_phone",
                         @"us_house_phone",
                         @"bio"];
    
    if([fields containsObject: field]){
        cell.userInteractionEnabled = YES;
    } else {
        cell.userInteractionEnabled = NO;
    }
    
}

@end
