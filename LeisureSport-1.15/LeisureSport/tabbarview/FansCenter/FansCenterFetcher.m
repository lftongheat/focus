//
//  FansCenterFetcher.m
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-6-4.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "FansCenterFetcher.h"
#import "LSWebServiceRequest.h"
#import "LSSoapResultXMLParser.h"
#import "UserTaskInfo.h"
#import "LeagueInfo.h"
#import "Comment.h"
#import "Follower.h"
#import "Fans.h"
#import "Message.h"
#import "Team.h"
#import "JSONKit.h"

#import "UserInfoPlistIO.h"

@implementation FansCenterFetcher

+ (UserInfo *)fetchUserInfo: (NSString *)userID myUserID:(NSString *)myUserID
{
    NSString *tmp = [ NSString stringWithFormat:@"<User_GetAllInfo xmlns=\"leisuresport\">"
                     "<userID>%@</userID>"
                     "<myUserID>%@</myUserID>"
                     "<userType>2</userType>"
                     "</User_GetAllInfo>", userID, myUserID];
    //从webservice获取数据
    NSString *soapAction = @"leisuresport/User_GetAllInfo";
    NSString *soapMessage = [NSString stringWithFormat: SOAP_CONTENT_WITHHEAD,@"",@"", tmp];
    
    LSWebServiceRequest *soapRequest = [[LSWebServiceRequest alloc] init];
    UserInfo *userInfo = [[UserInfo alloc] init];
    //请求成功
    if([soapRequest requestWithSOAPAction:soapAction SOAPMessage:soapMessage])
    {
        LSSoapResultXMLParser *xmlParser = [[LSSoapResultXMLParser alloc] init];
        [xmlParser parseWithData:soapRequest.soapResult SOAPAction:soapAction];         
        id jsonObject = [xmlParser.result objectFromJSONString];//jsonkit
        [xmlParser release];        
        
        for (id obj in jsonObject) {                            
            for (int i=0; i<[[obj allKeys]count]; i++) {        
                if([@"BetPoints" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    userInfo.BetPoints = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"CommentsCount" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    userInfo.CommentsCount = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"Email" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    userInfo.Email = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"FollowCount" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    userInfo.FollowCount = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"FollowerCount" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    userInfo.FollowerCount = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"ImageID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    userInfo.ImageID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"IsFocus" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    userInfo.IsFocus = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"LoginID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    userInfo.LoginID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"MessagesCount" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    userInfo.MessagesCount = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"NewFansNumber" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    userInfo.NewFansNumber = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"NewMessageNumber" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    userInfo.NewMessageNumber = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"NickName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    userInfo.NickName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"TotalAwardPoints" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    userInfo.TotalAwardPoints = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"TotalBetPoints" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    userInfo.TotalBetPoints = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"UserFavorTeams" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    userInfo.UserFavorTeams = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"UserID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    userInfo.UserID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"introduce" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    userInfo.introduce = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"points" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    userInfo.points = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"sex" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    userInfo.sex = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];               
            }                
        }
    }
    [soapRequest release];
    return userInfo;
}

+ (BOOL)updateUserInfo:(UserInfo *)userInfo
{
    UserInfoPlistIO *userInfoPlistIO = [[UserInfoPlistIO alloc] init];
    NSString *userPassword = [[userInfoPlistIO readUserPassword:@""] mutableCopy];
    [userInfoPlistIO release];
    NSString *tmp = [NSString stringWithFormat:@"<User_AlterBasicInfo xmlns=\"leisuresport\">"
                     "<userID>%@</userID>"
                     "<pwd>%@</pwd>"
                     "<email>%@</email>"
                     "<nickname>%@</nickname>"
                     "<sex>%@</sex>"
                     "<introduce>%@</introduce>"
                     "</User_AlterBasicInfo>", userInfo.UserID, userPassword, userInfo.Email, userInfo.NickName, userInfo.sex, userInfo.introduce ];
    NSString *soapAction = @"leisuresport/User_AlterBasicInfo";
    NSString *soapMessage = [NSString stringWithFormat: SOAP_CONTENT,tmp];
    //    NSLog(soapMessage);
    LSWebServiceRequest *soapRequest = [[[LSWebServiceRequest alloc] init] autorelease];
    //请求成功
    if([soapRequest requestWithSOAPAction:soapAction SOAPMessage:soapMessage])
    {
        LSSoapResultXMLParser *xmlParser = [[[LSSoapResultXMLParser alloc] init] autorelease];
        [xmlParser parseWithData:soapRequest.soapResult SOAPAction:soapAction]; 
        
        int relValue = [xmlParser.result intValue];
        if (relValue == 0)
            return YES;
        else
            return NO;
        
    }
    return NO;
}

+ (NSMutableArray *)fetchTaskInfoWithUserID: (NSString *)userID
{
    NSString *tmp = [NSString stringWithFormat:@"<Task_LoadAllInUse xmlns=\"leisuresport\">"
                     "<UserID>%@</UserID>"
                     "</Task_LoadAllInUse>",userID];
    //从webservice获取数据
    NSString *soapAction = @"leisuresport/Task_LoadAllInUse";
    NSString *soapMessage = [NSString stringWithFormat: SOAP_CONTENT_WITHHEAD,@"",@"",tmp];
    
    LSWebServiceRequest *soapRequest = [[LSWebServiceRequest alloc] init];
    NSMutableArray *taskInfoArray = [[NSMutableArray alloc] init];
    //请求成功
    if([soapRequest requestWithSOAPAction:soapAction SOAPMessage:soapMessage])
    {
        LSSoapResultXMLParser *xmlParser = [[LSSoapResultXMLParser alloc] init];
        [xmlParser parseWithData:soapRequest.soapResult SOAPAction:soapAction]; 
        id jsonObject = [xmlParser.result objectFromJSONString];//jsonkit
        [xmlParser release];
        
        for (id obj in jsonObject) {      
            UserTaskInfo *taskInfo = [[UserTaskInfo alloc] init];
            for (int i=0; i<[[obj allKeys]count]; i++) {        
                if([@"EndDate" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    taskInfo.EndDate = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"ImageID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    taskInfo.ImageID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"Introduce" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    taskInfo.Introduce = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"IsFinished" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    taskInfo.IsFinished = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"IsInUse" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    taskInfo.IsInUse = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"RepeatType" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    taskInfo.RepeatType = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"RewardPoints" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    taskInfo.RewardPoints = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"StartDate" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    taskInfo.StartDate = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"TaskID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    taskInfo.TaskID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"TaskTypeID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    taskInfo.TaskTypeID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"TaskTypeName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    taskInfo.TaskTypeName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"Title" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    taskInfo.Title = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
            }   
            [taskInfoArray addObject:taskInfo];
            [taskInfo release];
        } 
    }
    [soapRequest release];
    return [taskInfoArray autorelease];
}

+ (NSMutableArray *)fetchFollowerWithUserID:(NSString *)userID Time:(NSString *)time Count: (NSInteger) count Index:(NSString *)index Online:(NSString *)flag
{
    //从webservice获取数据
    NSString *tmp = [ NSString stringWithFormat:@"<User_Followers_LoadByUserID xmlns=\"leisuresport\">"
                     "<UserID>%@</UserID>"
                     "<TimeStamp>%@</TimeStamp>"
                     "<indexUserID>%@</indexUserID>"
                     "<count>%d</count>"
                     "<direction>0</direction>"
                     "<OnlineFlag>%@</OnlineFlag>"
                     "</User_Followers_LoadByUserID>",userID, time,index, count, flag];
    NSString *soapAction = @"leisuresport/User_Followers_LoadByUserID";
    NSString *soapMessage = [NSString stringWithFormat: SOAP_CONTENT_WITHHEAD,@"",@"",tmp];
    
    LSWebServiceRequest *soapRequest = [[[LSWebServiceRequest alloc] init] autorelease];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    //请求成功
    if([soapRequest requestWithSOAPAction:soapAction SOAPMessage:soapMessage])
    {
        LSSoapResultXMLParser *xmlParser = [[[LSSoapResultXMLParser alloc] init] autorelease];
        [xmlParser parseWithData:soapRequest.soapResult SOAPAction:soapAction]; 

        id jsonObject = [xmlParser.result objectFromJSONString];//jsonkit
        
        for (id obj in jsonObject) {    
            Follower *follower = [[Follower alloc] init];
            for (int i=0; i<[[obj allKeys]count]; i++) {        
                if([@"ImageID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    follower.ImageID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"LastLoginTime" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    follower.LastLoginTime = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"NickName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    follower.NickName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"PersonelInfo" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    follower.PersonelInfo = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"UserID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    follower.UserID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"dt" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    follower.dt = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"isOnLine" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    follower.isOnLine = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"sex" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    follower.sex = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
            }     
            [array addObject:follower];
            [follower release];
        }
    }
    return [array autorelease];
}

+ (NSMutableArray *)fetchFansWithUserID:(NSString *)userID Time:(NSString *)time Count: (NSInteger) count Index:(NSString *)index Online:(NSString *)flag
{
    //从webservice获取数据
    NSString *tmp = [ NSString stringWithFormat:@"<User_Fans_LoadByUserID xmlns=\"leisuresport\">"
                     "<UserID>%@</UserID>"
                     "<srcUserID></srcUserID>"
                     "<TimeStamp>%@</TimeStamp>"
                     "<indexUserID>%@</indexUserID>"
                     "<count>%d</count>"
                     "<direction>0</direction>"
                     "<OnlineFlag>%@</OnlineFlag>"
                     "</User_Fans_LoadByUserID>", userID, time, index, count, flag];
    NSString *soapAction = @"leisuresport/User_Fans_LoadByUserID";
    NSString *soapMessage = [NSString stringWithFormat: SOAP_CONTENT_WITHHEAD,@"",@"",tmp];
    
    LSWebServiceRequest *soapRequest = [[[LSWebServiceRequest alloc] init] autorelease];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    //请求成功
    if([soapRequest requestWithSOAPAction:soapAction SOAPMessage:soapMessage])
    {
        LSSoapResultXMLParser *xmlParser = [[[LSSoapResultXMLParser alloc] init] autorelease];
        [xmlParser parseWithData:soapRequest.soapResult SOAPAction:soapAction]; 
        
        id jsonObject = [xmlParser.result objectFromJSONString];//jsonkit
        
        for (id obj in jsonObject) {    
            Fans *fans = [[Fans alloc] init];
            for (int i=0; i<[[obj allKeys]count]; i++) {        
                if([@"ImageID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    fans.ImageID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"LastLoginTime" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    fans.LastLoginTime = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"NickName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    fans.NickName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"PersonelInfo" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    fans.PersonelInfo = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"UserFavorTeams" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    fans.UserFavorTeams = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"UserID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    fans.UserID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"dt" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    fans.dt = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"isOnLine" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    fans.isOnLine = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"sex" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    fans.sex = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
            }     
            [array addObject:fans];
            [fans release];
        }
    }
    return [array autorelease];
}
+ (NSMutableArray *)fetchCommentWithUserID:(NSString *)userID Time:(NSString *)time Count: (NSInteger) count Index:(NSString *)index
{
    //从webservice获取数据
    NSString *tmp = [ NSString stringWithFormat:@"<Comment_LoadByUserID xmlns=\"leisuresport\">"
                     "<UserID>%@</UserID>"
                     "<TimeStamp>%@</TimeStamp>"
                     "<count>%d</count>"
                     "<direction>0</direction>"
                     "<indexCommentID>%@</indexCommentID>"
                     "</Comment_LoadByUserID>", userID, time, count, index];
    NSString *soapAction = @"leisuresport/Comment_LoadByUserID";
    NSString *soapMessage = [NSString stringWithFormat: SOAP_CONTENT_WITHHEAD,@"",@"",tmp];
    
    LSWebServiceRequest *soapRequest = [[[LSWebServiceRequest alloc] init] autorelease];
    NSMutableArray *commentArray = [[NSMutableArray alloc] init];
    //请求成功
    if([soapRequest requestWithSOAPAction:soapAction SOAPMessage:soapMessage])
    {
        LSSoapResultXMLParser *xmlParser = [[[LSSoapResultXMLParser alloc] init] autorelease];
        [xmlParser parseWithData:soapRequest.soapResult SOAPAction:soapAction]; 
        
        id jsonObject = [xmlParser.result objectFromJSONString];//jsonkit
        
        for (id obj in jsonObject) {    
            Comment *comment = [[Comment alloc] init];
            for (int i=0; i<[[obj allKeys]count]; i++) {        
                if([@"AwayTeamName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    comment.AwayTeamName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"CommentID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    comment.CommentID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"Contents" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    comment.Contents = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"GameID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    comment.GameID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"GameTime" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    comment.GameTime = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"GameTypeName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    comment.GameTypeName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"HomeTeamName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    comment.HomeTeamName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"LeaugeName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    comment.LeaugeName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"NickName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    comment.NickName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"UserID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    comment.UserID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"UserImageID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    comment.UserImageID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"NickName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    comment.NickName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"time" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    comment.time = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];    
            }     
            [commentArray addObject:comment];
            [comment release];
        }
    }
    return [commentArray autorelease];
}
+ (NSMutableArray *)fetchMessageWithUserID:(NSString *)userID Time:(NSString *)time Count: (NSInteger) count
{
    //从webservice获取数据
    NSString *tmp = [ NSString stringWithFormat:@"<User_Message_LoadByUserID xmlns=\"leisuresport\">"
                     "<UserID>%@</UserID>"
                     "<TimeStamp>%@</TimeStamp>"
                     "<count>%d</count>"
                     "<direction>0</direction>"
                     "</User_Message_LoadByUserID>", userID, time, count];
    NSString *soapAction = @"leisuresport/User_Message_LoadByUserID";
    NSString *soapMessage = [NSString stringWithFormat: SOAP_CONTENT_WITHHEAD,@"",@"",tmp];
    
    LSWebServiceRequest *soapRequest = [[[LSWebServiceRequest alloc] init] autorelease];
    NSMutableArray *commentArray = [[NSMutableArray alloc] init];
    //请求成功
    if([soapRequest requestWithSOAPAction:soapAction SOAPMessage:soapMessage])
    {
        LSSoapResultXMLParser *xmlParser = [[[LSSoapResultXMLParser alloc] init] autorelease];
        [xmlParser parseWithData:soapRequest.soapResult SOAPAction:soapAction]; 
        id jsonObject = [xmlParser.result objectFromJSONString];//jsonkit
        
        for (id obj in jsonObject) {    
            Message *msg = [[Message alloc] init];
            for (int i=0; i<[[obj allKeys]count]; i++) {        
                if([@"FromUserID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    msg.FromUserID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"FromUserImageID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    msg.FromUserImageID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"FromUserIsOnline" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    msg.FromUserIsOnline = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"FromUserNickName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    msg.FromUserNickName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"FromUserSex" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    msg.FromUserSex = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"MainContent" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    msg.MainContent = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"MessageDT" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    msg.MessageDT = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"MessageID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    msg.MessageID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"RowNumber" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    msg.RowNumber = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"ToUserID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    msg.ToUserID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"ToUserImageID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    msg.ToUserImageID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"ToUserIsOnline" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    msg.ToUserIsOnline = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"ToUserNickName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    msg.ToUserNickName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"ToUserSex" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    msg.ToUserSex = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"UnReadNum" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    msg.UnReadNum = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"UserID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    msg.UserID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"readFlag" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    msg.readFlag = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];   
            }     
            [commentArray addObject:msg];
            [msg release];
        }
    }
    return [commentArray autorelease];
}

+ (NSMutableArray *)fetchLeagues
{
    //从webservice获取数据
    NSString *soapAction = @"leisuresport/Leauge_LoadAll";
    NSString *soapMessage = [NSString stringWithFormat: SOAP_CONTENT_WITHHEAD,@"",@"",
							 @"<Leauge_LoadAll xmlns=\"leisuresport\" />"
							 ];
    
    LSWebServiceRequest *soapRequest = [[LSWebServiceRequest alloc] init];
    NSMutableArray *leagueArray = [[NSMutableArray alloc] init];
    //请求成功
    if([soapRequest requestWithSOAPAction:soapAction SOAPMessage:soapMessage])
    {
        LSSoapResultXMLParser *xmlParser = [[LSSoapResultXMLParser alloc] init];
        [xmlParser parseWithData:soapRequest.soapResult SOAPAction:soapAction];        
        id jsonObject = [xmlParser.result objectFromJSONString];//jsonkit
        [xmlParser release];
        
        for (id obj in jsonObject) {      
            LeagueInfo *leagueInfo = [[LeagueInfo alloc] init];
            for (int i=0; i<[[obj allKeys]count]; i++) {        
                if([@"Country" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    leagueInfo.Country = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"GameTypeID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    leagueInfo.GameTypeID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"Introduce" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    leagueInfo.Introduce = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"GameTypeName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    leagueInfo.GameTypeName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"LeaugeID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    leagueInfo.LeaugeID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"Name" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    leagueInfo.Name = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"todaygamenum" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    leagueInfo.todaygamenum = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
            }   
            [leagueArray addObject:leagueInfo];
            [leagueInfo release];
        } 
    }
    [soapRequest release];
    return [leagueArray autorelease];
}


+ (NSMutableArray *)fetchFavorTeam: (NSString *)userID
{
    //从webservice获取数据
    NSString *tmp = [ NSString stringWithFormat:@"<Team_LoadByUserFavor xmlns=\"leisuresport\">"
                     "<UserID>%@</UserID>"
                     "</Team_LoadByUserFavor>", userID];
    NSString *soapAction = @"leisuresport/Team_LoadByUserFavor";
    NSString *soapMessage = [NSString stringWithFormat: SOAP_CONTENT_WITHHEAD,@"",@"",tmp];
    
    LSWebServiceRequest *soapRequest = [[[LSWebServiceRequest alloc] init] autorelease];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    //请求成功
    if([soapRequest requestWithSOAPAction:soapAction SOAPMessage:soapMessage])
    {
        LSSoapResultXMLParser *xmlParser = [[LSSoapResultXMLParser alloc] init];
        [xmlParser parseWithData:soapRequest.soapResult SOAPAction:soapAction]; 
        id jsonObject = [xmlParser.result objectFromJSONString];//jsonkit
        [xmlParser release];
        
        for (id obj in jsonObject) {    
            Team *team = [[Team alloc] init];
            for (int i=0; i<[[obj allKeys]count]; i++) {        
                if([@"City" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    team.City = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"GameTypeID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    team.GameTypeID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"GameTypeName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    team.GameTypeName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"ImageUrl" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    team.ImageUrl = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"Introduce" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    team.Introduce = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"LeaugeID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    team.LeaugeID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"LeaugeName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    team.LeaugeName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"Name" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    team.Name = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"ShortName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    team.ShortName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"TeamID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    team.TeamID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"isfocus" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    team.isfocus = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
            }     
            [array addObject:team];
            [team release];
        }
    }
    
    return [array autorelease];
}


+ (BOOL)commitTask: (NSString *)taskID WithUserID:(NSString *)userID
{
    NSString *tmp = [NSString stringWithFormat:@"<Task_Commit xmlns=\"leisuresport\">"
                     "<UserID>%@</UserID>"
                     "<TaskID>%@</TaskID>"
                     "</Task_Commit>",userID, taskID];
    NSString *soapAction = @"leisuresport/Task_Commit";
    NSString *soapMessage = [NSString stringWithFormat: SOAP_CONTENT,tmp];
//    NSLog(soapMessage);
    LSWebServiceRequest *soapRequest = [[[LSWebServiceRequest alloc] init] autorelease];
    //请求成功
    if([soapRequest requestWithSOAPAction:soapAction SOAPMessage:soapMessage])
    {
        LSSoapResultXMLParser *xmlParser = [[[LSSoapResultXMLParser alloc] init] autorelease];
        [xmlParser parseWithData:soapRequest.soapResult SOAPAction:soapAction]; 
        
        int relValue = [xmlParser.result intValue];
        if (relValue > 0)
            return YES;
        else
            return NO;
        
    }
    return NO;
}

+ (BOOL)focusUser:(NSString *)srcUserID TOUserID:(NSString *)toUserID Operation:(NSInteger)opr;
{
    NSString *tmp = [NSString stringWithFormat:@"<User_FocusUser xmlns=\"leisuresport\">"
                     "<srcUserID>%@</srcUserID>"
                     "<toUserID>%@</toUserID>"
                     "<operation>%d</operation>"
                     "</User_FocusUser>", srcUserID, toUserID, opr];
    NSString *soapAction = @"leisuresport/User_FocusUser";
    NSString *soapMessage = [NSString stringWithFormat: SOAP_CONTENT,tmp];
    //    NSLog(soapMessage);
    LSWebServiceRequest *soapRequest = [[[LSWebServiceRequest alloc] init] autorelease];
    //请求成功
    if([soapRequest requestWithSOAPAction:soapAction SOAPMessage:soapMessage])
    {
        LSSoapResultXMLParser *xmlParser = [[[LSSoapResultXMLParser alloc] init] autorelease];
        [xmlParser parseWithData:soapRequest.soapResult SOAPAction:soapAction]; 
        
        int relValue = [xmlParser.result intValue];
        if (relValue == 0)
            return YES;
        else
            return NO;
        
    }
    return NO;
}

+ (BOOL)focusTeam:(NSString *)teamID AndUserID:(NSString *)userID Operation:(NSInteger)opr
{
    NSString *tmp = [NSString stringWithFormat:@"<User_FocusTeam xmlns=\"leisuresport\">"
                     "<userID>%@</userID>"
                     "<teamID>%@</teamID>"
                     "<operation>%d</operation>"
                     "</User_FocusTeam>", userID, teamID, opr];
    NSString *soapAction = @"leisuresport/User_FocusTeam";
    NSString *soapMessage = [NSString stringWithFormat: SOAP_CONTENT,tmp];

    LSWebServiceRequest *soapRequest = [[[LSWebServiceRequest alloc] init] autorelease];
    //请求成功
    if([soapRequest requestWithSOAPAction:soapAction SOAPMessage:soapMessage])
    {
        LSSoapResultXMLParser *xmlParser = [[[LSSoapResultXMLParser alloc] init] autorelease];
        [xmlParser parseWithData:soapRequest.soapResult SOAPAction:soapAction]; 
        
        int relValue = [xmlParser.result intValue];
        NSLog(@"relValue:%d", relValue);
        if (relValue == 0)
            return YES;
        else
            return NO;
        
    }
    return NO;
}

+ (BOOL)sendMsgFrom:(NSString *)fromUserID TO:(NSString *)toUserID Content:(NSString *)content
{
    NSString *tmp = [NSString stringWithFormat:@"<User_SendMessage xmlns=\"leisuresport\">"
                     "<FromUserID>%@</FromUserID>"
                     "<ToUserID>%@</ToUserID>"
                     "<MainContent>%@</MainContent>"
                     "</User_SendMessage>", fromUserID, toUserID, content];
    NSString *soapAction = @"leisuresport/User_SendMessage";
    NSString *soapMessage = [NSString stringWithFormat: SOAP_CONTENT,tmp];
    //    NSLog(soapMessage);
    LSWebServiceRequest *soapRequest = [[[LSWebServiceRequest alloc] init] autorelease];
    //请求成功
    if([soapRequest requestWithSOAPAction:soapAction SOAPMessage:soapMessage])
    {
        LSSoapResultXMLParser *xmlParser = [[[LSSoapResultXMLParser alloc] init] autorelease];
        [xmlParser parseWithData:soapRequest.soapResult SOAPAction:soapAction]; 
        
        int relValue = [xmlParser.result intValue];
        if (relValue > 0)
            return YES;
        else
            return NO;
        
    }
    return NO;
}

+ (NSMutableArray *)fetchMsgFrom:(NSString *)fromUserID TO:(NSString *)toUserID Time:(NSString *)time Count:(NSInteger)count Direction:(NSInteger)direction Index:(NSString *)index
{
    NSString *tmp = [NSString stringWithFormat:@"<User_Message_BetweenUsers_LoadByUserID xmlns=\"leisuresport\">"
                     "<FromUserID>%@</FromUserID>"
                     "<ToUserID>%@</ToUserID>"
                     "<TimeStamp>%@</TimeStamp>"
                     "<count>%d</count>"
                     "<direction>%d</direction>"
                     "<indexMessageID>%@</indexMessageID>"
                     "</User_Message_BetweenUsers_LoadByUserID>", fromUserID, toUserID, time, count, direction, index];

    NSString *soapAction = @"leisuresport/User_Message_BetweenUsers_LoadByUserID";
    NSString *soapMessage = [NSString stringWithFormat: SOAP_CONTENT_WITHHEAD,@"",@"",tmp];
    
    LSWebServiceRequest *soapRequest = [[[LSWebServiceRequest alloc] init] autorelease];
    NSMutableArray *msgArray = [[NSMutableArray alloc] init];
    //请求成功
    if([soapRequest requestWithSOAPAction:soapAction SOAPMessage:soapMessage])
    {
        LSSoapResultXMLParser *xmlParser = [[[LSSoapResultXMLParser alloc] init] autorelease];
        [xmlParser parseWithData:soapRequest.soapResult SOAPAction:soapAction]; 
        
        id jsonObject = [xmlParser.result objectFromJSONString];//jsonkit
        
        for (id obj in jsonObject) {      
            Message *msg = [[Message alloc] init];
            for (int i=0; i<[[obj allKeys]count]; i++) {        
                if([@"FromUserID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    msg.FromUserID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"FromUserImageID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    msg.FromUserImageID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"FromUserIsOnline" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    msg.FromUserIsOnline = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"FromUserNickName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    msg.FromUserNickName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"FromUserSex" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    msg.FromUserSex = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"MainContent" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    msg.MainContent = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"MessageDT" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    msg.MessageDT = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"MessageID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    msg.MessageID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"RowNumber" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    msg.RowNumber = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"ToUserID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    msg.ToUserID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"ToUserImageID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    msg.ToUserImageID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"ToUserIsOnline" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    msg.ToUserIsOnline = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"ToUserNickName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    msg.ToUserNickName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"ToUserSex" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    msg.ToUserSex = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"UnReadNum" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    msg.UnReadNum = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"UserID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    msg.UserID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"readFlag" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    msg.readFlag = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];   
            }     
            [msgArray addObject:msg];
            [msg release];
        } 
    }
    return [msgArray autorelease];
}

+ (NSMutableArray *)searchTeamWithUserID:(NSString*) userID Key:(NSString *)key
{
    NSString *tmp = [NSString stringWithFormat:@"<Team_SearchByName xmlns=\"leisuresport\">"
                     "<UserID>%@</UserID>"
                     "<KeyWords>%@</KeyWords>"
                     "</Team_SearchByName>", userID, key];
    
    NSString *soapAction = @"leisuresport/Team_SearchByName";
    NSString *soapMessage = [NSString stringWithFormat: SOAP_CONTENT_WITHHEAD,@"",@"",tmp];
    
    LSWebServiceRequest *soapRequest = [[[LSWebServiceRequest alloc] init] autorelease];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    //请求成功
    if([soapRequest requestWithSOAPAction:soapAction SOAPMessage:soapMessage])
    {
        LSSoapResultXMLParser *xmlParser = [[[LSSoapResultXMLParser alloc] init] autorelease];
        [xmlParser parseWithData:soapRequest.soapResult SOAPAction:soapAction]; 
        
        id jsonObject = [xmlParser.result objectFromJSONString];//jsonkit
        
        for (id obj in jsonObject) {      
            Team *team = [[Team alloc] init];
            for (int i=0; i<[[obj allKeys]count]; i++) {        
                if([@"City" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    team.City = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"GameTypeID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    team.GameTypeID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"GameTypeName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    team.GameTypeName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"ImageUrl" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    team.ImageUrl = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"Introduce" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    team.Introduce = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"LeaugeID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    team.LeaugeID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"LeaugeName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    team.LeaugeName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"Name" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    team.Name = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"ShortName" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    team.ShortName = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"TeamID" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    team.TeamID = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
                if([@"isfocus" isEqualToString:[[obj allKeys]objectAtIndex:i]])
                    team.isfocus = [obj objectForKey:[[obj allKeys] objectAtIndex:i]];
            }     
            [array addObject:team];
            [team release];
        } 
    }
    return [array autorelease];
}

+ (NSMutableArray *)getFavorLeagueByUserID:(NSString*)userID
{

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	NSString *docPath = [paths objectAtIndex:0];
	NSString *newPath = [docPath stringByAppendingPathComponent:@"Preferences/FavorLeague.plist"];
    NSMutableArray *infoArray=[NSMutableArray arrayWithContentsOfFile:newPath];
    NSMutableArray *tmpArray = nil;
    for (int i=0; i<[infoArray count]; i++) {
        NSMutableDictionary *tmpDic = [infoArray objectAtIndex:i];
        if([[tmpDic allKeys] containsObject:userID]){
            tmpArray = [tmpDic objectForKey:userID];
        }
    }
    
    return tmpArray;
}


+ (void)updateFavorLeagueWithOperation:(NSInteger)opr LeaugeID:(NSString *)leagueID UserID: (NSString*)userID
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	NSString *docPath = [paths objectAtIndex:0];
	NSString *newPath = [docPath stringByAppendingPathComponent:@"Preferences/FavorLeague.plist"];
    NSMutableArray *infoArray=[NSMutableArray arrayWithContentsOfFile:newPath];
    if (infoArray == nil) {
        infoArray = [[[NSMutableArray alloc] init] autorelease];
    }
    BOOL IsUserExist = NO;
    for (int i=0; i<[infoArray count]; i++) {
        NSMutableDictionary *tmpDic = [infoArray objectAtIndex:i];
        if([[tmpDic allKeys] containsObject:userID]){
            IsUserExist = YES;
            NSMutableArray *tmpArray = [tmpDic objectForKey:userID];
            if (opr == 1) {
                [tmpArray addObject:leagueID];
            } else if(opr == 0){
                [tmpArray removeObject:leagueID];
            }
        }
    }
    if (!IsUserExist) {
        NSMutableDictionary *userDic = [[NSMutableDictionary alloc] init];
        NSMutableArray *leagueIDArray = [[NSMutableArray alloc] initWithCapacity:1];
        if (opr == 1) {
            [leagueIDArray addObject:leagueID];
        } else if(opr == 0){
            [leagueIDArray removeObject:leagueID];
        }
        [userDic setObject:leagueIDArray forKey:userID];
        [leagueIDArray release];
        [infoArray addObject:userDic];
        [userDic release];
    }

    [infoArray writeToFile:newPath atomically:YES];
}

@end
