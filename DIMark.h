//
//  DIMark.h
//  Wire
//
//  Created by Mirko on 7/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectiveGraphics.h"
#import "DataInkStructures.h"

@class DIPanel;



@interface DIMark : NSObject
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

@property(readonly) NSArray* childMarks;
@property(retain) DIMark* parentMark;
@property(readonly) DIPanel* parentPanel;

@property(strong, readonly) CALayer* layer;
@property(strong) LCRect* bounds;

- (void)add:(DIMark*)childMark;
- (void)addTopLeft:(DIMark*)childMark;
- (void)addTopRight:(DIMark*)childMark;
- (void)addBottomLeft:(DIMark*)childMark;
- (void)addBottomRight:(DIMark*)childMark;
- (void)remove:(DIMark*)childMark;
- (void)removeFromParentMark;
- (void)render;

@end

@interface DIMark(Abstract)
- (NSArray*)shapes;
- (void)setPositionsForShape:(id<LCShape>)shape inRect:(LCRect*)rect;
@end

@interface DIMark(CALayerDelegate)
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;
@end