//
//  LCTopRightAnchor.m
//  Wire
//
//  Created by Mirko on 8/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DataInk.h"

@implementation DITopRight

- (SEL)positionAsGetter {
  return @selector(topRight);
}

- (SEL)positionAsSetter {
  return @selector(setTopRight:);
}

- (DIAnchor *)opposite {
  return [DIBottomLeft anchor];
}

@end
