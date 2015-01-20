//
//  Person.m
//  ChaiOne
//
//  Created by prerna chavan on 19/01/15.
//  Copyright (c) 2015 Synerzip. All rights reserved.
//

#import "Person.h"

@implementation Person

-(instancetype)initWithAtrributes :(NSDictionary *)attributes
{
    self = [super init];
    if(self)
    {
        self.name = [attributes objectForKey:@"username"];
        NSDictionary *imageDictionary = [attributes objectForKey:@"avatar_image"];
        self.imageURL = [imageDictionary objectForKey:@"url"];
    }

    return self;
}

@end
