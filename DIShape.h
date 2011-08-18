//
//  DIShape.h
//  Wire
//
//  Created by Mirko on 7/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectiveGraphics.h"
#import "DataInkStructures.h"

@class DIPanel;



@interface DIShape : NSObject
@property(strong) NSArray* data;
@property(readwrite, copy) NumberObjBlock left;
@property(readwrite, copy) NumberObjBlock bottom;
@property(readwrite, copy) NumberObjBlock width;
@property(readwrite, copy) NumberObjBlock height;
@property(readwrite, copy) TransformObjBlock transform;

@property(readwrite, copy) ColourObjBlock fillColour;
@property(readwrite, copy) ColourObjBlock strokeColour;
@property(readwrite, copy) StringObjBlock fillStyle;
@property(readwrite, copy) StringObjBlock strokeStyle;
@property(readwrite, copy) NumberObjBlock strokeWidth;

@property(readonly) NSArray* dataComputed;
@property(readonly, copy) NumberObjBlock leftComputed;
@property(readonly, copy) NumberObjBlock bottomComputed;
@property(readonly, copy) NumberObjBlock widthComputed;
@property(readonly, copy) NumberObjBlock heightComputed;
@property(readonly, copy) TransformObjBlock transformComputed;

@property(readonly, copy) ColourObjBlock fillColourComputed;
@property(readonly, copy) ColourObjBlock strokeColourComputed;
@property(readonly, copy) StringObjBlock fillStyleComputed;
@property(readonly, copy) StringObjBlock strokeStyleComputed;
@property(readonly, copy) NumberObjBlock strokeWidthComputed;

@property(readonly) NSArray* childShapes;
@property(retain) DIShape* parentShape;
@property(readonly) DIPanel* parentPanel;

@property(strong, readonly) CALayer* layer;
@property(strong) LCRect* bounds;
@property(assign) BOOL scale;

- (void)add:(DIShape*)childShape;
- (void)addTopLeft:(DIShape*)childShape;
- (void)addTopRight:(DIShape*)childShape;
- (void)addBottomLeft:(DIShape*)childShape;
- (void)addBottomRight:(DIShape*)childShape;
- (void)remove:(DIShape*)childShape;
- (void)removeFromParentShape;
- (void)render;

@end

@interface DIShape(Abstract)
- (NSArray*)shapes;
- (void)setPositionsForShape:(id<LCShape>)shape inRect:(LCRect*)rect;
@end

@interface DIShape(CALayerDelegate)
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;
@end