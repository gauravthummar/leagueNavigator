//
//  LeagueListViewController.m
//  leagueNavigator
//
//  Created by Gaurav Thummar on 2019-03-03.
//  Copyright © 2019 Gaurav Thummar. All rights reserved.
//

#import "LeagueListViewController.h"
#import "TeamListViewController.h"

@interface LeagueListViewController ()
@property NSMutableArray *leaguesObjects;
@end

@implementation LeagueListViewController
#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.TeamListViewController = (TeamListViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}


- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
    [self readResponseFromTheJson];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showTeamList"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.leaguesObjects[indexPath.row];
        TeamListViewController *controller = (TeamListViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}


#pragma mark - Table View Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.leaguesObjects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text  = [self.leaguesObjects[indexPath.row] valueForKey:@"full_name"];
    return cell;
}

#pragma mark - Read Response

- (void)readResponseFromTheJson
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"leagues" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *unSortLeaguesObjects  = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"full_name" ascending:YES];
    NSArray *sortLeaguesObjects = [unSortLeaguesObjects sortedArrayUsingDescriptors:@[sort]];
    self.leaguesObjects = [[NSMutableArray alloc]initWithArray:sortLeaguesObjects];
}
#pragma mark - Searchbar Delegate Method

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length == 0) {
        [self readResponseFromTheJson];
        [self.tableView reloadData];
    }else{
        NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"full_name contains[c] %@", searchText];
        NSPredicate *slugPredicate = [NSPredicate predicateWithFormat:@"slug contains[c] %@", searchText];
        NSPredicate *predicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[namePredicate, slugPredicate]];
        NSArray *sortLeaguesObjects = [self.leaguesObjects filteredArrayUsingPredicate:predicate];
        self.leaguesObjects = [[NSMutableArray alloc]initWithArray:sortLeaguesObjects];
        [self.tableView reloadData];
    }
}
@end
