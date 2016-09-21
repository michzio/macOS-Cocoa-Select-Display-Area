//
//  SelectionWindow.m
//  SelectionView
//
//  Created by Michal Ziobro on 20/09/2016.
//  Copyright © 2016 Michal Ziobro. All rights reserved.
//

#import "SelectionWindow.h"

@implementation SelectionWindow
- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSWindowStyleMask)windowStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)deferCreation
{
    self = [super initWithContentRect:contentRect
                            styleMask:windowStyle | NSNonactivatingPanelMask
                              backing:bufferingType
                                defer:deferCreation];
    
    if (self) {
        [self setOpaque:NO];
        [self setBackgroundColor:[NSColor clearColor]];
        [self setFloatingPanel:true];
        [self setLevel: NSScreenSaverWindowLevel];
        
        //[self setLevel: kCGMainMenuWindowLevelKey];
        [self setCollectionBehavior: NSWindowCollectionBehaviorCanJoinAllSpaces | NSWindowCollectionBehaviorFullScreenAuxiliary];
        [self setIgnoresMouseEvents:NO];
    }
    return self;
}

- (BOOL)canBecomeKeyWindow {
    return YES;
}

- (BOOL)canBecomeMainWindow {
    return YES;
}

@end
