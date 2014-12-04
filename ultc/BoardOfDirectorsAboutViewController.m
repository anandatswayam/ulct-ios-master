//
//  BoardOfDirectorsAboutViewController.m
//  ultc
//
//  Created by shallowsummer on 9/10/13.
//
//

#import "BoardOfDirectorsAboutViewController.h"

@interface BoardOfDirectorsAboutViewController ()

@end

@implementation BoardOfDirectorsAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
self.title = @"About Board Of Directors";
    }
    
    FMDatabase * db = [[AppDelegate getAppDelegate] database ];
    NSString * sqlString = @"SELECT * FROM info";
    FMResultSet * s = [ db executeQuery:sqlString];
    if([s next]){
        
        NSString * text = [s stringForColumn:@"board_member_intro"];
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
