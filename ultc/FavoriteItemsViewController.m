//
//  FavoriteItemsViewController.m
//  ultc
//
//  Created by Matthew Shultz on 5/23/13.
//
//

#import "FavoriteItemsViewController.h"
#import "Favorite.h"
#import "ContentViewController.h"

@interface FavoriteItemsViewController ()

@end

@implementation FavoriteItemsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Saved Entries";
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
    
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Favorite"];
    NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:NO];
    [request setSortDescriptors:@[sortDescriptor]];
    
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
    Favorite * favorite = [self.items objectAtIndex:index];
    cell.textLabel.text = favorite.title;
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int index = (int)[indexPath row];
    Favorite * favorite = [self.items objectAtIndex:index];
    
    Class viewControllerClass = NSClassFromString (favorite.viewController);
    
    id vcInstance = [[viewControllerClass alloc] init];
    ContentViewController * vc = (ContentViewController * ) vcInstance;
    vc.itemId = favorite.itemId;
    
    [self pushViewController:vc];
    
}



@end
