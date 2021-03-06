//
//  TrickplayRectangle.m
//  TrickplayController
//
//  Created by Rex Fenley on 4/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TrickplayRectangle.h"

@implementation TrickplayRectangle

- (id)initWithID:(NSString *)rectID args:(NSDictionary *)args objectManager:(AdvancedUIObjectManager *)objectManager {
    if ((self = [super initWithID:rectID objectManager:objectManager])) {
        self.view = [[[UIView alloc] init] autorelease];
        view.layer.anchorPoint = CGPointMake(0.0, 0.0);
        
        view.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        [self setValuesFromArgs:args];
        
        [self addSubview:view];        
    }
    
    return self;
}

#pragma mark -
#pragma mark Deleter

/**
 * Deleter function
 */

- (void)deleteValuesFromArgs:(NSDictionary *)properties {
    for (NSString *property in [properties allKeys]) {
        SEL selector = NSSelectorFromString([NSString stringWithFormat:@"delete_%@:", property]);
        
        if ([TrickplayRectangle instancesRespondToSelector:selector]) {
            [self performSelector:selector withObject:properties];
        }
    }
}

#pragma mark -
#pragma mark Setters

/**
 * Setter function
 */

- (void)setValuesFromArgs:(NSDictionary *)properties {
    for (NSString *property in [properties allKeys]) {
        SEL selector = NSSelectorFromString([NSString stringWithFormat:@"set_%@:", property]);
        
        if ([TrickplayRectangle instancesRespondToSelector:selector]) {
            [self performSelector:selector withObject:properties];
        } else {
            selector = NSSelectorFromString([NSString stringWithFormat:@"do_set_%@:", property]);
            if ([TrickplayRectangle instancesRespondToSelector:selector]) {
                [self performSelector:selector withObject:properties];
            }
        }
    }
}

/**
 * Set the color of the rectangle
 */

- (void)set_color:(NSDictionary *)args {
    // ** Get the color and alpha values **
    CGFloat red, green, blue, alpha;
    if ([[args objectForKey:@"color"] isKindOfClass:[NSArray class]]) {
        NSArray *colorArray = [args objectForKey:@"color"];
        if (!colorArray || [colorArray count] < 3) {
            return;
        }
    
        red = [(NSNumber *)[colorArray objectAtIndex:0] floatValue]/255.0;
        green = [(NSNumber *)[colorArray objectAtIndex:1] floatValue]/255.0;
        blue = [(NSNumber *)[colorArray objectAtIndex:2] floatValue]/255.0;
    
        if ([colorArray count] > 3) {
            alpha = [(NSNumber *)[colorArray objectAtIndex:3] floatValue]/255.0;
        } else {
            alpha = CGColorGetAlpha(view.backgroundColor.CGColor);
        }
    } else if ([[args objectForKey:@"color"] isKindOfClass:[NSString class]]) {
        NSString *hexString = [args objectForKey:@"color"];
        if (!hexString || [hexString length] < 6) {
            return;
        }
        
        unsigned int value;
        
        if ([hexString characterAtIndex:0] == '#') {
            hexString = [hexString substringFromIndex:1];
        }
        
        [[NSScanner scannerWithString:hexString] scanHexInt:&value];
        if ([hexString length] > 6) {
            // alpha exists
            red = ((value & 0xFF000000) >> 24)/255.0;
            green = ((value & 0x00FF0000) >> 16)/255.0;
            blue = ((value & 0x0000FF00) >> 8)/255.0;
            alpha = (value & 0x000000FF)/255.0;
        } else {
            // just RGB
            red = ((value & 0xFF0000) >> 16)/255.0;
            green = ((value & 0x00FF00) >> 8)/255.0;
            blue = (value & 0x0000FF)/255.0;
            alpha = CGColorGetAlpha(view.backgroundColor.CGColor);
        }
    } else {
        return;
    }
    
    view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


/**
 * Set border color
 */

- (void)set_border_color:(NSDictionary *)args {
    CGFloat red, green, blue, alpha;
    if ([[args objectForKey:@"border_color"] isKindOfClass:[NSArray class]]) {
        NSArray *colorArray = [args objectForKey:@"border_color"];
        if (!colorArray || [colorArray count] < 3) {
            return;
        }
        
        red = [(NSNumber *)[colorArray objectAtIndex:0] floatValue]/255.0;
        green = [(NSNumber *)[colorArray objectAtIndex:1] floatValue]/255.0;
        blue = [(NSNumber *)[colorArray objectAtIndex:2] floatValue]/255.0;
        
        if ([colorArray count] > 3) {
            alpha = [(NSNumber *)[colorArray objectAtIndex:3] floatValue]/255.0;
        } else {
            alpha = CGColorGetAlpha(view.layer.borderColor);
        }
    } else if ([[args objectForKey:@"border_color"] isKindOfClass:[NSString class]]) {
        NSString *hexString = [args objectForKey:@"border_color"];
        if (!hexString || [hexString length] < 6) {
            return;
        }
        
        unsigned int value;
        
        if ([hexString characterAtIndex:0] == '#') {
            hexString = [hexString substringFromIndex:1];
        }
        
        [[NSScanner scannerWithString:hexString] scanHexInt:&value];
        if ([hexString length] > 6) {
            // alpha exists
            red = ((value & 0xFF000000) >> 24)/255.0;
            green = ((value & 0x00FF0000) >> 16)/255.0;
            blue = ((value & 0x0000FF00) >> 8)/255.0;
            alpha = (value & 0x000000FF)/255.0;
        } else {
            // just RGB
            red = ((value & 0xFF0000) >> 16)/255.0;
            green = ((value & 0x00FF00) >> 8)/255.0;
            blue = (value & 0x0000FF)/255.0;
            alpha = CGColorGetAlpha(view.layer.borderColor);
        }
    } else {
        return;
    }
    
    view.layer.borderColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha].CGColor;
}


