//
//  Constant.h
//  ChaiOne
//
//  Created by prerna chavan on 20/01/15.
//  Copyright (c) 2015 Synerzip. All rights reserved.
//

#ifndef ChaiOne_Constant_h
#define ChaiOne_Constant_h

#if defined(ADHOC) || defined(DEBUG)
#   define DebugLog(fmt, ...) {NSLog((fmt), ##__VA_ARGS__);}
#else
#   define DebugLog(...)
#endif

#define kPostURL  @"https://alpha-api.app.net/stream/0/posts/stream/global"

#define kNoInternetAlertTitle  @"No internet connection"
#define kNoInternetAlertMessage  @"Please make sure that you are connected to internet !!!"

#define kCannotLoadPostsAlertTitle  @"Something went wrong !!!"
#define kCannotLoadPostsAlertMessage  @"Cannot load posts"

#define kCancel @"Cancel"


#endif
