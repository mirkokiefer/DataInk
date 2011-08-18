//
//  DILabel.h
//  Wire
//
//  Created by Mirko on 7/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DIShape.h"

@interface DILabel : DIShape
@property(readwrite, copy) StringObjBlock text;
@property(readwrite, copy) NumberObjBlock size;
@property(readonly) NumberObjBlock sizeComputed;

+ (id)label;
@end
