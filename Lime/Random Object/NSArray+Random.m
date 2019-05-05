#import "NSArray+Random.h"

@implementation NSArray (Random)

-(id)randomObject {
    NSUInteger myCount = [self count];
    if (myCount)
        return [self objectAtIndex:arc4random_uniform(myCount)];
    else
        return nil;
}

@end
