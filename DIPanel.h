//
//  DIPanel.h
//  Wire
//
//  Created by Mirko on 7/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "DIMark.h"

@interface DIPanel : DIMark
+ (id)panel;
+ (id)panelWithLayer:(CALayer*)layer;
- (id)initWithLayer:(CALayer*)layer;
@end
