//
//  postMessage.m
//  testPostFromFunction
//
//  Created by Jigdaw on 11/22/13.
//  Copyright (c) 2013 arnan_srisontisuk. All rights reserved.
//

#import "postMessage.h"

@implementation postMessage{
    NSMutableArray* jsonObject;
    int errorNumber;
}

-(NSMutableArray*) post:(NSString*)postMessage toUrl:(NSURL*)url{
    
    NSData *postData = [postMessage dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded ; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    // create the NSURLRequest for this loop iteration
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    // do something with the data, response, error, etc
    id jsonReturn = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    if([self errorChecking:jsonReturn]){
        return nil;
    }else{
        return jsonObject;
    }
}

-(BOOL)postImage:(NSData*)image withObjectID:(NSString*)objectID toUrl:(NSURL*)url{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    // BOUNDARY
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    // CONTENT TYPE
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    // MAKE BODY
    NSMutableData *body = [NSMutableData data];
    // IMAGE
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploadedfile\"; filename=\"img.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:image]];
    // OBJECT ID
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"objectID\"\r\n\r\n" ]dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:objectID] dataUsingEncoding:NSUTF8StringEncoding]];
    // END
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // SEND REQUEST
    [request setHTTPBody:body];
    
    // create the NSURLRequest for this loop iteration
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    // do something with the data, response, error, etc
    id jsonReturn = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    if([self errorChecking:jsonReturn]){
        return TRUE;
    }else{
        return FALSE;
    }
}

-(BOOL) errorChecking:(id)jsonReturn{
    BOOL checkedHeader = NO;
    jsonObject = [[NSMutableArray alloc]init];
    for (NSDictionary *dataDict in jsonReturn) {
        if(checkedHeader){
            [jsonObject addObject:dataDict];
        }else{
            errorNumber = [[dataDict objectForKey:@"header"]intValue];
            if (errorNumber != 0) {
                return YES;
            }
            checkedHeader = YES;
        }
    }
    return NO;
}

-(void)getErrorMessage{
    UIAlertView *alertTextFieldNull;
    switch (errorNumber) {
        case 1:
            alertTextFieldNull =[[UIAlertView alloc]
                                 initWithTitle:@"ปกติ การทำงานว่างเปล่า"
                                 message:nil delegate:self
                                 cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertTextFieldNull show];
            break;
        case 2:
            alertTextFieldNull =[[UIAlertView alloc]
                                 initWithTitle:@"ปกติ ไม่ต้องการข้อมูล"
                                 message:nil delegate:self
                                 cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertTextFieldNull show];
            break;
        case -1:
            alertTextFieldNull =[[UIAlertView alloc]
                                 initWithTitle:@"ฐานข้อมูล"
                                 message:nil delegate:self
                                 cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertTextFieldNull show];
            break;
        case -2:
            alertTextFieldNull =[[UIAlertView alloc]
                                 initWithTitle:@"การส่งข้อมูลผิดพลาด"
                                 message:nil delegate:self
                                 cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertTextFieldNull show];
            break;
        case -3:
            alertTextFieldNull =[[UIAlertView alloc]
                                 initWithTitle:@"การเชื่อมต่ออินเตอร์เน็ตผิดพลาด"
                                 message:nil delegate:self
                                 cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertTextFieldNull show];
            break;
        default:
            alertTextFieldNull =[[UIAlertView alloc]
                                 initWithTitle:@"Unknow Error"
                                 message:nil delegate:self
                                 cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertTextFieldNull show];
            break;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // inform the user
    UIAlertView *didFailWithErrorMessage = [[UIAlertView alloc] initWithTitle: @"NSURLConnection " message: @"didFailWithError"  delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
    [didFailWithErrorMessage show];
    
    //inform the user
    NSLog(@"Connection failed! Error - %@", [error localizedDescription]);
}
@end
