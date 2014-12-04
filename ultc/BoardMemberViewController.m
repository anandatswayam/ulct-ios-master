//
//  BoardMemberViewController.m
//  ultc
//
//  Created by shallowsummer on 9/10/13.
//
//

#import "BoardMemberViewController.h"
#import "AppDelegate.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "WRUtilities.h"
#import "TitleTableViewCell.h"
#import "SingleLineTableViewCell.h"
#import "AddressTableViewCell.h"


@interface BoardMemberViewController ()

@property (nonatomic, strong) NSMutableDictionary * dict;
@property (nonatomic, strong) NSMutableArray * fieldOrder;

@end

@implementation BoardMemberViewController

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
    NSString * sqlString = [NSString stringWithFormat:@"SELECT * FROM ulct_board_members where id = %i", [self.itemId intValue]];
    FMResultSet * s = [ db executeQuery:sqlString];
    if([s next]){
        
        self.dict = [NSMutableDictionary dictionary];
        NSNumber * number = [NSNumber numberWithInt:[s intForColumn:@"id"]];
        [self.dict setObject:number forKey:@"id"];
        
        NSArray * textFields = @[@"name",
                                 @"league_title",
                                 @"work_title",
                                 @"work_address",
                                 @"work_city",
                                 @"work_state",
                                 @"work_zip",
                                 @"work_phone",
                                 @"work_email",
                                 @"area"];
       
        
        for(NSString * field in textFields){
            [self.dict setObject:[s stringForColumn:field] forKey:field];
        }
        
        [self.fieldOrder addObject:@"name"];
        [self.fieldOrder addObject:@"league_title"];
        [self.fieldOrder addObject:@"work_address"];
        //[self.fieldOrder addObject:@"work_city"];
        [self.fieldOrder addObject:@"work_phone"];
        [self.fieldOrder addObject:@"work_email"];
        [self.fieldOrder addObject:@"area"];
        
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
    
    else if([field isEqual:@"league_title"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"League Title:";
        singleCell.content.text = [self.dict objectForKey:@"league_title"];
        cell=singleCell;
        
    }
    
    else if([field isEqual:@"work_address"]){
        
        AddressTableViewCell * addressCell = [WRUtilities getViewFromNib:@"AddressTableViewCell" class:[AddressTableViewCell class]];
        addressCell.title.text = @"Work Address:";
        addressCell.addressLine1.text = [self.dict objectForKey:@"work_address"];
        addressCell.addressLine2.text = [NSString stringWithFormat:@"%@, %@ %@",
                                         [self.dict objectForKey:@"work_city"],
                                         [self.dict objectForKey:@"work_state"],
                                         [self.dict objectForKey:@"work_zip"]
                                         ];
        cell = addressCell;
        
    }
    
    else if([field isEqual:@"work_phone"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Work Phone:";
        singleCell.content.text = [self.dict objectForKey:@"work_phone"];
        cell=singleCell;
        
    }
    
    else if([field isEqual:@"work_email"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Work Email:";
        singleCell.content.text = [self.dict objectForKey:@"work_email"];
        cell=singleCell;
        
    }
    
    else if([field isEqual:@"area"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"League Area:";
        singleCell.content.text = [self.dict objectForKey:@"area"];
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
    
    else if([field isEqual:@"league_title"]){
        height = 57;
    }
        
    else if([field isEqual:@"work_address"]){
        height = 78;
    }
    
    else if([field isEqual:@"work_phone"]){
        height = 57;
        
    }
    
    else if([field isEqual:@"work_email"]){
        height = 57;
        
    }
    
    else if ([field isEqual:@"area"]){
        height = 57;
    }
    
    else {
        
    }
    return height;
}

@end
