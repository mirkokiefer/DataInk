//
//  DIMark.m
//  Wire
//
//  Created by Mirko on 7/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataInk.h"

typedef NSNumber* (^AbsoluteBlock)(id each, NSUInteger index, LCRect* rect, NumberObjBlock block);


@interface DIMark()
@property(strong) CALayer* _layer;
@property(strong) NSMutableArray* _childMarks;
@property(strong) NSArray* shapeLayers;
@property(strong) NSArray* cachedShapes;
@end

@interface DIMark(Private)
- (NumberObjBlock)absoluteBlockForProperty:(SEL)property withBlock:(AbsoluteBlock)block;
- (void)applyGenericRenderingToShapes:(NSArray *)shapesArray;
- (NSArray*)layersForShapes:(NSArray*)shapesArray;
- (id)lookupMarkChainUsingSelector:(SEL)selector;
- (void)addPrivate:(DIMark*)childMark;
@end

@implementation DIMark
@synthesize data, left, bottom, width, height, transform, parentMark;
@synthesize strokeColour, fillColour, strokeWidth, fillStyle, strokeStyle;
@synthesize _layer, _childMarks, shapeLayers, cachedShapes;

- (id)init {
  self = [super init];
  if (self) {
    self._childMarks = [NSMutableArray array];
    self._layer = [CALayer layer];
    self.layer.needsDisplayOnBoundsChange = YES;
    self.layer.delegate = self;
    self.shapeLayers = [NSArray array];
  }
  
  return self;
}

- (CALayer*)layer {
  return self._layer;
}

- (void)add:(DIMark*)childMark {
  [self addPrivate:childMark];
  if(childMark.bounds.width == 0) {
    childMark.bounds = self.bounds;
  }
}

- (void)addPrivate:(DIMark *)childMark {
  [self._childMarks addObject:childMark];
  childMark.parentMark = self;
  [self._layer addSublayer:childMark.layer];
}

- (void)addShape:(DIMark*)childMark toAnchor:(SEL)anchor {
  [self addPrivate:childMark];
  LCRect* childBounds = childMark.bounds;
  childBounds.bottomLeft = [self.bounds performSelector:anchor];
  childMark.bounds = childBounds;
}

- (void)addTopLeft:(DIMark *)childMark {
  [self addShape:childMark toAnchor:@selector(topLeft)];
}

- (void)addTopRight:(DIMark *)childMark {
  [self addShape:childMark toAnchor:@selector(topRight)];
}

- (void)addBottomLeft:(DIMark *)childMark {
  [self addShape:childMark toAnchor:@selector(bottomLeft)];
}

- (void)addBottomRight:(DIMark *)childMark {
  [self addShape:childMark toAnchor:@selector(bottomRight)];
}

- (void)remove:(DIMark*)childMark {
  [self._childMarks removeObject:childMark];
  childMark.parentMark = nil;
  [childMark.layer removeFromSuperlayer];
}

- (void)removeFromParentMark {
  [self.parentMark remove:self];
}

- (NSArray*)childMarks {
  return [NSArray arrayWithArray: self._childMarks];
}

- (DIPanel*)parentPanel {
  //the root should always be a panel:
  if(self.parentPanel == nil) {
    return (DIPanel*)self;
  }
  //recurse the parentMarks up until finding a Panel:
  if([self.parentMark isKindOfClass:[DIPanel class]]) {
    return (DIPanel*)self.parentMark;
  } else {
    return self.parentPanel;
  }
}

- (void)render {
  [self.shapeLayers forEach:^(id each) {
    CALayer* eachLayer = each;
    [eachLayer removeFromSuperlayer];
    eachLayer.delegate = nil;
  }];
  self.cachedShapes = [self shapes];
  [self applyGenericRenderingToShapes:self.cachedShapes];
  self.shapeLayers = [self layersForShapes:self.cachedShapes];
  [shapeLayers forEach:^(id each) {
    [self.layer addSublayer:each];
    [each setNeedsDisplay];
  }];
  
  [self._childMarks forEach:^(id each) {
    DIMark* eachMark = (DIMark*)each;
    [eachMark render];
  }];
  [self.layer setNeedsDisplay];
}

- (void)setBounds:(LCRect *)bounds {
  LCRect* oldBounds = self.bounds;
  self.layer.bounds = bounds.cRect;
  self.layer.position = bounds.rectCenter.cPoint;
  [self.childMarks forEach:^(id each) {
    DIMark* eachShape = each;
    if(bounds.width == oldBounds.width) {
      eachShape.bounds = [eachShape.bounds offsetX:bounds.x-oldBounds.x y:bounds.y-oldBounds.y];      
    } else {
      eachShape.bounds = [eachShape.bounds scale:bounds.width/oldBounds.width];
    }
  }];
}

- (LCRect*)bounds {
  return [LCRect rect:self._layer.bounds];
}

- (id)dataComputed {
  return [self lookupMarkChainUsingSelector:@selector(data)];
}

