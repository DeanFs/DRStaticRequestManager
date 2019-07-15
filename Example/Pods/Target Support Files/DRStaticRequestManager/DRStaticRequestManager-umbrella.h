#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "DRStaticRequestCache.h"
#import "DRStaticRequestManager.h"
#import "DRStaticRequestProtocol.h"

FOUNDATION_EXPORT double DRStaticRequestManagerVersionNumber;
FOUNDATION_EXPORT const unsigned char DRStaticRequestManagerVersionString[];

