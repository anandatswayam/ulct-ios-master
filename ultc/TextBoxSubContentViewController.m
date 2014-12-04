//
//  TextBoxSubContentViewController.m
//  ultc
//
//  Created by Matthew Shultz on 9/27/13.
//
//

#import "TextBoxSubContentViewController.h"

@interface TextBoxSubContentViewController ()

@end

@implementation TextBoxSubContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.saveAsRecent = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
