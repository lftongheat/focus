//
//  LSSoapResultXMLParser.m
//  DataFetchASIJSON
//
//  Created by ACE hitsz302 on 12-5-31.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "LSSoapResultXMLParser.h"

@implementation LSSoapResultXMLParser
@synthesize result;
//@synthesize tmpResult;

- (void) parseWithData: (NSString*)data SOAPAction:(NSString*)soapAction
{
    resultXmlName = [[NSMutableString alloc] init];
    NSRange slashRange = [soapAction rangeOfString:@"/"];
    [resultXmlName appendFormat:@"%@Result", [soapAction substringFromIndex:slashRange.location+1]];
    
    xmlParser = [[NSXMLParser alloc] initWithData:[data dataUsingEncoding:NSUTF8StringEncoding]];
	[xmlParser setDelegate: self];
	[xmlParser setShouldResolveExternalEntities: YES];
	[xmlParser parse];
}

//XMLParser
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
//	NSLog(@"xml 1 parser didStarElemen: namespaceURI: attributes:");
//    NSLog(resultXmlName);
    if( [elementName isEqualToString:resultXmlName])
	{
//        if (tmpResult)
//        {
//            NSLog(@"tmpResult release!");
//            [tmpResult release];
//            tmpResult = nil;
//        }
//        
        tmpResult = [[NSMutableString alloc] init];
//        NSLog(@"tmpResult alloc and init!");
	}
	
}


-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
//	NSLog(@"xml 2 parser: foundCharacters:");
    if (tmpResult) {
        [tmpResult appendString: string];
    }
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
//	NSLog(@"xml 3 parser: didEndElement:");
//    if (tmpResult) {
//        if (result)
//        {
//            NSLog(@"result release!");
//            [result release];
//            result = nil;
//        }
//       result = [[NSString alloc] initWithString:tmpResult]; 
//        NSLog(@"result alloc and initWithString!");
//    }
	
}
- (void)parserDidStartDocument:(NSXMLParser *)parser{
//	NSLog(@"-------------------start--------------");
}
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    result = [[NSString alloc] initWithString:tmpResult];
//	NSLog(@"-------------------end--------------");
}

- (void)dealloc 
{
	[xmlParser release];	
    if (tmpResult){
//        NSLog(@"tmpResult release!");
        [tmpResult release];
        tmpResult = nil;
    }
    if (result) {
//        NSLog(@"result release!");
        [result release];
        result = nil;
    }
    if (resultXmlName) 
        [resultXmlName release];
	[super dealloc];
}

@end
