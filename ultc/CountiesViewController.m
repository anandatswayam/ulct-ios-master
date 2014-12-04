//
//  CountiesViewController.m
//  ultc
//
//  Created by Matthew Shultz on 5/23/13.
//
//

#import "CountiesViewController.h"
#import "AppDelegate.h"
#import "FMResultSet.h"
#import "FMDatabase.h"
#import "CountyViewController.h"

@interface CountiesViewController ()
{
    NSMutableArray *aryCounties;
}

@end

@implementation CountiesViewController

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
        self.title = @"Counties";
        // 1) add the search key
        self.searchKey = @"name";
        self.isPenultimate  = true;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    aryCounties = [[NSMutableArray alloc] init];
    self.tableView.delegate = self;
    
    NSLog(@"Counties View");
    
    FMDatabase * db = [[AppDelegate getAppDelegate] database ];
    FMResultSet * s = [ db executeQuery:@"SELECT id, name FROM counties ORDER BY name"];
    while ([s next]) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        NSNumber * number = [NSNumber numberWithInt:[s intForColumn:@"id"]];
        [dict setObject:number forKey:@"id"];
        [dict setObject:[s stringForColumn:@"name"] forKey:@"name"];
        [self.items addObject:dict];
        
        [aryCounties addObject:[s stringForColumn:@"name"]];
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

/* 2) remove this */
/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}
*/

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //  3) New search bar cell
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
    //NSDictionary * dict = [self.items objectAtIndex:index];
    //cell.textLabel.text = [dict objectForKey:@"name"];
    cell.textLabel.text = [aryCounties objectAtIndex:index];
    return cell;
}

//method calls when cell will be seected
//- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//	return indexPath;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 4) don't do anything when tapping first section
    if([indexPath section] == 0)
    {
        return;
    }
    
    int index = (int)[indexPath row];
    NSDictionary * dict = [self.items objectAtIndex:index];
    
    CountyViewController * vc = [[CountyViewController alloc] init];
    vc.itemId = [dict objectForKey:@"id"];
    [self pushViewController:vc];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return[NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
        NSLog(@"title -%@",title);
        for (int i = 0; i< [aryCounties count]; i++)
        {
            NSString *letterString = [[aryCounties objectAtIndex:i] substringToIndex:1];
            if ([[letterString lowercaseString] isEqualToString:[title lowercaseString]])
            {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                break;
            }
        }
        return index;
}

@end
