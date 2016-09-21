//
//  SelectionView.h
//  SelectionView
//
//  Created by Michal Ziobro on 19/09/2016.
//  Copyright © 2016 Michal Ziobro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

#ifndef SelectionView_h
#define SelectionView_h

@interface SelectionView : NSView

@property (nonatomic) NSPoint startPoint;
@property (nonatomic) NSPoint endPoint;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic) NSPoint mousePosition;

@end

#endif /* SelectionView_h */
