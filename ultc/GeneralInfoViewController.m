//
//  InfoViewController.m
//  ultc
//
//  Created by Matthew Shultz on 5/23/13.
//
//

#import "GeneralInfoViewController.h"
#import "AboutViewController.h"
#import "MissionStatementViewController.h"
#import "EventsCalendarViewController.h"
#import "StaffMembersViewController.h"
#import "BoardOfDirectorsViewController.h"

@interface GeneralInfoViewController ()

@end

@implementation GeneralInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"ULCT";


    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.viewControllers = @[
                             [[AboutViewController alloc] init],
                             [[MissionStatementViewController alloc] init],
                             [[EventsCalendarViewController alloc] init],
                             [[StaffMembersViewController alloc] init],
                             
                             [[BoardOfDirectorsViewController alloc] init]
                             /*
                              [[OtherPublicationsViewController alloc] init],
                              [[CoverImageViewController alloc] init],
                              */
                             ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
