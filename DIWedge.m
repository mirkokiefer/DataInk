//
//  DIWedge.m
//  Wire
//
//  Created by Mirko on 7/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataInk.h"

@implementation DIWedge
@synthesize startAngle, angle, radius;

+ (id)wedge {
  return [[self alloc] init];
}


- (NumberObjBlock)radiusComputed {
  CGFloat maxRadius;
  LCRect* boundsComputed = self.boundsComputed;
  if(boundsComputed.width > boundsComputed.height) {
    maxRadius = boundsComputed.height/2;
  } else {
    maxRadius = boundsComputed.width/2;
  }
  NumberObjBlock absoluteBlock = ^(id val, NSUInteger index) {
    return oFloat(maxRadius * cFloat(self.radius(val, index))/1000);
  };
  return absoluteBlock;
}
@end

@implementation DIWedge(Abstract)

- (NSArray*)shapes {
  NSArray* wedges;
  if(self.startAngle) {
    wedges = [self.dataComputed collectIndexed:^id(id each, NSUInteger index) {
      //calculate width on size property given as the dot area:
      LCPoint* center = [LCPoint x:cFloat(self.leftComputed(each, index)) 
                                 y:cFloat(self.bottomComputed(each, index))];
      LCWedge* wedge = [LCWedge center:center radius:cFloat(self.radiusComputed(each, index)) 
                            startAngle:cFloat(self.startAngle(each, index)) 
                                 angle: cFloat(self.angle(each, index))];
      [wedge setDrawModeStrokeFill];
      return wedge;
    }]; 
  } else {
    __block CGFloat currentAngle = 0;
    wedges = [self.dataComputed collectIndexed:^id(id each, NSUInteger index) {
      //calculate width on size property given as the dot area:
      CGFloat wedgeAngle = cFloat(self.angle(each, index));
      LCPoint* center = [LCPoint x:cFloat(self.leftComputed(each, index)) 
                                 y:cFloat(self.bottomComputed(each, index))];
      LCWedge* wedge = [LCWedge center:center radius:cFloat(self.radiusComputed(each, index)) 
                            startAngle:currentAngle angle: wedgeAngle];
      [wedge setDrawModeStrokeFill];
      currentAngle = currentAngle + wedgeAngle;
      return wedge;
    }]; 
  }

  
  return wedges;
}
@end
