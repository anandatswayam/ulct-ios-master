//
//  FestivalsListViewController.m
//  ultc
//
//  Created by shallowsummer on 9/23/13.
//
//

#import "FestivalsListViewController.h"
#import "AppDelegate.h"
#import "FMResultSet.h"
#import "FMDatabase.h"
#import "FestivalViewController.h"
#import "NSDate+Pretty.h"

@interface FestivalsListViewController ()

@end

@implementation FestivalsListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    // for every dynamic drill down controller that is 2nd to last in navigation
    // 1 add this
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
       && UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])

       ){
        
        // nibNameOrNil = @"DrillDownViewControllerSkinny~ipad";
//         
    }
    // end 1
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Festivals";
        self.isPenultimate = true;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // This is probably important
    FMDatabase * db = [[AppDelegate getAppDelegate] database ];
    // DW: added date_from to query
    FMResultSet * s = [ db executeQuery:@"SELECT id, name, date_from, city,location FROM events where is_ulct_event = 0 ORDER BY date_from DESC"];
    while ([s next])
    {
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        NSNumber * number = [NSNumber numberWithInt:[s intForColumn:@"id"]];
        [dict setObject:number forKey:@"id"];
        [dict setObject:[s stringForColumn:@"name"] forKey:@"name"];
        NSString * location = [s stringForColumn:@"city"];
        //        NSString * location = [s stringForColumn:@"location"];
        if(location == nil)
        {
            location = @"";
        }
        else
        {
            if(![location isEqual:@""])
                location = [NSString stringWithFormat:@"– %@, %@",
                            location ,
                            @"UT"
                            ];
            
            
        }
        NSLog(@"--> LOCATION %@\n",location);
        [dict setObject:location forKey:@"location"];
        // DW: Read the date_from from the event and set it to the number in dict
        NSNumber * date_from = [NSNumber numberWithInt:[s intForColumn:@"date_from"]];
        [dict setObject:date_from forKey:@"date_from"];
        [self.items addObject:dict];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

#pragma mark Table View Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
    if(cell == nil)
    {
        // DW: changed to UITableViewCellStyleSubtitle
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kIdentifier];
    }
    int index = (int)[indexPath row];
    NSDictionary * dict = [self.items objectAtIndex:index];
    cell.textLabel.text = [dict objectForKey:@"name"];
    
    // DW: format the date from the timestamp
    NSNumber * date_from = [dict objectForKey:@"date_from"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[date_from intValue] ];
    
    // DW: Setting detail text
    NSString * dateString = [date prettyJustDate];
    NSString * detailString = [NSString stringWithFormat:@"%@ %@", dateString, [dict objectForKey:@"location"]];
    cell.detailTextLabel.text = detailString;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int index = (int)[indexPath row];
    NSDictionary * dict = [self.items objectAtIndex:index];
    
    FestivalViewController * vc = [[FestivalViewController alloc] init];
    vc.itemId = [dict objectForKey:@"id"];
    [self pushViewController:vc];
    
}

@end
