//
//  CitiesMunicipalitiesListViewController.m
//  ultc
//
//  Created by shallowsummer on 9/17/13.
//
//

#import "CitiesMunicipalitiesListViewController.h"
#import "AppDelegate.h"
#import "FMResultSet.h"
#import "FMDatabase.h"
#import "CityViewController.h"

@interface CitiesMunicipalitiesListViewController ()

@end

@implementation CitiesMunicipalitiesListViewController

@synthesize items_by_class, items_dict;

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
    if (self)
    {
        self.title = @"City Index";
        self.searchKey = @"name";
        // 2 and this
        self.isPenultimate = true;
        // end 2
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    items_by_class=[[NSMutableDictionary alloc] init];
    items_dict=[[NSMutableDictionary alloc] init];
    
    FMDatabase * db = [[AppDelegate getAppDelegate] database ];
    FMResultSet * s = [ db executeQuery:@"SELECT id, name,classification FROM municipalities ORDER BY short_name asc"];
    while ([s next]) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        NSNumber * number = [NSNumber numberWithInt:[s intForColumn:@"id"]];
        [dict setObject:number forKey:@"id"];
        [dict setObject:[s stringForColumn:@"name"] forKey:@"name"];
        [self.items addObject:dict];
        
        [items_dict setObject:dict forKey:number];

        NSString * classification=[s stringForColumn:@"classification"];
        
        NSMutableArray * items_in_the_class;
        
        if([items_by_class objectForKey:classification]!=nil)
        {
            items_in_the_class=[[NSMutableArray alloc] initWithArray:[items_by_class objectForKey:classification]];
        }
        else
        {
            items_in_the_class=[[NSMutableArray alloc] init];
            
        }
        //add object id
        [items_in_the_class addObject:number];
        
        [items_by_class setObject:items_in_the_class forKey:classification];
        
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table View Delegate Methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    
    return [items_by_class count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray * sorted_keys=[[items_by_class allKeys] sortedArrayUsingSelector: @selector(compare:)];
    return [sorted_keys objectAtIndex:section];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSArray * sorted_keys=[[items_by_class allKeys] sortedArrayUsingSelector: @selector(compare:)];
    
    NSNumber * classification = [sorted_keys objectAtIndex:section];
    
    NSArray * items_of_this_class = [items_by_class objectForKey:classification];
    
    return [items_of_this_class count];
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray * sorted_keys=[[items_by_class allKeys] sortedArrayUsingSelector: @selector(compare:)];
    
    NSNumber * classification = [sorted_keys objectAtIndex:indexPath.section];
    
    NSArray * items_of_this_class = [items_by_class objectForKey:classification];
    
    //  1) New search bar cell
    
    UITableViewCell * cell = nil;
    /*cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if(cell)
    {
        return cell; // The search cell
    }*/
    
    // End new search bar cell
    
    cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kIdentifier];
    }
    
    int index = (int)[indexPath row];
    
    NSNumber * key = [items_of_this_class objectAtIndex:index];
    NSDictionary * dict = [items_dict objectForKey:key];
    
    cell.textLabel.text = [dict objectForKey:@"name"];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    // 2) don't do anything when tapping first section
    /*if([indexPath section] == 0)
    {
        return;
    }*/
    
    
    NSArray * sorted_keys=[[items_by_class allKeys] sortedArrayUsingSelector: @selector(compare:)];
    
    NSNumber * classification = [sorted_keys objectAtIndex:indexPath.section];
    
    NSArray * items_of_this_class = [items_by_class objectForKey:classification];
    
    
    int index = (int)[indexPath row];
    //NSDictionary * dict = [self.items objectAtIndex:index];
  
    NSNumber * key = [items_of_this_class objectAtIndex:index];
    NSDictionary * dict = [items_dict objectForKey:key];
    
    CityViewController * vc = [[CityViewController alloc] init];
    vc.itemId = [dict objectForKey:@"id"];
    [self pushViewController:vc];
}


@end