//
//  DIShape.m
//  Wire
//
//  Created by Mirko on 7/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataInk.h"

typedef NSNumber* (^AbsoluteBlock)(id each, NSUInteger index, LCRect* rect, NumberObjBlock block);
typedef LCRect* (^RectBlock)(LCRect* rect);


@interface DIShape()
@property(strong) CALayer* _layer;
@property(strong) NSMutableArray* _childShapes;
@property(strong) NSArray* shapeLayers;
@property(strong) NSArray* cachedShapes;
@end

@interface DIShape(Private)
- (void)addPrivate:(DIShape*)childShape;
- (void)add:(DIShape*)childShape toAnchorSettingBounds:(RectBlock)block;
- (NumberObjBlock)absoluteBlockForProperty:(SEL)property withBlock:(AbsoluteBlock)block;
- (void)applyGenericRenderingToShapes:(NSArray *)shapesArray;
- (NSArray*)layersForShapes:(NSArray*)shapesArray;
- (id)lookupShapeChainUsingSelector:(SEL)selector;
@end

@implementation DIShape
@synthesize data, left, bottom, width, height, transform, parentShape, scale;
@synthesize strokeColour, fillColour, strokeWidth, fillStyle, strokeStyle;
@synthesize _layer, _childShapes, shapeLayers, cachedShapes;

- (id)init {
  self = [super init];
  if (self) {
    self._childShapes = [NSMutableArray array];
    self._layer = [CALayer layer];
    self.layer.needsDisplayOnBoundsChange = YES;
    self.layer.delegate = self;
    self.shapeLayers = [NSArray array];
    self.scale = YES;
  }
  
  return self;
}

- (CALayer*)layer {
  return self._layer;
}

- (void)add:(DIShape*)childShape {
  [self addPrivate:childShape];
  if(childShape.bounds.width == 0) {
    childShape.bounds = self.bounds;
  }
}

- (void)addTopLeft:(DIShape *)childShape {
  RectBlock setChildBounds = ^LCRect *(LCRect *childBounds) {
    childBounds.bottomRight = self.bounds.topLeft;
    return childBounds;
  };
  [self add:childShape toAnchorSettingBounds:[setChildBounds copy]];
}

- (void)addTopRight:(DIShape *)childShape {
  RectBlock setChildBounds = ^LCRect *(LCRect *childBounds) {
    childBounds.bottomLeft = self.bounds.topRight;
    return childBounds;
  };
  [self add:childShape toAnchorSettingBounds:[setChildBounds copy]];
}

- (void)addBottomLeft:(DIShape *)childShape {
  RectBlock setChildBounds = ^LCRect *(LCRect *childBounds) {
    childBounds.topRight = self.bounds.bottomLeft;
    return childBounds;
  };
  [self add:childShape toAnchorSettingBounds:[setChildBounds copy]];
}

- (void)addBottomRight:(DIShape *)childShape {
  RectBlock setChildBounds = ^LCRect *(LCRect *childBounds) {
    childBounds.topLeft = self.bounds.bottomRight;
    return childBounds;
  };
  [self add:childShape toAnchorSettingBounds:[setChildBounds copy]];
}

- (void)remove:(DIShape*)childShape {
  [self._childShapes removeObject:childShape];
  childShape.parentShape = nil;
  [childShape.layer removeFromSuperlayer];
}

- (void)removeFromParentShape {
  [self.parentShape remove:self];
}

- (NSArray*)childShapes {
  return [NSArray arrayWithArray: self._childShapes];
}

