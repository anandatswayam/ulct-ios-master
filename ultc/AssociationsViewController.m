//
//  AssociationsViewController.m
//  ultc
//
//  Created by shallowsummer on 9/22/13.
//
//

#import "AssociationsViewController.h"
#import "AboutAssociationsViewController.h"
#import "AssociationsListViewController.h"

@interface AssociationsViewController ()

@end

@implementation AssociationsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
self.title = @"Associations";    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllers = @[
                             [[AboutAssociationsViewController alloc] init],
                             [[AssociationsListViewController alloc] init]
                             ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
