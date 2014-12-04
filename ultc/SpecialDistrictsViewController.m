//
//  SpecialDistrictsViewController.m
//  ultc
//
//  Created by shallowsummer on 9/22/13.
//
//

#import "SpecialDistrictsViewController.h"
#import "AboutSpecialDistrictsViewController.h"
#import "SpecialDistrictsListViewController.h"

@interface SpecialDistrictsViewController ()

@end

@implementation SpecialDistrictsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Special Districts";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllers = @[
                             [[AboutSpecialDistrictsViewController alloc] init],
                             [[SpecialDistrictsListViewController alloc] init]
                             ];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
