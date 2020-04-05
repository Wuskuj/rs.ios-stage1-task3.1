#import "Combinator.h"

@implementation Combinator
- (NSNumber*)chechChooseFromArray:(NSArray <NSNumber*>*)array {
    NSInteger posters = array[0].intValue;
    NSInteger colors = array[1].intValue;
    NSInteger minColorsCount = 2;
    
    NSInteger colorsFactorial = [self factorialCalculation:colors];
    
    if (colors == 1) {
        return array[0];
    }
    
    if (colors == posters) {
        return @1;
    }
    
    for (NSInteger i = minColorsCount; i < colors; i++) {
        NSInteger remains = colors - i;
        NSInteger factRemains = [self factorialCalculation:remains];
        NSInteger factI = [self factorialCalculation:i];
        NSInteger result = colorsFactorial / (factRemains * factI);
        if(result == posters) {
            return [NSNumber numberWithInteger:i];
        }
    }
    return nil;
}

-(NSInteger)factorialCalculation:(NSInteger) numberOfColors {
    return numberOfColors == 0 ? 1 : numberOfColors * [self factorialCalculation:(numberOfColors - 1)] ;
}

@end
