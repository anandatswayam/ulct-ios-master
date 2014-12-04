//
//  DynamicDrillDownViewController.m
//  ultc
//
//  Created by Matthew Shultz on 5/23/13.
//
//

#import "DynamicDrillDownViewController.h"
#import "SearchTableViewCell.h"

#define kSEARCH_BAR_HEIGHT 44
#define kSearchBarIdentifier @"kSEARCH_BAR_HEIGHT"

@interface DynamicDrillDownViewController ()

@property (nonatomic, strong) NSArray * originalItems;
@property (nonatomic, strong) NSString * lastSearchText;

@end

@implementation DynamicDrillDownViewController

@synthesize items;
@synthesize hideSearchBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.items = [NSMutableArray array];
    }
    hideSearchBar = YES;
    if([self respondsToSelector: @selector(setAutomaticallyAdjustsScrollViewInsets:)]){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if(hideSearchBar)
    {
        [self performSelector:@selector(hideTheSearchBar) withObject:nil afterDelay:0.0f];
    }
}



- (void)hideTheSearchBar {
    self.tableView.contentOffset = CGPointMake(0, kSEARCH_BAR_HEIGHT);
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 1;
    } else {
        return [self.items count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = nil;
    if([indexPath section] == 0){
        
        cell = [tableView dequeueReusableCellWithIdentifier:kSearchBarIdentifier];
        if(cell == nil){
            SearchTableViewCell * sCell = [WRUtilities getViewFromNib:@"SearchTableViewCell" class:[SearchTableViewCell class]];
            sCell.searchBar.delegate = self;
            sCell.searchBar.text = self.lastSearchText;
            sCell.searchBar.showsCancelButton = NO;
            sCell.searchBar.showsSearchResultsButton = NO;
            sCell.searchBar.showsScopeBar = NO;
            cell = sCell;
        }
    }
    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if(self.originalItems == nil){
        self.originalItems = [self.items copy];
    }
    if(self.searchKey == nil){
        return;
    }
    
    if(searchText == nil || [searchText isEqualToString:@""]){
        self.items = [NSMutableArray arrayWithArray:self.originalItems];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        [searchBar resignFirstResponder];
        return;
    }
    
    self.items = [NSMutableArray array];
    for(NSDictionary * dict in self.originalItems){
        NSString * term = [dict objectForKey:self.searchKey];
        if(term == nil){
            continue;
        }
        if( [term rangeOfString:searchText options:NSCaseInsensitiveSearch].location == 0
           || [[NSString stringWithFormat:@" %@", term] rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound
           ) {
            [self.items addObject:dict];
        }
    }
    self.lastSearchText = searchText;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];

    
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


@end
