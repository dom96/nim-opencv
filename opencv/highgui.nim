#M///////////////////////////////////////////////////////////////////////////////////////
#//
#//  IMPORTANT: READ BEFORE DOWNLOADING, COPYING, INSTALLING OR USING.
#//
#//  By downloading, copying, installing or using the software you agree to this license.
#//  If you do not agree to this license, do not download, install,
#//  copy or use the software.
#//
#//
#//                        Intel License Agreement
#//                For Open Source Computer Vision Library
#//
#// Copyright (C) 2000, Intel Corporation, all rights reserved.
#// Third party copyrights are property of their respective owners.
#//
#// Redistribution and use in source and binary forms, with or without modification,
#// are permitted provided that the following conditions are met:
#//
#//   * Redistribution's of source code must retain the above copyright notice,
#//     this list of conditions and the following disclaimer.
#//
#//   * Redistribution's in binary form must reproduce the above copyright notice,
#//     this list of conditions and the following disclaimer in the documentation
#//     and/or other materials provided with the distribution.
#//
#//   * The name of Intel Corporation may not be used to endorse or promote products
#//     derived from this software without specific prior written permission.
#//
#// This software is provided by the copyright holders and contributors "as is" and
#// any express or implied warranties, including, but not limited to, the implied
#// warranties of merchantability and fitness for a particular purpose are disclaimed.
#// In no event shall the Intel Corporation or contributors be liable for any direct,
#// indirect, incidental, special, exemplary, or consequential damages
#// (including, but not limited to, procurement of substitute goods or services;
#// loss of use, data, or profits; or business interruption) however caused
#// and on any theory of liability, whether in contract, strict liability,
#// or tort (including negligence or otherwise) arising in any way out of
#// the use of this software, even if advised of the possibility of such damage.
#//
#//M

{.deadCodeElim: on.}
when defined(windows): 
  const 
    highguidll* = "(lib|)opencv_highgui(249|231)d.dll"
elif defined(macosx): 
  const 
    highguidll* = "libopencv_highgui.dylib"
else: 
  const 
    highguidll* = "libopencv_highgui.so"

import core

type
  TCapture*{.pure, final.} = object
  
  TVideoWriter*{.pure, final.} = object

#proc fontQt*(nameFont: cstring; pointSize: cint; color: TScalar; 
#             weight: cint; style: cint; spacing: cint): TFont{.cdecl, 
#    importc: "cvFontQt", dynlib: highguidll.}
#proc addText*(img: ptr TArr; text: cstring; org: TPoint; arg2: ptr TFont){.
#    cdecl, importc: "cvAddText", dynlib: highguidll.}
proc displayOverlay*(name: cstring; text: cstring; delayms: cint){.cdecl, 
    importc: "cvDisplayOverlay", dynlib: highguidll.}
proc displayStatusBar*(name: cstring; text: cstring; delayms: cint){.cdecl, 
    importc: "cvDisplayStatusBar", dynlib: highguidll.}
proc saveWindowParameters*(name: cstring){.cdecl, 
    importc: "cvSaveWindowParameters", dynlib: highguidll.}
proc loadWindowParameters*(name: cstring){.cdecl, 
    importc: "cvLoadWindowParameters", dynlib: highguidll.}
#int cvStartLoop(int (*pt2Func)(int argc, char *argv[]), int argc, char* argv[]);
proc stopLoop*(){.cdecl, importc: "cvStopLoop", dynlib: highguidll.}
type 
  TButtonCallback* = proc (state: cint; userdata: pointer){.cdecl.}
const 
  PUSH_BUTTON* = 0
  CHECKBOX* = 1
  RADIOBOX* = 2
proc createButton*(buttonName: cstring; onChange: TButtonCallback; 
                   userdata: pointer; buttonType: cint; 
                   initialButtonState: cint): cint{.cdecl, 
    importc: "cvCreateButton", dynlib: highguidll.}
#----------------------
# this function is used to set some external parameters in case of X Window 
proc initSystem*(argc: cint; argv: cstringArray): cint{.cdecl, 
    importc: "cvInitSystem", dynlib: highguidll.}
proc startWindowThread*(): cint{.cdecl, importc: "cvStartWindowThread", 
                                 dynlib: highguidll.}
