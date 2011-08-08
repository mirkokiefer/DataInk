//
//  DataInkStructures.h
//  Wire
//
//  Created by Mirko on 8/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSNumber* (^NumberObjBlock)(id each, NSUInteger index);
typedef LCColour* (^ColourObjBlock)(id each, NSUInteger index);
typedef LCAffineTransform* (^TransformObjBlock)(id each, NSUInteger index);
typedef NSString* (^StringObjBlock)(id each, NSUInteger index);