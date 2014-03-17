//
//  HTViewController.m
//  CorePlotProgram
//
//  Created by wb-shangguanhaitao on 14-2-24.
//  Copyright (c) 2014年 shangguan. All rights reserved.
//

#import "HTViewController.h"
#import "CorePlot-CocoaTouch.h"

@interface HTViewController ()<CPTPlotDataSource>

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

#pragma mark - Private API

- (void)setupCoreplotViews
{
    CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    
    CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    [graph applyTheme:theme];
    
    CPTXYPlotSpace *space = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    space.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromString(@"0.0f") length:CPTDecimalFromString(@"3.0f")];
    space.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromString(@"0.0f") length:CPTDecimalFromString(@"3.0f")];
    space.allowsUserInteraction = YES;

    graph.paddingTop = 0.0f;
    graph.paddingLeft = 0.0f;
    graph.paddingBottom = 0.0f;
    graph.paddingRight = 0.0f;
    
    graph.plotAreaFrame.paddingTop = 50.0f;
    graph.plotAreaFrame.paddingLeft = 50.0f;
    graph.plotAreaFrame.paddingBottom = 50.0f;
    graph.plotAreaFrame.paddingRight = 50.0f;
    
    graph.plotAreaFrame.borderLineStyle = nil;
    graph.plotAreaFrame.cornerRadius = 0.0f;
    graph.plotAreaFrame.masksToBorder = NO;
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.axisLineStyle               = nil;
    x.majorTickLineStyle          = nil;
    x.minorTickLineStyle          = nil;
//    x.majorIntervalLength         = CPTDecimalFromDouble(5.0);
//    x.orthogonalCoordinateDecimal = CPTDecimalFromDouble(0.0);
    x.title                       = @"X Axis";
    x.titleLocation               = CPTDecimalFromFloat(1.5f);
    x.titleOffset                 = 30.0f;
    
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    NSArray *customTickLocations = [NSArray arrayWithObjects:[NSDecimalNumber numberWithInt:0], [NSDecimalNumber numberWithInt:1], [NSDecimalNumber numberWithInt:2], nil];
    NSArray *xAxisLabels         = [NSArray arrayWithObjects:@"Label A", @"Label B", @"Label C", nil];
    NSUInteger labelLocation     = 0;
    NSMutableSet *customLabels   = [NSMutableSet setWithCapacity:[xAxisLabels count]];
    for ( NSNumber *tickLocation in customTickLocations ) {
        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:[xAxisLabels objectAtIndex:labelLocation++] textStyle:x.labelTextStyle];
        newLabel.tickLocation = [tickLocation decimalValue];
//        newLabel.offset       = x.labelOffset + x.majorTickLength;
        newLabel.rotation     = M_PI_4;
        [customLabels addObject:newLabel];
    }
    
    x.axisLabels = customLabels;

    CPTXYAxis *y = axisSet.yAxis;
    y.axisLineStyle = nil;
    y.majorTickLineStyle = nil;
    y.minorTickLineStyle = nil;
    y.title                       = @"Y Axis";
    y.titleLocation               = CPTDecimalFromFloat(1.5f);
    y.titleOffset                 = 30.0f;
    
    CPTBarPlot *barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor orangeColor] horizontalBars:NO];
//    barPlot.baseValue = CPTDecimalFromString(@"0.025f");
    barPlot.barCornerRadius = 5.0f;
//    barPlot.barBaseCornerRadius = 5.0f;
//    barPlot.barWidthScale = 2.0f;
    barPlot.dataSource = self;
    [graph addPlot:barPlot];
    
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color         = [CPTColor whiteColor];
    titleStyle.fontName      = @"Helvetica-Bold";
    titleStyle.fontSize      = 16.0;
    titleStyle.textAlignment = CPTTextAlignmentCenter;
    
    graph.title          = [NSString stringWithFormat:@"WhatsApp"];
    graph.titleTextStyle = titleStyle;
    
    graph.titleDisplacement        = CGPointMake(0.0, -20.0);
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    //...
    
    CPTGraphHostingView *hostingView = [[CPTGraphHostingView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:hostingView];
    hostingView.hostedGraph = graph;
}

#pragma makr - CPTPlotDataSource API

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return 3;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    if (fieldEnum == CPTScatterPlotFieldY)
    {
        return [NSNumber numberWithUnsignedInteger:idx + 1];
    }
    else
    {
        return [NSNumber numberWithUnsignedInteger:idx];
    }
}

@end
