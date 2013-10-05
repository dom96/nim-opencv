#M///////////////////////////////////////////////////////////////////////////////////////
#//
#//  IMPORTANT: READ BEFORE DOWNLOADING, COPYING, INSTALLING OR USING.
#//
#//  By downloading, copying, installing or using the software you agree to this license.
#//  If you do not agree to this license, do not download, install,
#//  copy or use the software.
#//
#//
#//                          License Agreement
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

from math import round

type 

  schar* = cchar

# CvArr* is used to pass arbitrary
#  array-like data structures
#  into functions where the particular
#  array type is recognized at runtime:
# 

type
  T32suf* {.pure, final.} = object 
    i*: cint

  T64suf* {.pure, final.} = object 
    i*: int64

  TStatus* = cint

#***************************************************************************************\
#                                  Image type (IplImage)                                 *
#\***************************************************************************************

const 
  IPL_DEPTH_SIGN* = 0x80000000
  IPL_DEPTH_1U* = 1
  IPL_DEPTH_8U* = 8
  IPL_DEPTH_16U* = 16
  IPL_DEPTH_32F* = 32
  IPL_DEPTH_8S* = (IPL_DEPTH_SIGN or 8)
  IPL_DEPTH_16S* = (IPL_DEPTH_SIGN or 16)
  IPL_DEPTH_32S* = (IPL_DEPTH_SIGN or 32)
  IPL_DATA_ORDER_PIXEL* = 0
  IPL_DATA_ORDER_PLANE* = 1
  IPL_ORIGIN_TL* = 0
  IPL_ORIGIN_BL* = 1
  IPL_ALIGN_4BYTES* = 4
  IPL_ALIGN_8BYTES* = 8
  IPL_ALIGN_16BYTES* = 16
  IPL_ALIGN_32BYTES* = 32
  IPL_ALIGN_DWORD* = IPL_ALIGN_4BYTES
  IPL_ALIGN_QWORD* = IPL_ALIGN_8BYTES
  IPL_BORDER_CONSTANT* = 0
  IPL_BORDER_REPLICATE* = 1
  IPL_BORDER_REFLECT* = 2
  IPL_BORDER_WRAP* = 3

type 
  TIplImage* {.pure, final.} = object 
    nSize*: cint              # sizeof(IplImage) 
    ID*: cint                 # version (=0)
    nChannels*: cint          # Most of OpenCV functions support 1,2,3 or 4 channels 
    alphaChannel*: cint       # Ignored by OpenCV 
    depth*: cint # Pixel depth in bits: IPL_DEPTH_8U, IPL_DEPTH_8S, IPL_DEPTH_16S,
                 #                               IPL_DEPTH_32S, IPL_DEPTH_32F and IPL_DEPTH_64F are supported.  
    colorModel*: array[0..4 - 1, char] # Ignored by OpenCV 
    channelSeq*: array[0..4 - 1, char] # ditto 
    dataOrder*: cint # 0 - interleaved color channels, 1 - separate color channels.
                     #                               cvCreateImage can only create interleaved images 
    origin*: cint             # 0 - top-left origin,
                              #                               1 - bottom-left origin (Windows bitmaps style).  
    align*: cint              # Alignment of image rows (4 or 8).
                              #                               OpenCV ignores it and uses widthStep instead.    
    width*: cint              # Image width in pixels.                           
    height*: cint             # Image height in pixels.                          
    roi*: ptr TIplROI          # Image ROI. If NULL, the whole image is selected. 
    maskROI*: ptr TIplImage    # Must be NULL. 
    imageId*: pointer         # "           " 
    tileInfo*: ptr TIplTileInfo # "           " 
    imageSize*: cint # Image data size in bytes
                     #                               (==image->height*image->widthStep
                     #                               in case of interleaved data)
    imageData*: cstring       # Pointer to aligned image data.         
    widthStep*: cint          # Size of aligned image row in bytes.    
    BorderMode*: array[0..4 - 1, cint] # Ignored by OpenCV.                     
    BorderConst*: array[0..4 - 1, cint] # Ditto.                                 
    imageDataOrigin*: cstring # Pointer to very origin of image data
                              #                               (not necessarily aligned) -
                              #                               needed for correct deallocation 
  
  TIplTileInfo* {.pure, final.} = object 
  
  TIplROI* {.pure, final.} = object 
    coi*: cint                # 0 - no COI (all channels are selected), 1 - 0th channel is selected ...
    xOffset*: cint
    yOffset*: cint
    width*: cint
    height*: cint

  TIplConvKernel* {.pure, final.} = object 
    nCols*: cint
    nRows*: cint
    anchorX*: cint
    anchorY*: cint
    values*: ptr cint
    nShiftR*: cint

  TIplConvKernelFP* {.pure, final.} = object 
    nCols*: cint
    nRows*: cint
    anchorX*: cint
    anchorY*: cint
    values*: ptr cfloat
  
  TArr* = TIplImage

