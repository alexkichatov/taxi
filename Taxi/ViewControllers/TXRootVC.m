//
//  TXRootVC.m
//  Taxi
//
//  Created by Irakli Vashakidze on 3/2/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXRootVC.h"

@interface TXRootVC ()

@end

@implementation TXRootVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self->app = [TXVCSharedUtil instance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setModel:(TXModelBase *) model_ eventNames:(NSArray *) eventNames {
    self->model = model_;
    for (NSString *evtName in eventNames) {
        [self->model addEventListener:self forEvent:evtName eventParams:nil];
    }
}

-(void)onEvent:(TXEvent *)event eventParams:(id)subscriptionParams{
    
}

@end
