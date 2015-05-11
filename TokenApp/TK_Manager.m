//
//  TK_Manager.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 3/26/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "TK_Manager.h"

@implementation TK_Manager

-(NSArray *)loadArrayOfContent:(NSMutableArray *)photos arrayOfVideos:(NSMutableArray *)videos arrayOfLinks:(NSMutableArray *)links
{
    NSArray *arrayOfContent = [NSMutableArray new];
    arrayOfContent = [NSArray arrayWithArray:[photos arrayByAddingObjectsFromArray:videos]];
    arrayOfContent = [arrayOfContent arrayByAddingObjectsFromArray:links];

    //    NSSortDescriptor *sortDescriptor;
    //    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt"
    //                                                 ascending:YES];
    //    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    //    NSArray *sortedArray;
    //    sortedArray = [arrayOfContent sortedArrayUsingDescriptors:sortDescriptors];

    return arrayOfContent;
}

@end
