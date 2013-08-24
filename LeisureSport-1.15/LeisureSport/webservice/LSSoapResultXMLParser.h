//
//  LSSoapResultXMLParser.h
//  DataFetchASIJSON
//
//  Created by ACE hitsz302 on 12-5-31.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSSoapResultXMLParser : NSObject <NSXMLParserDelegate> 
{
    NSMutableString *resultXmlName;
    NSXMLParser *xmlParser;
    NSMutableString *tmpResult;
    NSString *result;
}

@property(nonatomic, retain) NSString *result;
//@property(nonatomic, retain) NSMutableString *tmpResult;

//根据数据以及结果的xml名字解析得到所要的数据
- (void)parseWithData: (NSString*)data SOAPAction:(NSString*)soapAction;

@end