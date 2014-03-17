//
//  HTViewController.m
//  CorePlotProgram
//
//  Created by wb-shangguanhaitao on 14-3-3.
//  Copyright (c) 2014年 shangguan. All rights reserved.
//

#import "HTViewController.h"
#import "CorePlot-CocoaTouch.h"

static const NSTimeInterval oneDay = 24 * 60 * 60;

@interface HTViewController ()<CPTRangePlotDataSource>

/**
 *  plotData ohlc 数据
 */
@property (nonatomic, strong) NSMutableArray *plotData;

/**
 *  生成plotData数据
 */
-(void)generateData;

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

-(void)generateData
{
    if ( !self.plotData ) {
        NSMutableArray *newData = [NSMutableArray array];
        for ( NSUInteger i = 0; i < 5; i++ ) {
            NSTimeInterval x = oneDay * (i + 1.0);
            double y         = 3.0 * rand() / (double)RAND_MAX + 1.2;
            double rHigh     = rand() / (double)RAND_MAX * 0.5 + 0.25;
            double rLow      = rand() / (double)RAND_MAX * 0.5 + 0.25;
            double rLeft     = (rand() / (double)RAND_MAX * 0.125 + 0.125) * oneDay;
            double rRight    = (rand() / (double)RAND_MAX * 0.125 + 0.125) * oneDay;
            
            [newData addObject:
             [NSDictionary dictionaryWithObjectsAndKeys:
              [NSDecimalNumber numberWithDouble:x], [NSNumber numberWithInt:CPTRangePlotFieldX],
              [NSDecimalNumber numberWithDouble:y], [NSNumber numberWithInt:CPTRangePlotFieldY],
              [NSDecimalNumber numberWithDouble:rHigh], [NSNumber numberWithInt:CPTRangePlotFieldHigh],
              [NSDecimalNumber numberWithDouble:rLow], [NSNumber numberWithInt:CPTRangePlotFieldLow],
              [NSDecimalNumber numberWithDouble:rLeft], [NSNumber numberWithInt:CPTRangePlotFieldLeft],
              [NSDecimalNumber numberWithDouble:rRight], [NSNumber numberWithInt:CPTRangePlotFieldRight],
              nil]];
        }
        
        self.plotData = newData;
    }
}

- (void)setupCoreplotViews
{
    CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    
    CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    [graph applyTheme:theme];
    
    graph.paddingTop = 0.0f;
    graph.paddingLeft = 0.0f;
    graph.paddingBottom = 0.0f;
    graph.paddingRight = 0.0f;
    
    graph.plotAreaFrame.paddingTop = 50.0f;
    graph.plotAreaFrame.paddingLeft = 30.0f;
    graph.plotAreaFrame.paddingBottom = 50.0f;
    graph.plotAreaFrame.paddingRight = 30.0f;
    
    graph.plotAreaFrame.cornerRadius = 0.0f;
    
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color    = [CPTColor whiteColor];
    textStyle.fontSize = 14.0;
    textStyle.fontName = @"Helvetica";
    CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:@"Touch to Toggle Range Plot Style" style:textStyle];
    CPTLayerAnnotation *instructionsAnnotation = [[CPTLayerAnnotation alloc] initWithAnchorLayer:graph.plotAreaFrame.plotArea];
    instructionsAnnotation.contentLayer       = textLayer;
    instructionsAnnotation.rectAnchor         = CPTRectAnchorBottom;
    instructionsAnnotation.contentAnchorPoint = CGPointMake(0.5, 0.0);
    instructionsAnnotation.displacement       = CGPointMake(0.0, 10.0);
    [graph.plotAreaFrame.plotArea addAnnotation:instructionsAnnotation];
    
    CPTXYPlotSpace *space = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    NSTimeInterval xLow       = oneDay * 0.5;
    space.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromCGFloat(xLow) length:CPTDecimalFromCGFloat(oneDay * 5.0)];
    space.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromCGFloat(0.0f) length:CPTDecimalFromCGFloat(5.0f)];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
    x.majorIntervalLength         = CPTDecimalFromDouble(oneDay);
    x.orthogonalCoordinateDecimal = CPTDecimalFromCGFloat(1.0f);
    
    x.minorTickLineStyle = nil;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = kCFDateFormatterShortStyle;
    CPTTimeFormatter *timeFormatter = [[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter];
    timeFormatter.referenceDate = [NSDate date];
    x.labelFormatter            = timeFormatter;
    
    CPTXYAxis *y = axisSet.yAxis;
    y.orthogonalCoordinateDecimal = CPTDecimalFromCGFloat(xLow);
    
    y.minorTickLineStyle = nil;
    y.majorIntervalLength = CPTDecimalFromCGFloat(1.0f);

    [self generateData];
    
    CPTRangePlot *plot = [[CPTRangePlot alloc] init];
    
    CPTMutableLineStyle *barLineStyle = [CPTMutableLineStyle lineStyle];
    barLineStyle.lineWidth = 1.0;
    barLineStyle.lineColor = [CPTColor greenColor];
    plot.barLineStyle = barLineStyle;

    plot.barWidth = 20.0f;
    plot.gapWidth = 20.0f;
    plot.gapHeight = 20.0f;
    
    plot.dataSource = self;
    
    [graph addPlot:plot];
    
    CPTGraphHostingView *hostingView = [[CPTGraphHostingView alloc] initWithFrame:self.view.bounds];
    hostingView.hostedGraph = graph;
    [self.view addSubview:hostingView];
}

#pragma mark - CPTRangePlotDataSource API

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [self.plotData count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    switch (fieldEnum)
    {
        case CPTRangePlotFieldX:
            return [[self.plotData objectAtIndex:idx] objectForKey:[NSNumber numberWithInt:CPTRangePlotFieldX]];
            break;
        case CPTRangePlotFieldY:
            return [[self.plotData objectAtIndex:idx] objectForKey:[NSNumber numberWithInt:CPTRangePlotFieldY]];
            break;
        case CPTRangePlotFieldHigh:
            return [[self.plotData objectAtIndex:idx] objectForKey:[NSNumber numberWithInt:CPTRangePlotFieldHigh]];
            break;
        case CPTRangePlotFieldLow:
            return [[self.plotData objectAtIndex:idx] objectForKey:[NSNumber numberWithInt:CPTRangePlotFieldLow]];
            break;
        case CPTRangePlotFieldLeft:
            return [[self.plotData objectAtIndex:idx] objectForKey:[NSNumber numberWithInt:CPTRangePlotFieldLeft]];
            break;
        case CPTRangePlotFieldRight:
            return [[self.plotData objectAtIndex:idx] objectForKey:[NSNumber numberWithInt:CPTRangePlotFieldRight]];
            break;
        default:
            break;
    }
    return [NSNumber numberWithDouble:0.0];
}

@end
