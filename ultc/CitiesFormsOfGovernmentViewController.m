//
//  CitiesFormsOfGovernmentViewController.m
//  ultc
//
//  Created by shallowsummer on 9/12/13.
//
//

#import "CitiesFormsOfGovernmentViewController.h"
#import "AppDelegate.h"
#import "FMResultSet.h"
#import "FMDatabase.h"
#import "CityViewController.h"

@interface CitiesFormsOfGovernmentViewController ()

@end

@implementation CitiesFormsOfGovernmentViewController

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
        self.title = @"";
        self.isPenultimate = true;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    FMDatabase * db = [[AppDelegate getAppDelegate] database ];
    NSString * sql = [NSString stringWithFormat:@"SELECT id, name, forms_of_gov FROM municipalities WHERE forms_of_gov = '%@'", self.formOfGov ];
    FMResultSet * s = [ db executeQuery:sql];
    while ([s next]) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        NSNumber * number = [NSNumber numberWithInt:[s intForColumn:@"id"]];
        [dict setObject:number forKey:@"id"];
        [dict setObject:[s stringForColumn:@"name"] forKey:@"name"];
        NSString * formsOfGov = [s stringForColumn:@"forms_of_gov"];
        if(formsOfGov == nil){
            formsOfGov = @"";
        }
        [dict setObject:formsOfGov forKey:@"forms_of_gov"];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else
    {
        return [self.items count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = nil;
    cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if(cell){
        return cell; // The search cell
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kIdentifier];
    }
    int index = (int)[indexPath row];
    NSDictionary * dict = [self.items objectAtIndex:index];
    cell.textLabel.text = [dict objectForKey:@"name"];
    
    /*NSString * detailString = [NSString stringWithFormat:@"Form Of Gov: %@",[dict objectForKey:@"forms_of_gov"]];
    cell.detailTextLabel.text = detailString;*/
    
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
