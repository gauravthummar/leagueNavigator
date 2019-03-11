//
//  TeamListTableViewCell.m
//  leagueNavigator
//
//  Created by Gaurav Thummar on 2019-03-10.
//  Copyright © 2019 Gaurav Thummar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeamListTableViewCell.h"
@implementation TeamListTableViewCell

@synthesize logoImage = _logoImage;
@synthesize primaryColorLabel = _primaryColorLabel;
@synthesize countryNameLabel = _countryNameLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

+ (NSString *)reuseIdentifier {
    return @"TableCell";
}
@end
