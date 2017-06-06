//
//  ViewController.m
//  SmartGo
//
//  Created by Devl on 2017/5/24.
//  Copyright © 2017年 Devl. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>

@interface ViewController () <BMKMapViewDelegate, BMKLocationServiceDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKLocationService *locService;

@property (nonatomic, strong) BMKPointAnnotation *tmpAnnotation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _mapView = BMKMapView.new;
    _mapView.zoomLevel = 17;
    _mapView.showsUserLocation = YES;
    _mapView.logoPosition = BMKLogoPositionCenterBottom;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    
    [self.view addSubview:self.mapView];
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _locService = BMKLocationService.new;
    _locService.delegate = self;
    [_locService startUserLocationService];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_mapView viewWillAppear];
    _mapView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = NO;// 设置该标注点动画显示
        newAnnotationView.image = [UIImage imageNamed:@"Annotiation"];
        
        // 自定义内容起泡
//        UIView *paoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 350, 100)];
//        paoView.layer.contents = (id)[UIImage imageNamed:@"Background"].CGImage;
//        
//        BMKActionPaopaoView *paopao = [[BMKActionPaopaoView alloc] initWithCustomView:paoView];

        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        button.backgroundColor = [UIColor redColor];
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAction:)];
//        tap.delegate = self;
//        [newAnnotationView.paopaoView addGestureRecognizer:tap];
        [newAnnotationView.paopaoView addSubview:button];
        
        return newAnnotationView;
    }
    return nil;
}

- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi *)mapPoi
{
    if (_tmpAnnotation)
    {
        [_mapView removeAnnotation:_tmpAnnotation];
    }
    
    _tmpAnnotation = BMKPointAnnotation.new;
    _tmpAnnotation.coordinate = mapPoi.pt;
    _tmpAnnotation.title = mapPoi.text;
    [_mapView addAnnotation:_tmpAnnotation];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_mapView selectAnnotation:_tmpAnnotation animated:YES];
    });
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    NSLog(@"%@", NSStringFromCGRect(view.frame));
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    
}

- (void)mapView:(BMKMapView *)mapView onClickedBMKOverlayView:(BMKOverlayView *)overlayView
{
    
}

- (void)handleTapAction:(UITapGestureRecognizer *)gesture
{
    NSLog(@"Taped.");
}

@end
