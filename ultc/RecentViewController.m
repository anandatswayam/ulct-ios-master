//
//  RecentViewController.m
//  ultc
//
//  Created by Matthew Shultz on 5/23/13.
//
//

#import "RecentViewController.h"
#import "Recent.h"
#import "ContentViewController.h"

@interface RecentViewController () 

@end

@implementation RecentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Recent Views";
        self.hideSearchBar = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Recent"];
    NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"accessDate" ascending:NO];
    [request setSortDescriptors:@[sortDescriptor]];
    [request setFetchLimit:20];
    
    NSError * error;
    NSArray * results = [[AppDelegate getAppDelegate].managedObjectContext executeFetchRequest:request error:&error];
    if(results == nil){
        [WRUtilities criticalError:error];
    } else {
        self.items = [results mutableCopy];
    }
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 0;
    } else {
        return [self.items count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kIdentifier];
    }
    int index = (int)[indexPath row];
    Recent * recent = [self.items objectAtIndex:index];
    cell.textLabel.text = recent.title;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int index = (int)[indexPath row];
    Recent * recent = [self.items objectAtIndex:index];
    
    Class viewControllerClass = NSClassFromString (recent.viewController);
    
    id vcInstance = [[viewControllerClass alloc] init];
    ContentViewController * vc = (ContentViewController * ) vcInstance;
    vc.itemId = recent.itemId;
    
    [self pushViewController:vc];
}

@end