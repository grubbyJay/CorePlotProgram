//
//  HTViewController.m
//  CorePlotProgram
//
//  Created by wb-shangguanhaitao on 14-2-27.
//  Copyright (c) 2014年 shangguan. All rights reserved.
//

#import "HTViewController.h"
#import "CorePlot-CocoaTouch.h"

@interface HTViewController ()<CPTTradingRangePlotDataSource>

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
        for ( NSUInteger i = 0; i < 4; i++ ) {
            NSTimeInterval x = 1 * i + 1;
            double rOpen     = 3.0 * rand() / (double)RAND_MAX + 1.0;
            double rClose    = (rand() / (double)RAND_MAX - 0.5) * 0.5 + rOpen;
            double rHigh;
            double rLow;

//            double rHigh     = MAX( rOpen, MAX(rClose, (rand() / (double)RAND_MAX - 0.5) * 0.5 + rOpen) );
//            double rLow      = MIN( rOpen, MIN(rClose, (rand() / (double)RAND_MAX - 0.5) * 0.5 + rOpen) );
            
            if (rOpen > rClose)
            {
                rHigh = rOpen + 0.2;
                rLow = rClose - 0.2;
            }
            if (rOpen < rClose)
            {
                rLow = rOpen - 0.2;
                rHigh = rClose + 0.2;
            }
            
            [newData addObject:
             [NSDictionary dictionaryWithObjectsAndKeys:
              [NSDecimalNumber numberWithDouble:x], [NSNumber numberWithInt:CPTTradingRangePlotFieldX],
              [NSDecimalNumber numberWithDouble:rOpen], [NSNumber numberWithInt:CPTTradingRangePlotFieldOpen],
              [NSDecimalNumber numberWithDouble:rHigh], [NSNumber numberWithInt:CPTTradingRangePlotFieldHigh],
              [NSDecimalNumber numberWithDouble:rLow], [NSNumber numberWithInt:CPTTradingRangePlotFieldLow],
              [NSDecimalNumber numberWithDouble:rClose], [NSNumber numberWithInt:CPTTradingRangePlotFieldClose],
              nil]];
        }
        
        self.plotData = newData;
    }
}

- (void)setupCoreplotViews
{
    CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    
    CPTTheme *theme = [CPTTheme themeNamed:kCPTStocksTheme];
    [graph applyTheme:theme];
    
    graph.paddingTop = 0.0f;
    graph.paddingLeft = 0.0f;
    graph.paddingBottom = 0.0f;
    graph.paddingRight = 0.0f;
    
    graph.plotAreaFrame.paddingTop = 50.0f;
    graph.plotAreaFrame.paddingLeft = 40.0f;
    graph.plotAreaFrame.paddingBottom = 50.0f;
    graph.plotAreaFrame.paddingRight = 40.0f;
    
    graph.plotAreaFrame.cornerRadius = 0.0f;
    
    CPTXYPlotSpace *space = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    space.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(5.0f)];
    space.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(4.0f)];
    
    [self generateData];
    
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor whiteColor];
    lineStyle.lineWidth = 2.0f;
    
    CPTTradingRangePlot *tradingRangePlot = [[CPTTradingRangePlot alloc] init];
    tradingRangePlot.plotStyle = CPTTradingRangePlotStyleCandleStick;
    tradingRangePlot.lineStyle = lineStyle;
    tradingRangePlot.dataSource = self;
    
    [graph addPlot:tradingRangePlot];
    //...
    
    CPTGraphHostingView *hostingView = [[CPTGraphHostingView alloc] initWithFrame:self.view.bounds];
    hostingView.hostedGraph = graph;
    [self.view addSubview:hostingView];
}

#pragma mark - CPTTradingRangePlotDataSource API

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [self.plotData count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    switch (fieldEnum)
    {
        case CPTTradingRangePlotFieldX:
            return [[self.plotData objectAtIndex:idx] objectForKey:[NSNumber numberWithInt:CPTTradingRangePlotFieldX]];
            break;
        case CPTTradingRangePlotFieldOpen:
            return [[self.plotData objectAtIndex:idx] objectForKey:[NSNumber numberWithInt:CPTTradingRangePlotFieldOpen]];
            break;
        case CPTTradingRangePlotFieldHigh:
            return [[self.plotData objectAtIndex:idx] objectForKey:[NSNumber numberWithInt:CPTTradingRangePlotFieldHigh]];
            break;
        case CPTTradingRangePlotFieldLow:
            return [[self.plotData objectAtIndex:idx] objectForKey:[NSNumber numberWithInt:CPTTradingRangePlotFieldLow]];
            break;
        case CPTTradingRangePlotFieldClose:
            return [[self.plotData objectAtIndex:idx] objectForKey:[NSNumber numberWithInt:CPTTradingRangePlotFieldClose]];
            break;
        default:
            return [NSNumber numberWithDouble:0.0];
            break;
    }
}

@end
