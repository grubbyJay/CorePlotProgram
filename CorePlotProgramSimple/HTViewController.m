//
//  HTViewController.m
//  CorePlotProgram
//
//  Created by wb-shangguanhaitao on 14-3-6.
//  Copyright (c) 2014年 shangguan. All rights reserved.
//

#import "HTViewController.h"
#import "CorePlot-CocoaTouch.h"

@interface HTViewController ()<CPTScatterPlotDataSource, CPTAnimationDelegate>

@property (nonatomic, strong) CPTXYGraph *graph;

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
    /**
     *  生成CPTGraphHostingView和CPTXYGraph实例
     */
    CPTGraphHostingView *hostingView = [[CPTGraphHostingView alloc] initWithFrame:self.view.bounds];
    CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    hostingView.hostedGraph = graph;
    [self.view addSubview:hostingView];
//    self.graph = graph;
    
    graph.plotAreaFrame.paddingTop = 50.0f;
    graph.plotAreaFrame.paddingLeft = 50.0f;
    graph.plotAreaFrame.paddingBottom = 80.0f;
    graph.plotAreaFrame.paddingRight = 30.0f;
//    graph.plotAreaFrame.fill = [CPTFill fillWithColor:[CPTColor blueColor]];
    
    graph.paddingTop = 0.0f;
    graph.paddingLeft = 0.0f;
    graph.paddingBottom = 0.0f;
    graph.paddingRight = 0.0f;
//    graph.fill = [CPTFill fillWithColor:[CPTColor redColor]];
//    hostingView.backgroundColor = [UIColor whiteColor];
    
    /**
     *  设置主题，辅助设置一些基本信息
     */
    CPTTheme *theme = [CPTTheme themeNamed:kCPTSlateTheme];
    [graph applyTheme:theme];
    
    /**
     *  设置XY轴
     *
     */
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
    x.minorTicksPerInterval = 0;
    
    CPTXYAxis *y = axisSet.yAxis;
    y.minorTicksPerInterval = 0;
    
    /**
     *  设置二维散点
     */
    CPTScatterPlot *plot = [[CPTScatterPlot alloc] init];
    plot.dataSource = self;
    [graph addPlot:plot];
    
    /**
     *  设置显示的区域
     */
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromCGFloat(0.0f) length:CPTDecimalFromCGFloat(3.0f)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromCGFloat(0.0f) length:CPTDecimalFromCGFloat(3.0f)];
// 以下是扩展部分
    
    /**
     *  添加渐变色
     */
    CPTGradient *gradient = [CPTGradient gradientWithBeginningColor:[CPTColor greenColor]
                                                        endingColor:[CPTColor clearColor]];
    gradient.angle = -90;
    plot.areaFill = [CPTFill fillWithGradient:gradient];
    plot.areaBaseValue = CPTDecimalFromCGFloat(0.0f);
    
    CPTGradient *gradient2 = [CPTGradient gradientWithBeginningColor:[CPTColor greenColor]
                                                        endingColor:[CPTColor clearColor]];
    gradient2.angle = 90;
    plot.areaFill2 = [CPTFill fillWithGradient:gradient2];
    plot.areaBaseValue2 = CPTDecimalFromCGFloat(4.0f);
    
    /**
     *  添加散点符号
     */
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill = [CPTFill fillWithColor:[CPTColor blueColor]];
    plot.plotSymbol = plotSymbol;
    
//    /**
//     *  修改x轴时间节点
//     */
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateStyle = kCFDateFormatterShortStyle;
//    CPTTimeFormatter *timeFormatter = [[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter];
//    timeFormatter.referenceDate = [NSDate date];
//    x.labelFormatter            = timeFormatter;
//
//    NSTimeInterval xLow       = 0.0;
//    NSTimeInterval oneDay = 24 * 60 * 60;
//    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(xLow) length:CPTDecimalFromDouble(oneDay * 5.0)];
    
    /**
     *  添加动画
     */
    x.axisConstraints             = [CPTConstraints constraintWithLowerOffset:0.0f];
    y.axisConstraints             = [CPTConstraints constraintWithLowerOffset:0.0f];

    [CPTAnimation animate:plotSpace
                 property:@"xRange"
            fromPlotRange:plotSpace.xRange
              toPlotRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromCGFloat(3.0f) length:CPTDecimalFromCGFloat(3.0f)]
                 duration:2.0f];
    [CPTAnimation animate:plotSpace
                 property:@"yRange"
            fromPlotRange:plotSpace.yRange
              toPlotRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromCGFloat(3.0f) length:CPTDecimalFromCGFloat(3.0f)]
                 duration:2.0f
           animationCurve:CPTAnimationCurveDefault
                 delegate:self];
    
    /**
     *  添加图表说明
     */
    plot.identifier = @"XY";
    
    graph.legend                 = [CPTLegend legendWithGraph:graph];
    graph.legend.fill            = [CPTFill fillWithColor:[CPTColor darkGrayColor]];
//    graph.legend.entryFill       = [CPTFill fillWithColor:[CPTColor whiteColor]];
    graph.legend.borderLineStyle = x.axisLineStyle;
    graph.legend.cornerRadius    = 5.0;
    graph.legend.swatchSize      = CGSizeMake(50.0, 25.0);
//    graph.legend.swatchFill      = [CPTFill fillWithColor:[CPTColor redColor]];
    graph.legendAnchor           = CPTRectAnchorBottom;
    graph.legendDisplacement     = CGPointMake(0.0, 12.0);
    
    /**
     *  对某一层做说明
     */
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color    = [CPTColor whiteColor];
    textStyle.fontSize = 14.0;
    textStyle.fontName = @"Helvetica";
    CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:@"Scatter Plot Style" style:textStyle];
    CPTLayerAnnotation *instructionsAnnotation = [[CPTLayerAnnotation alloc] initWithAnchorLayer:graph.plotAreaFrame.plotArea];
    instructionsAnnotation.contentLayer       = textLayer;
    instructionsAnnotation.rectAnchor         = CPTRectAnchorBottom;
    instructionsAnnotation.contentAnchorPoint = CGPointMake(0.5, 0.0);
    instructionsAnnotation.displacement       = CGPointMake(0.0, 10.0);
    [graph.plotAreaFrame.plotArea addAnnotation:instructionsAnnotation];
//    graph.plotAreaFrame.plotArea.hidden = YES;
}

#pragma mark - CPTScatterPlotDataSource API


- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return 5;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    return [NSNumber numberWithUnsignedInteger:idx];
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index
{
    CPTTextLayer *label            = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%lu", (unsigned long)index]];
    CPTMutableTextStyle *textStyle = [label.textStyle mutableCopy];
    
    textStyle.color = [CPTColor lightGrayColor];
    label.textStyle = textStyle;
    return label;
}

#pragma mark - CPTAnimationDelegate API

-(void)animationDidFinish:(CPTAnimationOperation *)operation
{
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
}

@end
