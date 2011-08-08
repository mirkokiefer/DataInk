//
//  DIArea.m
//  Wire
//
//  Created by Mirko on 7/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataInk.h"

@implementation DIArea

+ (id)area {
  return [[self alloc] init];
}

@end

@implementation DIArea(Abstract)

- (NSArray*)shapes {
  NSArray* bottomPoints = [self.dataComputed collectIndexed:^id(id each, NSUInteger index) {
    return [LCPoint x:cFloat(self.leftComputed(each, index)) y:cFloat(self.bottomComputed(each, index))];    
  }];
  
  NSArray* topPoints = [self.dataComputed collectIndexed:^id(id each, NSUInteger index) {
    return [LCPoint x:cFloat(self.leftComputed(each, index)) 
                    y:cFloat(self.bottomComputed(each, index))+cFloat(self.heightComputed(each, index))];    
  }];
  
  LCArea* area = [LCArea areaWithTopPoints:topPoints bottomPoints:bottomPoints];
  [area setDrawModeStrokeFill];
  return [NSArray arrayWithObject:area];
}
@end