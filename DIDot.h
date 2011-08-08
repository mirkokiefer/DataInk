//
//  DIDot.h
//  Wire
//
//  Created by Mirko on 7/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DIMark.h"

@interface DIDot : DIMark
@property(readwrite, copy) NumberObjBlock size;

+ (id)dot;
@end