# ---------  YV ---------
const                       #These 3 flags are used by cvSet/GetWindowProperty
  WND_PROP_FULLSCREEN* = 0  #to change/get window's fullscreen property
  WND_PROP_AUTOSIZE* = 1    #to change/get window's autosize property
  WND_PROP_ASPECTRATIO* = 2 #to change/get window's aspectratio property
  WND_PROP_OPENGL* = 3      #to change/get window's opengl support
                            #These 2 flags are used by cvNamedWindow and cvSet/GetWindowProperty
  WINDOW_NORMAL* = 0x00000000 #the user can resize the window (no constraint)  / also use to switch a fullscreen window to a normal size
  WINDOW_AUTOSIZE* = 0x00000001 #the user cannot resize the window, the size is constrainted by the image displayed
  WINDOW_OPENGL* = 0x00001000 #window with opengl support
                              #Those flags are only for Qt
  GUI_EXPANDED* = 0x00000000 #status bar and tool bar
  GUI_NORMAL* = 0x00000010  #old fashious way
                            #These 3 flags are used by cvNamedWindow and cvSet/GetWindowProperty
  WINDOW_FULLSCREEN* = 1    #change the window to fullscreen
  WINDOW_FREERATIO* = 0x00000100 #the image expends as much as it can (no ratio constraint)
  WINDOW_KEEPRATIO* = 0x00000000 #the ration image is respected.
# create window 
proc namedWindow*(name: cstring; flags: cint): cint{.cdecl, 
    importc: "cvNamedWindow", dynlib: highguidll.}
# Set and Get Property of the window 
proc setWindowProperty*(name: cstring; propId: cint; propValue: cdouble){.
    cdecl, importc: "cvSetWindowProperty", dynlib: highguidll.}
proc getWindowProperty*(name: cstring; propId: cint): cdouble{.cdecl, 
    importc: "cvGetWindowProperty", dynlib: highguidll.}
# display image within window (highgui windows remember their content) 
proc showImage*(name: cstring; image: ptr TArr){.cdecl, 
    importc: "cvShowImage", dynlib: highguidll.}
# resize/move window 
proc resizeWindow*(name: cstring; width: cint; height: cint){.cdecl, 
    importc: "cvResizeWindow", dynlib: highguidll.}
proc moveWindow*(name: cstring; x: cint; y: cint){.cdecl, 
    importc: "cvMoveWindow", dynlib: highguidll.}
# destroy window and all the trackers associated with it 
proc destroyWindow*(name: cstring){.cdecl, importc: "cvDestroyWindow", 
                                    dynlib: highguidll.}
proc destroyAllWindows*(){.cdecl, importc: "cvDestroyAllWindows", 
                           dynlib: highguidll.}
# get native window handle (HWND in case of Win32 and Widget in case of X Window) 
proc getWindowHandle*(name: cstring): pointer{.cdecl, 
    importc: "cvGetWindowHandle", dynlib: highguidll.}
# get name of highgui window given its native handle 
proc getWindowName*(windowHandle: pointer): cstring{.cdecl, 
    importc: "cvGetWindowName", dynlib: highguidll.}

type 
    TTrackbarCallback* = proc (pos: cint){.cdecl.}
# create trackbar and display it on top of given window, set callback 
proc createTrackbar*(trackbarName: cstring; windowName: cstring; 
                     value: ptr cint; count: cint; 
                     onChange: TTrackbarCallback): cint{.cdecl, 
    importc: "cvCreateTrackbar", dynlib: highguidll.}
type 
  TTrackbarCallback2* = proc (pos: cint; userdata: pointer){.cdecl.}
proc createTrackbar2*(trackbarName: cstring; windowName: cstring; 
                      value: ptr cint; count: cint; 
                      onChange: TTrackbarCallback2; userdata: pointer): cint{.
    cdecl, importc: "cvCreateTrackbar2", dynlib: highguidll.}
# retrieve or set trackbar position 
proc getTrackbarPos*(trackbarName: cstring; windowName: cstring): cint{.
    cdecl, importc: "cvGetTrackbarPos", dynlib: highguidll.}
