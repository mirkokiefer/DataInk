//
//  DIWedge.h
//  Wire
//
//  Created by Mirko on 7/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DIShape.h"

@interface DIWedge : DIShape
@property(readwrite, copy) NumberObjBlock startAngle;
@property(readwrite, copy) NumberObjBlock angle;
@property(readwrite, copy) NumberObjBlock radius;
@property(readonly) NumberObjBlock radiusComputed;
+ (id)wedge;
@end
