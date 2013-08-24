//
//  SportsDynamicFetcher.m
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-6-8.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "SportsDynamicFetcher.h"
#import "LSWebServiceRequest.h"
#import "LSSoapResultXMLParser.h"
#import "SportsNews.h"
#import "JSONKit.h"

@implementation SportsDynamicFetcher

+ (NSMutableArray *)fetchNewsWithTime:(NSString *)time Count: (NSInteger)count
{
    //从webservice获取数据
    NSString *tmp = [ NSString stringWithFormat:@"<News_LoadByDate xmlns=\"leisuresport\">"
                     "<UserID></UserID>"
                     "<timeStamp>%@</timeStamp>"
                     "<direction>0</direction>"
                     "<mCount>%d</mCount>"
                     "</News_LoadByDate>", time, count];
    NSString *soapAction = @"leisuresport/News_LoadByDate";
    NSString *soapMessage = [NSString stringWithFormat: SOAP_CONTENT_WITHHEAD,@"",@"", tmp];
    
    LSWebServiceRequest *soapRequest = [[LSWebServiceRequest alloc] init];

    NSMutableArray *newsArray = [[NSMutableArray alloc] init];
    //请求成功
    if([soapRequest requestWithSOAPAction:soapAction SOAPMessage:soapMessage])
    {
        LSSoapResultXMLParser *xmlParser = [[[LSSoapResultXMLParser alloc] init] autorelease];
        [xmlParser parseWithData:soapRequest.soapResult SOAPAction:soapAction]; 
        id jsonObject = [xmlParser.result objectFromJSONString];//jsonkit
        
        for (id obj in jsonObject) {      
            SportsNews *sportsNews = [[SportsNews alloc] init];
            for (int i=0; i<[[obj allKeys]count]; i++) {        
                if([@"GameID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    sportsNews.GameID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"ImageUrl" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    sportsNews.ImageUrl = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"NewsID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    sportsNews.NewsID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"PostTime" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    sportsNews.PostTime = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"ShortIntro" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    sportsNews.ShortIntro = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"Title" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    sportsNews.Title = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"UpdateTime" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    sportsNews.UpdateTime = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"Url" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    sportsNews.Url = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
            }   
            [newsArray addObject:sportsNews];
            [sportsNews release];
        } 
    }
    [soapRequest release];
    return [newsArray autorelease];
}

+ (NSMutableArray *)fetchNewsWithTime:(NSString *)time Count: (NSInteger)count Index:(NSString *)index
{
    //从webservice获取数据
    NSString *tmp = [ NSString stringWithFormat:@"<News_LoadByDate_1 xmlns=\"leisuresport\">"
                     "<UserID></UserID>"
                     "<timeStamp>%@</timeStamp>"
                     "<direction>0</direction>"
                     "<mCount>%d</mCount>"
                     "<indexNewsID>%@</indexNewsID>"
                     "</News_LoadByDate_1>", time, count, index];
    NSString *soapAction = @"leisuresport/News_LoadByDate_1";
    NSString *soapMessage = [NSString stringWithFormat: SOAP_CONTENT_WITHHEAD,@"",@"", tmp];
    
    LSWebServiceRequest *soapRequest = [[LSWebServiceRequest alloc] init];
    NSMutableArray *newsArray = [[NSMutableArray alloc] init];
    //请求成功
    if([soapRequest requestWithSOAPAction:soapAction SOAPMessage:soapMessage])
    {
        LSSoapResultXMLParser *xmlParser = [[[LSSoapResultXMLParser alloc] init] autorelease];
        [xmlParser parseWithData:soapRequest.soapResult SOAPAction:soapAction]; 
        id jsonObject = [xmlParser.result objectFromJSONString];//jsonkit
        
        for (id obj in jsonObject) {      
            SportsNews *sportsNews = [[SportsNews alloc] init];
            for (int i=0; i<[[obj allKeys]count]; i++) {        
                if([@"GameID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    sportsNews.GameID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"ImageUrl" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    sportsNews.ImageUrl = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"NewsID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    sportsNews.NewsID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"PostTime" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    sportsNews.PostTime = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"ShortIntro" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    sportsNews.ShortIntro = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"Title" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    sportsNews.Title = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"UpdateTime" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    sportsNews.UpdateTime = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"Url" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    sportsNews.Url = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
            }   
            [newsArray addObject:sportsNews];
            [sportsNews release];
        } 
//        [jsonObject release];
    }
    [soapRequest release];
    return [newsArray autorelease];
}
@end