proc setTrackbarPos*(trackbarName: cstring; windowName: cstring; pos: cint){.
    cdecl, importc: "cvSetTrackbarPos", dynlib: highguidll.}
const 
  EVENT_MOUSEMOVE* = 0
  EVENT_LBUTTONDOWN* = 1
  EVENT_RBUTTONDOWN* = 2
  EVENT_MBUTTONDOWN* = 3
  EVENT_LBUTTONUP* = 4
  EVENT_RBUTTONUP* = 5
  EVENT_MBUTTONUP* = 6
  EVENT_LBUTTONDBLCLK* = 7
  EVENT_RBUTTONDBLCLK* = 8
  EVENT_MBUTTONDBLCLK* = 9
const 
  EVENT_FLAG_LBUTTON* = 1
  EVENT_FLAG_RBUTTON* = 2
  EVENT_FLAG_MBUTTON* = 4
  EVENT_FLAG_CTRLKEY* = 8
  EVENT_FLAG_SHIFTKEY* = 16
  EVENT_FLAG_ALTKEY* = 32
type 
  TCvMouseCallback* = proc (event: cint; x: cint; y: cint; flags: cint; 
                            param: pointer){.cdecl.}
# assign callback for mouse events 
proc setMouseCallback*(windowName: cstring; onMouse: TCvMouseCallback; 
                       param: pointer){.cdecl, importc: "cvSetMouseCallback", 
    dynlib: highguidll.}
const                       # 8bit, color or not 
                            #CV_LOAD_IMAGE_UNCHANGED  =-1,
                            # 8bit, gray 
  LOAD_IMAGE_GRAYSCALE* = 0 # ?, color 
  LOAD_IMAGE_COLOR* = 1     # any depth, ? 
  LOAD_IMAGE_ANYDEPTH* = 2  # ?, any color 
  LOAD_IMAGE_ANYCOLOR* = 4
# load image from file
#  iscolor can be a combination of above flags where CV_LOAD_IMAGE_UNCHANGED
#  overrides the other flags
#  using CV_LOAD_IMAGE_ANYCOLOR alone is equivalent to CV_LOAD_IMAGE_UNCHANGED
#  unless CV_LOAD_IMAGE_ANYDEPTH is specified images are converted to 8bit
#
proc loadImage*(filename: cstring; iscolor: cint): ptr TIplImage{.cdecl, 
    importc: "cvLoadImage", dynlib: highguidll.}
#proc loadImageM*(filename: cstring; iscolor: cint): ptr TMat{.cdecl, 
#    importc: "cvLoadImageM", dynlib: highguidll.}
const 
  IMWRITE_JPEG_QUALITY* = 1
  IMWRITE_PNG_COMPRESSION* = 16
  IMWRITE_PNG_STRATEGY* = 17
  IMWRITE_PNG_BILEVEL* = 18
  IMWRITE_PNG_STRATEGY_DEFAULT* = 0
  IMWRITE_PNG_STRATEGY_FILTERED* = 1
  IMWRITE_PNG_STRATEGY_HUFFMAN_ONLY* = 2
  IMWRITE_PNG_STRATEGY_RLE* = 3
  IMWRITE_PNG_STRATEGY_FIXED* = 4
  IMWRITE_PXM_BINARY* = 32
# save image to file 
proc saveImage*(filename: cstring; image: ptr TArr; params: ptr cint): cint{.
    cdecl, importc: "cvSaveImage", dynlib: highguidll.}
# decode image stored in the buffer 
#proc decodeImage*(buf: ptr TMat; iscolor: cint): ptr IplImage{.cdecl, 
#    importc: "cvDecodeImage", dynlib: highguidll.}
#proc decodeImageM*(buf: ptr TMat; iscolor: cint): ptr TMat{.cdecl, 
#    importc: "cvDecodeImageM", dynlib: highguidll.}
# encode image and store the result as a byte vector (single-row 8uC1 matrix) 
#proc encodeImage*(ext: cstring; image: ptr TArr; params: ptr cint): ptr TMat{.
#    cdecl, importc: "cvEncodeImage", dynlib: highguidll.}
const 
  CVTIMG_FLIP* = 1
  CVTIMG_SWAP_RB* = 2
