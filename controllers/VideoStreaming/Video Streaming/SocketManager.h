//
//  SocketManager.h
//  ImageOverSocket-test
//
//  Created by Rex Fenley on 2/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSStreamAdditions.h"



@interface WritePacket : NSObject
{
    NSData *data;
    NSUInteger position;
}

@property (retain) NSData *data;
@property (readwrite) NSUInteger position;

@end


@protocol SocketManagerDelegate

@required
- (void)socketErrorOccurred;
- (void)streamEndEncountered;

@end


@interface SocketManager : NSObject <NSStreamDelegate> {
    NSString *host;
    NSUInteger port;
    
    NSInputStream *input_stream;
    NSOutputStream *output_stream;
    
    BOOL functional;
    
    id <SocketManagerDelegate> delegate;
    id <SocketManagerDelegate> appViewController;
    
    NSMutableArray *writeQueue;
}

@property (retain) NSString *host;
@property (nonatomic, retain) NSOutputStream *output_stream;
@property (nonatomic, retain) NSInputStream *input_stream;
@property (nonatomic, assign) id <SocketManagerDelegate> delegate;
@property (nonatomic, assign) id <SocketManagerDelegate> appViewController;


- (id)initSocketStream:(NSString *)host
                  port:(NSUInteger)port
              delegate:(id <SocketManagerDelegate>)theDelegate;
- (BOOL)isFunctional;
- (void)disconnect;

- (void)sendData:(const void *)data numberOfBytes:(int)bytes;
- (BOOL)sendPackets;
- (BOOL)sendPacket;

// Getters/Setters not synthesized
- (NSUInteger)port;
- (void)setPort:(NSUInteger)value;

@end
