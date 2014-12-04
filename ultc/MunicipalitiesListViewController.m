//
//  MunicipalitiesListViewController.m
//  ultc
//
//  Created by anandpatel on 9/16/13.
//
//

#import "MunicipalitiesListViewController.h"
#import "AboutMunicipalitiesListViewController.h"
#import "CitiesMunicipalitiesListViewController.h"


@interface MunicipalitiesListViewController ()

@end

@implementation MunicipalitiesListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"Municipalities List";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.viewControllers = @[
                          [[AboutMunicipalitiesListViewController alloc] init],
                          [[CitiesMunicipalitiesListViewController alloc] init]
                          ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
