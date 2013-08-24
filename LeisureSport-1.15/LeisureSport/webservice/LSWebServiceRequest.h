//
//  LSWebServiceRequest.h
//  DataFetchASIJSON
//
//  Created by ACE hitsz302 on 12-5-31.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

//需要添加<soap:Body></soap:Body>中的内容
#define SOAP_CONTENT @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n<soap:Body>\n%@</soap:Body>\n</soap:Envelope>\n"
//需要添加<UserName></UserName>,<PassWord></PassWord>,<soap:Body></so1ap:Body>中的内容
#define SOAP_CONTENT_WITHHEAD @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n<soap:Header>\n<MySoapHeader xmlns=\"leisuresport\">\n<UserName>%@</UserName>\n<PassWord>%@</PassWord>\n<Version>1</Version>\n<RetType>json</RetType>\n<ReqPlant>IOS</ReqPlant>\n</MySoapHeader>\n</soap:Header>\n<soap:Body>\n%@</soap:Body>\n</soap:Envelope>\n"


@interface LSWebServiceRequest : NSObject
{
    NSString *soapResult;
    BOOL requestSuccess;
}

@property(nonatomic, retain) NSString *soapResult;

//发送请求，调用webservice。得到的普通数据存储于soapResults，json数据放在jsonObject中 同步下载方式
- (BOOL)requestWithSOAPAction: (NSString*)soapAction SOAPMessage:(NSString*)soapMessage;
@end
