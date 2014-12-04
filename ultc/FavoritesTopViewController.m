//
//  FavoritesTopViewController.m
//  ultc
//
//  Created by Matthew Shultz on 5/23/13.
//
//

#import "FavoritesTopViewController.h"
#import "RecentViewController.h"
#import "FavoriteItemsViewController.h"

@interface FavoritesTopViewController ()

@end

@implementation FavoritesTopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Dashboard";
        self.viewControllers = @[
                                [[RecentViewController alloc] init],
                                [[FavoriteItemsViewController alloc] init]
        ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
