//
//  AnnotationCellView.h
//  CheckPOI
//
//  Created by Li Fei on 4/8/14.
//  Copyright (c) 2014 Li Fei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnnotationCellView : UIView

@property (nonatomic , readonly) UILabel *mainLabel;

@property (nonatomic , readonly) UILabel *subLabel;


- (id)initWithFrame:(CGRect)frame Target:(id)target Selector:(SEL)selector;

@end
