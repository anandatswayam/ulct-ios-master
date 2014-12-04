//
//  FestivalsViewController.m
//  ultc
//
//  Created by Matthew Shultz on 5/23/13.
//
//

#import "FestivalsViewController.h"
#import "AboutFestivalsViewController.h"
#import "FestivalsListViewController.h"

@interface FestivalsViewController ()

@end

@implementation FestivalsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Festivals";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllers = @[
                             [[AboutFestivalsViewController alloc] init],
                             [[FestivalsListViewController alloc] init]
                             ];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
