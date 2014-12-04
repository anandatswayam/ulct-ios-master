//
//  TypeFormsOfGovernmentViewController.m
//  ulct
//
//
//
//

#import "TypeFormsOfGovernmentViewController.h"
#import "CitiesFormsOfGovernmentViewController.h"
#import "AppDelegate.h"
#import "FMResultSet.h"
#import "FMDatabase.h"
#import "CityViewController.h"

@interface TypeFormsOfGovernmentViewController ()

@end

@implementation TypeFormsOfGovernmentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"Forms of Government Index";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    FMDatabase * db = [[AppDelegate getAppDelegate] database ];
    FMResultSet * s = [ db executeQuery:@"SELECT distinct forms_of_gov FROM municipalities ORDER BY forms_of_gov"];
    while ([s next]) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setObject:[s stringForColumn:@"forms_of_gov"] forKey:@"forms_of_gov"];
        [self.items addObject:dict];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

#pragma mark Table View Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kIdentifier];
    }
    int index = (int)[indexPath row];
    NSDictionary * dict = [self.items objectAtIndex:index];
    cell.textLabel.text = [dict objectForKey:@"forms_of_gov"];
    
    /*NSString * detailString = [NSString stringWithFormat:@"Form Of Gov: %@",[dict objectForKey:@"forms_of_gov"]];
     cell.detailTextLabel.text = detailString;*/
    
    return cell;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int index = (int)[indexPath row];
    NSDictionary * dict = [self.items objectAtIndex:index];
    
    CitiesFormsOfGovernmentViewController * vc = [[CitiesFormsOfGovernmentViewController alloc] init];
    vc.formOfGov = [dict objectForKey:@"forms_of_gov"];
    vc.title = vc.formOfGov;
    [self pushViewController:vc];
    
}

@end