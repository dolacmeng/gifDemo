//
//  ViewController.m
//  gifDemo
//
//  Created by 许伟杰 on 2018/7/26.
//  Copyright © 2018年 JackXu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.加载Gif图片，转换成Data类型
    NSString *path = [NSBundle.mainBundle pathForResource:@"demo" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    //2.将data数据转换成CGImageSource对象
    CGImageSourceRef imageSource = CGImageSourceCreateWithData(CFBridgingRetain(data), nil);
    size_t imageCount = CGImageSourceGetCount(imageSource);
    
    //3.遍历所有图片
    NSMutableArray *images = [NSMutableArray array];
    NSTimeInterval totalDuration = 0;
    for (int i = 0; i<imageCount; i++) {
        //取出每一张图片
        CGImageRef cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil);
        UIImage *image = [UIImage imageWithCGImage:cgImage];
        [images addObject:image];
        
        //持续时间
        NSDictionary *properties = (__bridge_transfer  NSDictionary*)CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil);
        NSDictionary *gifDict = [properties objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
        NSNumber *frameDuration =
        [gifDict objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime];
        totalDuration += frameDuration.doubleValue;
    }
    
    //4.设置imageView属性
    self.imageView.animationImages = images;
    self.imageView.animationDuration = totalDuration;
    self.imageView.animationRepeatCount = 0;
    
    //5.开始播放
    [self.imageView startAnimating];
    
    
}



@end
