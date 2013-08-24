//
//  LoginAndRegisterFetcher.m
//  LeisureSport
//
//  Created by 高 峰 on 12-6-19.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "LoginAndRegisterFetcher.h"
#import "LSWebServiceRequest.h"
#import "LSSoapResultXMLParser.h"
#import "RegisterResponse.h"
#import "LoginResponse.h"
#import "JSONKit.h"

@implementation LoginAndRegisterFetcher
+ (NSMutableArray *)fetchRegister:(NSString *) loginIDParameter pwd:(NSString *) pwdParameter email:(NSString *) emailParameter nickname:(NSString *)nicknameParameter IMEI:(NSString *) IMEIParameter clientVersion:(NSString *) clientVersionParameter userType:(NSString *) userTypeParameter//用户注册,成功注册,返回USER_ID，使用方法:User_Register('qt@g.com','123','qt@g.com','景驰','000000','V1.0',0);新浪微博用户userType为1，,Android用户userType为1，IOS用户userType为2,userID=-2用户已存在
{
    //从webservice获取数据
    NSString *soapAction = @"leisuresport/User_Register";
    NSString *tmp=[NSString stringWithFormat:@"<User_Register xmlns=\"leisuresport\">"
                   "<loginID>%@</loginID>"
                   "<pwd>%@</pwd>"
                   "<email>%@</email>"
                   "<nickname>%@</nickname>"
                   "<IMEI>%@</IMEI>"
                   "<clientVersion>%@</clientVersion>"
                   "<userType>%@</userType>"
                   "</User_Register>",loginIDParameter,pwdParameter,emailParameter,nicknameParameter,IMEIParameter,clientVersionParameter,userTypeParameter];
    NSString *soapMessage = [NSString stringWithFormat: SOAP_CONTENT_WITHHEAD,@"",@"",tmp];
    
    LSWebServiceRequest *soapRequest = [[[LSWebServiceRequest alloc] init] autorelease];
    NSMutableArray *registerresponseArray = [[NSMutableArray alloc] init];
    //请求成功
    if([soapRequest requestWithSOAPAction:soapAction SOAPMessage:soapMessage])
    {
        LSSoapResultXMLParser *xmlParser = [[[LSSoapResultXMLParser alloc] init] autorelease];
        [xmlParser parseWithData:soapRequest.soapResult SOAPAction:soapAction]; 
        
        id jsonObject = [xmlParser.result objectFromJSONString];//jsonkit
        
        for (id obj in jsonObject) {     
               //         NSLog(@"obj-----jxx%@",obj);
            RegisterResponse *registerresponse = [[RegisterResponse alloc] init];
            for (int i=0; i<[[obj allKeys]count]; i++) {        
                if([@"UserID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    registerresponse.UserID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"userID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    registerresponse.userID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"LoginID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    registerresponse.LoginID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"sex" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    registerresponse.sex = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"Email" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    registerresponse.Email = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"NickName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    registerresponse.NickName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"points" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    registerresponse.points = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"ImageID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    registerresponse.ImageID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"userType" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    registerresponse.userType = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
            }   
            [registerresponseArray addObject:registerresponse];
            [registerresponse release];
        } 
    }
    return registerresponseArray;
}


+ (NSMutableArray *)fetchLogin:(NSString *) loginIDParameter pwd:(NSString *) pwdParameter clientVersion:(NSString *) clientVersionParameter userType:(NSString *) userTypeParameter//用户登录接口，使用方法:User_Login(1,'123','V1.0',0);新浪微博用户userType为1，,Android用户userType为1，IOS用户userType为2，loginID为登陆ID，pwd密码，clientVersion客户端版本号返回值：正常返回userID >0;返回-2密码错误，-3用户不存在
{
    //从webservice获取数据
    NSString *soapAction = @"leisuresport/User_Login";
    NSString *tmp=[NSString stringWithFormat:@"<User_Login xmlns=\"leisuresport\">"
                   "<loginID>%@</loginID>"
                   "<pwd>%@</pwd>"
                   "<clientVersion>%@</clientVersion>"
                   "<userType>%@</userType>"
                   "</User_Login>",loginIDParameter,pwdParameter,clientVersionParameter,userTypeParameter];
    NSString *soapMessage = [NSString stringWithFormat: SOAP_CONTENT_WITHHEAD,@"",@"",
							 tmp];
    
    LSWebServiceRequest *soapRequest = [[[LSWebServiceRequest alloc] init] autorelease];
    NSMutableArray *LoginresponseArray = [[NSMutableArray alloc] init];
    //请求成功
    if([soapRequest requestWithSOAPAction:soapAction SOAPMessage:soapMessage])
    {
        LSSoapResultXMLParser *xmlParser = [[[LSSoapResultXMLParser alloc] init] autorelease];
        [xmlParser parseWithData:soapRequest.soapResult SOAPAction:soapAction]; 
        
        id jsonObject = [xmlParser.result objectFromJSONString];//jsonkit
        
        for (id obj in jsonObject) {     
                        NSLog(@"obj-----%@",obj);
            LoginResponse *Loginresponse = [[LoginResponse alloc] init];
            for (int i=0; i<[[obj allKeys]count]; i++) {        
                if([@"UserID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    Loginresponse.UserID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"LoginID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    Loginresponse.LoginID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"sex" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    Loginresponse.sex = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"Email" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    Loginresponse.Email = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"NickName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    Loginresponse.NickName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"points" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    Loginresponse.points = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"ImageID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    Loginresponse.ImageID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"userType" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    Loginresponse.userType = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
            }   
            [LoginresponseArray addObject:Loginresponse];
            [Loginresponse release];
        } 
    }
    return LoginresponseArray;
}

+ (NSString *)fetchVersion
{
    //从webservice获取数据
    NSString *soapAction = @"leisuresport/getLatestVersion";

    NSString *soapMessage = [NSString stringWithFormat: SOAP_CONTENT_WITHHEAD,@"",@"",@"<getLatestVersion xmlns=\"leisuresport\">""</getLatestVersion>"];
    
    LSWebServiceRequest *soapRequest = [[[LSWebServiceRequest alloc] init] autorelease];
    //请求成功
    LSSoapResultXMLParser *xmlParser = [[[LSSoapResultXMLParser alloc] init] autorelease];
    if([soapRequest requestWithSOAPAction:soapAction SOAPMessage:soapMessage])
    {
        [xmlParser parseWithData:soapRequest.soapResult SOAPAction:soapAction]; 
        //NSLog(@"xmlParser.result11111:%@",xmlParser.result);
        
    }
    return xmlParser.result;
}

+ (NSString *)fetchFeedback:(NSString *) mainContent email:(NSString *) emailParameter IMEI:(NSString *) IMEIParameter userID:(NSString *) userIDParameter//用户反馈
{
    //从webservice获取数据
    NSString *soapAction = @"leisuresport/Sys_ls_Feedback";
    
    NSString *tmp=[NSString stringWithFormat:@"<Sys_ls_Feedback xmlns=\"leisuresport\">"
                   "<mainContent>%@</mainContent>"
                   "<email>%@</email>"
                   "<IMEI>%@</IMEI>"
                   "<userID>%@</userID>"
                   "</Sys_ls_Feedback>",mainContent,emailParameter,IMEIParameter,userIDParameter];
    NSString *soapMessage = [NSString stringWithFormat: SOAP_CONTENT_WITHHEAD,@"",@"",tmp];
    
    LSWebServiceRequest *soapRequest = [[[LSWebServiceRequest alloc] init] autorelease];
    //请求成功
    LSSoapResultXMLParser *xmlParser = [[[LSSoapResultXMLParser alloc] init] autorelease];
    if([soapRequest requestWithSOAPAction:soapAction SOAPMessage:soapMessage])
    {
        [xmlParser parseWithData:soapRequest.soapResult SOAPAction:soapAction]; 
        //NSLog(@"xmlParser.result11111:%@",xmlParser.result);
        
    }
    return xmlParser.result;
}

+ (NSString *)fetchFindPassword:(NSString *) loginID
{
    //从webservice获取数据
    NSString *soapAction = @"leisuresport/User_FindPwd";
    
    NSString *tmp=[NSString stringWithFormat:@"<User_FindPwd xmlns=\"leisuresport\">"
                   "<LoginID>%@</LoginID>"
                   "</User_FindPwd>",loginID];
    NSString *soapMessage = [NSString stringWithFormat: SOAP_CONTENT_WITHHEAD,@"",@"",tmp];
    
    LSWebServiceRequest *soapRequest = [[[LSWebServiceRequest alloc] init] autorelease];
    //请求成功
    LSSoapResultXMLParser *xmlParser = [[[LSSoapResultXMLParser alloc] init] autorelease];
    if([soapRequest requestWithSOAPAction:soapAction SOAPMessage:soapMessage])
    {
        [xmlParser parseWithData:soapRequest.soapResult SOAPAction:soapAction]; 
        //NSLog(@"xmlParser.result11111:%@",xmlParser.result);
        
    }
    return xmlParser.result;
}
@end
