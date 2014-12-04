//
//  StateHouseViewController.m
//  ultc
//
//  Created by shallowsummer on 9/17/13.
//
//

#import "StateHouseViewController.h"
#import "GeneralInfoStateHouseViewController.h"
#import "StateRepresentativesViewController.h"

@interface StateHouseViewController ()

@end

@implementation StateHouseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    // for every dynamic drill down controller that is 2nd to last in navigation
    // 1 add this
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
       && UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])

       ){
        
        // nibNameOrNil = @"DrillDownViewControllerSkinny~ipad";
//         
    }
    // end 1
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"State House";
        self.isPenultimate = false;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.viewControllers = @[
                          [[GeneralInfoStateHouseViewController alloc] init],
                          [[StateRepresentativesViewController alloc] init]
                          ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
