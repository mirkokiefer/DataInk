//
//  DILabel.h
//  Wire
//
//  Created by Mirko on 7/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DIMark.h"

@interface DILabel : DIMark
@property(readwrite, copy) StringObjBlock text;
@property(readwrite, copy) NumberObjBlock size;
@property(readonly) NumberObjBlock sizeComputed;

+ (id)label;
@end
