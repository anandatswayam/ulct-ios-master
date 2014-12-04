//
//  SponsorsViewController.m
//  ultc
//
//  Created by Matthew Shultz on 8/29/13.
//
//

#import "SponsorsViewController.h"
#import "AppDelegate.h"
#import "FMResultSet.h"
#import "FMDatabase.h"
#import "SponsorViewController.h"

@interface SponsorsViewController ()

@end

@implementation SponsorsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    // for every dynamic drill down controller that is 2nd to last in navigation
    // 1 add this
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
       && UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])

       ){
        // nibNameOrNil = @"DrillDownViewControllerSkinny~ipad";
    }
    // end 1
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Sponsors";
        self.isPenultimate = true;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.items removeAllObjects];
    // This is probably important
    FMDatabase * db = [[AppDelegate getAppDelegate] database ];
    FMResultSet * s = [ db executeQuery:@"SELECT id, name FROM ulct_sponsors ORDER BY name"];
    while ([s next]) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        NSNumber * number = [NSNumber numberWithInt:[s intForColumn:@"id"]];
        [dict setObject:number forKey:@"id"];
        [dict setObject:[s stringForColumn:@"name"] forKey:@"name"];
        [self.items addObject:dict];
        
    }
    NSLog(@"Array Count: %lu",(unsigned long)[self.items count]);
    [self.tableView reloadData];
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

/*- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Sponcers Count: %lu",(unsigned long)[self.items count]);
    return [self.items count];
}*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Index Pos: %ld",(long)[indexPath row]);
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
    //if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kIdentifier];
    //}
    int index = (int)[indexPath row];
    
    if([self.items count] > 0){
        NSDictionary * dict = [self.items objectAtIndex:index];
        
        NSLog(@"Sponcers Text: %@",[dict objectForKey:@"name"]);
        cell.textLabel.text = [dict objectForKey:@"name"];
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int index = (int)[indexPath row];
    NSDictionary * dict = [self.items objectAtIndex:index];
    
    SponsorViewController * vc = [[SponsorViewController alloc] init];
    vc.itemId = [dict objectForKey:@"id"];
    [self pushViewController:vc];
    
}

@end