# utility function: convert one image to another with optional vertical flip 
proc convertImage*(src: ptr TArr; dst: ptr TArr; flags: cint){.cdecl, 
    importc: "cvConvertImage", dynlib: highguidll.}
# wait for key event infinitely (delay<=0) or for "delay" milliseconds 
proc waitKey*(delay: cint): cint{.cdecl, importc: "cvWaitKey", 
                                  dynlib: highguidll.}
# OpenGL support
type 
  TCvOpenGlDrawCallback* = proc (userdata: pointer){.cdecl.}
proc setOpenGlDrawCallback*(windowName: cstring; 
                            callback: TCvOpenGlDrawCallback; userdata: pointer){.
    cdecl, importc: "cvSetOpenGlDrawCallback", dynlib: highguidll.}
proc setOpenGlContext*(windowName: cstring){.cdecl, 
    importc: "cvSetOpenGlContext", dynlib: highguidll.}
proc updateWindow*(windowName: cstring){.cdecl, importc: "cvUpdateWindow", 
    dynlib: highguidll.}

#***************************************************************************************
#                         Working with Video Files and Cameras                           
#***************************************************************************************

# start capturing frames from video file 
proc createFileCapture*(filename: cstring): ptr TCapture{.
    importc: "cvCreateFileCapture", dynlib: highguidll.}
const 
  CAP_ANY* = 0           # autodetect
  CAP_MIL* = 100         # MIL proprietary drivers
  CAP_VFW* = 200         # platform native
  CAP_V4L* = 200
  CAP_V4L2* = 200
  CAP_FIREWARE* = 300    # IEEE 1394 drivers
  CAP_FIREWIRE* = 300
  CAP_IEEE1394* = 300
  CAP_DC1394* = 300
  CAP_CMU1394* = 300
  CAP_STEREO* = 400      # TYZX proprietary drivers
  CAP_TYZX* = 400
  TYZX_LEFT* = 400
  TYZX_RIGHT* = 401
  TYZX_COLOR* = 402
  TYZX_Z* = 403
  CAP_QT* = 500          # QuickTime
  CAP_UNICAP* = 600      # Unicap drivers
  CAP_DSHOW* = 700       # DirectShow (via videoInput)
  CAP_PVAPI* = 800       # PvAPI, Prosilica GigE SDK
  CAP_OPENNI* = 900      # OpenNI (for Kinect)
  CAP_OPENNI_ASUS* = 910 # OpenNI (for Asus Xtion)
  CAP_ANDROID* = 1000    # Android
  CAP_XIAPI* = 1100      # XIMEA Camera API
  CAP_AVFOUNDATION* = 1200 # AVFoundation framework for iOS (OS X Lion will have the same API)
  CAP_GIGANETIX* = 1300  # Smartek Giganetix GigEVisionSDK

