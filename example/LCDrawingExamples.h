//
//  LCDrawingExamples.h
//  Wire
//
//  Created by Mirko on 8/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataInk.h"

@interface LCDrawingExamples : NSObject
@property(strong) DIPanel* rootPanel;
@property(strong) DIRectangle* rectangle;

+ (id)examples;
- (id)init;
- (DIRectangle*)defineRectanglesInBounds:(LCRect*)bounds;
- (DIDot*)defineDotsInBounds:(LCRect*)bounds;
- (DILabel*)defineLabelsInBounds:(LCRect*)bounds;
- (DILine*)defineLineInBounds:(LCRect*)bounds;
- (DIRule*)defineVerticalRulesInBounds:(LCRect*)bounds;
- (DIRule*)defineHorizontalRulesInBounds:(LCRect*)bounds;
- (DIWedge*)defineWedgeWithData:(NSArray*)data inBounds:(LCRect*)bounds;
- (DIArea*)defineAreaWithData:(NSArray*)data inBounds:(LCRect*)bounds;
@end
