#M///////////////////////////////////////////////////////////////////////////////////////
#//
#//  IMPORTANT: READ BEFORE DOWNLOADING, COPYING, INSTALLING OR USING.
#//
#//  By downloading, copying, installing or using the software you agree to this license.
#//  If you do not agree to this license, do not download, install,
#//  copy or use the software.
#//
#//
#//                           License Agreement
#//                For Open Source Computer Vision Library
#//
#// Copyright (C) 2000-2008, Intel Corporation, all rights reserved.
#// Copyright (C) 2009, Willow Garage Inc., all rights reserved.
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
#//   * The name of the copyright holders may not be used to endorse or promote products
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
import opencv/core
# Connected component structure 

type 
  TConnectedComp* {.pure, final.} = object 
    area*: cdouble            # area of the connected component  
    value*: TScalar            # average color of the connected component 
    rect*: TRect               # ROI of the component  
    contour*: pointer         # optional component boundary
                              #                      (the contour might have child contours corresponding to the holes)
  TContourScanner* {.pure, final.} = object

# Image smooth methods 

const 
  BLUR_NO_SCALE* = 0
  BLUR* = 1
  GAUSSIAN* = 2
  MEDIAN* = 3
  BILATERAL* = 4

# Filters used in pyramid decomposition 

const 
  GAUSSIAN_5x5* = 7

# Special filters 

const 
  SCHARR* = - 1
  MAX_SOBEL_KSIZE* = 7

# Constants for color conversion 

