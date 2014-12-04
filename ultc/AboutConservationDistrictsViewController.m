//
//  AboutConservationDistrictsViewController.m
//  ultc
//
//  Created by shallowsummer on 9/22/13.
//
//

#import "AboutConservationDistrictsViewController.h"

@interface AboutConservationDistrictsViewController ()

@end

@implementation AboutConservationDistrictsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
self.title = @"About Conservation Districts";    }
    FMDatabase * db = [[AppDelegate getAppDelegate] database ];
    NSString * sqlString = @"SELECT * FROM info";
    FMResultSet * s = [ db executeQuery:sqlString];
    if([s next]){
        
        NSString * text = [s stringForColumn:@"conservation_districts_intro"];
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
    // Dispose of any resources that can be recreated.
}

@end