#***************************************************************************************\
#                                  Matrix type (CvMat)                                   *
#\***************************************************************************************

const 
  CN_MAX* = 512
  CN_SHIFT* = 3
  DEPTH_MAX* = (1 shl CN_SHIFT)
  CV_8U* = 0
  CV_8S* = 1
  CV_16U* = 2
  CV_16S* = 3
  CV_32S* = 4
  CV_32F* = 5
  CV_64F* = 6
  USRTYPE1* = 7
  MAT_DEPTH_MASK* = (DEPTH_MAX - 1)

template MAT_DEPTH*(flags: expr): expr = 
  ((flags) and MAT_DEPTH_MASK)

template MAKETYPE*(depth, cn: expr): expr = 
  (MAT_DEPTH(depth) + (((cn) - 1) shl CN_SHIFT))

const 
  CV_8UC1* = MAKETYPE(CV_8U, 1)
  CV_8UC2* = MAKETYPE(CV_8U, 2)
  CV_8UC3* = MAKETYPE(CV_8U, 3)
  CV_8UC4* = MAKETYPE(CV_8U, 4)

template CV_8UC*(n: expr): expr = 
  MAKETYPE(CV_8U, (n))

const 
  CV_8SC1* = MAKETYPE(CV_8S, 1)
  CV_8SC2* = MAKETYPE(CV_8S, 2)
  CV_8SC3* = MAKETYPE(CV_8S, 3)
  CV_8SC4* = MAKETYPE(CV_8S, 4)

template CV_8SC*(n: expr): expr = 
  MAKETYPE(CV_8S, (n))

const 
  CV_16UC1* = MAKETYPE(CV_16U, 1)
  CV_16UC2* = MAKETYPE(CV_16U, 2)
  CV_16UC3* = MAKETYPE(CV_16U, 3)
  CV_16UC4* = MAKETYPE(CV_16U, 4)

template CV_16UC*(n: expr): expr = 
  MAKETYPE(CV_16U, (n))

const 
  CV_16SC1* = MAKETYPE(CV_16S, 1)
  CV_16SC2* = MAKETYPE(CV_16S, 2)
  CV_16SC3* = MAKETYPE(CV_16S, 3)
  CV_16SC4* = MAKETYPE(CV_16S, 4)

template CV_16SC*(n: expr): expr = 
  MAKETYPE(CV_16S, (n))

const 
  CV_32SC1* = MAKETYPE(CV_32S, 1)
  CV_32SC2* = MAKETYPE(CV_32S, 2)
  CV_32SC3* = MAKETYPE(CV_32S, 3)
  CV_32SC4* = MAKETYPE(CV_32S, 4)

template CV_32SC*(n: expr): expr = 
  MAKETYPE(CV_32S, (n))

const 
  CV_32FC1* = MAKETYPE(CV_32F, 1)
  CV_32FC2* = MAKETYPE(CV_32F, 2)
  CV_32FC3* = MAKETYPE(CV_32F, 3)
  CV_32FC4* = MAKETYPE(CV_32F, 4)

template CV_32FC*(n: expr): expr = 
  MAKETYPE(CV_32F, (n))

const 
  CV_64FC1* = MAKETYPE(CV_64F, 1)
  CV_64FC2* = MAKETYPE(CV_64F, 2)
  CV_64FC3* = MAKETYPE(CV_64F, 3)
  CV_64FC4* = MAKETYPE(CV_64F, 4)

template CV_64FC*(n: expr): expr = 
  MAKETYPE(CV_64F, (n))

template WHOLE_ARR*(): expr =
  Slice(0, 0x3FFFFFFF)

const 
  AUTO_STEP* = 0x7FFFFFFF
  MAT_CN_MASK* = ((CN_MAX - 1) shl CN_SHIFT)

template MAT_CN*(flags: expr): expr = 
  ((((flags) and MAT_CN_MASK) shr CN_SHIFT) + 1)

const 
  MAT_TYPE_MASK* = (DEPTH_MAX * CN_MAX - 1)

template MAT_TYPE*(flags: expr): expr = 
  ((flags) and MAT_TYPE_MASK)

const 
  MAT_CONT_FLAG_SHIFT* = 14
  MAT_CONT_FLAG* = (1 shl MAT_CONT_FLAG_SHIFT)

template IS_MAT_CONT*(flags: expr): expr = 
  ((flags) and MAT_CONT_FLAG)

template IS_CONT_MAT*(flags: expr): expr =
  IS_MAT_CONT(flags)

const
  SUBMAT_FLAG_SHIFT* = 15
  SUBMAT_FLAG* = (1 shl SUBMAT_FLAG_SHIFT)

