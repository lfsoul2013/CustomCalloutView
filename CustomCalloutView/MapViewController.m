//
//  MapViewController.m
//  CustomCalloutView
//
//  Created by Li Fei on 7/25/14.
//  Copyright (c) 2014 Li Fei. All rights reserved.
//

#import "MapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "CustomSMCalloutView.h"
#import "CustomAnnotationView.h"
#import "AnnotationCellView.h"

@interface MapViewController ()<MAMapViewDelegate , MAMapSMCalloutViewDelegate ,UITableViewDelegate , UITableViewDataSource>
{
    MAMapView           *_mapView;
    NSMutableArray      *_annotations;
    NSMutableArray      *_tableviewCellContens;
    MAMapSMCalloutView  *_customCalloutView;
    BOOL                 _poiSelected;
}

@end

@implementation MapViewController

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableviewCellContens count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"POIListCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:identifier];
    }
    cell.textLabel.text            = ((id<MAAnnotation>)[_tableviewCellContens objectAtIndex:indexPath.row]).title;
    cell.textLabel.textColor       = [UIColor whiteColor];
    cell.textLabel.shadowOffset    = CGSizeMake(0, -1);
    cell.textLabel.shadowColor     = [UIColor blackColor];
    cell.detailTextLabel.text      = ((id<MAAnnotation>)[_tableviewCellContens objectAtIndex:indexPath.row]).subtitle;
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.shadowOffset    = CGSizeMake(0, -1);
    cell.detailTextLabel.shadowColor     = [UIColor blackColor];
    cell.backgroundColor           = [UIColor clearColor];
    
    NSArray *subviews = cell.subviews;
    
    UIButton *selectBtn = nil;
    for (UIView *subview in subviews)
    {
        if ([subview isKindOfClass:[UIButton class]])
        {
            selectBtn = (UIButton *)subview;
        }
    }
    
    if (selectBtn)
    {
        selectBtn.tag = indexPath.row;
    }
    else
    {
        selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame     = cell.bounds;
        [selectBtn addTarget:self action:@selector(cellSelected:) forControlEvents:UIControlEventTouchUpInside];
        selectBtn.titleLabel.textAlignment   = UITextAlignmentLeft;
        selectBtn.titleLabel.lineBreakMode   = UILineBreakModeTailTruncation;
        selectBtn.backgroundColor            = [UIColor clearColor];
        selectBtn.tag                        = indexPath.row;
        [cell addSubview:selectBtn];
    }
    
    return cell;
}

#pragma mark - Btn Method

- (void) zoomlevelAdd
{
    [_mapView setZoomLevel:_mapView.zoomLevel + 1];
}

