//
//  Post.h
//  ChaiOne
//
//  Created by prerna chavan on 20/01/15.
//  Copyright (c) 2015 Synerzip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

@interface Post : NSObject
@property (nonatomic,strong) NSString *info;
@property (nonatomic,strong) NSDate *createdDate;

@property (nonatomic,strong) Person *person;

-(instancetype)initWithAtrributes :(NSDictionary *)attributes;
@end
