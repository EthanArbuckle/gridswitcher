#import "gridswitcher.h"
#import "MultitaskViewCard.h"
#import "ident_server.h"

@interface MultitaskView : UIView

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *cardsArray;

- (void)redrawCards;
- (void)resetScrollviewContentSize;
- (void)closeMultiview;
- (void)cardWantsToClose:(UIView *)card;
- (void)tellCardsToWobble;

@end