//
//  TopLevelViewController.m
//  ultc
//
//  Created by Matthew Shultz on 5/23/13.
//
//

#import "TopLevelViewController.h"
#import "GeneralInfoViewController.h"
#import "MunicipalitiesViewController.h"
#import "CountiesTopLevelViewController.h"
#import "StateViewController.h"
#import "OtherViewController.h"
#import "FestivalsViewController.h"
#import "SponsorsViewController.h"
#import "DistrictsViewController.h"
#import "AboutMunicipalitiesListViewController.h"
#import "CitiesMunicipalitiesListViewController.h"

@interface TopLevelViewController ()

@end

@implementation TopLevelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"DrillDownViewController" bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Directory";
           }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllers = @[
                             [[GeneralInfoViewController alloc] init],
                             [[MunicipalitiesViewController alloc] init],
                             [[CountiesTopLevelViewController alloc] init],
                             [[StateViewController alloc] init],
                             [[DistrictsViewController alloc] init],
                             [[OtherViewController alloc] init],
                             [[FestivalsViewController alloc] init],
                             [[SponsorsViewController alloc] init]
                             ];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