template IS_SUBMAT*(flags: expr): expr = 
  ((flags) and MAT_SUBMAT_FLAG)

const 
  MAGIC_MASK* = 0xFFFF0000
  MAT_MAGIC_VAL* = 0x42420000
  TYPE_NAME_MAT* = "opencv-matrix"

type 
  TMatData* {.pure, final.} = object 
    thePtr*: ptr cuchar

  TMat* {.pure, final.} = object 
    theType*: cint
    step*: cint               # for internal use only 
    refcount*: ptr cint
    hdr_refcount*: cint
    data*: TMatData
    rows*: cint
    cols*: cint


#***************************************************************************************\
#                       Multi-dimensional dense array (CvMatND)                          *
#\***************************************************************************************

const 
  MATND_MAGIC_VAL* = 0x42430000
  TYPE_NAME_MATND* = "opencv-nd-matrix"
  MAX_DIM* = 32
  MAX_DIM_HEAP* = 1024

type 
  TMatNDdata* {.pure, final.} = object 
    thePtr*: ptr cuchar

  TMatNDDim* {.pure, final.} = object 
    size*: cint
    step*: cint

  TMatND* {.pure, final.} = object 
    theType*: cint
    dims*: cint
    refcount*: ptr cint
    hdr_refcount*: cint
    data*: TMatNDData
    dim*: array[0..MAX_DIM - 1, TMatNDDim]


#***************************************************************************************\
#                      Multi-dimensional sparse array (CvSparseMat)                      *
#\***************************************************************************************

const 
  SPARSE_MAT_MAGIC_VAL* = 0x42440000
  TYPE_NAME_SPARSE_MAT* = "opencv-sparse-matrix"

type 
  TSet* {.pure, final.} = object 
  
  TSparseMat* {.pure, final.} = object 
    theType*: cint
    dims*: cint
    refcount*: ptr cint
    hdr_refcount*: cint
    heap*: ptr TSet
    hashtable*: ptr pointer
    hashsize*: cint
    valoffset*: cint
    idxoffset*: cint
    size*: array[0..MAX_DIM - 1, cint]


#*************** iteration through a sparse array ****************

type 
  TSparseNode* {.pure, final.} = object 
    hashval*: cuint
    next*: ptr TSparseNode

  TSparseMatIterator* {.pure, final.} = object 
    mat*: ptr TSparseMat
    node*: ptr TSparseNode
    curidx*: cint

#***************************************************************************************\
#                                         Histogram                                      *
#\***************************************************************************************

type 
  THistType* = cint

const 
  HIST_MAGIC_VAL* = 0x42450000
  HIST_UNIFORM_FLAG* = (1 shl 10)

# indicates whether bin ranges are set already or not 

const 
  HIST_RANGES_FLAG* = (1 shl 11)
  HIST_ARRAY* = 0
  HIST_SPARSE* = 1
  HIST_TREE* = HIST_SPARSE

# should be used as a parameter only,
#   it turns to CV_HIST_UNIFORM_FLAG of hist->type 

const 
  HIST_UNIFORM* = 1

type 
  THistogram* {.pure, final.} = object 
    theType*: cint
    bins*: ptr TArr
    thresh*: array[0..2 - 1, array[0..MAX_DIM - 1, cfloat]] # For uniform histograms.                      
    thresh2*: ptr ptr cfloat  # For non-uniform histograms.                  
    mat*: TMatND              # Embedded matrix header for array histograms. 
  

#***************************************************************************************\
#                      Other supplementary data type definitions                         *
#\***************************************************************************************
#************************************** CvRect ****************************************

type 
  TRect* {.pure, final.} = object 
    x*: cint
    y*: cint
    width*: cint
    height*: cint


proc Rect*(x: cint; y: cint; width: cint; height: cint): TRect {.cdecl.} = 
  var r: TRect
  r.x = x
  r.y = y
  r.width = width
  r.height = height
  return r

proc RectToROI*(rect: TRect; coi: cint): TIplROI {.cdecl.} = 
  var roi: TIplROI
  roi.xOffset = rect.x
  roi.yOffset = rect.y
  roi.width = rect.width
  roi.height = rect.height
  roi.coi = coi
  return roi

proc ROIToRect*(roi: TIplROI): TRect {.cdecl.} = 
  return Rect(roi.xOffset, roi.yOffset, roi.width, roi.height)

#********************************** CvTermCriteria ************************************

const 
  TERMCRIT_ITER* = 1
  TERMCRIT_NUMBER* = TERMCRIT_ITER
  TERMCRIT_EPS* = 2

type 
  TTermCriteria* {.pure, final.} = object 
    theType*: cint            # may be combination of
                              #                     CV_TERMCRIT_ITER
                              #                     CV_TERMCRIT_EPS 
    max_iter*: cint
    epsilon*: cdouble


