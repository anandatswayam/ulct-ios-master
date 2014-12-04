//
//  StateAgenciesViewController.m
//  ultc
//
//  Created by shallowsummer on 9/22/13.
//
//

#import "StateAgenciesViewController.h"
#import "AboutStateAgenciesViewController.h"
#import "StateAgenciesListViewController.h"

@interface StateAgenciesViewController ()

@end

@implementation StateAgenciesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"State Agencies";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllers = @[
                             [[AboutStateAgenciesViewController alloc] init],
                             [[StateAgenciesListViewController alloc] init]
                             ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
