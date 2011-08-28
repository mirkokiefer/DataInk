//
//  LCTopLeftAnchor.m
//  Wire
//
//  Created by Mirko on 8/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DataInk.h"

@interface DITopLeft()
@end

@implementation DITopLeft

- (SEL)positionAsGetter {
  return @selector(topLeft);
}

- (SEL)positionAsSetter {
  return @selector(setTopLeft:);
}

- (DIAnchor *)opposite {
  return [DIBottomRight anchor];
}

@end