const # modes of the controlling registers (can be: auto, manual, auto single push, absolute Latter allowed with any other mode)
      # every feature can have only one mode turned on at a time
  CAP_PROP_DC1394_OFF*         = -4  ## turn the feature off (not controlled manually nor automatically)
  CAP_PROP_DC1394_MODE_MANUAL* = -3  ## set automatically when a value of the feature is set by the user
  CAP_PROP_DC1394_MODE_AUTO* = -2
  CAP_PROP_DC1394_MODE_ONE_PUSH_AUTO* = -1
  CAP_PROP_POS_MSEC* = 0
  CAP_PROP_POS_FRAMES* = 1
  CAP_PROP_POS_AVI_RATIO* = 2
  CAP_PROP_FRAME_WIDTH* = 3
  CAP_PROP_FRAME_HEIGHT* = 4
  CAP_PROP_FPS* = 5
  CAP_PROP_FOURCC* = 6
  CAP_PROP_FRAME_COUNT* = 7
  CAP_PROP_FORMAT* = 8
  CAP_PROP_MODE* = 9
  CAP_PROP_BRIGHTNESS* = 10
  CAP_PROP_CONTRAST* = 11
  CAP_PROP_SATURATION* = 12
  CAP_PROP_HUE* = 13
  CAP_PROP_GAIN* = 14
  CAP_PROP_EXPOSURE* = 15
  CAP_PROP_CONVERT_RGB* = 16
  CAP_PROP_WHITE_BALANCE_BLUE_U* = 17
  CAP_PROP_RECTIFICATION* = 18
  CAP_PROP_MONOCROME* = 19
  CAP_PROP_SHARPNESS* = 20
  CAP_PROP_AUTO_EXPOSURE* = 21 # exposure control done by camera,
                               # user can adjust refernce level
                               # using this feature
  CAP_PROP_GAMMA* = 22
  CAP_PROP_TEMPERATURE* = 23
  CAP_PROP_TRIGGER* = 24
  CAP_PROP_TRIGGER_DELAY* = 25
  CAP_PROP_WHITE_BALANCE_RED_V* = 26
  CAP_PROP_ZOOM* = 27
  CAP_PROP_FOCUS* = 28
  CAP_PROP_GUID* = 29
  CAP_PROP_ISO_SPEED* = 30
  CAP_PROP_MAX_DC1394* = 31
  CAP_PROP_BACKLIGHT* = 32
  CAP_PROP_PAN* = 33
  CAP_PROP_TILT* = 34
  CAP_PROP_ROLL* = 35
  CAP_PROP_IRIS* = 36
  CAP_PROP_SETTINGS* = 37
  CAP_PROP_AUTOGRAB* = 1024 # property for highgui class CvCapture_Android only
  CAP_PROP_SUPPORTED_PREVIEW_SIZES_STRING* = 1025 # readonly, tricky property, returns cpnst char* indeed
  CAP_PROP_PREVIEW_FORMAT* = 1026 # readonly, tricky property, returns cpnst char* indeed
                                  # OpenNI map generators
                                  #CV_CAP_OPENNI_DEPTH_GENERATOR = 1 << 31,
                                  #CV_CAP_OPENNI_IMAGE_GENERATOR = 1 << 30,
                                  #CV_CAP_OPENNI_GENERATORS_MASK = CV_CAP_OPENNI_DEPTH_GENERATOR + CV_CAP_OPENNI_IMAGE_GENERATOR,
                                  # Properties of cameras available through OpenNI interfaces
  CAP_PROP_OPENNI_OUTPUT_MODE* = 100
  CAP_PROP_OPENNI_FRAME_MAX_DEPTH* = 101 # in mm
  CAP_PROP_OPENNI_BASELINE* = 102 # in mm
  CAP_PROP_OPENNI_FOCAL_LENGTH* = 103 # in pixels
  CAP_PROP_OPENNI_REGISTRATION* = 104 # flag
                                      #CV_CAP_PROP_OPENNI_REGISTRATION_ON = CV_CAP_PROP_OPENNI_REGISTRATION, // flag that synchronizes the remapping depth map to image map
                                      # by changing depth generator's view point (if the flag is "on") or
                                      # sets this view point to its normal one (if the flag is "off").
  CAP_PROP_OPENNI_APPROX_FRAME_SYNC* = 105
  CAP_PROP_OPENNI_MAX_BUFFER_SIZE* = 106
  CAP_PROP_OPENNI_CIRCLE_BUFFER* = 107
  CAP_PROP_OPENNI_MAX_TIME_DURATION* = 108
  CAP_PROP_OPENNI_GENERATOR_PRESENT* = 109 #CV_CAP_OPENNI_IMAGE_GENERATOR_PRESENT         = CV_CAP_OPENNI_IMAGE_GENERATOR + CV_CAP_PROP_OPENNI_GENERATOR_PRESENT,
                                           #CV_CAP_OPENNI_IMAGE_GENERATOR_OUTPUT_MODE     = CV_CAP_OPENNI_IMAGE_GENERATOR + CV_CAP_PROP_OPENNI_OUTPUT_MODE,
                                           #CV_CAP_OPENNI_DEPTH_GENERATOR_BASELINE        = CV_CAP_OPENNI_DEPTH_GENERATOR + CV_CAP_PROP_OPENNI_BASELINE,
                                           #CV_CAP_OPENNI_DEPTH_GENERATOR_FOCAL_LENGTH    = CV_CAP_OPENNI_DEPTH_GENERATOR + CV_CAP_PROP_OPENNI_FOCAL_LENGTH,
                                           #CV_CAP_OPENNI_DEPTH_GENERATOR_REGISTRATION    = CV_CAP_OPENNI_DEPTH_GENERATOR + CV_CAP_PROP_OPENNI_REGISTRATION,
                                           #CV_CAP_OPENNI_DEPTH_GENERATOR_REGISTRATION_ON = CV_CAP_OPENNI_DEPTH_GENERATOR_REGISTRATION,
                                           # Properties of cameras available through GStreamer interface
  CAP_GSTREAMER_QUEUE_LENGTH* = 200 # default is 1
  CAP_PROP_PVAPI_MULTICASTIP* = 300 # ip for anable multicast master mode. 0 for disable multicast
                                    # Properties of cameras available through XIMEA SDK interface
  CAP_PROP_XI_DOWNSAMPLING* = 400 # Change image resolution by binning or skipping.
  CAP_PROP_XI_DATA_FORMAT* = 401 # Output data format.
  CAP_PROP_XI_OFFSET_X* = 402 # Horizontal offset from the origin to the area of interest (in pixels).
  CAP_PROP_XI_OFFSET_Y* = 403 # Vertical offset from the origin to the area of interest (in pixels).
  CAP_PROP_XI_TRG_SOURCE* = 404 # Defines source of trigger.
  CAP_PROP_XI_TRG_SOFTWARE* = 405 # Generates an internal trigger. PRM_TRG_SOURCE must be set to TRG_SOFTWARE.
  CAP_PROP_XI_GPI_SELECTOR* = 406 # Selects general purpose input
  CAP_PROP_XI_GPI_MODE* = 407 # Set general purpose input mode
  CAP_PROP_XI_GPI_LEVEL* = 408 # Get general purpose level
  CAP_PROP_XI_GPO_SELECTOR* = 409 # Selects general purpose output
  CAP_PROP_XI_GPO_MODE* = 410 # Set general purpose output mode
  CAP_PROP_XI_LED_SELECTOR* = 411 # Selects camera signalling LED
  CAP_PROP_XI_LED_MODE* = 412 # Define camera signalling LED functionality
  CAP_PROP_XI_MANUAL_WB* = 413 # Calculates White Balance(must be called during acquisition)
  CAP_PROP_XI_AUTO_WB* = 414 # Automatic white balance
  CAP_PROP_XI_AEAG* = 415   # Automatic exposure/gain
  CAP_PROP_XI_EXP_PRIORITY* = 416 # Exposure priority (0.5 - exposure 50%, gain 50%).
  CAP_PROP_XI_AE_MAX_LIMIT* = 417 # Maximum limit of exposure in AEAG procedure
  CAP_PROP_XI_AG_MAX_LIMIT* = 418 # Maximum limit of gain in AEAG procedure
  CAP_PROP_XI_AEAG_LEVEL* = 419 # Average intensity of output signal AEAG should achieve(in %)
  CAP_PROP_XI_TIMEOUT* = 420 # Image capture timeout in milliseconds
                             # Properties for Android cameras
  CAP_PROP_ANDROID_FLASH_MODE* = 8001
  CAP_PROP_ANDROID_FOCUS_MODE* = 8002
  CAP_PROP_ANDROID_WHITE_BALANCE* = 8003
  CAP_PROP_ANDROID_ANTIBANDING* = 8004
  CAP_PROP_ANDROID_FOCAL_LENGTH* = 8005
  CAP_PROP_ANDROID_FOCUS_DISTANCE_NEAR* = 8006
  CAP_PROP_ANDROID_FOCUS_DISTANCE_OPTIMAL* = 8007
  CAP_PROP_ANDROID_FOCUS_DISTANCE_FAR* = 8008 # Properties of cameras available through AVFOUNDATION interface
  CAP_PROP_IOS_DEVICE_FOCUS* = 9001
  CAP_PROP_IOS_DEVICE_EXPOSURE* = 9002
  CAP_PROP_IOS_DEVICE_FLASH* = 9003
  CAP_PROP_IOS_DEVICE_WHITEBALANCE* = 9004
  CAP_PROP_IOS_DEVICE_TORCH* = 9005 # Properties of cameras available through Smartek Giganetix Ethernet Vision interface
                                    # --- Vladimir Litvinenko (litvinenko.vladimir@gmail.com) --- 
  CAP_PROP_GIGA_FRAME_OFFSET_X* = 10001
  CAP_PROP_GIGA_FRAME_OFFSET_Y* = 10002
  CAP_PROP_GIGA_FRAME_WIDTH_MAX* = 10003
  CAP_PROP_GIGA_FRAME_HEIGH_MAX* = 10004
  CAP_PROP_GIGA_FRAME_SENS_WIDTH* = 10005
  CAP_PROP_GIGA_FRAME_SENS_HEIGH* = 10006

