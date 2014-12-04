//
//  StateAgencyViewController.m
//  ultc
//
//  Created by shallowsummer on 9/22/13.
//
//

#import "StateAgencyViewController.h"
#import "AppDelegate.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "WRUtilities.h"
#import "SingleLineTableViewCell.h"
#import "TitleTableViewCell.h"

@interface StateAgencyViewController ()

@property (nonatomic, strong) NSMutableDictionary * dict;
@property (nonatomic, strong) NSMutableArray * fieldOrder;

@end

@implementation StateAgencyViewController

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
    NSString * sqlString = [NSString stringWithFormat:@"SELECT * FROM state_agencies where id = %i", [self.itemId intValue]];
    FMResultSet * s = [ db executeQuery:sqlString];
    if([s next]){
        
        self.dict = [NSMutableDictionary dictionary];
        NSNumber * number = [NSNumber numberWithInt:[s intForColumn:@"id"]];
        [self.dict setObject:number forKey:@"id"];
        
        NSArray * textFields = @[@"name",
                                 @"phone",
                                 @"fax",
                                 @"toll_free",
                                 @"website",
                                 @"contact",
                                 @"email",
                                 @"local_government_affiliation"];
                                 
        
        
        for(NSString * field in textFields){
            
            NSString * value=[s stringForColumn:field];
            if(value!=nil)
                [self.dict setObject:value forKey:field];
        }

        if([self.dict objectForKey:@"name"]!=nil && ![[self.dict objectForKey:@"name"] isEqualToString:@""])
            [self.fieldOrder addObject:@"name"];

        if([self.dict objectForKey:@"phone"]!=nil && ![[self.dict objectForKey:@"phone"] isEqualToString:@""])
            [self.fieldOrder addObject:@"phone"];
        
        if([self.dict objectForKey:@"fax"]!=nil && ![[self.dict objectForKey:@"fax"] isEqualToString:@""])
            [self.fieldOrder addObject:@"fax"];

        if([self.dict objectForKey:@"toll_free"]!=nil && ![[self.dict objectForKey:@"toll_free"] isEqualToString:@""])
            [self.fieldOrder addObject:@"toll_free"];
        
        if([self.dict objectForKey:@"website"]!=nil && ![[self.dict objectForKey:@"website"] isEqualToString:@""])
            [self.fieldOrder addObject:@"website"];
        
        if([self.dict objectForKey:@"contact"]!=nil && ![[self.dict objectForKey:@"contact"] isEqualToString:@""])
            [self.fieldOrder addObject:@"contact"];
        
        if([self.dict objectForKey:@"email"]!=nil && ![[self.dict objectForKey:@"email"] isEqualToString:@""])
            [self.fieldOrder addObject:@"email"];
        
        if([self.dict objectForKey:@"local_government_affiliation"]!=nil && ![[self.dict objectForKey:@"local_government_affiliation"] isEqualToString:@""])
            [self.fieldOrder addObject:@"local_government_affiliation"];
        
        self.title = [self.dict objectForKey:@"name"];
    }
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
    
    else if ([field isEqual:@"phone"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Phone:";
        singleCell.content.text = [self.dict objectForKey:@"phone"];
        cell=singleCell;
    }
    
    else if ([field isEqual:@"fax"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Fax:";
        singleCell.content.text = [self.dict objectForKey:@"fax"];
        cell=singleCell;
    }
    
    else if ([field isEqual:@"toll_free"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Toll Free #:";
        singleCell.content.text = [self.dict objectForKey:@"toll_free"];
        cell=singleCell;
    }
    
    else if ([field isEqual:@"website"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"website:";
        singleCell.content.text = [self.dict objectForKey:@"website"];
        cell=singleCell;
    }
    
    else if ([field isEqual:@"contact"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Contact:";
        singleCell.content.text = [self.dict objectForKey:@"contact"];
        cell=singleCell;
    }
    
    else if ([field isEqual:@"email"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Email:";
        singleCell.content.text = [self.dict objectForKey:@"email"];
        cell=singleCell;
    }
    
    else if ([field isEqual:@"local_government_affiliation"]){
        SingleLineTableViewCell * singleCell = [WRUtilities getViewFromNib:@"SingleLineTableViewCell" class:[SingleLineTableViewCell class]];
        singleCell.title.text = @"Local Government Affiliation:";
        singleCell.content.text = [self.dict objectForKey:@"local_government_affiliation"];
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
    
    else if([field isEqual:@"phone"]){
        height = 57;
        
    }
    
    else if([field isEqual:@"fax"]){
     height = 57;
     
     }
     else if([field isEqual:@"toll_free"]){
     height = 57;
     
     }
     else if([field isEqual:@"website"]){
         height = 57;
         
     }
     else if([field isEqual:@"contact"]){
         height = 57;
         
     }
     else if([field isEqual:@"email"]){
         height = 57;
         
     }
     else if([field isEqual:@"local_government_affiliation"]){
         height = 57;
         
     }
    else {
        
    }
    
    
    return height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