const 
  BGR2BGRA* = 0
  RGB2RGBA* = BGR2BGRA
  BGRA2BGR* = 1
  RGBA2RGB* = BGRA2BGR
  BGR2RGBA* = 2
  RGB2BGRA* = BGR2RGBA
  RGBA2BGR* = 3
  BGRA2RGB* = RGBA2BGR
  BGR2RGB* = 4
  RGB2BGR* = BGR2RGB
  BGRA2RGBA* = 5
  RGBA2BGRA* = BGRA2RGBA
  BGR2GRAY* = 6
  RGB2GRAY* = 7
  GRAY2BGR* = 8
  GRAY2RGB* = GRAY2BGR
  GRAY2BGRA* = 9
  GRAY2RGBA* = GRAY2BGRA
  BGRA2GRAY* = 10
  RGBA2GRAY* = 11
  BGR2BGR565* = 12
  RGB2BGR565* = 13
  BGR5652BGR* = 14
  BGR5652RGB* = 15
  BGRA2BGR565* = 16
  RGBA2BGR565* = 17
  BGR5652BGRA* = 18
  BGR5652RGBA* = 19
  GRAY2BGR565* = 20
  BGR5652GRAY* = 21
  BGR2BGR555* = 22
  RGB2BGR555* = 23
  BGR5552BGR* = 24
  BGR5552RGB* = 25
  BGRA2BGR555* = 26
  RGBA2BGR555* = 27
  BGR5552BGRA* = 28
  BGR5552RGBA* = 29
  GRAY2BGR555* = 30
  BGR5552GRAY* = 31
  BGR2XYZ* = 32
  RGB2XYZ* = 33
  XYZ2BGR* = 34
  XYZ2RGB* = 35
  BGR2YCrCb* = 36
  RGB2YCrCb* = 37
  YCrCb2BGR* = 38
  YCrCb2RGB* = 39
  BGR2HSV* = 40
  RGB2HSV* = 41
  BGR2Lab* = 44
  RGB2Lab* = 45
  BayerBG2BGR* = 46
  BayerGB2BGR* = 47
  BayerRG2BGR* = 48
  BayerGR2BGR* = 49
  BayerBG2RGB* = BayerRG2BGR
  BayerGB2RGB* = BayerGR2BGR
  BayerRG2RGB* = BayerBG2BGR
  BayerGR2RGB* = BayerGB2BGR
  BGR2Luv* = 50
  RGB2Luv* = 51
  BGR2HLS* = 52
  RGB2HLS* = 53
  HSV2BGR* = 54
  HSV2RGB* = 55
  Lab2BGR* = 56
  Lab2RGB* = 57
  Luv2BGR* = 58
  Luv2RGB* = 59
  HLS2BGR* = 60
  HLS2RGB* = 61
  BayerBG2BGR_VNG* = 62
  BayerGB2BGR_VNG* = 63
  BayerRG2BGR_VNG* = 64
  BayerGR2BGR_VNG* = 65
  BayerBG2RGB_VNG* = BayerRG2BGR_VNG
  BayerGB2RGB_VNG* = BayerGR2BGR_VNG
  BayerRG2RGB_VNG* = BayerBG2BGR_VNG
  BayerGR2RGB_VNG* = BayerGB2BGR_VNG
  BGR2HSV_FULL* = 66
  RGB2HSV_FULL* = 67
  BGR2HLS_FULL* = 68
  RGB2HLS_FULL* = 69
  HSV2BGR_FULL* = 70
  HSV2RGB_FULL* = 71
  HLS2BGR_FULL* = 72
  HLS2RGB_FULL* = 73
  LBGR2Lab* = 74
  LRGB2Lab* = 75
  LBGR2Luv* = 76
  LRGB2Luv* = 77
  Lab2LBGR* = 78
  Lab2LRGB* = 79
  Luv2LBGR* = 80
  Luv2LRGB* = 81
  BGR2YUV* = 82
  RGB2YUV* = 83
  YUV2BGR* = 84
  YUV2RGB* = 85
  BayerBG2GRAY* = 86
  BayerGB2GRAY* = 87
  BayerRG2GRAY* = 88
  BayerGR2GRAY* = 89          #YUV 4:2:0 formats family
  YUV2RGB_NV12* = 90
  YUV2BGR_NV12* = 91
  YUV2RGB_NV21* = 92
  YUV2BGR_NV21* = 93
  YUV420sp2RGB* = YUV2RGB_NV21
  YUV420sp2BGR* = YUV2BGR_NV21
  YUV2RGBA_NV12* = 94
  YUV2BGRA_NV12* = 95
  YUV2RGBA_NV21* = 96
  YUV2BGRA_NV21* = 97
  YUV420sp2RGBA* = YUV2RGBA_NV21
  YUV420sp2BGRA* = YUV2BGRA_NV21
  YUV2RGB_YV12* = 98
  YUV2BGR_YV12* = 99
  YUV2RGB_IYUV* = 100
  YUV2BGR_IYUV* = 101
  YUV2RGB_I420* = YUV2RGB_IYUV
  YUV2BGR_I420* = YUV2BGR_IYUV
  YUV420p2RGB* = YUV2RGB_YV12
  YUV420p2BGR* = YUV2BGR_YV12
  YUV2RGBA_YV12* = 102
  YUV2BGRA_YV12* = 103
  YUV2RGBA_IYUV* = 104
  YUV2BGRA_IYUV* = 105
  YUV2RGBA_I420* = YUV2RGBA_IYUV
  YUV2BGRA_I420* = YUV2BGRA_IYUV
  YUV420p2RGBA* = YUV2RGBA_YV12
  YUV420p2BGRA* = YUV2BGRA_YV12
  YUV2GRAY_420* = 106
  YUV2GRAY_NV21* = YUV2GRAY_420
  YUV2GRAY_NV12* = YUV2GRAY_420
  YUV2GRAY_YV12* = YUV2GRAY_420
  YUV2GRAY_IYUV* = YUV2GRAY_420
  YUV2GRAY_I420* = YUV2GRAY_420
  YUV420sp2GRAY* = YUV2GRAY_420
  YUV420p2GRAY* = YUV2GRAY_420 #YUV 4:2:2 formats family
  YUV2RGB_UYVY* = 107
  YUV2BGR_UYVY* = 108         #CV_YUV2RGB_VYUY = 109,
                              #CV_YUV2BGR_VYUY = 110,
  YUV2RGB_Y422* = YUV2RGB_UYVY
  YUV2BGR_Y422* = YUV2BGR_UYVY
  YUV2RGB_UYNV* = YUV2RGB_UYVY
  YUV2BGR_UYNV* = YUV2BGR_UYVY
  YUV2RGBA_UYVY* = 111
  YUV2BGRA_UYVY* = 112        #CV_YUV2RGBA_VYUY = 113,
                              #CV_YUV2BGRA_VYUY = 114,
  YUV2RGBA_Y422* = YUV2RGBA_UYVY
  YUV2BGRA_Y422* = YUV2BGRA_UYVY
  YUV2RGBA_UYNV* = YUV2RGBA_UYVY
  YUV2BGRA_UYNV* = YUV2BGRA_UYVY
  YUV2RGB_YUY2* = 115
  YUV2BGR_YUY2* = 116
  YUV2RGB_YVYU* = 117
  YUV2BGR_YVYU* = 118
  YUV2RGB_YUYV* = YUV2RGB_YUY2
  YUV2BGR_YUYV* = YUV2BGR_YUY2
  YUV2RGB_YUNV* = YUV2RGB_YUY2
  YUV2BGR_YUNV* = YUV2BGR_YUY2
  YUV2RGBA_YUY2* = 119
  YUV2BGRA_YUY2* = 120
  YUV2RGBA_YVYU* = 121
  YUV2BGRA_YVYU* = 122
  YUV2RGBA_YUYV* = YUV2RGBA_YUY2
  YUV2BGRA_YUYV* = YUV2BGRA_YUY2
  YUV2RGBA_YUNV* = YUV2RGBA_YUY2
  YUV2BGRA_YUNV* = YUV2BGRA_YUY2
  YUV2GRAY_UYVY* = 123
  YUV2GRAY_YUY2* = 124        #CV_YUV2GRAY_VYUY = CV_YUV2GRAY_UYVY,
  YUV2GRAY_Y422* = YUV2GRAY_UYVY
  YUV2GRAY_UYNV* = YUV2GRAY_UYVY
  YUV2GRAY_YVYU* = YUV2GRAY_YUY2
  YUV2GRAY_YUYV* = YUV2GRAY_YUY2
  YUV2GRAY_YUNV* = YUV2GRAY_YUY2 # alpha premultiplication
  RGBA2mRGBA* = 125
  mRGBA2RGBA* = 126
  RGB2YUV_I420* = 127
  BGR2YUV_I420* = 128
  RGB2YUV_IYUV* = RGB2YUV_I420
  BGR2YUV_IYUV* = BGR2YUV_I420
  RGBA2YUV_I420* = 129
  BGRA2YUV_I420* = 130
  RGBA2YUV_IYUV* = RGBA2YUV_I420
  BGRA2YUV_IYUV* = BGRA2YUV_I420
  RGB2YUV_YV12* = 131
  BGR2YUV_YV12* = 132
  RGBA2YUV_YV12* = 133
  BGRA2YUV_YV12* = 134
  COLORCVT_MAX* = 135

