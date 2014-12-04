//
//  PopulationListViewController.m
//  ultc
//
//  Created by shallowsummer on 9/16/13.
//
//

#import "PopulationListViewController.h"
#import "AppDelegate.h"
#import "FMResultSet.h"
#import "FMDatabase.h"
#import "CityViewController.h"

@interface PopulationListViewController ()

@end

@implementation PopulationListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
       && UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])

       ){
        
        // nibNameOrNil = @"DrillDownViewControllerSkinny~ipad";
//         
    }
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Population";
        self.isPenultimate = true;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    FMDatabase * db = [[AppDelegate getAppDelegate] database ];
    FMResultSet * s = [ db executeQuery:@"SELECT id, name, population FROM municipalities ORDER BY population DESC"];
    while ([s next]) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        NSNumber * number = [NSNumber numberWithInt:[s intForColumn:@"id"]];
        [dict setObject:number forKey:@"id"];
        [dict setObject:[s stringForColumn:@"name"] forKey:@"name"];
        NSString * population = [s stringForColumn:@"population"];
        if(population == nil){
            population = @"";
        }
        [dict setObject:population forKey:@"population"];
        [self.items addObject:dict];
                
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kIdentifier];
    }
    int index = (int)[indexPath row];
    NSDictionary * dict = [self.items objectAtIndex:index];
    cell.textLabel.text = [dict objectForKey:@"name"];
    
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
    
    NSString *formatted_number = [formatter stringFromNumber:[formatter numberFromString:[dict objectForKey:@"population"]]];
    
    NSString * detailString = [NSString stringWithFormat:@"Population: %@",formatted_number];
    //    NSString * detailString = [NSString stringWithFormat:@"Population: %@",[dict objectForKey:@"population"]];
    cell.detailTextLabel.text = detailString;
    
    return cell;
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int index = (int)[indexPath row];
    NSDictionary * dict = [self.items objectAtIndex:index];
    
    CityViewController * vc = [[CityViewController alloc] init];
    vc.itemId = [dict objectForKey:@"id"];
    [self pushViewController:vc];
    
}


@end
