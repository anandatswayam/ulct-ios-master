//
//  EventsCalendarViewController.m
//  ultc
//
//  Created by shallowsummer on 9/8/13.
//
//

#import "EventsCalendarViewController.h"
#import "AppDelegate.h"
#import "FMResultSet.h"
#import "FMDatabase.h"
#import "EventViewController.h"

@interface EventsCalendarViewController ()

@end

@implementation EventsCalendarViewController

@synthesize items_by_month,items_dict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Events Calendar";
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    items_by_month=[[NSMutableDictionary alloc] init];
    items_dict=[[NSMutableDictionary alloc] init];
    
    // This is probably important
    FMDatabase * db = [[AppDelegate getAppDelegate] database ];
    FMResultSet * s = [ db executeQuery:@"SELECT id, name,date_from FROM events where is_ulct_event = 1 ORDER BY date_from"];
    while ([s next])
    {
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        NSNumber * number = [NSNumber numberWithInt:[s intForColumn:@"id"]];
        [dict setObject:number forKey:@"id"];
        [dict setObject:[s stringForColumn:@"name"] forKey:@"name"];
        [self.items addObject:dict];
        
        [items_dict setObject:dict forKey:number];
        
        ///
        
        //generate timestamp for 01/month/year
        
        NSNumber * month = [self month_year_timestamp:[s stringForColumn:@"date_from"]];
        
        NSMutableArray * items_in_the_month;
        
        if([items_by_month objectForKey:month]!=nil)
        {
            items_in_the_month=[[NSMutableArray alloc] initWithArray:[items_by_month objectForKey:month]];
        }
        else
        {
            items_in_the_month=[[NSMutableArray alloc] init];

        }
        //add object id
        [items_in_the_month addObject:number];
        
        [items_by_month setObject:items_in_the_month forKey:month];
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

#pragma mark Table View Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    
    return [items_by_month count];


}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSArray * sorted_keys=[[items_by_month allKeys] sortedArrayUsingSelector: @selector(compare:)];
    return [self monthFromName:[sorted_keys objectAtIndex:section]];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    NSArray * sorted_keys=[[items_by_month allKeys] sortedArrayUsingSelector: @selector(compare:)];
    
    NSNumber * month = [sorted_keys objectAtIndex:section];
    
    NSArray * items_of_this_month = [items_by_month objectForKey:month];
    

    
    return [items_of_this_month count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * sorted_keys=[[items_by_month allKeys] sortedArrayUsingSelector: @selector(compare:)];

    NSNumber * month = [sorted_keys objectAtIndex:indexPath.section];
    
    NSArray * items_of_this_month = [items_by_month objectForKey:month];
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kIdentifier];
    }
    int index = (int)[indexPath row];
    NSNumber * key = [items_of_this_month objectAtIndex:index];
    NSDictionary * dict = [items_dict objectForKey:key];

    cell.textLabel.text = [dict objectForKey:@"name"];
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int index = (int)[indexPath row];
    NSDictionary * dict = [self.items objectAtIndex:index];
    
    EventViewController * vc = [[EventViewController alloc] init];
    vc.itemId = [dict objectForKey:@"id"];
    [self pushViewController:vc];
    
}
-(NSString*)monthFromName:(NSNumber*)month
{
    
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:[month doubleValue] ];
    

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM, YYYY"];
    NSString *stringFromDate = [formatter stringFromDate:myDate];
    
    return stringFromDate;
}


-(NSNumber*)month_year_timestamp:(NSString*)date_from
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[date_from intValue] ];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
    
    //month should be a timestamp of day 1 of the month and year (NSNumber)
    //this way we can still sort by this key
    
    //then change monthFromName to receive timestamp and output "month, year"
    NSNumber * month=[NSNumber numberWithInteger:[components month]];
    NSNumber * year=[NSNumber numberWithInteger:[components year]];


    NSString * dateString = [NSString stringWithFormat: @"%02d01%d", [month intValue],[year intValue]];
    
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMddyyyy"];
    NSDate* myDate = [dateFormatter dateFromString:dateString];
    
    NSLog(@"month: (%@) timestamp: %f", dateString, [myDate timeIntervalSince1970]);
    return [NSNumber numberWithDouble:[myDate timeIntervalSince1970]];
}

@end