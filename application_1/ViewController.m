//
//  ViewController.m
//  application_1
//
//  Created by Lizaveta Rudzko on 2/15/1398 AP.
//  Copyright © 1398 Lizaveta Rudzko. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *canvas;
@property (strong, nonatomic) IBOutlet UIImageView *colorsImage;
@property (strong, nonatomic) IBOutlet UISegmentedControl *colorsSegmentedControl;
@property (strong, nonatomic) IBOutlet UISwitch *formSwitch;
@property (strong, nonatomic) IBOutlet UISlider *sizeSlider;

@property NSArray* colorsArray;
@property CGPoint lastPoint;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.colorsArray = [NSArray arrayWithObjects: UIColor.purpleColor, UIColor.blueColor, UIColor.greenColor, UIColor.orangeColor, UIColor.redColor, nil];
    
    UIImage* colors = [UIImage imageNamed: @"colors.png"]; //??
    self.colorsImage = [[UIImageView alloc] initWithFrame:self.colorsImage.frame];
    self.colorsImage.contentMode = UIViewContentModeScaleAspectFit;
    self.colorsImage.image = colors;
    [self.view addSubview:self.colorsImage];

}
- (IBAction)formSwitchTapped:(id)sender {
    if (self.formSwitch.isOn)
    {
        CGContextSetLineDash(UIGraphicsGetCurrentContext(), 0, (CGFloat[]){1}, 0);
    }
    else {
        CGContextSetLineDash(UIGraphicsGetCurrentContext(), 0, (CGFloat[]){2, 1}, 2);
    }
}

- (IBAction)saveTapped:(id)sender {
    NSData* data = UIImagePNGRepresentation(_canvas.image);
    [data writeToFile:@"/Users/eliz/Desktop/TP/lab8/application_1/drawed_images/picture.png" atomically:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    [self setLastPoint:[touch locationInView:self.view]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    UIGraphicsBeginImageContext(self.view.frame.size);
    CGRect drawRect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width,
                                 self.view.frame.size.height);
    [[[self canvas] image] drawInRect:drawRect];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), (int)_sizeSlider.value);
    
    UIColor* c = [[self colorsArray] objectAtIndex:(int)self.colorsSegmentedControl.selectedSegmentIndex];
    const CGFloat* comp =  CGColorGetComponents(c.CGColor);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), comp[0], comp[1], comp[2], CGColorGetAlpha(c.CGColor));
    
    
    if (self.formSwitch.isOn)
    {
        CGContextSetLineDash(UIGraphicsGetCurrentContext(), 0, (CGFloat[]){1}, 0);
    }
    else {
        CGContextSetLineDash(UIGraphicsGetCurrentContext(), 0, (CGFloat[]){2, 1}, 2);
    }
    
    CGContextSetLineJoin(UIGraphicsGetCurrentContext(), kCGLineJoinRound);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), _lastPoint.x,
                         _lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x,
                            currentPoint.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    [[self canvas] setImage:UIGraphicsGetImageFromCurrentImageContext()];
    UIGraphicsEndImageContext();
    _lastPoint = currentPoint;
}


@end
