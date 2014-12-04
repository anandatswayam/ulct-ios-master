//
//  UsSenateViewController.m
//  ultc
//
//  Created by shallowsummer on 9/20/13.
//
//

#import "UsSenateViewController.h"
#import "UsSenatorsViewController.h"
#import "GeneralInfoUsSenateViewController.h"

@interface UsSenateViewController ()

@end

@implementation UsSenateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"US Senate";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllers = @[
                             [[GeneralInfoUsSenateViewController alloc] init],
                             [[UsSenatorsViewController alloc] init]
                             ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
