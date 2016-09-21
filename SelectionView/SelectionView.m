//
//  SelectionView.m
//  SelectionView
//
//  Created by Michal Ziobro on 19/09/2016.
//  Copyright © 2016 Michal Ziobro. All rights reserved.
//
#import <AppKit/AppKit.h>
#import "SelectionView.h"

@implementation SelectionView

NSCursor *crosshairCursor;
NSTrackingArea *trackingArea;
NSView *mousePositionSubview;
NSTextField *mouseXPosLabel;
NSTextField *mouseYPosLabel;

- (void)awakeFromNib {
    
   /* __weak SelectionView *weakSelf = self;
    areaSelectionCursorImage = [NSImage imageWithSize: NSMakeSize(40.0, 40.0)
                                 flipped:YES
                          drawingHandler:^BOOL(NSRect dstRect) {
                              
                              NSLog(@"Drawing curosr image.\n");
                              [crosshairCursorImage drawInRect: CGRectMake(0.0, 0.0, 20.0, 20.0)];
                              
                              NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
                              textStyle.alignment = NSTextAlignmentLeft;
                              NSDictionary* textFontAttributes = @{NSFontAttributeName: [NSFont fontWithName: @"Helvetica" size: 10], NSForegroundColorAttributeName: [NSColor darkGrayColor], NSParagraphStyleAttributeName: textStyle};
                              
                              NSString *xMousePos = [NSString stringWithFormat:@"%d", (int) weakSelf.mousePosition.x];
                              NSString *yMousePos = [NSString stringWithFormat:@"%d", (int) (weakSelf.bounds.size.height - weakSelf.mousePosition.y)];
                              
                              [xMousePos drawInRect: CGRectMake(15.0, 10.0, 25.0, 20.0) withAttributes: textFontAttributes];
                              [yMousePos drawInRect: CGRectMake(15.0, 20.0, 25.0, 20.0) withAttributes: textFontAttributes];
                              
                              return YES;
                          }];
    */
    NSImage *crosshairCursorImage = [NSImage imageNamed:@"crosshairCursorBig.png"];
    [crosshairCursorImage setSize:NSMakeSize(24.0f, 24.0f)];
    crosshairCursor = [[NSCursor alloc] initWithImage: crosshairCursorImage
                                                  hotSpot: NSMakePoint(12.0f,12.0f)];
    
    trackingArea = [[NSTrackingArea alloc] initWithRect: [self bounds]
                                                options: (NSTrackingMouseEnteredAndExited |NSTrackingMouseMoved | NSTrackingActiveAlways)
                                                  owner:self
                                               userInfo:nil];
    
    [self addTrackingArea: trackingArea];
    [[self window] setAcceptsMouseMovedEvents:YES];
    [[self window] makeFirstResponder:self];
    
    for (NSView *subview in self.subviews) {
        if([subview.identifier isEqualToString: @"mousePositionView"])
            mousePositionSubview = subview;
    }
    
    if(mousePositionSubview != nil) {
        for(NSView *subview in mousePositionSubview.subviews) {
            if([subview.identifier isEqualToString:@"mouseXPosLabel"]) {
                mouseXPosLabel = (NSTextField *) subview;
            } else if([subview.identifier isEqualToString:@"mouseYPosLabel"]) {
                mouseYPosLabel = (NSTextField *) subview;
            }
        }
    }
}

- (void)resetCursorRects
{
    [super resetCursorRects];
    [self discardCursorRects];
    [self addCursorRect: self.bounds cursor: crosshairCursor];
}


#pragma mark Mouse Events

- (void)mouseEntered:(NSEvent *)theEvent {
    self.mousePosition = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    
    [self setNeedsDisplayInRect: self.bounds];
    [self displayIfNeeded];
}

- (void)mouseMoved:(NSEvent *)theEvent {
    self.mousePosition = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    
    [self updateMousePositionView];
    
    [self setNeedsDisplayInRect:self.bounds];
    [self displayIfNeeded];
    
    
}

- (void)mouseExited:(NSEvent *)theEvent {
    [self setNeedsDisplayInRect:self.bounds];
    [self displayIfNeeded];
}

- (void) updateMousePositionView {
    
    [mousePositionSubview setFrameOrigin: NSMakePoint(self.mousePosition.x + 4.0f, self.mousePosition.y - 28.0f)];
    [mouseXPosLabel setStringValue: [NSString stringWithFormat:@"%d", (int) self.mousePosition.x] ];
    [mouseYPosLabel setStringValue: [NSString stringWithFormat:@"%d", (int) (self.bounds.size.height -self.mousePosition.y)] ];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    self.startPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    
    // create and configure shape layer
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.lineWidth = 1.0;
    self.shapeLayer.strokeColor = [[NSColor whiteColor] CGColor];
    self.shapeLayer.fillColor = [[NSColor colorWithHue:0.0f
                                            saturation:0.0f
                                            brightness:0.0f
                                                 alpha:0.1f] CGColor];
    //self.shapeLayer.lineDashPattern = @[@10, @5];
    [self.layer addSublayer:self.shapeLayer];
    
    // create animation for the layer
    /*
    CABasicAnimation *dashAnimation;
    dashAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
    [dashAnimation setFromValue:@0.0f];
    [dashAnimation setToValue:@15.0f];
    [dashAnimation setDuration:0.75f];
    [dashAnimation setRepeatCount:HUGE_VALF];
    [self.shapeLayer addAnimation:dashAnimation forKey:@"linePhase"];
    */
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    
   // create path for the shape layer
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.startPoint.x, self.startPoint.y);
    CGPathAddLineToPoint(path, NULL, self.startPoint.x, point.y);
    CGPathAddLineToPoint(path, NULL, point.x, point.y);
    CGPathAddLineToPoint(path, NULL, point.x, self.startPoint.y);
    CGPathCloseSubpath(path);
    
    // set the shape layer's path
    self.shapeLayer.path = path;
    CGPathRelease(path);
    
    self.mousePosition = point;
    [self updateMousePositionView];
}

- (void)mouseUp:(NSEvent *)theEvent
{
    self.endPoint = [self convertPoint: [theEvent locationInWindow] fromView: nil];
    
   [self.shapeLayer removeFromSuperlayer];
    self.shapeLayer = nil;
    
    int x = MIN(self.startPoint.x, self.endPoint.x);
    int y = MIN(self.startPoint.y, self.endPoint.y);
    int w = ABS(self.startPoint.x-self.endPoint.x);
    int h = ABS(self.startPoint.y-self.endPoint.y);
    
    // returning output with start point and end point of rectangle
    printf("x=%d,y=%d,w=%d,h=%d\n", x,y,w,h);
    [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}

@end
