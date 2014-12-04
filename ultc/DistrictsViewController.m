//
//  DistrictsViewController.m
//  ultc
//
//
//
//

#import "DistrictsViewController.h"
#import "SpecialDistrictsViewController.h"
#import "RegionalPlanningDistrictsViewController.h"
#import "ConservationDistrictsViewController.h"

@interface DistrictsViewController ()

@end

@implementation DistrictsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Districts";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllers = @[
                             [[SpecialDistrictsViewController alloc] init],
                             [[RegionalPlanningDistrictsViewController alloc] init],
                             [[ConservationDistrictsViewController alloc] init]
                              ];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
