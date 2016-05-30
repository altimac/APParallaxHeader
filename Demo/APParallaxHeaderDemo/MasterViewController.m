//
//  MasterViewController.m
//  APParallaxHeaderDemo
//
//  Created by Mathias Amnell on 2013-04-12.
//  Copyright (c) 2013 Apping AB. All rights reserved.
// Modified by Aurelien HUGELE May 2016

#import "MasterViewController.h"
#import "UIScrollView+APParallaxHeader.h"

@import MapKit;

#define PARALLAX_MIN_HEIGHT 200.
#define USE_MAP_VIEW 1


@interface MasterViewController () <APParallaxViewDelegate>

@property (nonatomic) BOOL parallaxWithView;
@property (nonatomic) CGPoint contentOffsetToRestore;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _contentOffsetToRestore = CGPointZero;
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"with view" style:UIBarButtonItemStylePlain target:self action:@selector(toggle:)];
    [self.navigationItem setRightBarButtonItem:barButton];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Close/Open" style:UIBarButtonItemStylePlain target:self action:@selector(closeOrHideList:)];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];

    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self toggle:nil];
}

- (void)toggle:(id)sender {
    /**
     *  For demo purposes this view controller either adds a parallaxView with a custom view
     *  or a parallaxView with an image.
     */
    if(_parallaxWithView == NO) {
        // add parallax with view
#if USE_MAP_VIEW
        MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
        [self.tableView addParallaxWithView:mapView andHeight:mapView.bounds.size.height-150. andMinHeight:PARALLAX_MIN_HEIGHT];
#else
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Rover.jpg"]];
        [imageView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)]; // square view
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.tableView addParallaxWithView:imageView andHeight:self.view.frame.size.width];
#endif
        _parallaxWithView = YES;
        
        // Update the toggle button
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"with image" style:UIBarButtonItemStylePlain target:self action:@selector(toggle:)];
        [self.navigationItem setRightBarButtonItem:barButton];
    }
    else {
        // add parallax with image
        [self.tableView addParallaxWithImage:[UIImage imageNamed:@"ParallaxImage.jpg"] andHeight:self.view.frame.size.width andMinHeight:128 andShadow:YES]; // square image
        _parallaxWithView = NO;
        
        // Update the toggle button
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"with view" style:UIBarButtonItemStylePlain target:self action:@selector(toggle:)];
        [self.navigationItem setRightBarButtonItem:barButton];
    }
    
    /**
     *  Setting a delegate for the parallaxView will allow you to get callbacks for when the
     *  frame of the parallaxView changes.
     *  Totally optional thou.
     */
    self.tableView.parallaxView.delegate = self;
    
}

-(void)closeOrHideList:(id)sender
{
    if(self.tableView.parallaxView.bounds.size.height < self.view.bounds.size.height) {
        self.contentOffsetToRestore = self.tableView.contentOffset;
        [self.tableView setContentOffset:CGPointMake(0, -1*self.view.bounds.size.height) animated:YES];
    }
    else {
        [self.tableView setContentOffset:self.contentOffsetToRestore animated:YES];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    cell.textLabel.text = [NSString stringWithFormat:@"Row %li", (NSInteger)indexPath.row+1];
    return cell;
}

#pragma mark - APParallaxViewDelegate

//- (void)parallaxView:(APParallaxView *)view willChangeFrame:(CGRect)frame {
//    // Do whatever you need to do to the parallaxView or your subview before its frame changes
//    NSLog(@"parallaxView:willChangeFrame: %@", NSStringFromCGRect(frame));
//}
//
//- (void)parallaxView:(APParallaxView *)view didChangeFrame:(CGRect)frame {
//    // Do whatever you need to do to the parallaxView or your subview after its frame changed
//    NSLog(@"parallaxView:didChangeFrame: %@", NSStringFromCGRect(frame));
//}

@end
