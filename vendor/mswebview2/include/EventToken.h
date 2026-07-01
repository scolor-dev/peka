/*
 * Minimal EventRegistrationToken definition (Windows WinRT ABI).
 * Not provided by Zig's bundled mingw-w64 headers; required by WebView2.h.
 * Layout is part of the public WinRT ABI and is identical across all
 * implementations (e.g. mingw-w64's eventtoken.h, the Windows SDK).
 */
#ifndef __EventToken_h__
#define __EventToken_h__

#if defined(__cplusplus)
extern "C" {
#endif

typedef struct EventRegistrationToken {
    __int64 value;
} EventRegistrationToken;

#if defined(__cplusplus)
}
#endif

#endif
