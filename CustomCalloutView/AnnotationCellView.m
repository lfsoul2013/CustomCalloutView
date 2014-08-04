//
//  AnnotationCellView.m
//  CheckPOI
//
//  Created by Li Fei on 4/8/14.
//  Copyright (c) 2014 Li Fei. All rights reserved.
//

#import "AnnotationCellView.h"


@interface AnnotationCellView ()
{
    
}

@end

@implementation AnnotationCellView
{
    UIImageView *_svRect;
}
@synthesize mainLabel       = _mainLabel;

@synthesize subLabel        = _subLabel;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _mainLabel                 = [[UILabel alloc] init];
        _mainLabel.backgroundColor = [UIColor clearColor];
        _mainLabel.textColor       = [UIColor whiteColor];
        _mainLabel.font            = [UIFont systemFontOfSize:15];
        _mainLabel.shadowOffset    = CGSizeMake(0, -1);
        _mainLabel.shadowColor     = [UIColor blackColor];
        _mainLabel.frame           = CGRectMake(0, 0, frame.size.width, frame.size.height/2);
        [self addSubview:_mainLabel];
        
        _subLabel                 = [[UILabel alloc] init];
        _subLabel.backgroundColor = [UIColor clearColor];
        _subLabel.textColor       = [UIColor whiteColor];
        _subLabel.font            = [UIFont systemFontOfSize:13];
        _subLabel.shadowOffset    = CGSizeMake(0, -1);
        _subLabel.shadowColor     = [UIColor blackColor];
        _subLabel.frame           = CGRectMake(0, frame.size.height/2, frame.size.width, frame.size.height/2);
        
        [self addSubview:_subLabel];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame Target:(id)target Selector:(SEL)selector
{
    self = [self initWithFrame:frame];
    if (self)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
        btn.frame = CGRectMake(frame.size.width - 30 , 10 , 30, 30);
        [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
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
