//
//  postMessage.h
//  testPostFromFunction
//
//  Created by Jigdaw on 11/22/13.
//  Copyright (c) 2013 arnan_srisontisuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface postMessage : NSObject

-(BOOL) post:(NSString*)postMessage toUrl:(NSURL*)url;
-(BOOL)postImage:(NSData*)image withObjectID:(NSString*)objectID toUrl:(NSURL*)url;
-(void)getErrorMessage;
-(int)getReturnMessage;
-(NSMutableArray*)getData;

@end
