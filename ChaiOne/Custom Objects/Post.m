//
//  Post.m
//  ChaiOne
//
//  Created by prerna chavan on 20/01/15.
//  Copyright (c) 2015 Synerzip. All rights reserved.
//

#import "Post.h"

@implementation Post


-(instancetype)initWithAtrributes:(NSDictionary *) attributes
{
    self = [super init];
    if(self)
    {
        // Convert string to date format and then save (Since we will be needing NSDate format for sorting the list and not the NSString format)
        
        self.createdDate = [self convertStringToDate:[attributes objectForKey:@"created_at"]];
        self.info = [attributes objectForKey:@"text"];
        
        self.person = [[Person alloc] initWithAtrributes:[attributes objectForKey:@"user"]];
    }

   
    return self;
}


-(NSDate *)convertStringToDate:(NSString *) dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss'Z'"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:dateString];
    
    return dateFromString;
}


@end