proc TermCriteria*(theType: cint; max_iter: cint; epsilon: cdouble): TTermCriteria {.
    cdecl.} = 
  var t: TTermCriteria
  t.theType = theType
  t.max_iter = max_iter
  t.epsilon = cast[cfloat](epsilon)
  return t

#****************************** CvPoint and variants **********************************

type 
  TPoint* {.pure, final.} = object 
    x*: cint
    y*: cint


proc Point*(x: cint; y: cint): TPoint {.cdecl.} = 
  var p: TPoint
  p.x = x
  p.y = y
  return p

type 
  TPoint2D32f* {.pure, final.} = object 
    x*: cfloat
    y*: cfloat


proc Point2D32f*(x: cdouble; y: cdouble): TPoint2D32f {.cdecl.} = 
  var p: TPoint2D32f
  p.x = cast[cfloat](x)
  p.y = cast[cfloat](y)
  return p

proc PointTo32f*(point: TPoint): TPoint2D32f {.cdecl.} = 
  return Point2D32f(cast[cfloat](point.x), cast[cfloat](point.y))

proc PointFrom32f*(point: TPoint2D32f): TPoint {.cdecl.} = 
  var ipt: TPoint
  ipt.x = round(point.x).cint
  ipt.y = round(point.y).cint
  return ipt

type 
  TPoint3D32f* {.pure, final.} = object 
    x*: cfloat
    y*: cfloat
    z*: cfloat


proc Point3D32f*(x: cdouble; y: cdouble; z: cdouble): TPoint3D32f {.cdecl.} = 
  var p: TPoint3D32f
  p.x = cast[cfloat](x)
  p.y = cast[cfloat](y)
  p.z = cast[cfloat](z)
  return p

type 
  TPoint2D64f* {.pure, final.} = object 
    x*: cdouble
    y*: cdouble


proc Point2D64f*(x: cdouble; y: cdouble): TPoint2D64f {.cdecl.} = 
  var p: TPoint2D64f
  p.x = x
  p.y = y
  return p

type 
  TPoint3D64f* {.pure, final.} = object 
    x*: cdouble
    y*: cdouble
    z*: cdouble


proc Point3D64f*(x: cdouble; y: cdouble; z: cdouble): TPoint3D64f {.cdecl.} = 
  var p: TPoint3D64f
  p.x = x
  p.y = y
  p.z = z
  return p

#******************************* CvSize's & CvBox *************************************

type 
  TSize* {.pure, final.} = object 
    width*: cint
    height*: cint


proc Size*(width: cint; height: cint): TSize {.cdecl.} = 
  var s: TSize
  s.width = width
  s.height = height
  return s

type 
  TSize2D32f* {.pure, final.} = object 
    width*: cfloat
    height*: cfloat


proc Size2D32f*(width: cdouble; height: cdouble): TSize2D32f {.cdecl.} = 
  var s: TSize2D32f
  s.width = cast[cfloat](width)
  s.height = cast[cfloat](height)
  return s

type 
  TBox2D* {.pure, final.} = object 
    center*: TPoint2D32f      # Center of the box.                          
    size*: TSize2D32f         # Box width and length.                       
    angle*: cfloat            # Angle between the horizontal axis           
                              # and the first side (i.e. length) in degrees 
  

# Line iterator state: 

type 
  TLineIterator* {.pure, final.} = object 
    thePtr*: ptr cuchar        # Pointer to the current point: \
    # Bresenham algorithm state: 
    err*: cint
    plus_delta*: cint
    minus_delta*: cint
    plus_step*: cint
    minus_step*: cint


#************************************ CvSlice *****************************************

type 
  TSlice* {.pure, final.} = object 
    start_index*: cint
    end_index*: cint


proc Slice*(start: cint; theEnd: cint): TSlice {.cdecl.} = 
  var slice: TSlice
  slice.start_index = start
  slice.end_index = theEnd
  return slice

const 
  WHOLE_SEQ_END_INDEX* = 0x3FFFFFFF

template WHOLE_SEQ*: expr = Slice(0, WHOLE_SEQ_END_INDEX)

#************************************ CvScalar ****************************************

type 
  TScalar* {.pure, final.} = object 
    val*: array[0..4 - 1, cdouble]


proc Scalar*(val0: cdouble; val1: cdouble = 0; val2: cdouble = 0; 
               val3: cdouble = 0): TScalar {.cdecl.} = 
  var scalar: TScalar
  scalar.val[0] = val0
  scalar.val[1] = val1
  scalar.val[2] = val2
  scalar.val[3] = val3
  return scalar

proc RealScalar*(val0: cdouble): TScalar {.cdecl.} = 
  var scalar: TScalar
  scalar.val[0] = val0
  scalar.val[1] = 0
  scalar.val[2] = 0
  scalar.val[3] = 0
  return scalar

