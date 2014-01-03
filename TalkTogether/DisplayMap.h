//
//  DisplayMap.h
//  TalkTogether
//
//  Created by PloyZb on 12/20/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface DisplayMap : NSObject <MKAnnotation> {
    
	CLLocationCoordinate2D coordinate;
	NSString *title;
	NSString *subtitle;
}
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
