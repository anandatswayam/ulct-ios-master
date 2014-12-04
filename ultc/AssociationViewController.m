//
//  AssociationViewController.m
//  ultc
//
//  Created by shallowsummer on 9/22/13.
//
//

#import "AssociationViewController.h"
#import "AppDelegate.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "WRUtilities.h"
#import "TitleTableViewCell.h"
#import "SingleLineTableViewCell.h"
#import "TitleExtraListTableViewCell.h"
#import "FourLineExtraListTableViewCell.h"

@interface AssociationViewController ()

@property (nonatomic, strong) NSMutableDictionary * dict;
@property (nonatomic, strong) NSMutableArray * fieldOrder;

@end

@implementation AssociationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    
    // DW: configuration for extra list items
    self.extraListSqlString = [NSString stringWithFormat:@"SELECT * FROM officials JOIN association_officials ON officials.id = association_officials.official_id WHERE association_officials.association_id = %i", [self.itemId intValue]];
    self.extraListFields = @[
                             @[@"name", @"string"],
                             @[@"title", @"string"],
                             @[@"phone", @"string"],
                             @[@"email", @"string"]
                             ];
    self.extraListFieldOrder = [ @[@"name", @"title", @"phone", @"email"] mutableCopy];
    
    [super viewDidLoad];
    
    self.fieldOrder = [[NSMutableArray alloc] init];
    
    
    FMDatabase * db = [[AppDelegate getAppDelegate] database ];
    NSString * sqlString = [NSString stringWithFormat:@"SELECT * FROM associations where id = %i", [self.itemId intValue]];
    FMResultSet * s = [ db executeQuery:sqlString];
    if([s next])
    {
        self.dict = [NSMutableDictionary dictionary];
        NSNumber * number = [NSNumber numberWithInt:[s intForColumn:@"id"]];
        [self.dict setObject:number forKey:@"id"];
        
    
        NSArray * textFields = @[@"name",
                                 @"meetings",
                                 @"contact_name",
                                 @"contact_email",
                                 ];
        
        
        for(NSString * field in textFields)
        {
            [self.dict setObject:[s stringForColumn:field] forKey:field];
        }
        
        [self.fieldOrder addObject:@"name"];
        
        [self.fieldOrder addObject:@"meetings"];
        [self.fieldOrder addObject:@"contact_name"];
        [self.fieldOrder addObject:@"contact_email"];
        
        self.title = [self.dict objectForKey:@"name"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

#pragma mark UITableView Delegate Methods

- (UITableViewCell*) cellForField: (NSString*) field {
    
    UITableViewCell * cell;
    
    if ([field isEqual:@"name"]){
        TitleTableViewCell * titleCell = [WRUtilities getViewFromNib:@"TitleTableViewCell" class:[TitleTableViewCell class]];
        titleCell.title.text = [self.dict objectForKey:@"name"];
        titleCell.delegate = self;
        [titleCell selectIfFavorited:self];
        cell=titleCell;
    }
    
    else if([field isEqual:@"meetings"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Meetings:";
        singleCell.content.text = [self.dict objectForKey:@"meetings"];
        cell=singleCell;
        
    }
    
    else if([field isEqual:@"contact_name"] && ![[NSString stringWithFormat:@"%@",[self.dict objectForKey:@"contact_name"]] isEqualToString:@""]){
        NSLog(@"%@", [self.dict objectForKey:@"contact_name"]);
        
            SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
            singleCell.title.text = @"Contact Name:";
            singleCell.content.text = [self.dict objectForKey:@"contact_name"];
            cell=singleCell;
    }
    
    else if([field isEqual:@"contact_email"] && ![[NSString stringWithFormat:@"%@",[self.dict objectForKey:@"contact_email"]] isEqualToString:@""]){
        NSLog(@"%@", [self.dict objectForKey:@"contact_email"]);
       
            SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
            singleCell.title.text = @"Email:";
            singleCell.content.text = [self.dict objectForKey:@"contact_email"];
            cell=singleCell;
    }
    
    [self setUserInteractionForField:field withCell:cell];
    
    return cell;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell;
    
    
    if([indexPath row] < [self.fieldOrder count])
    {
        NSString * field = [self.fieldOrder objectAtIndex:[indexPath row]];
        cell = [self cellForField:field];
    }
    else if ([indexPath row] == [self.fieldOrder count])
    {
        TitleExtraListTableViewCell * titleCell = [WRUtilities getViewFromNib:@"TitleExtraListTableViewCell" class:[TitleExtraListTableViewCell class]];
        titleCell.title.text = @"Officials:";
        cell=titleCell;
        
    }
    else if([indexPath row] < [self.fieldOrder count] + self.extraListThreshold)
    {
        FourLineExtraListTableViewCell * lineCell = [WRUtilities getViewFromNib:@"FourLineExtraListTableViewCell" class:[FourLineExtraListTableViewCell class]];
        NSDictionary * dict = [self.extraListItems objectAtIndex:[indexPath row] - ([self.fieldOrder count] + 1) ];
        lineCell.line1.text = [dict objectForKey:@"name"];
        lineCell.line2.text = [dict objectForKey:@"title"];
        lineCell.line3.text = [dict objectForKey:@"phone"];
        lineCell.line4.text = [dict objectForKey:@"email"];
        
        cell=lineCell;
    }
    
    
    
    if(cell == NULL)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IDENTIFIER"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath row] == [self.fieldOrder count]){
        return 32;
    }
    else if ([indexPath row] > [self.fieldOrder count] && [indexPath row] < [self.fieldOrder count] + self.extraListThreshold){
        return 95;
    }
    
    float height = 40;
    
    NSString * field = [self.fieldOrder objectAtIndex:[indexPath row]];
    
    if ([field isEqual:@"name"])
    {
        height = 47;
        
    }
    else if([field isEqual:@"meetings"])
    {
        height = 57;
        
    }
    else if([field isEqual:@"contact_name"] && ![[NSString stringWithFormat:@"%@",[self.dict objectForKey:@"contact_name"]] isEqualToString:@""])
    {
        height = 57;
        
    }
    else if([field isEqual:@"contact_email"] && ![[NSString stringWithFormat:@"%@",[self.dict objectForKey:@"contact_email"]] isEqualToString:@""])
    {
        height = 57;
        
    }
    
    return height;
}

@end