//
//  EventViewController.m
//  ultc
//
//  Created by shallowsummer on 9/8/13.
//
//

#import "EventViewController.h"
#import "AppDelegate.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "WRUtilities.h"
#import "SingleLineTableViewCell.h"
#import "TitleTableViewCell.h"
#import "NSDate+Pretty.h"

@interface EventViewController ()

@property (nonatomic, strong) NSMutableDictionary * dict;
@property (nonatomic, strong) NSMutableArray * fieldOrder;

@end

@implementation EventViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.fieldOrder = [[NSMutableArray alloc] init];
    
    
    FMDatabase * db = [[AppDelegate getAppDelegate] database ];
    NSString * sqlString = [NSString stringWithFormat:@"SELECT name,date_to,date_from,location,contact,phone,type, date_to as time_to, date_from as time_from,description FROM events where id = %i", [self.itemId intValue]];
    FMResultSet * s = [ db executeQuery:sqlString];
    if([s next]){
        
        self.dict = [NSMutableDictionary dictionary];
        NSNumber * number = [NSNumber numberWithInt:[s intForColumn:@"id"]];
        [self.dict setObject:number forKey:@"id"];
        
        NSArray * textFields = @[@"name",
                                 @"date_to",
                                 @"date_from",
                                 //@"time_to",
                                 //@"time_from",
                                 @"location",
                                 @"contact",
                                 @"phone",
                                 @"type",
                                 @"description",
                                 @"img",
                                 @"url",
                                 @"municipality_id"];
        
        
        for(NSString * field in textFields)
        {
            if([s stringForColumn:field] != NULL)
            {
                [self.dict setObject:[s stringForColumn:field] forKey:field];
                [self.fieldOrder addObject:field];
            }
            else
            {
                [self.dict setObject:@"" forKey:field];
            }
        }

        self.title = [self.dict objectForKey:@"name"];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

#pragma mark UITableView Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fieldOrder count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell;
    
    NSString * field = [self.fieldOrder objectAtIndex:[indexPath row]];
    
    if ([field isEqual:@"name"])
    {
        TitleTableViewCell * titleCell = [WRUtilities getViewFromNib:@"TitleTableViewCell" class:[TitleTableViewCell class]];
        titleCell.title.text = [self.dict objectForKey:@"name"];
        titleCell.delegate = self;
        [titleCell selectIfFavorited:self];
        cell=titleCell;
    }
    
//    else if ([field isEqual:@"date_from"]){
//        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
//        singleCell.title.text = @"Event Date:";
//        
//        NSNumber * date_from = [self.dict objectForKey:@"date_from"];
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[date_from intValue] ];
//        
//        singleCell.content.text = [date prettyJustDate];
//        cell=singleCell;
//    }
    
    else if ([field isEqual:@"date_from"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Start Date:";
        NSNumber * date_from = [self.dict objectForKey:@"date_from"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[date_from intValue] ];
        
        singleCell.content.text = [date prettyJustDate];
        cell=singleCell;
    }
    
    else if ([field isEqual:@"date_to"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"End Date:";
        NSNumber * date_from = [self.dict objectForKey:@"date_to"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[date_from intValue] ];
        
        singleCell.content.text = [date prettyJustDate];
        cell=singleCell;
    }
    
    else if ([field isEqual:@"time_from"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Start Time:";
        NSNumber * date_from = [self.dict objectForKey:@"time_from"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[date_from intValue] ];
        
        singleCell.content.text = [date dayAndTime];
        cell=singleCell;
    }
    
    else if ([field isEqual:@"time_to"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"End Time:";
        NSNumber * date_from = [self.dict objectForKey:@"time_to"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[date_from intValue] ];
        
        singleCell.content.text = [date dayAndTime];
        cell=singleCell;
    }
    
    else if ([field isEqual:@"location"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Location Address:";
        singleCell.content.text = [self.dict objectForKey:@"location"];
        cell=singleCell;
    }
    
    else if ([field isEqual:@"description"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"About:";
        singleCell.content.text = [self.dict objectForKey:@"description"];
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
    
//    else if([field isEqual:@"date_from"]){
//        height = 57;
//        
//    }
    else if([field isEqual:@"date_from"]){
        height = 57;
        
    }
    else if([field isEqual:@"date_to"]){
        height = 57;
        
    }
    else if([field isEqual:@"time_from"]){
        height = 57;
        
    }
    else if([field isEqual:@"time_to"]){
        height = 57;
        
    }
    else if([field isEqual:@"location"]){
        height = 57;
        
    }
    else if([field isEqual:@"description"]){
        height = 57;
        
    }
    
    else
    {
        
    }
    
    
    return height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end