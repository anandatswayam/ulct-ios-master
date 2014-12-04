//
//  BoardOfDirectorsViewController.m
//  ultc
//
//  Created by shallowsummer on 9/10/13.
//
//

#import "BoardOfDirectorsViewController.h"
#import "BoardMembersViewController.h"
#import "BoardOfDirectorsAboutViewController.h"

@interface BoardOfDirectorsViewController ()

@end

@implementation BoardOfDirectorsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Board Of Directors";
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllers = @[
                             [[BoardOfDirectorsAboutViewController alloc] init],
                             [[BoardMembersViewController alloc] init],];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
