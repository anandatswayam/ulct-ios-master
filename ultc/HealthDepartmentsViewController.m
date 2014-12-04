//
//  HeathDepartmentsViewController.m
//  ultc
//
//  Created by shallowsummer on 9/22/13.
//
//

#import "HealthDepartmentsViewController.h"
#import "AboutHealthDepartmentsViewController.h"
#import "HealthDepartmentsListViewController.h"

@interface HealthDepartmentsViewController ()

@end

@implementation HealthDepartmentsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
self.title = @"Health Departments";
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllers = @[
                             [[AboutHealthDepartmentsViewController alloc] init],
                             [[HealthDepartmentsListViewController alloc] init]
                             ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
