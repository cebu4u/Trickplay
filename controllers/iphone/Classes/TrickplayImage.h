//
//  TrickplayImage.h
//  TrickplayController
//
//  Created by Rex Fenley on 4/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrickplayUIElement.h"
#import "ResourceManager.h"

@interface TrickplayImage : TrickplayUIElement {
    
}

- (id)initWithID:(NSString *)imageID args:(NSDictionary *)args resourceManager:(ResourceManager *)resourceManager;

@end