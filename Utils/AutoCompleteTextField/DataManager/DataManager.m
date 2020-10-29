//
//  DataManager.m
//  NHAutoCompleteTextBox
//
//  Created by Shahan on 14/12/2014.
//  Copyright (c) 2014 Shahan. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

@synthesize dataSource;

-(id)fetchDataSynchronously
{
    // Run Asynchronous request to fetch results    
    dataSource = [[NSUserDefaults standardUserDefaults] objectForKey:@"history"];
     return dataSource;
}

+ (void) addAddressToHistory:(NSString*)address
{
    @try {
        NSUserDefaults* userDf = [NSUserDefaults standardUserDefaults];
        NSMutableArray* historyAddress = [[userDf objectForKey:@"history"] mutableCopy];
        if(!historyAddress)
        {
            historyAddress = [NSMutableArray new];
        }
        BOOL flag = FALSE;
        for (NSString* item in historyAddress)
        {
            if([item isEqualToString:address])
            {
                flag = TRUE;
                break;
            }
        }
        if(!flag)
        {
            [historyAddress addObject:address];
            [userDf setObject:historyAddress forKey:@"history"];
        }
        [userDf synchronize];
    }
    @catch (NSException *exception) {
        NSLog(@"exception::%@", exception);
    }
    @finally {
        
    }
    
}

@end