# start capturing frames from camera: index = camera_index + domain_offset (CV_CAP_*) 
proc createCameraCapture*(index: cint): ptr TCapture{.
    importc: "cvCreateCameraCapture", dynlib: highguidll.}
# grab a frame, return 1 on success, 0 on fail.
#  this function is thought to be fast               
proc grabFrame*(capture: ptr TCapture): cint{.importc: "cvGrabFrame", 
    dynlib: highguidll.}
# get the frame grabbed with cvGrabFrame(..)
#  This function may apply some frame processing like
#  frame decompression, flipping etc.
#  !!!DO NOT RELEASE or MODIFY the retrieved frame!!! 
proc retrieveFrame*(capture: ptr TCapture; streamIdx: cint): ptr TIplImage{.
    importc: "cvRetrieveFrame", dynlib: highguidll.}
# Just a combination of cvGrabFrame and cvRetrieveFrame
#   !!!DO NOT RELEASE or MODIFY the retrieved frame!!!      
proc queryFrame*(capture: ptr TCapture): ptr TIplImage{.
    importc: "cvQueryFrame", dynlib: highguidll.}
# stop capturing/reading and free resources 
proc releaseCapture*(capture: ptr ptr TCapture){.
    importc: "cvReleaseCapture", dynlib: highguidll.}

