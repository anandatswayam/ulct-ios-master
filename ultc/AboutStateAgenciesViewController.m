//
//  AboutStateAgenciesViewController.m
//  ultc
//
//  Created by shallowsummer on 9/22/13.
//
//

#import "AboutStateAgenciesViewController.h"

@interface AboutStateAgenciesViewController ()

@end

@implementation AboutStateAgenciesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"About State Agencies";
    }
    FMDatabase * db = [[AppDelegate getAppDelegate] database ];
    NSString * sqlString = @"SELECT * FROM info";
    FMResultSet * s = [ db executeQuery:sqlString];
    if([s next]){
        
        NSString * text = [s stringForColumn:@"state_agencies_intro"];
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