- (void) cellSelected:(id)sender
{
    _poiSelected = YES;

    id<MAAnnotation> annotation = [_tableviewCellContens objectAtIndex:((UIButton *)sender).tag];
    
    [_mapView selectAnnotation:annotation animated:YES];

}

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didTouchPois:(NSArray *)pois
{
    [_customCalloutView dismissCalloutAnimated:YES];
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    [_customCalloutView dismissCalloutAnimated:YES];
    [mapView deselectAnnotation:view.annotation animated:NO];
    if (_tableviewCellContens)
    {
        [_tableviewCellContens removeAllObjects];
    }
    else
    {
        _tableviewCellContens = [[NSMutableArray alloc] init];
    }
    
    CGPoint comparePoint = [_mapView convertCoordinate:view.annotation.coordinate toPointToView:_mapView];
    CGRect rect          = CGRectMake(comparePoint.x - 10, comparePoint.y - 10, 20, 20);
    for ( id<MAAnnotation> annotation in _mapView.annotations )
    {
        CGPoint point = [_mapView convertCoordinate:annotation.coordinate toPointToView:_mapView];
        
        if (CGRectContainsPoint(rect , point))
        {
            [_tableviewCellContens addObject:annotation];
        }
    }
    [_mapView setCenterCoordinate:view.annotation.coordinate animated:YES];

    _customCalloutView = [[MAMapSMCalloutView alloc] init];
    
    if (_poiSelected)
    {
        _poiSelected = NO;
        [_tableviewCellContens removeAllObjects];
    }
    
    
    //对于CustomCalloutView的使用方式，在rightAccessoryView中配置你需要的view（不过仔细阅读源码可以发现不仅是如此配置），并添加你所要添加的view的Class，最后调用presentCalloutFromRect 的方法实现自己指定样式CalloutView的样式，在此提供了两种Custom样式，UITableView和自定义的AnnotationCellView;
    if ([_tableviewCellContens count] > 1)
    {
        _customCalloutView.calloutHeight = 170;
        
        UITableView *poiListView    = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 260, 150)
                                                                   style:UITableViewStylePlain];
        poiListView.separatorColor  = [UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:1.0];
        poiListView.delegate        = self;
        poiListView.dataSource      = self;
        poiListView.backgroundColor = [UIColor clearColor];
        _customCalloutView.rightAccessoryView = poiListView;
        _customCalloutView.subviewClass       = [UITableView class];
        
        _customCalloutView.backgroundImage    = [UIImage imageNamed:@"map_bubble"];

        [_customCalloutView presentCalloutFromRect:CGRectMake(view.bounds.origin.x,
                                                              view.bounds.origin.y,
                                                              view.bounds.size.width,
                                                              100)
                                            inView:view
                                 constrainedToView:self.view
                          permittedArrowDirections:MAMapSMCalloutArrowDirectionDown
                                          animated:YES];
    }
    else
    {
        AnnotationCellView *annotationCellView = [[AnnotationCellView alloc] initWithFrame:CGRectMake(5, 0, 260, 50)
                                                                                    Target:self
                                                                                  Selector:@selector(zoomlevelAdd)];
        annotationCellView.mainLabel.text     = view.annotation.title;
        annotationCellView.subLabel.text      = view.annotation.subtitle;
        _customCalloutView.rightAccessoryView = annotationCellView;
        _customCalloutView.calloutHeight      = 70;
        _customCalloutView.subviewClass       = [annotationCellView class];
        _customCalloutView.backgroundImage    = [UIImage imageNamed:@"map_bubble"];
        
        [_customCalloutView presentCalloutFromRect:CGRectMake(view.bounds.origin.x,
                                                              view.bounds.origin.y,
                                                              view.bounds.size.width,
                                                              100)
                                             inView:view
                                  constrainedToView:self.view
                           permittedArrowDirections:MAMapSMCalloutArrowDirectionDown
                                           animated:YES];

    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    CustomAnnotationView *annotationview = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"PinAnnotationsIdentifier"];
    
    if (annotationview == nil)
    {
        annotationview = [[CustomAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:@"PinAnnotationsIdentifier"];
    }
    annotationview.canShowCallout = YES;
    annotationview.image          = [UIImage imageNamed:@"poi_yellow"];
    return annotationview;
}

#pragma mark - INIT

- (void)addAnnotations
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Annotations"  ofType:@"plist"];
    
    NSArray *annotionsArray = [NSArray arrayWithContentsOfFile:path];
    
    for (int i = 0 ; i < 50; i++)
    {
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        NSNumber *latNum = [annotionsArray objectAtIndex:i*2];
        NSNumber *lngNum = [annotionsArray objectAtIndex:i*2 + 1];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(latNum.floatValue,
                                                                lngNum.floatValue);
        pointAnnotation.title      = @"CustomCallout";
        pointAnnotation.subtitle   = [NSString stringWithFormat:@"CustomCalloutSubtitle%d",i];
        
        [_annotations addObject:pointAnnotation];
    }
    
    [_mapView addAnnotations:_annotations];
    [_mapView showAnnotations:_annotations animated:YES];
}

- (void)initMapView
{
    _mapView                     = [[MAMapView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _mapView.delegate            = self;
    _mapView.touchPOIEnabled     = YES;
    self.view                    = _mapView;
}

#pragma mark - Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title    = @"CustomCalloutView";
        _tableviewCellContens = [[NSMutableArray alloc] init];
        _annotations  = [[NSMutableArray alloc] init];

        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initMapView];
    
    [self addAnnotations];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
