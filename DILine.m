//
//  DILine.m
//  Wire
//
//  Created by Mirko on 7/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataInk.h"

@implementation DILine

+ (id)line {
  return [[self alloc] init];
}

@end

@implementation DILine(Abstract)

- (NSArray*)shapes {
  NSArray* points = [self.dataComputed collectIndexed:^id(id each, NSUInteger index) {
    return [LCPoint x:cFloat(self.leftComputed(each, index)) y:cFloat(self.bottomComputed(each, index))];    
  }];
  
  LCLine* line = [LCLine lineWithPoints:points];
  
  return [NSArray arrayWithObject:line];
}
@end