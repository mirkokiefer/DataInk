//
//  DIPanel.m
//  Wire
//
//  Created by Mirko on 7/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DIPanel.h"

@implementation DIPanel

+ (id)panel {
  return [[self alloc] initWithLayer:nil];
}

+ (id)panelWithLayer:(CALayer*)layer {
  return [[self alloc] initWithLayer:layer];
}

- (id)initWithLayer:(CALayer*)aLayer {
  self = [super init];
  if (self) {
    self.layer = aLayer;
  }
  
  return self;
}

- (NSArray*)shapes {
  return [NSArray array];
}


@end
