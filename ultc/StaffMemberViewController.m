//
//  StaffMemberViewController.m
//  ultc
//
//  Created by shallowsummer on 9/10/13.
//
//

#import "StaffMemberViewController.h"
#import "AppDelegate.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "WRUtilities.h"
#import "SingleLineTableViewCell.h"
#import "TitleTableViewCell.h"
#import "TextBoxSubContentViewController.h"

@interface StaffMemberViewController ()

@property (nonatomic, strong) NSMutableDictionary * dict;
@property (nonatomic, strong) NSMutableArray * fieldOrder;


@end

@implementation StaffMemberViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.fieldOrder = [[NSMutableArray alloc] init];
    
    // This is probably important
    
    
    FMDatabase * db = [[AppDelegate getAppDelegate] database ];
    NSString * sqlString = [NSString stringWithFormat:@"SELECT * FROM ulct_staff_members where id = %i", [self.itemId intValue]];
    FMResultSet * s = [ db executeQuery:sqlString];
    if([s next]){
        
        self.dict = [NSMutableDictionary dictionary];
        NSNumber * number = [NSNumber numberWithInt:[s intForColumn:@"id"]];
        [self.dict setObject:number forKey:@"id"];
        
        NSArray * textFields = @[@"name",
                                 @"title",
                                 @"email",
                                 @"bio",
                                 //@"photo"
                                 ];
        
        
        for(NSString * field in textFields){
            [self.dict setObject:[s stringForColumn:field] forKey:field];
        }
        
        [self.fieldOrder addObject:@"name"];
        [self.fieldOrder addObject:@"title"];
        [self.fieldOrder addObject:@"email"];
        [self.fieldOrder addObject:@"bio"];
        [self.fieldOrder addObject:@"photo"];
        
        self.title = [self.dict objectForKey:@"name"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

#pragma mark UITableView Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.fieldOrder count];
    
    //number of rows in section
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell;
    
    NSString * field = [self.fieldOrder objectAtIndex:[indexPath row]];
    
    if ([field isEqual:@"name"]){
        TitleTableViewCell * titleCell = [WRUtilities getViewFromNib:@"TitleTableViewCell" class:[TitleTableViewCell class]];
        titleCell.title.text = [self.dict objectForKey:@"name"];
        titleCell.delegate = self;
        [titleCell selectIfFavorited:self];
        cell=titleCell;
    }
    else if ([field isEqual:@"title"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Title:";
        singleCell.content.text = [self.dict objectForKey:@"title"];
        cell=singleCell;
    }
    else if ([field isEqual:@"email"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Email:";
        singleCell.content.text = [self.dict objectForKey:@"email"];
        cell=singleCell;
    }
    else if ([field isEqual:@"bio"] && ![[NSString stringWithFormat:@"%@",[self.dict objectForKey:@"bio"]] isEqualToString:@"(null)"] && ![[NSString stringWithFormat:@"%@",[self.dict objectForKey:@"bio"]] isEqualToString:@""]){
        NSLog(@"about--%@",[self.dict objectForKey:@"bio"]);
        
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        
        singleCell.title.text = @"Bio:";
        singleCell.content.text = @"Tap for more info";//[self.dict objectForKey:@"bio"];
        cell=singleCell;
    }
    
    
    if(cell == NULL){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IDENTIFIER"];
    }
    
    [self setUserInteractionForField:field withCell:cell];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    float height = 40;
    
    NSString * field = [self.fieldOrder objectAtIndex:[indexPath row]];
    if ([field isEqual:@"name"]) {
        height = 44;
    }
    
    else if([field isEqual:@"title"]){
        height = 57;
    }
   
    else if([field isEqual:@"email"]){
        height = 57;
    }
    
    else if([field isEqual:@"bio"]){
        height = 57;
    }
    
    else {
        
    }
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    if([indexPath row] == [self.fieldOrder indexOfObject:@"bio"]){
        TextBoxSubContentViewController * vc = [[TextBoxSubContentViewController alloc] init];
        vc.text = [self.dict objectForKey:@"bio"];
        [self pushViewController:vc];
    }
    
}



@end
