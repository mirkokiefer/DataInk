//
//  DIRule.m
//  Wire
//
//  Created by Mirko on 7/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataInk.h"

@implementation DIRule

+ (id)rule {
  return [[self alloc] init];
}

@end

@implementation DIRule(Abstract)

- (NSArray*)shapes {
  NSArray* lines;
  if(self.widthComputed) {
    lines = [self.dataComputed collectIndexed:^id(id each, NSUInteger index) {
      CGFloat leftVal = cFloat(self.leftComputed(each, index));
      CGFloat bottomVal = cFloat(self.bottomComputed(each, index));
      LCPoint* leftPoint = [LCPoint x:leftVal y:bottomVal];
      LCPoint* rightPoint = [LCPoint x:leftVal + cFloat(self.widthComputed(each, index)) 
                                    y:bottomVal];
      return [LCLine lineWithPoints:[NSArray arrayWithObjects:leftPoint, rightPoint, nil]];
    }];
  } else {
    lines = [self.dataComputed collectIndexed:^id(id each, NSUInteger index) {
      CGFloat leftVal = cFloat(self.leftComputed(each, index));
      CGFloat bottomVal = cFloat(self.bottomComputed(each, index));
      LCPoint* bottomPoint = [LCPoint x:leftVal y:bottomVal];
      LCPoint* topPoint = [LCPoint x:leftVal 
                                   y:bottomVal + cFloat(self.heightComputed(each, index))];
      return [LCLine lineWithPoints:[NSArray arrayWithObjects:bottomPoint, topPoint, nil]];
    }];
  }
  
  return lines;
}
@end