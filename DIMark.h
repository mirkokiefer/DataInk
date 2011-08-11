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
@property(retain) NSArray* data;
@property(readwrite, copy) NumberObjBlock left;
@property(readwrite, copy) NumberObjBlock bottom;
@property(readwrite, copy) NumberObjBlock width;
@property(readwrite, copy) NumberObjBlock height;
@property(readwrite, copy) TransformObjBlock transform;

@property(readwrite, copy) ColourObjBlock fillColour;
@property(readwrite, copy) ColourObjBlock strokeColour;
@property(readwrite, copy) NumberObjBlock strokeWidth;

@property(readonly) NSArray* dataComputed;
@property(readonly) NumberObjBlock leftComputed;
@property(readonly) NumberObjBlock bottomComputed;
@property(readonly) NumberObjBlock widthComputed;
@property(readonly) NumberObjBlock heightComputed;
@property(readonly) TransformObjBlock transformComputed;

@property(readonly) ColourObjBlock fillColourComputed;
@property(readonly) ColourObjBlock strokeColourComputed;
@property(readonly) NumberObjBlock strokeWidthComputed;

@property(readonly) NSArray* childMarks;
@property(retain) DIMark* parentMark;
@property(readonly) DIPanel* parentPanel;

@property(strong, readonly) CALayer* layer;
@property(retain) LCRect* bounds;
@property(readonly) LCRect* boundsComputed;

- (void)add:(DIMark*)childMark;
- (void)render;

- (LCPoint*)topAnchorForShape:(id<LCShape>)shape;
- (LCPoint*)leftAnchorForShape:(id<LCShape>)shape;
- (LCPoint*)rightAnchorForShape:(id<LCShape>)shape;
- (LCPoint*)bottomAnchorForShape:(id<LCShape>)shape;

@end

@interface DIMark(Abstract)
- (NSArray*)shapes;
- (void)setPositionsForShape:(id<LCShape>)shape inRect:(LCRect*)rect;
@end

@interface DIMark(CALayerDelegate)
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;
@end