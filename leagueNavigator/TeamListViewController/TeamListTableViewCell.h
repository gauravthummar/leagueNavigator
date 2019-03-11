//
//  TeamListTableViewCell.h
//  leagueNavigator
//
//  Created by Gaurav Thummar on 2019-03-10.
//  Copyright © 2019 Gaurav Thummar. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface TeamListTableViewCell : UITableViewCell
{
    
}
+ (NSString *)reuseIdentifier;
@property (nonatomic, weak) IBOutlet UIImageView *logoImage;
@property (nonatomic, weak) IBOutlet UILabel *primaryColorLabel;
@property (nonatomic, weak) IBOutlet UILabel *countryNameLabel;
@end


