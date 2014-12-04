//
//  AboutRegionalPlanningDistrictsViewController.m
//  ultc
//
//  Created by shallowsummer on 9/22/13.
//
//

#import "AboutRegionalPlanningDistrictsViewController.h"

@interface AboutRegionalPlanningDistrictsViewController ()

@end

@implementation AboutRegionalPlanningDistrictsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"About Regional Planning Districts";
    }
    
    FMDatabase * db = [[AppDelegate getAppDelegate] database ];
    NSString * sqlString = @"SELECT * FROM info";
    FMResultSet * s = [ db executeQuery:sqlString];
    if([s next])
    {
        NSString * text = [s stringForColumn:@"regional_planning_districts_intro"];
        self.text = text;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end