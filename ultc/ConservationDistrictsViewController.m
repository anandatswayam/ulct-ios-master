    //
//  ConservationDistrictsViewController.m
//  ultc
//
//  Created by shallowsummer on 9/22/13.
//
//

#import "ConservationDistrictsViewController.h"
#import "AboutConservationDistrictsViewController.h"
#import "ConservationDistrictsListViewController.h"

@interface ConservationDistrictsViewController ()

@end

@implementation ConservationDistrictsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Conservation Districts";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllers = @[
                             [[AboutConservationDistrictsViewController alloc] init],
                             [[ConservationDistrictsListViewController alloc] init]
                             ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
