//
//  DIDot.h
//  Wire
//
//  Created by Mirko on 7/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DIShape.h"

@interface DIDot : DIShape
@property(readwrite, copy) NumberObjBlock size;

+ (id)dot;
@end
