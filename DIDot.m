//
//  DIDot.m
//  Wire
//
//  Created by Mirko on 7/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataInk.h"

@implementation DIDot
@synthesize size;

+ (id)dot {
  return [[self alloc] init];
}

@end

@implementation DIDot(Abstract)

- (NSArray*)shapes {  
  NSArray* dots = [self.dataComputed collectIndexed:^id(id each, NSUInteger index) {
    //calculate width on size property given as the dot area:
    CGFloat width = 2*sqrt(cFloat(self.size(each,index)))/sqrt(pi);
    LCRect* dotData = [LCRect x:cFloat(self.leftComputed(each, index))
                               y:cFloat(self.bottomComputed(each,index))
                           width:width
                          height:width];
    LCEllipse* dotShape = [LCEllipse ellipseWithRect:dotData];
    [dotShape setDrawModeStrokeFill];
    return dotShape;
  }];
  
  return dots;
}
@end
