//
//  Person.h
//  ChaiOne
//
//  Created by prerna chavan on 19/01/15.
//  Copyright (c) 2015 Synerzip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *imageURL;

-(instancetype)initWithAtrributes :(NSDictionary *)attributes;

@end