/**
 * Set border width
 */

- (void)set_border_width:(NSDictionary *)args {
    CGFloat borderWidth = [(NSNumber *)[args objectForKey:@"border_width"] floatValue];
    
    if (borderWidth) {
        view.layer.borderWidth = borderWidth;
    }
}

#pragma mark -
#pragma mark Getters

/**
 * Get color
 */

- (void)get_color:(NSMutableDictionary *)dictionary {
    NSNumber *red, *green, *blue, *alpha;
        
    const CGFloat *components = CGColorGetComponents(view.backgroundColor.CGColor);
    red = [NSNumber numberWithFloat:components[0] * 255.0];
    green = [NSNumber numberWithFloat:components[1] * 255.0];
    blue = [NSNumber numberWithFloat:components[2] * 255.0];
    alpha = [NSNumber numberWithFloat:CGColorGetAlpha(view.backgroundColor.CGColor) * 255.0];
        
    NSArray *colorArray = [NSArray arrayWithObjects:red, green, blue, alpha, nil];
    [dictionary setObject:colorArray forKey:@"color"];
}

/**
 * Get border color
 */

- (void)get_border_color:(NSMutableDictionary *)dictionary {
    NSNumber *red, *green, *blue, *alpha;
        
    const CGFloat *components = CGColorGetComponents(view.layer.borderColor);
    red = [NSNumber numberWithFloat:components[0] * 255.0];
    green = [NSNumber numberWithFloat:components[1] * 255.0];
    blue = [NSNumber numberWithFloat:components[2] * 255.0];
    alpha = [NSNumber numberWithFloat:CGColorGetAlpha(view.layer.borderColor) * 255.0];
        
    NSArray *colorArray = [NSArray arrayWithObjects:red, green, blue, alpha, nil];
    [dictionary setObject:colorArray forKey:@"border_color"];
}

/**
 * Get border width
 */

- (void)get_border_width:(NSMutableDictionary *)dictionary {
    [dictionary setObject:[NSNumber numberWithFloat:view.layer.borderWidth] forKey:@"border_width"];
}

/**
 * Getter function
 */

- (NSDictionary *)getValuesFromArgs:(NSDictionary *)properties {
    NSMutableDictionary *JSON_Dictionary = [NSMutableDictionary dictionaryWithDictionary:properties];
    
    for (NSString *property in [properties allKeys]) {
        SEL selector = NSSelectorFromString([NSString stringWithFormat:@"get_%@:", property]);
        
        if ([TrickplayRectangle instancesRespondToSelector:selector]) {
            [self performSelector:selector withObject:JSON_Dictionary];
        } else {
            [JSON_Dictionary removeObjectForKey:property];
        }
    }
    
    return JSON_Dictionary;
}

#pragma mark -
#pragma mark New Protocol

- (id)callMethod:(NSString *)method withArgs:(NSArray *)args {
    return [super callMethod:method withArgs:args];
}


- (void)dealloc {
    NSLog(@"TrickplayRectangle dealloc");
    
    [super dealloc];
}

@end
