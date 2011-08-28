//
//  LCBottomLeftAnchor.m
//  Wire
//
//  Created by Mirko on 8/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DataInk.h"

@implementation DIBottomLeft

- (SEL)positionAsGetter {
  return @selector(bottomLeft);
}

- (SEL)positionAsSetter {
  return @selector(setBottomLeft:);
}

- (DIAnchor *)opposite {
  return [DITopRight anchor];
}

@end
