//
//  DIAnchor.h
//  Wire
//
//  Created by Mirko on 8/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ObjectiveGraphics.h"

@class DIShape;

@interface DIAnchor : NSObject
@property(readonly) SEL positionAsGetter;
@property(readonly) SEL positionAsSetter;
@property(readonly) DIAnchor* opposite;

- (LCPoint *)pointOn:(LCRect*)rect;
- (LCRect *)setPointOn:(LCRect*)rect to:(LCPoint*)point;
@end

@interface DIAnchor(Abstract)
+ (id)anchor;
- (LCPoint *)pointOn:(LCRect *)rect;
- (LCRect *)position:(LCRect *)rect in:(LCRect*)parentRect;
@end