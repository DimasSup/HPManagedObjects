//
//  NSString+NSString_MD5.m
//  Little Pal
//
//  Created by DimasSup on 07.10.14.
//  Copyright (c) 2014 BrillKids. All rights reserved.
//

#import "NSString+NSString_MD5.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (NSString_MD5)
-(NSString*) sha256{
	const char *s=[self cStringUsingEncoding:NSASCIIStringEncoding];
	NSData *keyData=[NSData dataWithBytes:s length:strlen(s)];
	
	uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
	CC_SHA256(keyData.bytes, keyData.length, digest);
	NSData *out=[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
	NSString *hash=[out description];
	hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
	hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
	hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
	return hash;
}
- (NSString *)MD5String
{
    const char *cstr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, strlen(cstr), result);
    
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
