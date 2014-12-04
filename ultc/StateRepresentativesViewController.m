//
//  StateRepresentativesViewController.m
//  ultc
//
//  Created by shallowsummer on 9/17/13.
//
//

#import "StateRepresentativesViewController.h"
#import "AppDelegate.h"
#import "FMResultSet.h"
#import "FMDatabase.h"
#import "StateRepresentativeViewController.h"

@interface StateRepresentativesViewController ()

@end

@implementation StateRepresentativesViewController

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
        self.title = @"State Representatives";
        self.isPenultimate = true;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // This is probably important
    FMDatabase * db = [[AppDelegate getAppDelegate] database ];
    FMResultSet * s = [ db executeQuery:@"SELECT id, name FROM congressmen where type = \"state_rep\" ORDER BY name"];
    while ([s next]) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        NSNumber * number = [NSNumber numberWithInt:[s intForColumn:@"id"]];
        [dict setObject:number forKey:@"id"];
        [dict setObject:[s stringForColumn:@"name"] forKey:@"name"];
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


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //  1) New search bar cell
    UITableViewCell * cell = nil;
    cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if(cell){
        return cell; // The search cell
    }
    // End new search bar cell
    
    
   cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kIdentifier];
    }
    int index = (int)[indexPath row];
    NSDictionary * dict = [self.items objectAtIndex:index];
    cell.textLabel.text = [dict objectForKey:@"name"];
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int index = (int)[indexPath row];
    NSDictionary * dict = [self.items objectAtIndex:index];
    
    StateRepresentativeViewController * vc = [[StateRepresentativeViewController alloc] init];
    vc.itemId = [dict objectForKey:@"id"];
    [self pushViewController:vc];
    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return[NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    NSLog(@"title -%@",title);
    for (int i = 0; i< [self.items count]; i++)
    {
        NSString *letterString = [[[self.items objectAtIndex:i] objectForKey:@"name"] substringToIndex:1];
        if ([[letterString lowercaseString] isEqualToString:[title lowercaseString]]) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            break;
        }
    }
    return index;
}


@end
