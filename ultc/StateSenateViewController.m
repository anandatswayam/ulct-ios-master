//
//  StateSenateViewController.m
//  ultc
//
//  Created by shallowsummer on 9/17/13.
//
//

#import "StateSenateViewController.h"
#import "GeneralInfoStateSenateViewController.h"
#import "StateSenatorsViewController.h"

@interface StateSenateViewController ()

@end

@implementation StateSenateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"State Senate";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllers = @[
                             [[GeneralInfoStateSenateViewController alloc] init],
                             [[StateSenatorsViewController alloc] init]                             
                             ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
