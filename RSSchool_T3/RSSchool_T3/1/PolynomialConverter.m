#import "PolynomialConverter.h"

@implementation PolynomialConverter
- (NSString*)convertToStringFrom:(NSArray <NSNumber*>*)numbers {
    if (numbers.count == 0){
        return nil;
    }
    NSMutableString *string = [NSMutableString new];
    int count = (int)numbers.count;
    int order = count - 1;
    for (NSNumber *number in numbers) {
        int numberInt = number.intValue;
        NSString *sign = numberInt < 0 ? @"-" : @"+";
        if (numberInt == 0) {
            order--;
            continue;
        }
        if (numbers.count == 1) {
            [string appendFormat:@"%d",numberInt];
            break;
        }
        if ([number isEqual:numbers.firstObject] && [sign isEqualToString:@"+"]) {
            numbers.count == 2 ? [string appendFormat:@"%dx" ,numberInt] : [string appendFormat:@"%dx^%d " ,numberInt ,order];
        }else{
            if (order < 1){
                [string appendFormat:@"%@ %d" ,sign ,numberInt];
                continue;
            }
            if (order == 1) {
                abs(numberInt) == 1 ? [string appendFormat:@"%@ x " ,sign] : [string appendFormat:@"%@ %dx " ,sign ,abs(numberInt)];
                order--;
                continue;
            }
            [string appendFormat:@"%@ %dx^%d " ,sign ,abs(numberInt),order];
        }
        order--;
    }
    return string;
}
@end