- (DIPanel*)parentPanel {
  //the root should always be a panel:
  if(self.parentPanel == nil) {
    return (DIPanel*)self;
  }
  //recurse the parentShapes up until finding a Panel:
  if([self.parentShape isKindOfClass:[DIPanel class]]) {
    return (DIPanel*)self.parentShape;
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
  
  [self._childShapes forEach:^(id each) {
    DIShape* eachShape = (DIShape*)each;
    [eachShape render];
  }];
  [self.layer setNeedsDisplay];
}

- (void)setBounds:(LCRect *)bounds {
  LCRect* oldBounds = self.bounds;
  self.layer.bounds = bounds.cRect;
  self.layer.position = bounds.rectCenter.cPoint;
  [self.childShapes forEach:^(id each) {
    DIShape* eachShape = each;
    if(bounds.width == oldBounds.width) {
      eachShape.bounds = [eachShape.bounds offsetX:bounds.x-oldBounds.x y:bounds.y-oldBounds.y];      
    } else {
      CGFloat scaleFactor = bounds.width/oldBounds.width;
      if(eachShape.scale) {
        eachShape.bounds = [eachShape.bounds scale:scaleFactor];        
      } else {
        eachShape.bounds = [eachShape.bounds offsetFactor:scaleFactor];
      }
    }
  }];
}

- (LCRect*)bounds {
  return [LCRect rect:self._layer.bounds];
}

- (id)dataComputed {
  return [self lookupShapeChainUsingSelector:@selector(data)];
}

- (NumberObjBlock)leftComputed {
  AbsoluteBlock absoluteBlock = ^(id val, NSUInteger index, LCRect* shapeBounds, NumberObjBlock relativeBlock) {
    return oFloat(shapeBounds.bottomLeft.x + (shapeBounds.width * cFloat(relativeBlock(val, index))/1000));
  };
  
  return [self absoluteBlockForProperty:@selector(left) withBlock:[absoluteBlock copy]];
}

- (NumberObjBlock)bottomComputed {
  AbsoluteBlock absoluteBlock = ^(id val, NSUInteger index, LCRect* shapeBounds, NumberObjBlock relativeBlock) {
    return oFloat(shapeBounds.bottomLeft.y + (shapeBounds.height * cFloat(relativeBlock(val, index))/1000));
  };
  
  return [self absoluteBlockForProperty:@selector(bottom) withBlock:[absoluteBlock copy]];
}

- (NumberObjBlock)widthComputed {  
  AbsoluteBlock absoluteBlock = ^(id val, NSUInteger index, LCRect* shapeBounds, NumberObjBlock relativeBlock) {
    return oFloat(shapeBounds.width * cFloat(relativeBlock(val, index))/1000);
  };
  
  return [self absoluteBlockForProperty:@selector(width) withBlock:[absoluteBlock copy]];
}

- (NumberObjBlock)heightComputed {
  AbsoluteBlock absoluteBlock = ^(id val, NSUInteger index, LCRect* shapeBounds, NumberObjBlock relativeBlock) {
    return oFloat(shapeBounds.height * cFloat(relativeBlock(val, index))/1000);
  };
  
  return [self absoluteBlockForProperty:@selector(height) withBlock:[absoluteBlock copy]];
}

- (TransformObjBlock)transformComputed {
  return [self lookupShapeChainUsingSelector:@selector(transform)];
}

- (ColourObjBlock)fillColourComputed {
  return [self lookupShapeChainUsingSelector:@selector(fillColour)];
}

- (ColourObjBlock)strokeColourComputed {
  return [self lookupShapeChainUsingSelector:@selector(strokeColour)];
}

- (StringObjBlock)fillStyleComputed {
  return [self lookupShapeChainUsingSelector:@selector(fillStyle)];
}

- (StringObjBlock)strokeStyleComputed {
  return [self lookupShapeChainUsingSelector:@selector(strokeStyle)];
}


- (NumberObjBlock)strokeWidthComputed {
  return [self lookupShapeChainUsingSelector:@selector(strokeWidth)];
}

@end

@implementation DIShape(CALayerDelegate)

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
  [self render];
}

@end

@implementation DIShape(Private)

- (void)addPrivate:(DIShape *)childShape {
  [self._childShapes addObject:childShape];
  childShape.parentShape = self;
  [self._layer addSublayer:childShape.layer];
}

- (void)add:(DIShape*)childShape toAnchorSettingBounds:(RectBlock)block {
  [self addPrivate:childShape];
  childShape.bounds = block(childShape.bounds);
}

- (NumberObjBlock)absoluteBlockForProperty:(SEL)property withBlock:(AbsoluteBlock)block {
  NumberObjBlock relativeBlock = [self lookupShapeChainUsingSelector:property];
  if(relativeBlock) {
    LCRect* shapeBounds = self.bounds;
    NumberObjBlock absoluteBlock = ^(id val, NSUInteger index) {
      return block(val, index, shapeBounds, relativeBlock);
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

- (id)lookupShapeChainUsingSelector:(SEL)selector {
  id value = [self performSelector:selector];
  if(value) {
    return value;
  } else {
    if(self.parentShape && (self.data == nil)) {
      return [self.parentShape lookupShapeChainUsingSelector:selector];      
    } else {
      return nil;
    }
  }
}

@end