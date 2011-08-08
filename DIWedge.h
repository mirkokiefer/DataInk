//
//  DIWedge.h
//  Wire
//
//  Created by Mirko on 7/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DIMark.h"

@interface DIWedge : DIMark
@property(readwrite, copy) NumberObjBlock startAngle;
@property(readwrite, copy) NumberObjBlock angle;
@property(readwrite, copy) NumberObjBlock radius;
@property(readonly) NumberObjBlock radiusComputed;
+ (id)wedge;
@end
