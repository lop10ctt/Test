//
//  ViewController.h
//  ScreenMove
//
//  Created by An Ngọc on 24/03/2023.
//

#import <UIKit/UIKit.h>

NSString *APP_TITLE = @"Image Gesture Demo";
NSString *INTRO_ALERT = @"\nDrag, Pinch and Rotate the Image!"
                        "\n\nYou can also Drag, Pinch and Rotate the background image."
                        "\n\nDouble tap an image to reset it";

float touchRadius = 48;   // max distance from corners to touch point

typedef NS_ENUM(NSInteger, DragType) {
    DRAG_OFF,
    DRAG_ON,
    DRAG_CENTER,
    DRAG_TOP,
    DRAG_BOTTOM,
    DRAG_LEFT,
    DRAG_RIGHT,
    DRAG_TOPLEFT,
    DRAG_TOPRIGHT,
    DRAG_BOTTOMLEFT,
    DRAG_BOTTOMRIGHT
};


@interface ViewController : UIViewController

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;
- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer;
- (IBAction)handleRotate:(UIRotationGestureRecognizer *)recognizer;
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;
@end

@interface BorderBeingDragged : NSObject
typedef enum NSInteger {
    kBorderTypeNone   = 0,
    kBorderTypeLeft   = 1 << 0,
    kBorderTypeRight  = 1 << 1,
    kBorderTypeTop    = 1 << 2,
    kBorderTypeBottom = 1 << 3
} BorderType;

+ (NSArray *)findBordersBeingDraggedForView:(UIView *)view fromLocation:(CGPoint)point;
+ (void)dragBorders:(NSArray *)matches translation:(CGPoint)translation;

@property (nonatomic, weak) UIView *view;
@property (nonatomic) BorderType borderTypes;
@property (nonatomic) CGRect originalFrame;


@end
