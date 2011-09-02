/*-
 *  Glitch iOS SDK Sample App
 *  
 *  Copyright 2011 Tiny Speck, Inc.
 *  Created by Brady Archambo.
 *
 *  http://www.glitch.com
 *  http://www.tinyspeck.com
 */

#import <UIKit/UIKit.h>
#import "Glitch.h"


@interface SampleViewController : UIViewController <GCSessionDelegate, GCRequestDelegate> {
    Glitch * _glitch;
    UILabel * _playerNameLabel;
}


@property (nonatomic, retain) Glitch * glitch;


@end
