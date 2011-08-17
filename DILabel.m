//
//  DILabel.m
//  Wire
//
//  Created by Mirko on 7/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataInk.h"

@implementation DILabel
@synthesize text, size;

+ (id)label {
  return [[self alloc] init];
}

- (NumberObjBlock)sizeComputed {
  LCRect* markBounds = self.bounds;
  NumberObjBlock absoluteBlock = ^(id val, NSUInteger index) {
    return oFloat(markBounds.height * cFloat(self.size(val, index))/1000);
  };
  return [absoluteBlock copy];
}

@end

@implementation DILabel(Abstract)

- (NSArray*)shapes {  
  NSArray* dots = [self.dataComputed collectIndexed:^id(id each, NSUInteger index) {
    LCPoint* position = [LCPoint x:cFloat(self.leftComputed(each, index))
                                 y:cFloat(self.bottomComputed(each, index))];
    LCText* labelShape = [LCText text:self.text(each, index) position:position
                                 size:cFloat(self.sizeComputed(each, index))];
    return labelShape;
  }];
  
  return dots;
}
@end
