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

+ (id)rectangle:(LCRectangle *)aRectangle {
  DIRectangle* newObj = [self rectangle];
  LCRect* bounds = aRectangle.rect;
  newObj.bounds = bounds;
  newObj.data = [NSArray arrayWithObjects:[NSNull null], nil];
  newObj.left = ^(id val, NSUInteger index) {
    return oFloat(0);
  };
  newObj.bottom = ^(id val, NSUInteger index) {
    return oFloat(0);
  };
  newObj.height = ^(id val, NSUInteger index) {
    return oFloat(1000);
  };
  newObj.width = ^(id val, NSUInteger index) {
    return oFloat(1000);
  };
  newObj.strokeColour = ^(id val, NSUInteger index) {
    return aRectangle.strokeColour;
  };
  newObj.fillColour = ^(id val, NSUInteger index) {
    return aRectangle.fillColour;
  };
  newObj.strokeWidth = ^(id val, NSUInteger index) {
    return oFloat(aRectangle.strokeWidth);
  };
  newObj.fillStyle = ^(id val, NSUInteger index) {
    return @"stroke";
  };
  return newObj;
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