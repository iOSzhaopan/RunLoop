//
//  ViewController.m
//  RunLoop实践
//
//  Created by miaolin on 16/6/16.
//  Copyright © 2016年 赵攀. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/** 线程 */
@property (nonatomic, weak) NSThread *therad;

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSThread *therad = [[NSThread alloc] initWithTarget:self selector:@selector(text) object:nil];
    [therad start];
    self.therad = therad;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self afterGCD];
}

- (void)afterGCD {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC, 2.0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.timer, ^{
        NSLog(@"%@", [NSThread currentThread]);
    });
    dispatch_resume(self.timer);
    //创建队列
//    //创建定时器
//    dispatch_source_t time = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//    dispatch_source_set_timer(time, dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), 2.0 * NSEC_PER_SEC, 0);
//    dispatch_source_set_event_handler(time, ^{
//        NSLog(@"%@", [NSThread currentThread]);
//    });
//    dispatch_resume(time);
}

- (void)time {
    [self performSelector:@selector(timerInSubThread) onThread:self.therad withObject:nil waitUntilDone:NO];
}

- (void)timerInSubThread {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(runText) userInfo:@"xxxx" repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)setTimerMode {
    //这样创建的方法必须手动添加到runLoop中
    //mode是用来设置定时器在哪个模式下起作用
    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(run:) userInfo:@"xxxx" repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)text {
    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
}

- (void)run:(NSString *)str {
    NSLog(@"%@---------%@",str, [NSThread currentThread]);
    
}

- (void)runText {
    NSLog(@"---------%@", [NSThread currentThread]);
}

- (void)setImage {
    //让图片的渲染在默认模式下才进行，不影响scrollView的拖动
    [self.imageView performSelector:@selector(setImage:) withObject:[UIImage imageNamed:@"xuexi8Icon"] afterDelay:3.0 inModes:@[NSDefaultRunLoopMode]];
}

@end
