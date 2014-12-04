//
//  CountiesTopLevelViewController.m
//  ultc
//
//  Created by shallowsummer on 9/17/13.
//
//

#import "CountiesTopLevelViewController.h"
#import "AboutCountiesViewController.h"
#import "CountiesViewController.h"

@interface CountiesTopLevelViewController ()

@end

@implementation CountiesTopLevelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    self.title = @"Counties";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.viewControllers = @[
                          [[AboutCountiesViewController alloc] init],
                          [[CountiesViewController alloc] init]
                          ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
