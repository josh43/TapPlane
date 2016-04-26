//
//  Clickable.h
//  TapMyPlane
//
//  Created by joshua on 2/17/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#ifndef Clickable_h
#define Clickable_h
#import <Foundation/Foundation.h>

@interface Clickable : NSObject

@property(weak,nonatomic) id obj;
@property(weak,nonatomic) id callBack;

-(id)initWithRect:(id )ref;
-(void)touchUpInside:(CGPoint) point;
-(void)setCallBack:(id)callBack
         forMethod:(SEL) method;

@end

@implementation Clickable
SEL callBackMethod;

-(void)setCallBack:(id)callBack
         forMethod:(SEL) method
{
    self.callBack = callBack;
    callBackMethod = method;
}
-(void)callBack{
    if(callBackMethod){
        if(_callBack){
            [self performSelector:callBackMethod withObject:_callBack];
        }else{
            NSLog(@"Need to set caller id");
        }
    }else{
        NSLog(@"NEed to set callback method");
    }
}
-(id)initWithRect:(id)ref{
    self = [super init];
    if(ref){
        if([ref respondsToSelector:@selector(rect)]){
            self.obj = ref;
        }else{
            NSLog(@"Error the object trying to be clickable does not have a rect, or at least it does not have ObjectYouPut.rect..\n");
        }
    }
    
    return self;
}
-(void)touchUpInside:(CGPoint) point{
    CGRect rect;
    if([self->_obj respondsToSelector:@selector(rect)]){
        rect = [self->_obj rect];
    }else{
        NSLog(@"Doesnt have a rect");
        return;
    }
    
    if( point.x > rect.origin.x && point.x < (rect.origin.x + rect.size.width)
       && point.y > rect.origin.y && point.y < (rect.origin.y + rect.size.height)){
        [self callBack];
    }
    
}
@end
#endif /* Clickable_h */
