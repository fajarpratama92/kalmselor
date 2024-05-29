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

#import "WonderPushPlugin.h"

FOUNDATION_EXPORT double wonderpush_flutterVersionNumber;
FOUNDATION_EXPORT const unsigned char wonderpush_flutterVersionString[];

