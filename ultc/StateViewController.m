//
//  StateViewController.m
//  ultc
//
//  Created by Matthew Shultz on 5/23/13.
//
//

#import "StateViewController.h"
#import "GovernorViewController.h"
#import "LtGovernorViewController.h"
#import "StateSenateViewController.h"
#import "StateHouseViewController.h"
#import "UsSenateViewController.h"
#import "UsHouseViewController.h"
#import "StateAgenciesViewController.h"

@interface StateViewController ()

@end

@implementation StateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"State";
        self.isPenultimate = true;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.viewControllers = @[
                             [[GovernorViewController alloc] init],
                             [[LtGovernorViewController alloc] init],
                             [[StateSenateViewController alloc] init],
                             [[StateHouseViewController alloc] init],
                             [[StateAgenciesViewController alloc] init],
                             [[UsSenateViewController alloc] init],
                             [[UsHouseViewController alloc] init]
                             
                             ];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
