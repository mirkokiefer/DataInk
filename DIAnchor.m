//
//  DIAnchor.m
//  Wire
//
//  Created by Mirko on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DIAnchor.h"

@interface DIAnchor()
@property(assign) SEL anchorForShape;
@end

@implementation DIAnchor
@synthesize anchorForShape;

+ (id)left {
  DIAnchor* newAnchor = [[self alloc] init];
  newAnchor.anchorForShape = @selector(leftAnchorForShape:);
  return newAnchor;
}

+ (id)top {
  DIAnchor* newAnchor = [[self alloc] init];
  newAnchor.anchorForShape = @selector(topAnchorForShape:);
  return newAnchor;
}

+ (id)right {
  DIAnchor* newAnchor = [[self alloc] init];
  newAnchor.anchorForShape = @selector(rightAnchorForShape:);
  return newAnchor;
}

+ (id)bottom {
  DIAnchor* newAnchor = [[self alloc] init];
  newAnchor.anchorForShape = @selector(bottomAnchorForShape:);
  return newAnchor;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
