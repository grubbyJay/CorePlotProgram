//
//  HTViewController.m
//  CorePlotProgram
//
//  Created by wb-shangguanhaitao on 14-2-26.
//  Copyright (c) 2014年 shangguan. All rights reserved.
//

#import "HTViewController.h"
#import "CorePlot-CocoaTouch.h"

@interface HTViewController ()<CPTPieChartDataSource, CPTPieChartDelegate>

/**
 *  设置图表绘制的配置
 */
- (void)setupCoreplotViews;

@end

@implementation HTViewController

#pragma mark - Superclass API

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCoreplotViews];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Pivate API

- (void)setupCoreplotViews
{
    CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [graph applyTheme:theme];
    
    graph.plotAreaFrame.axisSet = nil;
    
    CPTPieChart *pieChart = [[CPTPieChart alloc] init];
    pieChart.centerAnchor = CGPointMake(0.5f, 0.5f);
    pieChart.pieRadius = 131.0f;
    pieChart.sliceDirection = CPTPieDirectionCounterClockwise;
    pieChart.startAngle = M_PI_2;
    pieChart.dataSource = self;
    pieChart.delegate = self;
    
    [graph addPlot:pieChart];
    // ...
    
    CPTGraphHostingView *hostingView = [[CPTGraphHostingView alloc] initWithFrame:self.view.bounds];
    hostingView.hostedGraph = graph;
    [self.view addSubview:hostingView];
}

#pragma mark - CPTPieChartDataSource API

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return 4;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    return [NSNumber numberWithUnsignedInteger:idx + 1];
}

-(CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)idx
{
    switch (idx) {
        case 0:
            return [CPTFill fillWithColor:[CPTColor lightGrayColor]];
            break;
        case 1:
            return [CPTFill fillWithColor:[CPTColor redColor]];
            break;
        case 2:
            return [CPTFill fillWithColor:[CPTColor greenColor]];
            break;
        case 3:
            return [CPTFill fillWithColor:[CPTColor blueColor]];
            break;
        default:
            break;
    }
    return [CPTFill fillWithColor:[CPTColor whiteColor]];
}

#pragma mark - CPTPieChartDelegate API

-(void)pieChart:(CPTPieChart *)plot sliceWasSelectedAtRecordIndex:(NSUInteger)idx
{
    NSLog(@"idx = %lu", (unsigned long)idx);
    
    [plot reloadDataInIndexRange:NSMakeRange(0, 1)];
}

-(CGFloat)radialOffsetForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)idx
{
    static BOOL isFirstSetup = NO;
    CGFloat offset = 0.0;
    
    if ( idx == 0 )
    {
        if (!isFirstSetup) {
            isFirstSetup = YES;
        }
        else
        {
            offset = pieChart.pieRadius / 8.0;
        }
    }
    
    return offset;
}

@end
