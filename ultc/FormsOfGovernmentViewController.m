//
//  FormsOfGovernmentViewController.m
//  ultc
//
//  Created by anandpatel on 9/12/13.
//
//

#import "FormsOfGovernmentViewController.h"
#import "AboutFormsOfGovernmentViewController.h"
#import "CitiesFormsOfGovernmentViewController.h"
#import "TypeFormsOfGovernmentViewController.h"

@interface FormsOfGovernmentViewController ()

@end

@implementation FormsOfGovernmentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       self.title = @"Forms Of Government";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.viewControllers = @[
                          [[AboutFormsOfGovernmentViewController alloc] init],
                          [[TypeFormsOfGovernmentViewController alloc] init]
                          ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