- (NumberObjBlock)leftComputed {
  AbsoluteBlock absoluteBlock = ^(id val, NSUInteger index, LCRect* markBounds, NumberObjBlock relativeBlock) {
    return oFloat(markBounds.bottomLeft.x + (markBounds.width * cFloat(relativeBlock(val, index))/1000));
  };
  
  return [self absoluteBlockForProperty:@selector(left) withBlock:[absoluteBlock copy]];
}

- (NumberObjBlock)bottomComputed {
  AbsoluteBlock absoluteBlock = ^(id val, NSUInteger index, LCRect* markBounds, NumberObjBlock relativeBlock) {
    return oFloat(markBounds.bottomLeft.y + (markBounds.height * cFloat(relativeBlock(val, index))/1000));
  };
  
  return [self absoluteBlockForProperty:@selector(bottom) withBlock:[absoluteBlock copy]];
}

- (NumberObjBlock)widthComputed {  
  AbsoluteBlock absoluteBlock = ^(id val, NSUInteger index, LCRect* markBounds, NumberObjBlock relativeBlock) {
    return oFloat(markBounds.width * cFloat(relativeBlock(val, index))/1000);
  };
  
  return [self absoluteBlockForProperty:@selector(width) withBlock:[absoluteBlock copy]];
}

- (NumberObjBlock)heightComputed {
  AbsoluteBlock absoluteBlock = ^(id val, NSUInteger index, LCRect* markBounds, NumberObjBlock relativeBlock) {
    return oFloat(markBounds.height * cFloat(relativeBlock(val, index))/1000);
  };
  
  return [self absoluteBlockForProperty:@selector(height) withBlock:[absoluteBlock copy]];
}

- (TransformObjBlock)transformComputed {
  return [self lookupMarkChainUsingSelector:@selector(transform)];
}

- (ColourObjBlock)fillColourComputed {
  return [self lookupMarkChainUsingSelector:@selector(fillColour)];
}

- (ColourObjBlock)strokeColourComputed {
  return [self lookupMarkChainUsingSelector:@selector(strokeColour)];
}

- (StringObjBlock)fillStyleComputed {
  return [self lookupMarkChainUsingSelector:@selector(fillStyle)];
}

- (StringObjBlock)strokeStyleComputed {
  return [self lookupMarkChainUsingSelector:@selector(strokeStyle)];
}


- (NumberObjBlock)strokeWidthComputed {
  return [self lookupMarkChainUsingSelector:@selector(strokeWidth)];
}

@end

@implementation DIMark(CALayerDelegate)

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
  [self render];
}

@end

@implementation DIMark(Private)

- (NumberObjBlock)absoluteBlockForProperty:(SEL)property withBlock:(AbsoluteBlock)block {
  NumberObjBlock relativeBlock = [self lookupMarkChainUsingSelector:property];
  if(relativeBlock) {
    LCRect* markBounds = self.bounds;
    NumberObjBlock absoluteBlock = ^(id val, NSUInteger index) {
      return block(val, index, markBounds, relativeBlock);
    };
    return absoluteBlock;  
  } else {
    return nil;
  }
}

- (void)applyGenericRenderingToShapes:(NSArray *)shapesArray {
  [shapesArray forEachIndexed:^(id<LCShape> shape, NSUInteger index) {
    id dataVal = [self.data objectAtIndex:index];
    if(self.strokeColourComputed) {
      shape.strokeColour = self.strokeColourComputed(dataVal, index);
    }
    if(self.fillColourComputed) {
      shape.fillColour = self.fillColourComputed(dataVal, index);
    }
    if(self.strokeWidthComputed) {
      shape.strokeWidth = cFloat(self.strokeWidthComputed(dataVal, index));
    }
    if(self.fillStyleComputed) {
      NSString* fillSyle = self.fillStyleComputed(dataVal, index);
      if([fillSyle isEqualToString:@"fill"]) {
        [shape setDrawModeStrokeFill];
      } else {
        [shape setDrawModeStroke];
      }
    }
    if(self.transformComputed) {
      shape.transform = self.transformComputed(dataVal, index);
    }
  }];
}

- (NSArray*)layersForShapes:(NSArray*)shapesArray {
  NSArray* layers = [shapesArray collect:^(id<LCShape> each) {
    CALayer* shapeLayer = [CALayer layer];
    LCRect* boundingBox = [each boundingBox];
    shapeLayer.bounds = boundingBox.cRect;
    shapeLayer.position = boundingBox.rectCenter.cPoint;
    shapeLayer.delegate = each;
    return shapeLayer;
  }];
  return layers;
}

- (id)lookupMarkChainUsingSelector:(SEL)selector {
  id value = [self performSelector:selector];
  if(value) {
    return value;
  } else {
    if(self.parentMark && (self.data == nil)) {
      return [self.parentMark lookupMarkChainUsingSelector:selector];      
    } else {
      return nil;
    }
  }
}

@end