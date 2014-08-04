//
//  CustomAnnotationView.m
//  CheckPOI
//
//  Created by Li Fei on 3/15/14.
//  Copyright (c) 2014 Li Fei. All rights reserved.
//

#import "CustomAnnotationView.h"

@implementation CustomAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    NSArray *subViews = self.subviews;
    if ([subViews count] > 0)
    {
        UIView *subview = [subViews objectAtIndex:0];
        if ([subview pointInside:[self convertPoint:point toView:subview] withEvent:event])
        {
            return YES;
        }
    }
    if (point.x > 0 && point.x < self.frame.size.width && point.y > 0 && point.y < 0 + self.frame.size.height)
    {
        return YES;
    }
    return NO;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
