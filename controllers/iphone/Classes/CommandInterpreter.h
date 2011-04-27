//
//  CommandInterpreter.h
//  Services-test
//
//  Created by Rex Fenley on 2/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol CommandInterpreterDelegate

// Commands issued here
@required
- (void)do_MC:(NSArray *)args;
- (void)do_DR:(NSArray *)args;
- (void)do_DG:(NSArray *)args;
- (void)do_UB:(NSArray *)args;
- (void)do_UG:(NSArray *)args;
- (void)do_RT:(NSArray *)args;
/** depricated
- (void)do_SC;
- (void)do_PC;
//*/
- (void)do_ST;
- (void)do_PT;
- (void)do_CU;
- (void)do_ET:(NSArray *)args;
- (void)do_SA:(NSArray *)args;
- (void)do_PA:(NSArray *)args;
- (void)do_SS:(NSArray *)args;
- (void)do_PS:(NSArray *)args;

/** Advanced UI junk **/
- (void)do_UX:(NSArray *)args;

// Welcome Message
- (void)do_WM:(NSArray *)args;

// Take pictures
- (void)do_PI:(NSArray *)args;

@end

@interface CommandInterpreter : NSObject {
    id <CommandInterpreterDelegate> delegate;
    NSMutableString *commandLine;
    NSMutableDictionary *commandDictionary;
    
    BOOL firstCommand;
}

@property (nonatomic, assign) id <CommandInterpreterDelegate> delegate;

- (id)init:(id <CommandInterpreterDelegate>)theDelegate;
- (void)createCommandDictionary;
- (void)addBytes:(const uint8_t *)bytes length:(NSUInteger)length;
- (void)parse;
- (void)interpret:(NSString *)command;

@end
