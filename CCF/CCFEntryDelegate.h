
#import <Foundation/Foundation.h>
@class CCFEntry;

@protocol CCFEntryDelegate <NSObject>

@required
-(void)transValue:(CCFEntry *)value;

@end