# Sub-pixel interpolation methods 

const 
  INTER_NN* = 0
  INTER_LINEAR* = 1
  INTER_CUBIC* = 2
  INTER_AREA* = 3
  INTER_LANCZOS4* = 4

# ... and other image warping flags 

const 
  WARP_FILL_OUTLIERS* = 8
  WARP_INVERSE_MAP* = 16

# Shapes of a structuring element for morphological operations 

const 
  SHAPE_RECT* = 0
  SHAPE_CROSS* = 1
  SHAPE_ELLIPSE* = 2
  SHAPE_CUSTOM* = 100

# Morphological operations 

const 
  MOP_ERODE* = 0
  MOP_DILATE* = 1
  MOP_OPEN* = 2
  MOP_CLOSE* = 3
  MOP_GRADIENT* = 4
  MOP_TOPHAT* = 5
  MOP_BLACKHAT* = 6

# Spatial and central moments 

type 
  TMoments* {.pure, final.} = object 
    m00*: cdouble
    m10*: cdouble
    m01*: cdouble
    m20*: cdouble
    m11*: cdouble
    m02*: cdouble
    m30*: cdouble
    m21*: cdouble
    m12*: cdouble
    m03*: cdouble             # spatial moments 
    mu20*: cdouble
    mu11*: cdouble
    mu02*: cdouble
    mu30*: cdouble
    mu21*: cdouble
    mu12*: cdouble
    mu03*: cdouble            # central moments 
    inv_sqrt_m00*: cdouble    # m00 != 0 ? 1/sqrt(m00) : 0 
  

