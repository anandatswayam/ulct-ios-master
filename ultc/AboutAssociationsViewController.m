//
//  AboutAssociationsViewController.m
//  ultc
//
//  Created by shallowsummer on 9/22/13.
//
//

#import "AboutAssociationsViewController.h"

@interface AboutAssociationsViewController ()

@end

@implementation AboutAssociationsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"About Associations";
    }
    
    FMDatabase * db = [[AppDelegate getAppDelegate] database ];
    NSString * sqlString = @"SELECT * FROM info";
    FMResultSet * s = [ db executeQuery:sqlString];
    if([s next])
    {
        NSString * text = [s stringForColumn:@"associations_intro"];
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
