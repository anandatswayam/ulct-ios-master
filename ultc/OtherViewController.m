//
//  OtherViewController.m
//  ultc
//
//  Created by Matthew Shultz on 5/23/13.
//
//

#import "OtherViewController.h"
#import "HealthDepartmentsViewController.h"
#import "AssociationsViewController.h"
#import "LeaguesViewController.h"

@interface OtherViewController ()

@end

@implementation OtherViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Other";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllers = @[
                             [[HealthDepartmentsViewController alloc] init],
                             [[AssociationsViewController alloc] init],
                             [[LeaguesViewController alloc] init]
                             ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
