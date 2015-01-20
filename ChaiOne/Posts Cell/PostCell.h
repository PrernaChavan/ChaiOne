//
//  CustomCell.h
//  ChaiOne
//
//  Created by prerna chavan on 19/01/15.
//  Copyright (c) 2015 Synerzip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
#import "Post.h"

@interface PostCell : UITableViewCell

@property (nonatomic,strong) Post *post;

+ (CGFloat)heightForCellForPost:(Post *)post ;
@end
