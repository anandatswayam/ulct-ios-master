//
//  AboutCountiesViewController.m
//  ultc
//
//  Created by shallowsummer on 9/17/13.
//
//

#import "AboutCountiesViewController.h"

@interface AboutCountiesViewController ()

@end

@implementation AboutCountiesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    self.title = @"About Counties";
    }
    FMDatabase * db = [[AppDelegate getAppDelegate] database ];
    NSString * sqlString = @"SELECT * FROM info";
    FMResultSet * s = [ db executeQuery:sqlString];
    if([s next]){
        
        NSString * text = [s stringForColumn:@"county_intro"];
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
