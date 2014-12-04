//
//  RegionalPlanningDistrictsViewController.m
//  ultc
//
//  Created by shallowsummer on 9/22/13.
//
//

#import "RegionalPlanningDistrictsViewController.h"
#import "AboutRegionalPlanningDistrictsViewController.h"
#import "RegionalPlanningDistrictsListViewController.h"

@interface RegionalPlanningDistrictsViewController ()

@end

@implementation RegionalPlanningDistrictsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Regional Planning Districts";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllers = @[
                             [[AboutRegionalPlanningDistrictsViewController alloc] init],
                             [[RegionalPlanningDistrictsListViewController alloc] init]
                             ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
