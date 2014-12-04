//
//  UsHouseViewController.m
//  ultc
//
//  Created by shallowsummer on 9/20/13.
//
//

#import "UsHouseViewController.h"
#import "UsRepresentativesViewController.h"
#import "GeneralInfoUsHouseViewController.h"

@interface UsHouseViewController ()

@end

@implementation UsHouseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"US House";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllers = @[
                             [[GeneralInfoUsHouseViewController alloc] init],
                             [[UsRepresentativesViewController alloc] init]
                             ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