proc ScalarAll*(val0123: cdouble): TScalar {.cdecl.} = 
  var scalar: TScalar
  scalar.val[0] = val0123
  scalar.val[1] = val0123
  scalar.val[2] = val0123
  scalar.val[3] = val0123
  return scalar

#***************************************************************************************\
#                                   Dynamic Data structures                              *
#\***************************************************************************************
#******************************* Memory storage ***************************************

type 
  TMemBlock* {.pure, final.} = object 
    prev*: ptr TMemBlock
    next*: ptr TMemBlock


const 
  STORAGE_MAGIC_VAL* = 0x42890000

type 
  TMemStorage* {.pure, final.} = object 
    signature*: cint
    bottom*: ptr TMemBlock    # First allocated block.                   
    top*: ptr TMemBlock       # Current memory block - top of the stack. 
    parent*: ptr TMemStorage  # We get new blocks from parent as needed. 
    block_size*: cint         # Block size.                              
    free_space*: cint         # Remaining free space in current block.   
  
  TMemStoragePos* {.pure, final.} = object 
    top*: ptr TMemBlock
    free_space*: cint


#********************************** Sequence ******************************************

type 
  TSeqBlock* {.pure, final.} = object 
    prev*: ptr TSeqBlock      # Previous sequence block.                   
    next*: ptr TSeqBlock      # Next sequence block.                       
    start_index*: cint        # Index of the first element in the block +  
                              # sequence->first->start_index.              
    count*: cint              # Number of elements in the block.           
    data*: ptr schar          # Pointer to the first element of the block. 
  

#
#   Read/Write sequence.
#   Elements can be dynamically inserted to or deleted from the sequence.
#

type 
  TSeq* {.pure, final.} = object 
    flags*: cint              # Miscellaneous flags.     
    header_size*: cint        # Size of sequence header. 
    v_next*: ptr TSeq         # 2nd next sequence.       
    total*: cint              # Total number of elements.            
    elem_size*: cint          # Size of sequence element in bytes.   
    block_max*: ptr schar     # Maximal bound of the last block.     
    thePtr*: ptr schar        # Current write pointer.               
    delta_elems*: cint        # Grow seq this many at a time.        
    storage*: ptr TMemStorage # Where the seq is stored.             
    free_blocks*: ptr TSeqBlock # Free blocks list.                    
    first*: ptr TSeqBlock     # Pointer to the first sequence block. 
  

const 
  TYPE_NAME_SEQ* = "opencv-sequence"
  TYPE_NAME_SEQ_TREE* = "opencv-sequence-tree"

#************************************** Set *******************************************
#
#  Set.
#  Order is not preserved. There can be gaps between sequence elements.
#  After the element has been inserted it stays in the same place all the time.
#  The MSB(most-significant or sign bit) of the first field (flags) is 0 iff the element exists.
#

type 
  TSetElem* {.pure, final.} = object 
    flags*: cint
    next_free*: ptr TSetElem

  TCvSet* {.pure, final.} = object 
    flags*: cint              # Miscellaneous flags.     
    header_size*: cint        # Size of sequence header. 
    v_next*: ptr TSeq         # 2nd next sequence.       
    total*: cint              # Total number of elements.            
    elem_size*: cint          # Size of sequence element in bytes.   
    block_max*: ptr schar     # Maximal bound of the last block.     
    thePtr*: ptr schar        # Current write pointer.               
    delta_elems*: cint        # Grow seq this many at a time.        
    storage*: ptr TMemStorage # Where the seq is stored.             
    free_blocks*: ptr TSeqBlock # Free blocks list.                    
    first*: ptr TSeqBlock     # Pointer to the first sequence block. 
    free_elems*: ptr TSetElem
    active_count*: cint


const 
  SET_ELEM_IDX_MASK* = ((1 shl 26) - 1)
  SET_ELEM_FREE_FLAG* = (1 shl (sizeof(cint) * 8 - 1))

# Checks whether the element pointed by ptr belongs to a set or not 

#************************************ Graph *******************************************
#
#  We represent a graph as a set of vertices.
#  Vertices contain their adjacency lists (more exactly, pointers to first incoming or
#  outcoming edge (or 0 if isolated vertex)). Edges are stored in another set.
#  There is a singly-linked list of incoming/outcoming edges for each vertex.
#
#  Each edge consists of
#
#     o   Two pointers to the starting and ending vertices
#         (vtx[0] and vtx[1] respectively).
#
#   A graph may be oriented or not. In the latter case, edges between
#   vertex i to vertex j are not distinguished during search operations.
#
#     o   Two pointers to next edges for the starting and ending vertices, where
#         next[0] points to the next edge in the vtx[0] adjacency list and
#         next[1] points to the next edge in the vtx[1] adjacency list.
#

