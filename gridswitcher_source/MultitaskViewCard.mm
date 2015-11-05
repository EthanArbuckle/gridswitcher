#import "MultitaskViewCard.h"
#import <QuartzCore/QuartzCore.h>

@implementation MultitaskViewCard

- (id)initWithIdentifier:(NSString *)identifier {

	 if (self = [super init]) {

		_identifier = identifier;
         
         UIView *img = [[[ident_server daemon] _private_cached_snapshots] objectForKey:_identifier];
         CGRect reassertFrame = [self frame];
         [img setTransform:CGAffineTransformMakeScale(kMultiViewCardWidth / kScreenWidth, kMultiViewCardHeight / kScreenHeight)];
         [self setFrame:reassertFrame];
         [self addSubview:img];
		  
		//get instance of the application
		_application = [[NSClassFromString(@"SBApplicationController") sharedInstance] applicationWithBundleIdentifier:identifier];

		//create the label that displays the name of the app
		UILabel *appName = [[UILabel alloc] initWithFrame:CGRectMake(0, 145, kMultiViewCardWidth, 20)];
		[appName setText:[(SBApplication *)_application valueForKey:@"_displayName"]];
		[appName setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
		[appName setTextColor:[UIColor whiteColor]];
		[appName setTextAlignment:NSTextAlignmentCenter];
		[self addSubview:appName];

		//add tap recognizer so we can open the app when this card is touched
		UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openApp)];
		[tapGes setCancelsTouchesInView:YES];
		[self addGestureRecognizer:tapGes];

		_closeView = [[objc_getClass("SBCloseBoxView") alloc] initWithFrame:CGRectMake(-10,-10,20,20)];
		[self addSubview:_closeView];
		_closeView.alpha = 0;

	}

	return self;

}

- (void)shouldTellSuperToKill {

	//disable the gesture just to be safe
	[self setUserInteractionEnabled:NO];

	//[(MultitaskView *)_superView cardWantsToClose:self];
}

- (void)setEditing:(NSNumber *)editing {
	if ([editing boolValue]){
		CGAffineTransform leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity,((-5 * M_PI) / 180.0));
		CGAffineTransform rightWobble = CGAffineTransformRotate(CGAffineTransformIdentity, ((5 * M_PI) / 180.0));

		self.transform = leftWobble;  // starting point

		[UIView beginAnimations:@"iconShake" context:nil];
		[UIView setAnimationRepeatAutoreverses:YES]; // important
		[UIView setAnimationRepeatCount:9999];
		[UIView setAnimationDuration:0.1];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(didStopWobble)];
		self.transform = rightWobble; // end here & auto-reverse
		[UIView commitAnimations];

		_closeView.alpha = 1;
	} else {
		[self.layer removeAnimationForKey:@"iconShake"];
		_closeView.alpha = 0;
	}
}

- (void)openApp {

	 //open the app
	 [[NSClassFromString(@"SBUIController") sharedInstance] activateApplicationAnimated:[[NSClassFromString(@"SBApplicationController") sharedInstance] applicationWithBundleIdentifier:_identifier]];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	
	 return YES;
}

- (void)didStopWobble {

	[self setTransform:CGAffineTransformIdentity];
}

@end