//
//  LeaguesViewController.m
//  ultc
//
//  Created by shallowsummer on 9/22/13.
//
//

#import "LeaguesViewController.h"
#import "AboutLeaguesViewController.h"
#import "LeaguesListViewController.h"


@interface LeaguesViewController ()

@end

@implementation LeaguesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
self.title = @"Leagues";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllers = @[
                             [[AboutLeaguesViewController alloc] init],
                             [[LeaguesListViewController alloc] init]
                             ];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
