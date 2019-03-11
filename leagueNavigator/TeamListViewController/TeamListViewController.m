//
//  TeamListViewController.m
//  leagueNavigator
//
//  Created by Gaurav Thummar on 2019-03-03.
//  Copyright © 2019 Gaurav Thummar. All rights reserved.
//

#import "TeamListViewController.h"

@interface TeamListViewController ()
@property NSMutableArray *teamObjects;
@end

@implementation TeamListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark - View Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
    [self readResponseFromTheJson];
}

#pragma mark - Table View

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  70.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.teamObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"TableCell";
    
    TeamListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TeamListTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    if(![self.teamObjects[indexPath.row] valueForKey:@"logo"] && ![self.teamObjects[indexPath.row] valueForKey:@"colour_1"]){
        cell.primaryColorLabel.hidden = true;
        cell.logoImage.hidden = true;
        cell.countryNameLabel.frame = CGRectMake( 25.0, cell.countryNameLabel.frame.origin.y, cell.countryNameLabel.frame.size.width, cell.countryNameLabel.frame.size.height);

    }
    else if([self.teamObjects[indexPath.row] valueForKey:@"logo"]){
        cell.primaryColorLabel.hidden = true;
        cell.logoImage.hidden = false;
        cell.countryNameLabel.frame = CGRectMake( 90.0, cell.countryNameLabel.frame.origin.y, cell.countryNameLabel.frame.size.width, cell.countryNameLabel.frame.size.height);
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [self.teamObjects[indexPath.row] valueForKey:@"logo"]]];
            if ( data == nil )
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.logoImage.image = [UIImage imageWithData: data];
            });
        });
        
    }else{
        cell.primaryColorLabel.hidden = false;
        cell.logoImage.hidden = true;
        cell.countryNameLabel.frame = CGRectMake( 90.0, cell.countryNameLabel.frame.origin.y, cell.countryNameLabel.frame.size.width, cell.countryNameLabel.frame.size.height);
        [cell.primaryColorLabel setBackgroundColor:[self colorFromHexString:[self.teamObjects[indexPath.row] valueForKey:@"colour_1"]] ];
    }
    cell.countryNameLabel.text = [self.teamObjects[indexPath.row] valueForKey:@"full_name"];
    return cell;
}
- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
#pragma mark - Read Response

- (void)readResponseFromTheJson
{
    NSString *path = [[NSBundle mainBundle] pathForResource:[self.detailItem valueForKey:@"slug"] ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *unSortLeaguesObjects  = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"full_name" ascending:YES];
    NSArray *sortLeaguesObjects = [unSortLeaguesObjects sortedArrayUsingDescriptors:@[sort]];
    self.teamObjects = [[NSMutableArray alloc]initWithArray:sortLeaguesObjects];
    NSLog(@"%@",self.teamObjects);
}
#pragma mark - Searchbar Delegate Method

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length == 0) {
        [self readResponseFromTheJson];
        [self.tableView reloadData];
    }else{
        NSPredicate *fullNamePredicate = [NSPredicate predicateWithFormat:@"full_name contains[c] %@", searchText];
        NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
        NSPredicate *locationPredicate = [NSPredicate predicateWithFormat:@"location contains[c] %@", searchText];
        NSPredicate *predicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[namePredicate, fullNamePredicate,locationPredicate]];
                NSArray *sortLeaguesObjects = [self.teamObjects filteredArrayUsingPredicate:predicate];
        self.teamObjects = [[NSMutableArray alloc]initWithArray:sortLeaguesObjects];
        [self.tableView reloadData];
    }
}
@end
