//
//  ViewController.m
//  ScreenMove
//
//  Created by An Ngọc on 24/03/2023.
//

#import "ViewController.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface ViewController ()<UIGestureRecognizerDelegate>{
    UIView* newView;
    UIView* elementView;
    UILongPressGestureRecognizer *gesture;
}
//@property (nonatomic) UIView* newView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    newView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/2)];
    newView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:newView];
    elementView = [[UIView alloc]initWithFrame:CGRectMake(0, newView.bounds.size.height*1/5, newView.bounds.size.width, newView.bounds.size.height*3/5)];
    elementView.backgroundColor = [UIColor redColor];
    [newView addSubview:elementView];
    // Do any additional setup after loading the view.
    gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self getView: self.view];
    //[gesture addTarget:newView action:@selector(handlePan:)];
    gesture.minimumPressDuration = 0.0;
    gesture.allowableMovement = CGFLOAT_MAX;
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
}

- (void)handlePan:(UILongPressGestureRecognizer *)gesture
{
    static NSArray *matches;
    static CGPoint firstLocation;

    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        firstLocation = [gesture locationInView:gesture.view];
        matches = [BorderBeingDragged findBordersBeingDraggedForView:gesture.view fromLocation:firstLocation];
        if (!matches)
        {
            gesture.state = UIGestureRecognizerStateFailed;
            return;
        }
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint location    = [gesture locationInView:gesture.view];
        CGPoint translation = CGPointMake(location.x - firstLocation.x, location.y - firstLocation.y);
        [BorderBeingDragged dragBorders:matches translation:translation];
        NSLog(@"translation x: %lf", translation.x);
        NSLog(@"translation y: %lf", translation.y);
    }
}

// if your subviews are scrollviews, you might need to tell the gesture recognizer
// to allow simultaneous gestures

-(void)getView:(UIView*)view{
    if(view){
        for (UIView* subview in view.subviews) {
            [self getView: subview];
            NSLog(@"%@", subview.description);
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return TRUE;
}

#pragma mark - BorderBeingDragged

@end

@interface BorderBeingDragged ()

@end

static CGFloat const kTolerance = 15.0;

@implementation BorderBeingDragged

+ (NSArray *)findBordersBeingDraggedForView:(UIView *)view fromLocation:(CGPoint)point
{
    NSMutableArray *matches = nil;

    for (UIView *subview in view.subviews)
    {
        BorderType types = kBorderTypeNone;
        CGRect frame = subview.frame;

        // test top and bottom borders

        if (point.x >= (frame.origin.x - kTolerance) &&
            point.x <= (frame.origin.x + frame.size.width + kTolerance))
        {
            if (point.y >= (frame.origin.y - kTolerance) && point.y <= (frame.origin.y + kTolerance))
                types |= kBorderTypeTop;
            else if (point.y >= (frame.origin.y + frame.size.height - kTolerance) && point.y <= (frame.origin.y + frame.size.height + kTolerance))
                types |= kBorderTypeBottom;
        }

        // test left and right borders

        if (point.y >= (frame.origin.y - kTolerance) &&
            point.y <= (frame.origin.y + frame.size.height + kTolerance))
        {
            if (point.x >= (frame.origin.x - kTolerance) && point.x <= (frame.origin.x + kTolerance))
                types |= kBorderTypeLeft;
            else if (point.x >= (frame.origin.x + frame.size.width - kTolerance) && point.x <= (frame.origin.x + frame.size.width + kTolerance))
                types |= kBorderTypeRight;
        }

        // if we found any borders, add it to our array of matches

        if (types != kBorderTypeNone)
        {
            if (!matches)
                matches = [NSMutableArray array];

            BorderBeingDragged *object = [[BorderBeingDragged alloc] init];
            object.borderTypes   = types;
            object.view          = subview;
            object.originalFrame = frame;

            [matches addObject:object];
        }
    }

    return matches;
}

+ (void)dragBorders:(NSArray *)matches translation:(CGPoint)translation
{
    for (BorderBeingDragged *object in matches)
    {
        CGRect newFrame = object.originalFrame;

        if (object.borderTypes & kBorderTypeLeft)
        {
//            newFrame.origin.x   += translation.x;
//            newFrame.size.width -= translation.x;
        }
        else if (object.borderTypes & kBorderTypeRight)
        {
//            newFrame.size.width += translation.x;
        }

        if (object.borderTypes & kBorderTypeTop)
        {
            newFrame.origin.y    += translation.y;
            newFrame.size.height -= translation.y;
        }
        else if (object.borderTypes & kBorderTypeBottom)
        {
//            newFrame.size.height += translation.y;
        }

        object.view.frame = newFrame;
//        NSLog(@"newFrame x: %lf", newFrame.origin.x);
//        NSLog(@"newFrame y: %lf", newFrame.origin.y);
    }
}



@end