# retrieve or set capture properties 
proc getCaptureProperty*(capture: ptr TCapture; propertyId: cint): cdouble{.
    importc: "cvGetCaptureProperty", dynlib: highguidll.}
proc setCaptureProperty*(capture: ptr TCapture; propertyId: cint; 
                           value: cdouble): cint{.
    importc: "cvSetCaptureProperty", dynlib: highguidll.}
# Return the type of the capturer (eg, CV_CAP_V4W, CV_CAP_UNICAP), which is unknown if created with CV_CAP_ANY
proc getCaptureDomain*(capture: ptr TCapture): cint{.
    importc: "cvGetCaptureDomain", dynlib: highguidll.}

proc fOURCC*(c1, c2, c3, c4: char): cint =
  return cint((ord(c1).cint and 255) + ((ord(c2).cint and 255) shl 8) +
         ((ord(c3).cint and 255) shl 16) + ((ord(c4).cint and 255) shl 24))


const 
  FOURCC_PROMPT* = -1  # Open Codec Selection Dialog (Windows only)
  FOURCC_DEFAULT* = fOURCC('I', 'Y', 'U', 'V') # Use default codec for specified filename (Linux only)

# initialize video file writer 
proc createVideoWriter*(filename: cstring; fourcc: cint; fps: cdouble; 
                          frameSize: TSize; isColor: cint = 1): ptr TVideoWriter{.
    importc: "cvCreateVideoWriter", dynlib: highguidll.}

# write frame to video file 
proc writeFrame*(writer: ptr TVideoWriter; image: ptr TIplImage): cint{.
    importc: "cvWriteFrame", dynlib: highguidll.}
# close video file writer 
proc releaseVideoWriter*(writer: ptr ptr TVideoWriter){.
    importc: "cvReleaseVideoWriter", dynlib: highguidll.}
#***************************************************************************************\
#                              Obsolete functions/synonyms                               *
#\*************************************************************************************** 
template captureFromFile*: expr = createFileCapture
template captureFromCAM*(x: int): expr = createCameraCapture(x)
template captureFromAVI*: expr = captureFromFile
template createAVIWriter*: expr = createVideoWriter
template writeToAVI*: expr = writeFrame
