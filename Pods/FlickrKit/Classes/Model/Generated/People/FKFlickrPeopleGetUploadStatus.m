//
//  FKFlickrPeopleGetUploadStatus.m
//  FlickrKit
//
//  Generated by FKAPIBuilder.
//  Copyright (c) 2013 DevedUp Ltd. All rights reserved. http://www.devedup.com
//
//  DO NOT MODIFY THIS FILE - IT IS MACHINE GENERATED


#import "FKFlickrPeopleGetUploadStatus.h" 

@implementation FKFlickrPeopleGetUploadStatus



- (BOOL) needsLogin {
    return YES;
}

- (BOOL) needsSigning {
    return YES;
}

- (FKPermission) requiredPerms {
    return 0;
}

- (NSString *) name {
    return @"flickr.people.getUploadStatus";
}

- (BOOL) isValid:(NSError **)error {
    BOOL valid = YES;
	NSMutableString *errorDescription = [[NSMutableString alloc] initWithString:@"You are missing required params: "];

	if(error != NULL) {
		if(!valid) {	
			NSDictionary *userInfo = @{NSLocalizedDescriptionKey: errorDescription};
			*error = [NSError errorWithDomain:FKFlickrKitErrorDomain code:FKErrorInvalidArgs userInfo:userInfo];
		}
	}
    return valid;
}

- (NSDictionary *) args {
    NSMutableDictionary *args = [NSMutableDictionary dictionary];

    return [args copy];
}

- (NSString *) descriptionForError:(NSInteger)error {
    switch(error) {
		case FKFlickrPeopleGetUploadStatusError_SSLIsRequired:
			return @"SSL is required";
		case FKFlickrPeopleGetUploadStatusError_InvalidSignature:
			return @"Invalid signature";
		case FKFlickrPeopleGetUploadStatusError_MissingSignature:
			return @"Missing signature";
		case FKFlickrPeopleGetUploadStatusError_LoginFailedOrInvalidAuthToken:
			return @"Login failed / Invalid auth token";
		case FKFlickrPeopleGetUploadStatusError_UserNotLoggedInOrInsufficientPermissions:
			return @"User not logged in / Insufficient permissions";
		case FKFlickrPeopleGetUploadStatusError_InvalidAPIKey:
			return @"Invalid API Key";
		case FKFlickrPeopleGetUploadStatusError_ServiceCurrentlyUnavailable:
			return @"Service currently unavailable";
		case FKFlickrPeopleGetUploadStatusError_WriteOperationFailed:
			return @"Write operation failed";
		case FKFlickrPeopleGetUploadStatusError_FormatXXXNotFound:
			return @"Format \"xxx\" not found";
		case FKFlickrPeopleGetUploadStatusError_MethodXXXNotFound:
			return @"Method \"xxx\" not found";
		case FKFlickrPeopleGetUploadStatusError_InvalidSOAPEnvelope:
			return @"Invalid SOAP envelope";
		case FKFlickrPeopleGetUploadStatusError_InvalidXMLRPCMethodCall:
			return @"Invalid XML-RPC Method Call";
		case FKFlickrPeopleGetUploadStatusError_BadURLFound:
			return @"Bad URL found";
  
		default:
			return @"Unknown error code";
    }
}

@end