type 
  TGraphEdge* {.pure, final.} = object 
    flags*: cint
    weight*: cfloat
    next*: array[0..2 - 1, ptr TGraphEdge]
    vtx*: array[0..2 - 1, ptr TGraphVtx]

  TGraphVtx* {.pure, final.} = object 
    flags*: cint
    first*: ptr TGraphEdge

  TGraphVtx2D* {.pure, final.} = object 
    flags*: cint
    first*: ptr TGraphEdge
    thePtr*: ptr TPoint2D32f


#
#   Graph is "derived" from the set (this is set a of vertices)
#   and includes another set (edges)
#

type 
  TGraph* {.pure, final.} = object 
    flags*: cint              # Miscellaneous flags.     
    header_size*: cint        # Size of sequence header. 
    v_next*: ptr TSeq         # 2nd next sequence.       
    total*: cint              # Total number of elements.            
    elem_size*: cint          # Size of sequence element in bytes.   
    block_max*: ptr schar     # Maximal bound of the last block.     
    thePtr*: ptr schar        # Current write pointer.               
    delta_elems*: cint        # Grow seq this many at a time.        
    storage*: ptr TMemStorage # Where the seq is stored.             
    free_blocks*: ptr TSeqBlock # Free blocks list.                    
    first*: ptr TSeqBlock     # Pointer to the first sequence block. 
    free_elems*: ptr TSetElem
    active_count*: cint
    edges*: ptr TSet


const 
  TYPE_NAME_GRAPH* = "opencv-graph"

#********************************** Chain/Countour ************************************

type 
  TChain* {.pure, final.} = object 
    flags*: cint              # Miscellaneous flags.     
    header_size*: cint        # Size of sequence header. 
    v_next*: ptr TSeq         # 2nd next sequence.       
    total*: cint              # Total number of elements.            
    elem_size*: cint          # Size of sequence element in bytes.   
    block_max*: ptr schar     # Maximal bound of the last block.     
    thePtr*: ptr schar        # Current write pointer.               
    delta_elems*: cint        # Grow seq this many at a time.        
    storage*: ptr TMemStorage # Where the seq is stored.             
    free_blocks*: ptr TSeqBlock # Free blocks list.                    
    first*: ptr TSeqBlock     # Pointer to the first sequence block. 
    origin*: TPoint

  TContour* {.pure, final.} = object 
    flags*: cint              # Miscellaneous flags.     
    header_size*: cint        # Size of sequence header. 
    v_next*: ptr TSeq         # 2nd next sequence.       
    total*: cint              # Total number of elements.            
    elem_size*: cint          # Size of sequence element in bytes.   
    block_max*: ptr schar     # Maximal bound of the last block.     
    thePtr*: ptr schar        # Current write pointer.               
    delta_elems*: cint        # Grow seq this many at a time.        
    storage*: ptr TMemStorage # Where the seq is stored.             
    free_blocks*: ptr TSeqBlock # Free blocks list.                    
    first*: ptr TSeqBlock     # Pointer to the first sequence block. 
    rect*: TRect
    color*: cint
    reserved*: array[0..3 - 1, cint]

  TPoint2DSeq* = TContour

#***************************************************************************************\
#                                    Sequence types                                      *
#\***************************************************************************************

const 
  SEQ_MAGIC_VAL* = 0x42990000

const 
  SET_MAGIC_VAL* = 0x42980000

const 
  SEQ_ELTYPE_BITS* = 12
  SEQ_ELTYPE_MASK* = ((1 shl SEQ_ELTYPE_BITS) - 1)
  SEQ_ELTYPE_POINT* = CV_32SC2 # (x,y) 
  SEQ_ELTYPE_CODE* = CV_8UC1  # freeman code: 0..7 
  SEQ_ELTYPE_GENERIC* = 0
  SEQ_ELTYPE_PTR* = USRTYPE1
  SEQ_ELTYPE_PPOINT* = SEQ_ELTYPE_PTR # &(x,y) 
  SEQ_ELTYPE_INDEX* = CV_32SC1 # #(x,y) 
  SEQ_ELTYPE_GRAPH_EDGE* = 0  # &next_o, &next_d, &vtx_o, &vtx_d 
  SEQ_ELTYPE_GRAPH_VERTEX* = 0 # first_edge, &(x,y) 
  SEQ_ELTYPE_TRIAN_ATR* = 0   # vertex of the binary tree   
  SEQ_ELTYPE_CONNECTED_COMP* = 0 # connected component  
  SEQ_ELTYPE_POINT3D* = CV_32FC3 # (x,y,z)  
  SEQ_KIND_BITS* = 2
  SEQ_KIND_MASK* = (((1 shl SEQ_KIND_BITS) - 1) shl SEQ_ELTYPE_BITS)

# types of sequences 

