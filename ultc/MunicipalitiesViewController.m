//
//  MunicipalitiesViewController.m
//  ultc
//
//  Created by Anand Patel on 5/23/13.
//
//

#import "MunicipalitiesViewController.h"
#import "FormsOfGovernmentViewController.h"
#import "PopulationListViewController.h"
#import "MunicipalitiesListViewController.h"
#import "CitiesMunicipalitiesListViewController.h"
#import "AboutMunicipalitiesListViewController.h"

@interface MunicipalitiesViewController ()
@end

@implementation MunicipalitiesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Municipalities";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.viewControllers = @[
                             [[AboutMunicipalitiesListViewController alloc] init],
                             [[CitiesMunicipalitiesListViewController alloc] init],
                             [[FormsOfGovernmentViewController alloc] init],
                             [[PopulationListViewController alloc] init],
                             ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
