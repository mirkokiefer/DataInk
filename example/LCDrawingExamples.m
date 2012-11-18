//
//  LCDrawingExamples.m
//  Wire
//
//  Created by Mirko on 8/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LCDrawingExamples.h"

@interface LCDrawingExamples()
- (void)initializeShapes;
@end

@implementation LCDrawingExamples
@synthesize rootPanel, rectangle;

+ (id)examples {
  return [[self alloc] init];
}

- (id)init {
    self = [super init];
    if (self) {
      [self initializeShapes];
    }
    
    return self;
}

- (void)initializeShapes {
  NSArray* data = [NSArray arrayWithObjects:oFloat(1.2), oFloat(2.5), oFloat(4.1), oFloat(2), oFloat(3.7),
                   oFloat(5), oFloat(2.4), nil];
  NSArray* ruleData = [NSArray arrayWithObjects:oFloat(0), oFloat(1), oFloat(2), oFloat(3), oFloat(4), oFloat(5), nil];
  NSArray* coordData = [NSArray arrayWithObjects: [LCPoint x:0 y:1.4], [LCPoint x:1 y:1.9],
                        [LCPoint x:3 y:2.4], [LCPoint x:4 y:5.1], [LCPoint x:2 y:7.2],
                        [LCPoint x:6 y:1.1], [LCPoint x:1 y:2.1], nil];
  
  DIPanel* aPanel = [DIPanel panel];
  
  LCRect* rectangleBounds = [LCRect x:40 y:10 width:400 height:400];
  DIRectangle* aRectangle = [self defineRectanglesInBounds:rectangleBounds];
  aRectangle.data = data;
  
  DILine* line = [self defineLineInBounds:rectangleBounds];
  line.data = data;
  
  DIRule* vertRule = [self defineVerticalRulesInBounds:rectangleBounds];
  vertRule.data = ruleData;
  [aRectangle add:vertRule];
  
  LCRect* dotBounds = [LCRect x:400 y:50 width:300 height:200];
  DIDot* dot = [self defineDotsInBounds:dotBounds];
  dot.data = coordData;
  DIRule* horizRule = [self defineHorizontalRulesInBounds:dotBounds];
  horizRule.data = ruleData;
  [dot add:horizRule];
  DILabel* label = [self defineLabelsInBounds:dotBounds];
  [dot add:label];
  
  LCRect* wedgeBounds = [LCRect x:100 y:400 width:300 height:300];
  NSArray* wedgeData = [NSArray arrayWithObjects:oFloat(60), oFloat(40), oFloat(100), oFloat(160), nil];
  DIWedge* wedge = [self defineWedgeWithData:wedgeData inBounds:wedgeBounds];
  
  LCRect* areaBounds = [LCRect x:400 y:400 width:300 height:200];
  DIArea* area = [self defineAreaWithData:coordData inBounds:areaBounds];
  
  [aPanel add:aRectangle];
  [aPanel add:line];
  [aPanel add:dot];
  [aPanel add:wedge];
  [aPanel add:area];
  self.rootPanel = aPanel;
  self.rectangle = aRectangle;
}

- (DIRectangle*)defineRectanglesInBounds:(LCRect *)bounds {
  DIRectangle* aRectangle = [DIRectangle rectangle];
  aRectangle.bounds = bounds;
  aRectangle.left = ^(id val, NSUInteger index) {
    return oFloat(index * 100 + 20);
  };
  aRectangle.bottom = ^(id val, NSUInteger index) {
    return oFloat(50);
  };
  aRectangle.height = ^(id val, NSUInteger index) {
    return oFloat(cFloat(val) * 100);
  };
  aRectangle.width = ^(id val, NSUInteger index) {
    return oFloat(80);
  };
  aRectangle.fillColour = ^(id val, NSUInteger index) {
    return [oBool(cFloat(val)>2.5) ifYes:^id(void) {
      return [LCColour green];
    } ifNo:^id(void) {
      return [LCColour blue];
    }];
  };
  aRectangle.strokeWidth = ^(id val, NSUInteger index) {
    return oFloat(1);
  };
  return aRectangle;
}

- (DIDot*)defineDotsInBounds:(LCRect *)bounds {
  DIDot* dot = [DIDot dot];
  dot.bounds = bounds;
  dot.left = ^(id val, NSUInteger index) {
    return oFloat(index*120);
  };
  dot.bottom = ^(id val, NSUInteger index) {
    return oFloat(((LCPoint*)val).x*150);
  };
  dot.size = ^(id val, NSUInteger index) {
    return oFloat(((LCPoint*)val).y*100);
  };
  dot.strokeWidth = ^(id val, NSUInteger index) {
    return oFloat(1);
  };
  dot.fillColour = ^(id val, NSUInteger index) {
    return [oBool(((LCPoint*)val).y > 5) ifYes:^id(void) {
      return [LCColour red];
    } ifNo:^id(void) {
      return [LCColour white];
    }];
  };
  return dot;
}

