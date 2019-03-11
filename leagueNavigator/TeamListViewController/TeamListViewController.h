//
//  TeamListViewController.h
//  leagueNavigator
//
//  Created by Gaurav Thummar on 2019-03-03.
//  Copyright © 2019 Gaurav Thummar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamListTableViewCell.h"
@interface TeamListViewController : UITableViewController<UISearchBarDelegate>
@property (strong, nonatomic) NSDate *detailItem;
@end