const 
  SEQ_KIND_GENERIC* = (0 shl SEQ_ELTYPE_BITS)
  SEQ_KIND_CURVE* = (1 shl SEQ_ELTYPE_BITS)
  SEQ_KIND_BIN_TREE* = (2 shl SEQ_ELTYPE_BITS)

# types of sparse sequences (sets) 

const 
  SEQ_KIND_GRAPH* = (1 shl SEQ_ELTYPE_BITS)
  SEQ_KIND_SUBDIV2D* = (2 shl SEQ_ELTYPE_BITS)
  SEQ_FLAG_SHIFT* = (SEQ_KIND_BITS + SEQ_ELTYPE_BITS)

# flags for curves 

const 
  SEQ_FLAG_CLOSED* = (1 shl SEQ_FLAG_SHIFT)
  SEQ_FLAG_SIMPLE* = (0 shl SEQ_FLAG_SHIFT)
  SEQ_FLAG_CONVEX* = (0 shl SEQ_FLAG_SHIFT)
  SEQ_FLAG_HOLE* = (2 shl SEQ_FLAG_SHIFT)

# flags for graphs 

const 
  GRAPH_FLAG_ORIENTED* = (1 shl SEQ_FLAG_SHIFT)
  GRAPH* = SEQ_KIND_GRAPH
  ORIENTED_GRAPH* = (SEQ_KIND_GRAPH or GRAPH_FLAG_ORIENTED)

# point sets 

const 
  SEQ_POINT_SET* = (SEQ_KIND_GENERIC or SEQ_ELTYPE_POINT)
  SEQ_POINT3D_SET* = (SEQ_KIND_GENERIC or SEQ_ELTYPE_POINT3D)
  SEQ_POLYLINE* = (SEQ_KIND_CURVE or SEQ_ELTYPE_POINT)
  SEQ_POLYGON* = (SEQ_FLAG_CLOSED or SEQ_POLYLINE)
  SEQ_CONTOUR* = SEQ_POLYGON
  SEQ_SIMPLE_POLYGON* = (SEQ_FLAG_SIMPLE or SEQ_POLYGON)

# chain-coded curves 

const 
  SEQ_CHAIN* = (SEQ_KIND_CURVE or SEQ_ELTYPE_CODE)
  SEQ_CHAIN_CONTOUR* = (SEQ_FLAG_CLOSED or SEQ_CHAIN)

# binary tree for the contour 

const 
  SEQ_POLYGON_TREE* = (SEQ_KIND_BIN_TREE or SEQ_ELTYPE_TRIAN_ATR)

# sequence of the connected components 

const 
  SEQ_CONNECTED_COMP* = (SEQ_KIND_GENERIC or SEQ_ELTYPE_CONNECTED_COMP)

# sequence of the integer numbers 

const 
  SEQ_INDEX* = (SEQ_KIND_GENERIC or SEQ_ELTYPE_INDEX)

# flag checking 

#**************************************************************************************
#                            Sequence writer & reader                                  
#**************************************************************************************

type 
  TSeqWriter* {.pure, final.} = object 
    header_size*: cint
    seq*: ptr TSeq            # the sequence written 
    theBlock*: ptr TSeqBlock     # current block 
    thePtr*: ptr schar        # pointer to free space 
    block_min*: ptr schar     # pointer to the beginning of block
    block_max*: ptr schar     # pointer to the end of block 
  
  TSeqReader* {.pure, final.} = object 
    header_size*: cint
    seq*: ptr TSeq            # sequence, beign read 
    theBlock*: ptr TSeqBlock     # current block 
    thePtr*: ptr schar        # pointer to element be read next 
    block_min*: ptr schar     # pointer to the beginning of block 
    block_max*: ptr schar     # pointer to the end of block 
    delta_index*: cint        # = seq->first->start_index   
    prev_elem*: ptr schar     # pointer to previous element 
  

#**************************************************************************************
#                                Operations on sequences                               
#**************************************************************************************
#***************************************************************************************\
#             Data structures for persistence (a.k.a serialization) functionality        *
#\***************************************************************************************
# "black box" file storage 


# Storage flags: 

const 
  STORAGE_READ* = 0
  STORAGE_WRITE* = 1
  STORAGE_WRITE_TEXT* = STORAGE_WRITE
  STORAGE_WRITE_BINARY* = STORAGE_WRITE
  STORAGE_APPEND* = 2
  STORAGE_MEMORY* = 4
  STORAGE_FORMAT_MASK* = (7 shl 3)
  STORAGE_FORMAT_AUTO* = 0
  STORAGE_FORMAT_XML* = 8
  STORAGE_FORMAT_YAML* = 16

# List of attributes: 

type 
  TAttrList* {.pure, final.} = object 
    attr*: cstringArray       # NULL-terminated array of (attribute_name,attribute_value) pairs. 
    next*: ptr TAttrList      # Pointer to next chunk of the attributes list.                    
  

