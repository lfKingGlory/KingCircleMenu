//
//  ViewController.m
//  circleMenu
//
//  Created by msj on 2017/6/30.
//  Copyright © 2017年 msj. All rights reserved.
//

#import "ViewController.h"
#import "UIView+FrameUtil.h"
#import "MSCircleModel.h"

@interface ViewController ()
@property (assign, nonatomic) CGPoint beginPoint;
@property (strong, nonatomic) UIView *menu;
@property (strong, nonatomic) UIImageView *imageCenter;
@property (strong, nonatomic) NSMutableArray *datas;
@property (strong, nonatomic) NSMutableArray *circles;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.circles = [NSMutableArray array];
    self.datas = [NSMutableArray array];
    
    for (int i = 0; i < 8; i++) {
        MSCircleModel *model = [MSCircleModel new];
        model.image = [NSString stringWithFormat:@"Image-%d",i+1];
        model.title = [NSString stringWithFormat:@"Image-%d",i+1];
        [self.datas addObject:model];
    }
    
    self.menu = [[UIView alloc] initWithFrame:CGRectMake(0, (self.view.height - self.view.width)/2.0, self.view.width, self.view.width)];
    [self.view addSubview:self.menu];
    
    self.imageCenter = [[UIImageView alloc] initWithFrame:CGRectMake(self.menu.width*0.7/2, self.menu.width*0.7/2, self.menu.width*0.3, self.menu.width*0.3)];
    self.imageCenter.image = [UIImage imageNamed:@"circle"];
    [self.menu addSubview:self.imageCenter];
    
    for (int i = 0; i < self.datas.count; i++) {
        
        CGFloat radius = self.menu.width  * 0.5;
        CGFloat width = radius * 0.4;
        
        CGFloat x = (radius - width*0.5) * sin(M_PI*2/self.datas.count*i);
        CGFloat y = (radius - width*0.5) * cos(M_PI*2/self.datas.count*i);
        
        UIView *view = [[UIView alloc] init];
        view.width = width;
        view.height = width;
        view.centerX = radius + x;
        view.centerY = radius - y;
        
        MSCircleModel *model = self.datas[i];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, view.width - 20, view.width - 20)];
        imageView.image = [UIImage imageNamed:model.image];
        
        UILabel *imageTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, view.height - 20, view.width, 20)];
        imageTitle.text = model.title;
        imageTitle.textAlignment = NSTextAlignmentCenter;
        imageTitle.font = [UIFont systemFontOfSize:12];
        
        [view addSubview:imageView];
        [view addSubview:imageTitle];
        
        [self.menu addSubview:view];
        [self.circles addObject:view];
    }
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.beginPoint = [[touches anyObject] locationInView:self.view];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGPoint orginlPoint = self.menu.center;
    CGPoint currentPoint = [[touches anyObject] locationInView:self.view];
    
    CGFloat angleBegin = atan2(self.beginPoint.y-orginlPoint.y, self.beginPoint.x-orginlPoint.x);
    CGFloat angleAfter = atan2(currentPoint.y-orginlPoint.y, currentPoint.x-orginlPoint.x);
    CGFloat angle = angleAfter-angleBegin;
    
    self.menu.transform = CGAffineTransformRotate(self.menu.transform, angle);
    self.imageCenter.transform = CGAffineTransformRotate(self.imageCenter.transform, -angle);
    for (int i = 0; i < self.circles.count; i++) {
        UIView *view = self.circles[i];
        view.transform = CGAffineTransformRotate(view.transform, -angle);
    }
    self.beginPoint = currentPoint;
}

- (CGFloat)distanceFromPoint:(CGPoint)point toPoint:(CGPoint)toPoint {
    return sqrtf((point.x-toPoint.x)*(point.x-toPoint.x)+(point.y-toPoint.y)*(point.y-toPoint.y));
}

@end
