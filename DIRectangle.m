//
//  DIRectangle.m
//  Wire
//
//  Created by Mirko on 7/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataInk.h"

@implementation DIRectangle

+ (id)rectangle {
  return [[self alloc] init];
}

@end

@implementation DIRectangle(Abstract)

- (NSArray*)shapes {
  NSArray* rectangles = [self.dataComputed collectIndexed:^id(id each, NSUInteger index) {
    LCRect* rectData = [LCRect x:cFloat(self.leftComputed(each, index))
                               y:cFloat(self.bottomComputed(each,index))
                           width:cFloat(self.widthComputed(each,index))
                          height:cFloat(self.heightComputed(each, index))];
    LCRectangle* rect = [LCRectangle rectangleWithRect:rectData];
    [rect setDrawModeStrokeFill];
    return rect;
  }];
  
  return rectangles;
}

@end