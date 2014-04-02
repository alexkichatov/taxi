//
//  TXStackedView.h
//  TXStackedView
//

#import "TXStackedViewDelegate.h"
#import "TXStackedViewController.h"
#import "TXContainerView.h"
#import "UIViewController+PSStackedView.h"

enum {
    PSSVLogLevelNothing,
    PSSVLogLevelError,    
    PSSVLogLevelInfo,
    PSSVLogLevelVerbose
}typedef PSSVLogLevel;

extern PSSVLogLevel kPSSVDebugLogLevel; // defaults to PSSVLogLevelError