- (DILabel*)defineLabelsInBounds:(LCRect *)bounds {
  DILabel* label = [DILabel label];
  label.bounds = bounds;
  label.left = ^(id val, NSUInteger index) {
    return oFloat(index*120+80);
  };
  label.size = ^(id val, NSUInteger index) {
    return oFloat(50);
  };
  label.text = ^(id val, NSUInteger index) {
    return [oFloat(((LCPoint*)val).y) stringValue];
  };
  label.fillColour = ^(id val, NSUInteger index) {
    return [LCColour black];
  };
  label.transform = ^(id val, NSUInteger index) {
    return [LCAffineTransform rotate:30];
  };
  return label;
}

- (DILine*)defineLineInBounds:(LCRect *)bounds {
  DILine* line = [DILine line];
  line.bounds = bounds;
  line.left = ^(id val, NSUInteger index) {
    return oFloat(index * 100 + 20);
  };
  line.bottom = ^(id val, NSUInteger index) {
    return oFloat(cFloat(val) * 100 + 50);
  };
  line.strokeWidth = ^(id val, NSUInteger index) {
    return oFloat(2);
  };
  line.strokeColour = ^(id val, NSUInteger index) {
    return [LCColour black];
  };
  return line;
}

- (DIRule*)defineVerticalRulesInBounds:(LCRect *)bounds {
  DIRule* rule = [DIRule rule];
  rule.bounds = bounds;
  rule.left = ^(id val, NSUInteger index) {
    return oFloat(-20);
  };
  rule.bottom = ^(id val, NSUInteger index) {
    return oFloat(cFloat(val) * 100 + 50);
  };
  rule.width = ^(id val, NSUInteger index) {
    return oFloat(20);
  };
  
  DILabel* label = [DILabel label];
  label.left = ^(id val, NSUInteger index) {
    return oFloat(-50);
  };
  label.size = ^(id val, NSUInteger index) {
    return oFloat(40);
  };
  label.text = ^(id val, NSUInteger index) {
    return [val stringValue];
  };
  label.fillColour = ^(id val, NSUInteger index) {
    return [LCColour black];
  };
  [rule add:label];
  return rule;
}

- (DIRule*)defineHorizontalRulesInBounds:(LCRect *)bounds {
  DIRule* rule = [DIRule rule];
  rule.bounds = bounds;
  rule.left = ^(id val, NSUInteger index) {
    return oFloat(cFloat(val) * 200);
  };
  rule.bottom = ^(id val, NSUInteger index) {
    return oFloat(-20);
  };
  rule.height = ^(id val, NSUInteger index) {
    return oFloat(20);
  };
  
  DILabel* label = [DILabel label];
  //label.bounds = bounds;
  label.bottom = ^(id val, NSUInteger index) {
    return oFloat(-90);
  };
  label.size = ^(id val, NSUInteger index) {
    return oFloat(60);
  };
  label.text = ^(id val, NSUInteger index) {
    return [val stringValue];
  };
  label.fillColour = ^(id val, NSUInteger index) {
    return [LCColour black];
  };
  [rule add:label];
  return rule;
}

- (DIWedge*)defineWedgeWithData:(NSArray*)data inBounds:(LCRect *)bounds {
  DIWedge* wedge = [DIWedge wedge];
  wedge.bounds = bounds;
  wedge.data = data;
  wedge.left = ^(id val, NSUInteger index) {
    return oFloat(500);
  };
  wedge.bottom = ^(id val, NSUInteger index) {
    return oFloat(500);
  };
  wedge.angle = ^(id val, NSUInteger index) {
    return val;
  };
  wedge.radius = ^(id val, NSUInteger index) {
    return oFloat(1000);
  };
  wedge.fillColour = ^(id val, NSUInteger index) {
    NSArray* colours = [NSArray arrayWithObjects:[LCColour green], [LCColour red], [LCColour blue],
                        [LCColour white], [LCColour white], nil];
    return [colours objectAtIndex:index];
  };
  return wedge;
}

- (DIArea*)defineAreaWithData:(NSArray *)data inBounds:(LCRect *)bounds {
  DIArea* area = [DIArea area];
  area.bounds = bounds;
  area.data = data;
  area.left = ^(id val, NSUInteger index) {
    return oFloat(index * 120);
  };
  area.bottom = ^(id val, NSUInteger index) {
    LCPoint* point = (LCPoint*)val;
    return oFloat(point.x * 150);
  };
  area.height = ^(id val, NSUInteger index) {
    LCPoint* point = (LCPoint*)val;
    return oFloat(point.y * 70);
  };
  area.strokeWidth = ^(id val, NSUInteger index) {
    return oFloat(1);
  };
  area.fillColour = ^(id val, NSUInteger index) {
    return [LCColour white];
  };
  return area;
}

@end