# Hu invariants 

type 
  THuMoments* {.pure, final.} = object 
    hu1*: cdouble
    hu2*: cdouble
    hu3*: cdouble
    hu4*: cdouble
    hu5*: cdouble
    hu6*: cdouble
    hu7*: cdouble             # Hu invariants 
  

# Template matching methods 

const 
  TM_SQDIFF* = 0
  TM_SQDIFF_NORMED* = 1
  TM_CCORR* = 2
  TM_CCORR_NORMED* = 3
  TM_CCOEFF* = 4
  TM_CCOEFF_NORMED* = 5

type 
  TDistanceFunction* = proc (a: ptr cfloat; b: ptr cfloat; user_param: pointer): cfloat {.
      cdecl, cdecl.}

# Contour retrieval modes 

const 
  RETR_EXTERNAL* = 0
  RETR_LIST* = 1
  RETR_CCOMP* = 2
  RETR_TREE* = 3
  RETR_FLOODFILL* = 4

# Contour approximation methods 

const 
  CHAIN_CODE* = 0
  CHAIN_APPROX_NONE* = 1
  CHAIN_APPROX_SIMPLE* = 2
  CHAIN_APPROX_TC89_L1* = 3
  CHAIN_APPROX_TC89_KCOS* = 4
  LINK_RUNS* = 5

#
#Internal structure that is used for sequental retrieving contours from the image.
#It supports both hierarchical and plane variants of Suzuki algorithm.
#

type 
  PContourScanner* = pointer

# Freeman chain reader state 

type 
  TChainPtReader* {.pure, final.} = object 
    code*: char               #CV_SEQ_READER_FIELDS()
    pt*: TPoint
    deltas*: array[0..2 - 1, array[0..8 - 1, Schar]]


# initializes 8-element array for fast access to 3x3 neighborhood of a pixel 

#***************************************************************************************\
#                              Planar subdivisions                                       *
#\***************************************************************************************

type 
  TSubdiv2DEdge* = csize

const 
  SUBDIV2D_VIRTUAL_POINT_FLAG* = (1 shl 30)

type 
  TQuadEdge2D* {.pure, final.} = object 
    flags*: cint
    pt*: array[0..4 - 1, ptr TSubdiv2DPoint]
    next*: array[0..4 - 1, TSubdiv2DEdge]

  TSubdiv2DPoint* {.pure, final.} = object 
    flags*: cint
    first*: TSubdiv2DEdge
    pt*: TPoint2D32f
    id*: cint

  TSubdiv2D* {.pure, final.} = object 
    quad_edges*: cint         #CV_GRAPH_FIELDS()
    is_geometry_valid*: cint
    recent_edge*: TSubdiv2DEdge
    topleft*: TPoint2D32f
    bottomright*: TPoint2D32f

  TSubdiv2DPointLocation* {.size: sizeof(cint).} = enum 
    PTLOC_ERROR = - 2, PTLOC_OUTSIDE_RECT = - 1, PTLOC_INSIDE = 0, 
    PTLOC_VERTEX = 1, PTLOC_ON_EDGE = 2
discard """ TNextEdgeType* {.size: sizeof(cint).} = enum 
  NEXT_AROUND_ORG = 0x00000000, NEXT_AROUND_DST = 0x00000022, 
  PREV_AROUND_ORG = 0x00000011, PREV_AROUND_DST = 0x00000033, 
  NEXT_AROUND_LEFT = 0x00000013, NEXT_AROUND_RIGHT = 0x00000031, 
  PREV_AROUND_LEFT = 0x00000020, PREV_AROUND_RIGHT = 0x00000002 """