proc AttrList*(attr: cstringArray = nil; next: ptr TAttrList = nil): TAttrList {.
    cdecl.} = 
  var l: TAttrList
  l.attr = attr
  l.next = next
  return l

type 
  TTypeInfo* {.pure, final.} = object 
  

const 
  NODE_NONE* = 0
  NODE_INT* = 1
  NODE_INTEGER* = NODE_INT
  NODE_REAL* = 2
  NODE_FLOAT* = NODE_REAL
  NODE_STR* = 3
  NODE_STRING* = NODE_STR
  NODE_REF* = 4               # not used 
  NODE_SEQ* = 5
  NODE_MAP* = 6
  NODE_TYPE_MASK* = 7

template NODE_TYPE*(flags: expr): expr = 
  ((flags) and NODE_TYPE_MASK)

# file node flags 

const 
  NODE_FLOW* = 8              # Used only for writing structures in YAML format. 
  NODE_USER* = 16
  NODE_EMPTY* = 32
  NODE_NAMED* = 64

template NODE_IS_INT*(flags: expr): expr = 
  (NODE_TYPE(flags) == NODE_INT)

template NODE_IS_REAL*(flags: expr): expr = 
  (NODE_TYPE(flags) == NODE_REAL)

template NODE_IS_STRING*(flags: expr): expr = 
  (NODE_TYPE(flags) == NODE_STRING)

template NODE_IS_SEQ*(flags: expr): expr = 
  (NODE_TYPE(flags) == NODE_SEQ)

template NODE_IS_MAP*(flags: expr): expr = 
  (NODE_TYPE(flags) == NODE_MAP)

template NODE_IS_COLLECTION*(flags: expr): expr = 
  (NODE_TYPE(flags) >= NODE_SEQ)

template NODE_IS_FLOW*(flags: expr): expr = 
  (((flags) and NODE_FLOW) != 0)

template NODE_IS_EMPTY*(flags: expr): expr = 
  (((flags) and NODE_EMPTY) != 0)

template NODE_IS_USER*(flags: expr): expr = 
  (((flags) and NODE_USER) != 0)

template NODE_HAS_NAME*(flags: expr): expr = 
  (((flags) and NODE_NAMED) != 0)

const 
  NODE_SEQ_SIMPLE* = 256

type 
  TString* {.pure, final.} = object 
    len*: cint
    thePtr*: cstring


# All the keys (names) of elements in the readed file storage
#   are stored in the hash to speed up the lookup operations: 

type 
  TStringHashNode* {.pure, final.} = object 
    hashval*: cuint
    str*: TString
    next*: ptr TStringHashNode

  TGenericHash {.pure, final.} = object

  TFileNodeHash* = TGenericHash
  TFileNodeData* {.pure, final.} = object 
    f*: cdouble               # scalar floating-point number 
    i*: cint                  # scalar integer number 
    str*: TString             # text string 
    seq*: TSeq                # sequence (ordered collection of file nodes) 
    map*: TFileNodeHash       # map (collection of named file nodes) 
  

#var fileNodeData*: TFileNodeData

# Basic element of the file storage - scalar or collection: 

type 
  TFileNode* {.pure, final.} = object 
    tag*: cint
    info*: ptr TTypeInfo      # type information
                              #            (only for user-defined object, for others it is 0) 
    data*: TFileNodeData
  TFileStorage* {.pure, final.} = object
  TIsInstanceFunc* = proc (struct_ptr: pointer): cint {.cdecl.}
  TReleaseFunc* = proc (struct_dblptr: ptr pointer) {.cdecl.}
  TReadFunc* = proc (storage: ptr TFileStorage; node: ptr TFileNode): pointer {.
      cdecl.}
  TWriteFunc* = proc (storage: ptr TFileStorage; name: cstring; 
                      struct_ptr: pointer; attributes: TAttrList) {.cdecl.}
  TCloneFunc* = proc (struct_ptr: pointer): pointer {.cdecl.}
  TCvTypeInfo* {.pure, final.} = object 
    flags*: cint
    header_size*: cint
    prev*: ptr TTypeInfo
    next*: ptr TTypeInfo
    type_name*: cstring
    is_instance*: TIsInstanceFunc
    release*: TReleaseFunc
    read*: TReadFunc
    write*: TWriteFunc
    clone*: TCloneFunc


#*** System data types *****

type 
  TPluginFuncInfo* {.pure, final.} = object 
    func_addr*: ptr pointer
    default_func_addr*: pointer
    func_names*: cstring
    search_modules*: cint
    loaded_from*: cint

  TModuleInfo* {.pure, final.} = object 
    next*: ptr TModuleInfo
    name*: cstring
    version*: cstring
    func_tab*: ptr TPluginFuncInfo


# End of file. 
