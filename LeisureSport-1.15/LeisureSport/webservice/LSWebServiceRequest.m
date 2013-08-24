//
//  LSWebServiceRequest.m
//  DataFetchASIJSON
//
//  Created by ACE hitsz302 on 12-5-31.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "LSWebServiceRequest.h"
#import "LSUtil.h"

@implementation LSWebServiceRequest
@synthesize soapResult;

- (BOOL)requestWithSOAPAction: (NSString*)soapAction SOAPMessage:(NSString*)soapMessage
{    
    NSURL *url = [NSURL URLWithString:@"http://113.106.89.74:8081/leisuresport/leisuresport.asmx"];
    NSMutableURLRequest *soapRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	[soapRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[soapRequest addValue: soapAction forHTTPHeaderField:@"SOAPAction"];
	[soapRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[soapRequest setHTTPMethod:@"POST"];
	[soapRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];

    NSURLResponse *response;
    NSError *error;
    //在模拟器上 无网络时会在这里中断
    if (![LSUtil connectedToNetwork]) {
        return NO;
    }
    NSData *result = [NSURLConnection sendSynchronousRequest:soapRequest returningResponse:&response error:&error];
    if(!result)
        return NO;
    else if([response expectedContentLength] < 0)
        return NO;
    else
    {
        NSMutableData *data = [NSMutableData dataWithData:result];
        soapResult = [[NSString alloc] initWithBytes: [data mutableBytes] length:[data length] encoding:NSUTF8StringEncoding];
        return YES;
    }
        
}

- (void) dealloc
{
    if (soapResult){
        [soapResult release];
        soapResult = nil;
    }
    [super dealloc];
}

@end