# get the next edge with the same origin point (counterwise) 

discard """ template SUBDIV2D_NEXT_EDGE*(edge: expr): expr = 
  cast[(cast[ptr TQuadEdge2D](((edge) and not 3)))](.next[(edge) and 3]) """

# Contour approximation algorithms 

const 
  POLY_APPROX_DP* = 0

# Shape matching methods 

const 
  CONTOURS_MATCH_I1* = 1
  CONTOURS_MATCH_I2* = 2
  CONTOURS_MATCH_I3* = 3

# Shape orientation 

const 
  CLOCKWISE* = 1
  COUNTER_CLOCKWISE* = 2

# Convexity defect 

type 
  TConvexityDefect* {.pure, final.} = object 
    start*: ptr TPoint         # point of the contour where the defect begins 
    theEnd*: ptr TPoint        # point of the contour where the defect ends 
    depth_point*: ptr TPoint   # the farthest from the convex hull point within the defect 
    depth*: cfloat            # distance between the farthest point and the convex hull 
  

# Histogram comparison methods 

const 
  COMP_CORREL* = 0
  COMP_CHISQR* = 1
  COMP_INTERSECT* = 2
  COMP_BHATTACHARYYA* = 3
  COMP_HELLINGER* = COMP_BHATTACHARYYA

# Mask size for distance transform 

const 
  DIST_MASK_3* = 3
  DIST_MASK_5* = 5
  DIST_MASK_PRECISE* = 0

# Content of output label array: connected components or pixels 

const 
  DIST_LABEL_CCOMP* = 0
  DIST_LABEL_PIXEL* = 1

# Distance types for Distance Transform and M-estimators 

const 
  DIST_USER* = - 1            # User defined distance 
  DIST_L1* = 1                # distance = |x1-x2| + |y1-y2| 
  DIST_L2* = 2                # the simple euclidean distance 
  DIST_C* = 3                 # distance = max(|x1-x2|,|y1-y2|) 
  DIST_L12* = 4               # L1-L2 metric: distance = 2(sqrt(1+x*x/2) - 1)) 
  DIST_FAIR* = 5              # distance = c^2(|x|/c-log(1+|x|/c)), c = 1.3998 
  DIST_WELSCH* = 6            # distance = c^2/2(1-exp(-(x/c)^2)), c = 2.9846 
  DIST_HUBER* = 7             # distance = |x|<c ? x^2/2 : c(|x|-c/2), c=1.345 

# Threshold types 

const 
  THRESH_BINARY* = 0          # value = value > threshold ? max_value : 0       
  THRESH_BINARY_INV* = 1      # value = value > threshold ? 0 : max_value       
  THRESH_TRUNC* = 2           # value = value > threshold ? threshold : value   
  THRESH_TOZERO* = 3          # value = value > threshold ? value : 0           
  THRESH_TOZERO_INV* = 4      # value = value > threshold ? 0 : value           
  THRESH_MASK* = 7
  THRESH_OTSU* = 8 # use Otsu algorithm to choose the optimal threshold value;
                   #                                 combine the flag with one of the above CV_THRESH_* values 

# Adaptive threshold methods 

const 
  ADAPTIVE_THRESH_MEAN_C* = 0
  ADAPTIVE_THRESH_GAUSSIAN_C* = 1

# FloodFill flags 

const 
  FLOODFILL_FIXED_RANGE* = (1 shl 16)
  FLOODFILL_MASK_ONLY* = (1 shl 17)

# Canny edge detector flags 

const 
  CANNY_L2_GRADIENT* = (1 shl 31)

# Variants of a Hough transform 

const 
  HOUGH_STANDARD* = 0
  HOUGH_PROBABILISTIC* = 1
  HOUGH_MULTI_SCALE* = 2
  HOUGH_GRADIENT* = 3

# Fast search data structures  

type 
  TFeatureTree* {.pure, final.} = object 
  
  TLSH* {.pure, final.} = object 
  
  TLSHOperations* {.pure, final.} = object 
  
