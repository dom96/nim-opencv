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
when defined(windows): 
  const 
    coredll* = "libopencv_core.dll"
elif defined(macosx): 
  const 
    coredll* = "libopencv_core.dylib"
else: 
  const 
    coredll* = "libopencv_core.so"
include types

#from math import round

#
#***************************************************************************************\
#          Array allocation, deallocation, initialization and access to elements         *
#
#\***************************************************************************************
# <malloc> wrapper.
#   If there is no enough memory, the function
#   (as well as other OpenCV functions that call cvAlloc)
#   raises an error. 

# proc Alloc*(size: csize): pointer {.cdecl, importc: "cvAlloc", dynlib: coredll.}
# <free> wrapper.
#   Here and further all the memory releasing functions
#   (that all call cvFree) take double pointer in order to
#   to clear pointer to the data after releasing it.
#   Passing pointer to NULL pointer is Ok: nothing happens in this case
#

# proc Free_*(thePtr: pointer) {.cdecl, importc: "cvFree_", dynlib: coredll.}
# #define cvFree(ptr) (cvFree_(*(ptr)), *(ptr)=0)
# Allocates and initializes IplImage header 

proc CreateImageHeader*(size: TSize; depth: cint; channels: cint): ptr TIplImage {.
    cdecl, importc: "cvCreateImageHeader", dynlib: coredll.}
# Inializes IplImage header 

proc InitImageHeader*(image: ptr TIplImage; size: TSize; depth: cint; 
                      channels: cint; origin: cint = 0; align: cint = 4): ptr TIplImage {.
    cdecl, importc: "cvInitImageHeader", dynlib: coredll.}
# Creates IPL image (header and data) 

proc CreateImage*(size: TSize; depth: cint; channels: cint): ptr TIplImage {.
    cdecl, importc: "cvCreateImage", dynlib: coredll.}
# Releases (i.e. deallocates) IPL image header 

proc ReleaseImageHeader*(image: ptr ptr TIplImage) {.cdecl, 
    importc: "cvReleaseImageHeader", dynlib: coredll.}
# Releases IPL image header and data 

proc ReleaseImage*(image: ptr ptr TIplImage) {.cdecl, 
    importc: "cvReleaseImage", dynlib: coredll.}
# Creates a copy of IPL image (widthStep may differ) 

proc CloneImage*(image: ptr TIplImage): ptr TIplImage {.cdecl, 
    importc: "cvCloneImage", dynlib: coredll.}
# Sets a Channel Of Interest (only a few functions support COI) -
#   use cvCopy to extract the selected channel and/or put it back 

proc SetImageCOI*(image: ptr TIplImage; coi: cint) {.cdecl, 
    importc: "cvSetImageCOI", dynlib: coredll.}
# Retrieves image Channel Of Interest 

proc GetImageCOI*(image: ptr TIplImage): cint {.cdecl, 
    importc: "cvGetImageCOI", dynlib: coredll.}
# Sets image ROI (region of interest) (COI is not changed) 

proc SetImageROI*(image: ptr TIplImage; rect: TRect) {.cdecl, 
    importc: "cvSetImageROI", dynlib: coredll.}
# Resets image ROI and COI 

proc ResetImageROI*(image: ptr TIplImage) {.cdecl, importc: "cvResetImageROI", 
    dynlib: coredll.}
# Retrieves image ROI 

proc GetImageROI*(image: ptr TIplImage): TRect {.cdecl, 
    importc: "cvGetImageROI", dynlib: coredll.}
# Allocates and initalizes CvMat header 

proc CreateMatHeader*(rows: cint; cols: cint; theType: cint): ptr TMat {.cdecl, 
    importc: "cvCreateMatHeader", dynlib: coredll.}


# Initializes CvMat header 

proc InitMatHeader*(mat: ptr TMat; rows: cint; cols: cint; theType: cint; 
                    data: pointer = nil; step: cint = AUTOSTEP): ptr TMat {.
    cdecl, importc: "cvInitMatHeader", dynlib: coredll.}
# Allocates and initializes CvMat header and allocates data 

proc CreateMat*(rows: cint; cols: cint; theType: cint): ptr TMat {.cdecl, 
    importc: "cvCreateMat", dynlib: coredll.}
# Releases CvMat header and deallocates matrix data
#   (reference counting is used for data) 

proc ReleaseMat*(mat: ptr ptr TMat) {.cdecl, importc: "cvReleaseMat", 
                                      dynlib: coredll.}
# Decrements CvMat data reference counter and deallocates the data if
#   it reaches 0 

discard """ proc DecRefData*(arr: ptr TArr) {.cdecl.} = 
  if IS_MAT(arr): 
    var mat: ptr TMat = cast[ptr TMat](arr)
    mat.data.thePtr = nil
    if mat.refcount != nil and dec(mat.refcount[]) == 0: 
      Free(addr(mat.refcount))
    mat.refcount = nil
  elif IS_MATND(arr): 
    var mat: ptr TMatND = cast[ptr TMatND](arr)
    mat.data.thePtr = nil
    if mat.refcount != nil and dec(mat.refcount[]) == 0: 
      Free(addr(mat.refcount))
    mat.refcount = nil """

# Increments CvMat data reference counter 

discard """ proc IncRefData*(arr: ptr TArr): cint {.cdecl.} = 
  var refcount: cint = 0
  if IS_MAT(arr): 
    var mat: ptr TMat = cast[ptr TMat](arr)
    if mat.refcount != nil: refcount = inc(mat.refcount[])
  elif IS_MATND(arr): 
    var mat: ptr TMatND = cast[ptr TMatND](arr)
    if mat.refcount != nil: refcount = inc(mat.refcount[])
  return refcount """

# Creates an exact copy of the input matrix (except, may be, step value) 

proc CloneMat*(mat: ptr TMat): ptr TMat {.cdecl, importc: "cvCloneMat", 
    dynlib: coredll.}
# Makes a new matrix from <rect> subrectangle of input array.
#   No data is copied 

proc GetSubRect*(arr: ptr TArr; submat: ptr TMat; rect: TRect): ptr TMat {.
    cdecl, importc: "cvGetSubRect", dynlib: coredll.}
const 
  GetSubArr* = GetSubRect

# Selects row span of the input array: arr(start_row:delta_row:end_row,:)
#    (end_row is not included into the span). 

proc GetRows*(arr: ptr TArr; submat: ptr TMat; start_row: cint; end_row: cint; 
              delta_row: cint = 1): ptr TMat {.cdecl, importc: "cvGetRows", 
    dynlib: coredll.}
proc GetRow*(arr: ptr TArr; submat: ptr TMat; row: cint): ptr TMat {.cdecl.} = 
  return GetRows(arr, submat, row, row + 1, 1)

# Selects column span of the input array: arr(:,start_col:end_col)
#   (end_col is not included into the span) 

proc GetCols*(arr: ptr TArr; submat: ptr TMat; start_col: cint; end_col: cint): ptr TMat {.
    cdecl, importc: "cvGetCols", dynlib: coredll.}
proc GetCol*(arr: ptr TArr; submat: ptr TMat; col: cint): ptr TMat {.cdecl.} = 
  return GetCols(arr, submat, col, col + 1)

# Select a diagonal of the input array.
#   (diag = 0 means the main diagonal, >0 means a diagonal above the main one,
#   <0 - below the main one).
#   The diagonal will be represented as a column (nx1 matrix). 

proc GetDiag*(arr: ptr TArr; submat: ptr TMat; diag: cint = 0): ptr TMat {.
    cdecl, importc: "cvGetDiag", dynlib: coredll.}
# low-level scalar <-> raw data conversion functions 

proc ScalarToRawData*(scalar: ptr TScalar; data: pointer; theType: cint; 
                      extend_to_12: cint = 0) {.cdecl, 
    importc: "cvScalarToRawData", dynlib: coredll.}
proc RawDataToScalar*(data: pointer; theType: cint; scalar: ptr TScalar) {.
    cdecl, importc: "cvRawDataToScalar", dynlib: coredll.}
# Allocates and initializes CvMatND header 

proc CreateMatNDHeader*(dims: cint; sizes: ptr cint; theType: cint): ptr TMatND {.
    cdecl, importc: "cvCreateMatNDHeader", dynlib: coredll.}
# Allocates and initializes CvMatND header and allocates data 

proc CreateMatND*(dims: cint; sizes: ptr cint; theType: cint): ptr TMatND {.
    cdecl, importc: "cvCreateMatND", dynlib: coredll.}
# Initializes preallocated CvMatND header 

proc InitMatNDHeader*(mat: ptr TMatND; dims: cint; sizes: ptr cint; 
                      theType: cint; data: pointer = nil): ptr TMatND {.cdecl, 
    importc: "cvInitMatNDHeader", dynlib: coredll.}
# Releases CvMatND 

proc ReleaseMatND*(mat: ptr ptr TMatND) {.cdecl.} = 
  ReleaseMat(cast[ptr ptr TMat](mat))

# Creates a copy of CvMatND (except, may be, steps) 

proc CloneMatND*(mat: ptr TMatND): ptr TMatND {.cdecl, importc: "cvCloneMatND", 
    dynlib: coredll.}
# Allocates and initializes CvSparseMat header and allocates data 

proc CreateSparseMat*(dims: cint; sizes: ptr cint; theType: cint): ptr TSparseMat {.
    cdecl, importc: "cvCreateSparseMat", dynlib: coredll.}
# Releases CvSparseMat 

proc ReleaseSparseMat*(mat: ptr ptr TSparseMat) {.cdecl, 
    importc: "cvReleaseSparseMat", dynlib: coredll.}
# Creates a copy of CvSparseMat (except, may be, zero items) 

proc CloneSparseMat*(mat: ptr TSparseMat): ptr TSparseMat {.cdecl, 
    importc: "cvCloneSparseMat", dynlib: coredll.}
# Initializes sparse array iterator
#   (returns the first node or NULL if the array is empty) 

proc InitSparseMatIterator*(mat: ptr TSparseMat; 
                            mat_iterator: ptr TSparseMatIterator): ptr TSparseNode {.
    cdecl, importc: "cvInitSparseMatIterator", dynlib: coredll.}
# returns next sparse array node (or NULL if there is no more nodes)

discard """ proc GetNextSparseNode*(mat_iterator: ptr TSparseMatIterator): ptr TSparseNode {.
    cdecl.} = 
  if mat_iterator.node.next != nil: 
    mat_iterator.node = mat_iterator.node.next
    return mat_iterator.node
  else: 
    inc(mat_iterator.curidx)
    for idx in mat_iterator.curidx .. <mat_iterator.mat.hashsize: 
      var node: ptr TSparseNode = cast[ptr TSparseNode](mat_iterator.mat.hashtable[
          idx])
      if node: 
        mat_iterator.curidx = idx
        mat_iterator.node = node
        return mat_iterator.node
    return nil """

#*************** matrix iterator: used for n-ary operations on dense arrays ********

const 
  MAX_ARR* = 10

type 
  TNArrayIterator* {.pure, final.} = object 
    count*: cint              # number of arrays 
    dims*: cint               # number of dimensions to iterate 
    size*: TSize              # maximal common linear size: { width = size, height = 1 } 
    thePtr*: array[0..MAX_ARR - 1, ptr cuchar] # pointers to the array slices 
    stack*: array[0..MAX_DIM - 1, cint] # for internal use 
    hdr*: array[0..MAX_ARR - 1, ptr TMatND] # pointers to the headers of the
                                            #                                 matrices that are processed 
  

const 
  NO_DEPTH_CHECK* = 1
  NO_CN_CHECK* = 2
  NO_SIZE_CHECK* = 4

# initializes iterator that traverses through several arrays simulteneously
#   (the function together with cvNextArraySlice is used for
#    N-ari element-wise operations) 

proc InitNArrayIterator*(count: cint; arrs: ptr ptr TArr; mask: ptr TArr; 
                         stubs: ptr TMatND; array_iterator: ptr TNArrayIterator; 
                         flags: cint = 0): cint {.cdecl, 
    importc: "cvInitNArrayIterator", dynlib: coredll.}
# returns zero value if iteration is finished, non-zero (slice length) otherwise 

proc NextNArraySlice*(array_iterator: ptr TNArrayIterator): cint {.cdecl, 
    importc: "cvNextNArraySlice", dynlib: coredll.}
# Returns type of array elements:
#   CV_8UC1 ... CV_64FC4 ... 

proc GetElemType*(arr: ptr TArr): cint {.cdecl, importc: "cvGetElemType", 
    dynlib: coredll.}
# Retrieves number of an array dimensions and
#   optionally sizes of the dimensions 

proc GetDims*(arr: ptr TArr; sizes: ptr cint = nil): cint {.cdecl, 
    importc: "cvGetDims", dynlib: coredll.}
# Retrieves size of a particular array dimension.
#   For 2d arrays cvGetDimSize(arr,0) returns number of rows (image height)
#   and cvGetDimSize(arr,1) returns number of columns (image width) 

proc GetDimSize*(arr: ptr TArr; index: cint): cint {.cdecl, 
    importc: "cvGetDimSize", dynlib: coredll.}
# ptr = &arr(idx0,idx1,...). All indexes are zero-based,
#   the major dimensions go first (e.g. (y,x) for 2D, (z,y,x) for 3D 

proc Ptr1D*(arr: ptr TArr; idx0: cint; theType: ptr cint = nil): ptr cuchar {.
    cdecl, importc: "cvPtr1D", dynlib: coredll.}
proc Ptr2D*(arr: ptr TArr; idx0: cint; idx1: cint; theType: ptr cint = nil): ptr cuchar {.
    cdecl, importc: "cvPtr2D", dynlib: coredll.}
proc Ptr3D*(arr: ptr TArr; idx0: cint; idx1: cint; idx2: cint; 
            theType: ptr cint = nil): ptr cuchar {.cdecl, importc: "cvPtr3D", 
    dynlib: coredll.}
# For CvMat or IplImage number of indices should be 2
#   (row index (y) goes first, column index (x) goes next).
#   For CvMatND or CvSparseMat number of infices should match number of <dims> and
#   indices order should match the array dimension order. 

proc PtrND*(arr: ptr TArr; idx: ptr cint; theType: ptr cint = nil; 
            create_node: cint = 1; precalc_hashval: ptr cuint = nil): ptr cuchar {.
    cdecl, importc: "cvPtrND", dynlib: coredll.}
# value = arr(idx0,idx1,...) 

proc Get1D*(arr: ptr TArr; idx0: cint): TScalar {.cdecl, importc: "cvGet1D", 
    dynlib: coredll.}
proc Get2D*(arr: ptr TArr; idx0: cint; idx1: cint): TScalar {.cdecl, 
    importc: "cvGet2D", dynlib: coredll.}
proc Get3D*(arr: ptr TArr; idx0: cint; idx1: cint; idx2: cint): TScalar {.cdecl, 
    importc: "cvGet3D", dynlib: coredll.}
proc GetND*(arr: ptr TArr; idx: ptr cint): TScalar {.cdecl, importc: "cvGetND", 
    dynlib: coredll.}
# for 1-channel arrays 

proc GetReal1D*(arr: ptr TArr; idx0: cint): cdouble {.cdecl, 
    importc: "cvGetReal1D", dynlib: coredll.}
proc GetReal2D*(arr: ptr TArr; idx0: cint; idx1: cint): cdouble {.cdecl, 
    importc: "cvGetReal2D", dynlib: coredll.}
proc GetReal3D*(arr: ptr TArr; idx0: cint; idx1: cint; idx2: cint): cdouble {.
    cdecl, importc: "cvGetReal3D", dynlib: coredll.}
proc GetRealND*(arr: ptr TArr; idx: ptr cint): cdouble {.cdecl, 
    importc: "cvGetRealND", dynlib: coredll.}
# arr(idx0,idx1,...) = value 

proc Set1D*(arr: ptr TArr; idx0: cint; value: TScalar) {.cdecl, 
    importc: "cvSet1D", dynlib: coredll.}
proc Set2D*(arr: ptr TArr; idx0: cint; idx1: cint; value: TScalar) {.cdecl, 
    importc: "cvSet2D", dynlib: coredll.}
proc Set3D*(arr: ptr TArr; idx0: cint; idx1: cint; idx2: cint; value: TScalar) {.
    cdecl, importc: "cvSet3D", dynlib: coredll.}
proc SetND*(arr: ptr TArr; idx: ptr cint; value: TScalar) {.cdecl, 
    importc: "cvSetND", dynlib: coredll.}
# for 1-channel arrays 

proc SetReal1D*(arr: ptr TArr; idx0: cint; value: cdouble) {.cdecl, 
    importc: "cvSetReal1D", dynlib: coredll.}
proc SetReal2D*(arr: ptr TArr; idx0: cint; idx1: cint; value: cdouble) {.cdecl, 
    importc: "cvSetReal2D", dynlib: coredll.}
proc SetReal3D*(arr: ptr TArr; idx0: cint; idx1: cint; idx2: cint; 
                value: cdouble) {.cdecl, importc: "cvSetReal3D", dynlib: coredll.}
proc SetRealND*(arr: ptr TArr; idx: ptr cint; value: cdouble) {.cdecl, 
    importc: "cvSetRealND", dynlib: coredll.}
# clears element of ND dense array,
#   in case of sparse arrays it deletes the specified node 

proc ClearND*(arr: ptr TArr; idx: ptr cint) {.cdecl, importc: "cvClearND", 
    dynlib: coredll.}
# Converts CvArr (IplImage or CvMat,...) to CvMat.
#   If the last parameter is non-zero, function can
#   convert multi(>2)-dimensional array to CvMat as long as
#   the last array's dimension is continous. The resultant
#   matrix will be have appropriate (a huge) number of rows 

proc GetMat*(arr: ptr TArr; header: ptr TMat; coi: ptr cint = nil; 
             allowND: cint = 0): ptr TMat {.cdecl, importc: "cvGetMat", 
    dynlib: coredll.}
# Converts CvArr (IplImage or CvMat) to IplImage 

proc GetImage*(arr: ptr TArr; image_header: ptr TIplImage): ptr TIplImage {.
    cdecl, importc: "cvGetImage", dynlib: coredll.}
# Changes a shape of multi-dimensional array.
#   new_cn == 0 means that number of channels remains unchanged.
#   new_dims == 0 means that number and sizes of dimensions remain the same
#   (unless they need to be changed to set the new number of channels)
#   if new_dims == 1, there is no need to specify new dimension sizes
#   The resultant configuration should be achievable w/o data copying.
#   If the resultant array is sparse, CvSparseMat header should be passed
#   to the function else if the result is 1 or 2 dimensional,
#   CvMat header should be passed to the function
#   else CvMatND header should be passed 

proc ReshapeMatND*(arr: ptr TArr; sizeof_header: cint; header: ptr TArr; 
                   new_cn: cint; new_dims: cint; new_sizes: ptr cint): ptr TArr {.
    cdecl, importc: "cvReshapeMatND", dynlib: coredll.}
# #define cvReshapeND( arr, header, new_cn, new_dims, new_sizes )   \
#      cvReshapeMatND( (arr), sizeof(*(header)), (header),         \
#                      (new_cn), (new_dims), (new_sizes))
# 

proc Reshape*(arr: ptr TArr; header: ptr TMat; new_cn: cint; new_rows: cint = 0): ptr TMat {.
    cdecl, importc: "cvReshape", dynlib: coredll.}
# Repeats source 2d array several times in both horizontal and
#   vertical direction to fill destination array 

proc Repeat*(src: ptr TArr; dst: ptr TArr) {.cdecl, importc: "cvRepeat", 
    dynlib: coredll.}
# Allocates array data 

proc CreateData*(arr: ptr TArr) {.cdecl, importc: "cvCreateData", 
                                  dynlib: coredll.}
# Releases array data 

proc ReleaseData*(arr: ptr TArr) {.cdecl, importc: "cvReleaseData", 
                                   dynlib: coredll.}
# Attaches user data to the array header. The step is reffered to
#   the pre-last dimension. That is, all the planes of the array
#   must be joint (w/o gaps) 

proc SetData*(arr: ptr TArr; data: pointer; step: cint) {.cdecl, 
    importc: "cvSetData", dynlib: coredll.}
# Retrieves raw data of CvMat, IplImage or CvMatND.
#   In the latter case the function raises an error if
#   the array can not be represented as a matrix 

proc GetRawData*(arr: ptr TArr; data: ptr ptr cuchar; step: ptr cint = nil; 
                 roi_size: ptr TSize = nil) {.cdecl, importc: "cvGetRawData", 
    dynlib: coredll.}
# Returns width and height of array in elements 

proc GetSize*(arr: ptr TArr): TSize {.cdecl, importc: "cvGetSize", 
                                      dynlib: coredll.}
# Copies source array to destination array 

proc Copy*(src: ptr TArr; dst: ptr TArr; mask: ptr TArr = nil) {.cdecl, 
    importc: "cvCopy", dynlib: coredll.}
# Sets all or "masked" elements of input array
#   to the same value

proc Set*(arr: ptr TArr; value: TScalar; mask: ptr TArr = nil) {.cdecl, 
    importc: "cvSet", dynlib: coredll.}
# Clears all the array elements (sets them to 0) 

proc SetZero*(arr: ptr TArr) {.cdecl, importc: "cvSetZero", dynlib: coredll.}
const 
  Zero* = SetZero

# Splits a multi-channel array into the set of single-channel arrays or
#   extracts particular [color] plane 

proc Split*(src: ptr TArr; dst0: ptr TArr; dst1: ptr TArr; dst2: ptr TArr; 
            dst3: ptr TArr) {.cdecl, importc: "cvSplit", dynlib: coredll.}
# Merges a set of single-channel arrays into the single multi-channel array
#   or inserts one particular [color] plane to the array 

proc Merge*(src0: ptr TArr; src1: ptr TArr; src2: ptr TArr; src3: ptr TArr; 
            dst: ptr TArr) {.cdecl, importc: "cvMerge", dynlib: coredll.}
# Copies several channels from input arrays to
#   certain channels of output arrays 

proc MixChannels*(src: ptr ptr TArr; src_count: cint; dst: ptr ptr TArr; 
                  dst_count: cint; from_to: ptr cint; pair_count: cint) {.cdecl, 
    importc: "cvMixChannels", dynlib: coredll.}
# Performs linear transformation on every source array element:
#   dst(x,y,c) = scale*src(x,y,c)+shift.
#   Arbitrary combination of input and output array depths are allowed
#   (number of channels must be the same), thus the function can be used
#   for type conversion 

proc ConvertScale*(src: ptr TArr; dst: ptr TArr; scale: cdouble = 1; 
                   shift: cdouble = 0) {.cdecl, importc: "cvConvertScale", 
    dynlib: coredll.}
const 
  CvtScale* = ConvertScale
  Scale* = ConvertScale

template Convert*(src, dst: expr): expr = 
  ConvertScale((src), (dst), 1, 0)

# Performs linear transformation on every source array element,
#   stores absolute value of the result:
#   dst(x,y,c) = abs(scale*src(x,y,c)+shift).
#   destination array must have 8u type.
#   In other cases one may use cvConvertScale + cvAbsDiffS 

proc ConvertScaleAbs*(src: ptr TArr; dst: ptr TArr; scale: cdouble = 1; 
                      shift: cdouble = 0) {.cdecl, importc: "cvConvertScaleAbs", 
    dynlib: coredll.}
const 
  CvtScaleAbs* = ConvertScaleAbs

# checks termination criteria validity and
#   sets eps to default_eps (if it is not set),
#   max_iter to default_max_iters (if it is not set)
#

proc CheckTermCriteria*(criteria: TTermCriteria; default_eps: cdouble; 
                        default_max_iters: cint): TTermCriteria {.cdecl, 
    importc: "cvCheckTermCriteria", dynlib: coredll.}
#***************************************************************************************\
#                   Arithmetic, logic and comparison operations                          *
#\***************************************************************************************
# dst(mask) = src1(mask) + src2(mask) 

proc Add*(src1: ptr TArr; src2: ptr TArr; dst: ptr TArr; mask: ptr TArr = nil) {.
    cdecl, importc: "cvAdd", dynlib: coredll.}
# dst(mask) = src(mask) + value 

proc AddS*(src: ptr TArr; value: TScalar; dst: ptr TArr; mask: ptr TArr = nil) {.
    cdecl, importc: "cvAddS", dynlib: coredll.}
# dst(mask) = src1(mask) - src2(mask) 

proc Sub*(src1: ptr TArr; src2: ptr TArr; dst: ptr TArr; mask: ptr TArr = nil) {.
    cdecl, importc: "cvSub", dynlib: coredll.}
# dst(mask) = src(mask) - value = src(mask) + (-value) 

proc SubS*(src: ptr TArr; value: TScalar; dst: ptr TArr; mask: ptr TArr = nil) {.
    cdecl.} = 
  AddS(src, 
       Scalar(- value.val[0], - value.val[1], - value.val[2], - value.val[3]), 
       dst, mask)

# dst(mask) = value - src(mask) 

proc SubRS*(src: ptr TArr; value: TScalar; dst: ptr TArr; mask: ptr TArr = nil) {.
    cdecl, importc: "cvSubRS", dynlib: coredll.}
# dst(idx) = src1(idx) * src2(idx) * scale
#   (scaled element-wise multiplication of 2 arrays) 

proc Mul*(src1: ptr TArr; src2: ptr TArr; dst: ptr TArr; scale: cdouble = 1) {.
    cdecl, importc: "cvMul", dynlib: coredll.}
# element-wise division/inversion with scaling:
#    dst(idx) = src1(idx) * scale / src2(idx)
#    or dst(idx) = scale / src2(idx) if src1 == 0 

proc `Div`*(src1: ptr TArr; src2: ptr TArr; dst: ptr TArr; scale: cdouble = 1) {.
    cdecl, importc: "cvDiv", dynlib: coredll.}
# dst = src1 * scale + src2 

proc ScaleAdd*(src1: ptr TArr; scale: TScalar; src2: ptr TArr; dst: ptr TArr) {.
    cdecl, importc: "cvScaleAdd", dynlib: coredll.}
template AXPY*(A, real_scalar, B, C: expr): expr = 
  ScaleAdd(A, RealScalar(real_scalar), B, C)

# dst = src1 * alpha + src2 * beta + gamma 

proc AddWeighted*(src1: ptr TArr; alpha: cdouble; src2: ptr TArr; beta: cdouble; 
                  gamma: cdouble; dst: ptr TArr) {.cdecl, 
    importc: "cvAddWeighted", dynlib: coredll.}
# result = sum_i(src1(i) * src2(i)) (results for all channels are accumulated together) 

proc DotProduct*(src1: ptr TArr; src2: ptr TArr): cdouble {.cdecl, 
    importc: "cvDotProduct", dynlib: coredll.}
# dst(idx) = src1(idx) & src2(idx) 

proc bitwiseAnd*(src1: ptr TArr; src2: ptr TArr; dst: ptr TArr; mask: ptr TArr = nil) {.
    cdecl, importc: "cvAnd", dynlib: coredll.}
# dst(idx) = src(idx) & value 

proc AndS*(src: ptr TArr; value: TScalar; dst: ptr TArr; mask: ptr TArr = nil) {.
    cdecl, importc: "cvAndS", dynlib: coredll.}
# dst(idx) = src1(idx) | src2(idx) 

proc bitwiseOr*(src1: ptr TArr; src2: ptr TArr; dst: ptr TArr; mask: ptr TArr = nil) {.
    cdecl, importc: "cvOr", dynlib: coredll.}
# dst(idx) = src(idx) | value 

proc OrS*(src: ptr TArr; value: TScalar; dst: ptr TArr; mask: ptr TArr = nil) {.
    cdecl, importc: "cvOrS", dynlib: coredll.}
# dst(idx) = src1(idx) ^ src2(idx) 

proc bitwiseXor*(src1: ptr TArr; src2: ptr TArr; dst: ptr TArr; mask: ptr TArr = nil) {.
    cdecl, importc: "cvXor", dynlib: coredll.}
# dst(idx) = src(idx) ^ value 

proc XorS*(src: ptr TArr; value: TScalar; dst: ptr TArr; mask: ptr TArr = nil) {.
    cdecl, importc: "cvXorS", dynlib: coredll.}
# dst(idx) = ~src(idx) 

proc bitwiseNot*(src: ptr TArr; dst: ptr TArr) {.cdecl, importc: "cvNot", 
    dynlib: coredll.}
# dst(idx) = lower(idx) <= src(idx) < upper(idx) 

proc InRange*(src: ptr TArr; lower: ptr TArr; upper: ptr TArr; dst: ptr TArr) {.
    cdecl, importc: "cvInRange", dynlib: coredll.}
# dst(idx) = lower <= src(idx) < upper 

proc InRangeS*(src: ptr TArr; lower: TScalar; upper: TScalar; dst: ptr TArr) {.
    cdecl, importc: "cvInRangeS", dynlib: coredll.}
const 
  CMP_EQ* = 0
  CMP_GT* = 1
  CMP_GE* = 2
  CMP_LT* = 3
  CMP_LE* = 4
  CMP_NE* = 5

# The comparison operation support single-channel arrays only.
#   Destination image should be 8uC1 or 8sC1 
# dst(idx) = src1(idx) _cmp_op_ src2(idx) 

proc Cmp*(src1: ptr TArr; src2: ptr TArr; dst: ptr TArr; cmp_op: cint) {.cdecl, 
    importc: "cvCmp", dynlib: coredll.}
# dst(idx) = src1(idx) _cmp_op_ value 

proc CmpS*(src: ptr TArr; value: cdouble; dst: ptr TArr; cmp_op: cint) {.cdecl, 
    importc: "cvCmpS", dynlib: coredll.}
# dst(idx) = min(src1(idx),src2(idx)) 

proc Min*(src1: ptr TArr; src2: ptr TArr; dst: ptr TArr) {.cdecl, 
    importc: "cvMin", dynlib: coredll.}
# dst(idx) = max(src1(idx),src2(idx)) 

proc Max*(src1: ptr TArr; src2: ptr TArr; dst: ptr TArr) {.cdecl, 
    importc: "cvMax", dynlib: coredll.}
# dst(idx) = min(src(idx),value) 

proc MinS*(src: ptr TArr; value: cdouble; dst: ptr TArr) {.cdecl, 
    importc: "cvMinS", dynlib: coredll.}
# dst(idx) = max(src(idx),value) 

proc MaxS*(src: ptr TArr; value: cdouble; dst: ptr TArr) {.cdecl, 
    importc: "cvMaxS", dynlib: coredll.}
# dst(x,y,c) = abs(src1(x,y,c) - src2(x,y,c)) 

proc AbsDiff*(src1: ptr TArr; src2: ptr TArr; dst: ptr TArr) {.cdecl, 
    importc: "cvAbsDiff", dynlib: coredll.}
# dst(x,y,c) = abs(src(x,y,c) - value(c)) 

proc AbsDiffS*(src: ptr TArr; dst: ptr TArr; value: TScalar) {.cdecl, 
    importc: "cvAbsDiffS", dynlib: coredll.}
template Abs*(src, dst: expr): expr = 
  AbsDiffS((src), (dst), ScalarAll(0))

#***************************************************************************************\
#                                Math operations                                         *
#\***************************************************************************************
# Does cartesian->polar coordinates conversion.
#   Either of output components (magnitude or angle) is optional 

proc CartToPolar*(x: ptr TArr; y: ptr TArr; magnitude: ptr TArr; 
                  angle: ptr TArr = nil; angle_in_degrees: cint = 0) {.cdecl, 
    importc: "cvCartToPolar", dynlib: coredll.}
# Does polar->cartesian coordinates conversion.
#   Either of output components (magnitude or angle) is optional.
#   If magnitude is missing it is assumed to be all 1's 

proc PolarToCart*(magnitude: ptr TArr; angle: ptr TArr; x: ptr TArr; 
                  y: ptr TArr; angle_in_degrees: cint = 0) {.cdecl, 
    importc: "cvPolarToCart", dynlib: coredll.}
# Does powering: dst(idx) = src(idx)^power 

proc Pow*(src: ptr TArr; dst: ptr TArr; power: cdouble) {.cdecl, 
    importc: "cvPow", dynlib: coredll.}
# Does exponention: dst(idx) = exp(src(idx)).
#   Overflow is not handled yet. Underflow is handled.
#   Maximal relative error is ~7e-6 for single-precision input 

proc Exp*(src: ptr TArr; dst: ptr TArr) {.cdecl, importc: "cvExp", 
    dynlib: coredll.}
# Calculates natural logarithms: dst(idx) = log(abs(src(idx))).
#   Logarithm of 0 gives large negative number(~-700)
#   Maximal relative error is ~3e-7 for single-precision output
#

proc Log*(src: ptr TArr; dst: ptr TArr) {.cdecl, importc: "cvLog", 
    dynlib: coredll.}
# Fast arctangent calculation 

proc FastArctan*(y: cfloat; x: cfloat): cfloat {.cdecl, importc: "cvFastArctan", 
    dynlib: coredll.}
# Fast cubic root calculation 

proc Cbrt*(value: cfloat): cfloat {.cdecl, importc: "cvCbrt", dynlib: coredll.}
# Checks array values for NaNs, Infs or simply for too large numbers
#   (if CV_CHECK_RANGE is set). If CV_CHECK_QUIET is set,
#   no runtime errors is raised (function returns zero value in case of "bad" values).
#   Otherwise cvError is called 

const 
  CHECK_RANGE* = 1
  CHECK_QUIET* = 2

proc CheckArr*(arr: ptr TArr; flags: cint = 0; min_val: cdouble = 0; 
               max_val: cdouble = 0): cint {.cdecl, importc: "cvCheckArr", 
    dynlib: coredll.}
const 
  CheckArray* = CheckArr
  RAND_UNI* = 0
  RAND_NORMAL* = 1

discard """ proc RandArr*(rng: ptr TRNG; arr: ptr TArr; dist_type: cint; param1: TScalar; 
              param2: TScalar) {.cdecl, importc: "cvRandArr", dynlib: coredll.}
proc RandShuffle*(mat: ptr TArr; rng: ptr TRNG; 
                  iter_factor: cdouble = 1.0000000000000000e+00) {.cdecl, 
    importc: "cvRandShuffle", dynlib: coredll.} """
const 
  SORT_EVERY_ROW* = 0
  SORT_EVERY_COLUMN* = 1
  SORT_ASCENDING* = 0
  SORT_DESCENDING* = 16

proc Sort*(src: ptr TArr; dst: ptr TArr = nil; idxmat: ptr TArr = nil; 
           flags: cint = 0) {.cdecl, importc: "cvSort", dynlib: coredll.}
# Finds real roots of a cubic equation 

proc SolveCubic*(coeffs: ptr TMat; roots: ptr TMat): cint {.cdecl, 
    importc: "cvSolveCubic", dynlib: coredll.}
# Finds all real and complex roots of a polynomial equation 

proc SolvePoly*(coeffs: ptr TMat; roots2: ptr TMat; maxiter: cint = 20; 
                fig: cint = 100) {.cdecl, importc: "cvSolvePoly", 
                                   dynlib: coredll.}
#***************************************************************************************\
#                                Matrix operations                                       *
#\***************************************************************************************
# Calculates cross product of two 3d vectors 

proc CrossProduct*(src1: ptr TArr; src2: ptr TArr; dst: ptr TArr) {.cdecl, 
    importc: "cvCrossProduct", dynlib: coredll.}
# Matrix transform: dst = A*B + C, C is optional 

template MatMulAdd*(src1, src2, src3, dst: expr): expr = 
  GEMM((src1), (src2), 1.0000000000000000e+00, (src3), 1.0000000000000000e+00, 
       (dst), 0)

template MatMul*(src1, src2, dst: expr): expr = 
  MatMulAdd((src1), (src2), nil, (dst))

const 
  GEMM_A_T* = 1
  GEMM_B_T* = 2
  GEMM_C_T* = 4

# Extended matrix transform:
#   dst = alpha*op(A)*op(B) + beta*op(C), where op(X) is X or X^T 

proc GEMM*(src1: ptr TArr; src2: ptr TArr; alpha: cdouble; src3: ptr TArr; 
           beta: cdouble; dst: ptr TArr; tABC: cint = 0) {.cdecl, 
    importc: "cvGEMM", dynlib: coredll.}
const 
  MatMulAddEx* = GEMM

# Transforms each element of source array and stores
#   resultant vectors in destination array 

proc Transform*(src: ptr TArr; dst: ptr TArr; transmat: ptr TMat; 
                shiftvec: ptr TMat = nil) {.cdecl, importc: "cvTransform", 
    dynlib: coredll.}
const 
  MatMulAddS* = Transform

# Does perspective transform on every element of input array 

proc PerspectiveTransform*(src: ptr TArr; dst: ptr TArr; mat: ptr TMat) {.cdecl, 
    importc: "cvPerspectiveTransform", dynlib: coredll.}
# Calculates (A-delta)*(A-delta)^T (order=0) or (A-delta)^T*(A-delta) (order=1) 

proc MulTransposed*(src: ptr TArr; dst: ptr TArr; order: cint; 
                    delta: ptr TArr = nil; 
                    scale: cdouble = 1.0000000000000000e+00) {.cdecl, 
    importc: "cvMulTransposed", dynlib: coredll.}
# Tranposes matrix. Square matrices can be transposed in-place 

proc Transpose*(src: ptr TArr; dst: ptr TArr) {.cdecl, importc: "cvTranspose", 
    dynlib: coredll.}
const 
  T* = Transpose

# Completes the symmetric matrix from the lower (LtoR=0) or from the upper (LtoR!=0) part 

proc CompleteSymm*(matrix: ptr TMat; LtoR: cint = 0) {.cdecl, 
    importc: "cvCompleteSymm", dynlib: coredll.}
# Mirror array data around horizontal (flip=0),
#   vertical (flip=1) or both(flip=-1) axises:
#   cvFlip(src) flips images vertically and sequences horizontally (inplace) 

proc Flip*(src: ptr TArr; dst: ptr TArr = nil; flip_mode: cint = 0) {.cdecl, 
    importc: "cvFlip", dynlib: coredll.}
const 
  Mirror* = Flip
  SVD_MODIFY_A* = 1
  SVD_U_T* = 2
  SVD_V_T* = 4

# Performs Singular Value Decomposition of a matrix 

proc SVD*(A: ptr TArr; W: ptr TArr; U: ptr TArr = nil; V: ptr TArr = nil; 
          flags: cint = 0) {.cdecl, importc: "cvSVD", dynlib: coredll.}
# Performs Singular Value Back Substitution (solves A*X = B):
#   flags must be the same as in cvSVD 

proc SVBkSb*(W: ptr TArr; U: ptr TArr; V: ptr TArr; B: ptr TArr; X: ptr TArr; 
             flags: cint) {.cdecl, importc: "cvSVBkSb", dynlib: coredll.}
const 
  LU* = 0
  CvSVD* = 1
  SVD_SYM* = 2
  CHOLESKY* = 3
  QR* = 4
  NORMAL* = 16

# Inverts matrix 

proc Invert*(src: ptr TArr; dst: ptr TArr; theMethod: cint = LU): cdouble {.cdecl, 
    importc: "cvInvert", dynlib: coredll.}
const 
  Inv* = Invert

# Solves linear system (src1)*(dst) = (src2)
#   (returns 0 if src1 is a singular and CV_LU method is used) 

proc Solve*(src1: ptr TArr; src2: ptr TArr; dst: ptr TArr; theMethod: cint = LU): cint {.
    cdecl, importc: "cvSolve", dynlib: coredll.}
# Calculates determinant of input matrix 

proc Det*(mat: ptr TArr): cdouble {.cdecl, importc: "cvDet", dynlib: coredll.}
# Calculates trace of the matrix (sum of elements on the main diagonal) 

proc Trace*(mat: ptr TArr): TScalar {.cdecl, importc: "cvTrace", dynlib: coredll.}
# Finds eigen values and vectors of a symmetric matrix 

proc EigenVV*(mat: ptr TArr; evects: ptr TArr; evals: ptr TArr; 
              eps: cdouble = 0; lowindex: cint = - 1; highindex: cint = - 1) {.
    cdecl, importc: "cvEigenVV", dynlib: coredll.}
#/* Finds selected eigen values and vectors of a symmetric matrix */
#CVAPI(void)  cvSelectedEigenVV( CvArr* mat, CvArr* evects, CvArr* evals,
#                                int lowindex, int highindex );
# Makes an identity matrix (mat_ij = i == j) 

proc SetIdentity*(mat: ptr TArr; value: TScalar = RealScalar(1)) {.cdecl, 
    importc: "cvSetIdentity", dynlib: coredll.}
# Fills matrix with given range of numbers 

proc Range*(mat: ptr TArr; start: cdouble; theEnd: cdouble): ptr TArr {.cdecl, 
    importc: "cvRange", dynlib: coredll.}
# Calculates covariation matrix for a set of vectors 
# transpose([v1-avg, v2-avg,...]) * [v1-avg,v2-avg,...] 

const 
  COVAR_SCRAMBLED* = 0

# [v1-avg, v2-avg,...] * transpose([v1-avg,v2-avg,...]) 

const 
  COVAR_NORMAL* = 1

# do not calc average (i.e. mean vector) - use the input vector instead
#   (useful for calculating covariance matrix by parts) 

const 
  COVAR_USE_AVG* = 2

# scale the covariance matrix coefficients by number of the vectors 

const 
  COVAR_SCALE* = 4

# all the input vectors are stored in a single matrix, as its rows 

const 
  COVAR_ROWS* = 8

# all the input vectors are stored in a single matrix, as its columns 

const 
  COVAR_COLS* = 16

proc CalcCovarMatrix*(vects: ptr ptr TArr; count: cint; cov_mat: ptr TArr; 
                      avg: ptr TArr; flags: cint) {.cdecl, 
    importc: "cvCalcCovarMatrix", dynlib: coredll.}
const 
  PCA_DATA_AS_ROW* = 0
  PCA_DATA_AS_COL* = 1
  PCA_USE_AVG* = 2

proc CalcPCA*(data: ptr TArr; mean: ptr TArr; eigenvals: ptr TArr; 
              eigenvects: ptr TArr; flags: cint) {.cdecl, importc: "cvCalcPCA", 
    dynlib: coredll.}
proc ProjectPCA*(data: ptr TArr; mean: ptr TArr; eigenvects: ptr TArr; 
                 result: ptr TArr) {.cdecl, importc: "cvProjectPCA", 
                                     dynlib: coredll.}
proc BackProjectPCA*(proj: ptr TArr; mean: ptr TArr; eigenvects: ptr TArr; 
                     result: ptr TArr) {.cdecl, importc: "cvBackProjectPCA", 
    dynlib: coredll.}
# Calculates Mahalanobis(weighted) distance 

proc Mahalanobis*(vec1: ptr TArr; vec2: ptr TArr; mat: ptr TArr): cdouble {.
    cdecl, importc: "cvMahalanobis", dynlib: coredll.}
const 
  Mahalonobis* = Mahalanobis

#***************************************************************************************\
#                                    Array Statistics                                    *
#\***************************************************************************************
# Finds sum of array elements 

proc Sum*(arr: ptr TArr): TScalar {.cdecl, importc: "cvSum", dynlib: coredll.}
# Calculates number of non-zero pixels 

proc CountNonZero*(arr: ptr TArr): cint {.cdecl, importc: "cvCountNonZero", 
    dynlib: coredll.}
# Calculates mean value of array elements 

proc Avg*(arr: ptr TArr; mask: ptr TArr = nil): TScalar {.cdecl, 
    importc: "cvAvg", dynlib: coredll.}
# Calculates mean and standard deviation of pixel values 

proc AvgSdv*(arr: ptr TArr; mean: ptr TScalar; std_dev: ptr TScalar; 
             mask: ptr TArr = nil) {.cdecl, importc: "cvAvgSdv", dynlib: coredll.}
# Finds global minimum, maximum and their positions 

proc MinMaxLoc*(arr: ptr TArr; min_val: ptr cdouble; max_val: ptr cdouble; 
                min_loc: ptr TPoint = nil; max_loc: ptr TPoint = nil; 
                mask: ptr TArr = nil) {.cdecl, importc: "cvMinMaxLoc", 
                                        dynlib: coredll.}
# types of array norm 

const 
  C* = 1
  L1* = 2
  L2* = 4
  NORM_MASK* = 7
  RELATIVE* = 8
  DIFF* = 16
  MINMAX* = 32
  DIFF_C* = (DIFF or C)
  DIFF_L1* = (DIFF or L1)
  DIFF_L2* = (DIFF or L2)
  RELATIVE_C* = (RELATIVE or C)
  RELATIVE_L1* = (RELATIVE or L1)
  RELATIVE_L2* = (RELATIVE or L2)

# Finds norm, difference norm or relative difference norm for an array (or two arrays) 

proc Norm*(arr1: ptr TArr; arr2: ptr TArr = nil; norm_type: cint = L2; 
           mask: ptr TArr = nil): cdouble {.cdecl, importc: "cvNorm", 
    dynlib: coredll.}
proc Normalize*(src: ptr TArr; dst: ptr TArr; 
                a: cdouble = 1.0000000000000000e+00; 
                b: cdouble = 0.0000000000000000e+00; norm_type: cint = L2; 
                mask: ptr TArr = nil) {.cdecl, importc: "cvNormalize", 
                                        dynlib: coredll.}
const 
  REDUCE_SUM* = 0
  REDUCE_AVG* = 1
  REDUCE_MAX* = 2
  REDUCE_MIN* = 3

proc Reduce*(src: ptr TArr; dst: ptr TArr; dim: cint = - 1; 
             op: cint = REDUCE_SUM) {.cdecl, importc: "cvReduce", 
                                      dynlib: coredll.}
#***************************************************************************************\
#                      Discrete Linear Transforms and Related Functions                  *
#\***************************************************************************************

const 
  DXT_FORWARD* = 0
  DXT_INVERSE* = 1
  DXT_SCALE* = 2              # divide result by size of array 
  DXT_INV_SCALE* = (DXT_INVERSE + DXT_SCALE)
  DXT_INVERSE_SCALE* = DXT_INV_SCALE
  DXT_ROWS* = 4               # transform each row individually 
  DXT_MUL_CONJ* = 8           # conjugate the second argument of cvMulSpectrums 

# Discrete Fourier Transform:
#    complex->complex,
#    real->ccs (forward),
#    ccs->real (inverse) 

proc DFT*(src: ptr TArr; dst: ptr TArr; flags: cint; nonzero_rows: cint = 0) {.
    cdecl, importc: "cvDFT", dynlib: coredll.}
const 
  FFT* = DFT

# Multiply results of DFTs: DFT(X)*DFT(Y) or DFT(X)*conj(DFT(Y)) 

proc MulSpectrums*(src1: ptr TArr; src2: ptr TArr; dst: ptr TArr; flags: cint) {.
    cdecl, importc: "cvMulSpectrums", dynlib: coredll.}
# Finds optimal DFT vector size >= size0 

proc GetOptimalDFTSize*(size0: cint): cint {.cdecl, 
    importc: "cvGetOptimalDFTSize", dynlib: coredll.}
# Discrete Cosine Transform 

proc DCT*(src: ptr TArr; dst: ptr TArr; flags: cint) {.cdecl, importc: "cvDCT", 
    dynlib: coredll.}
#***************************************************************************************\
#                              Dynamic data structures                                   *
#\***************************************************************************************
# Calculates length of sequence slice (with support of negative indices). 

proc SliceLength*(slice: core.TSlice; seq: ptr TSeq): cint {.cdecl, 
    importc: "cvSliceLength", dynlib: coredll.}
# Creates new memory storage.
#   block_size == 0 means that default,
#   somewhat optimal size, is used (currently, it is 64K) 

proc CreateMemStorage*(block_size: cint = 0): ptr TMemStorage {.cdecl, 
    importc: "cvCreateMemStorage", dynlib: coredll.}
# Creates a memory storage that will borrow memory blocks from parent storage 

proc CreateChildMemStorage*(parent: ptr TMemStorage): ptr TMemStorage {.cdecl, 
    importc: "cvCreateChildMemStorage", dynlib: coredll.}
# Releases memory storage. All the children of a parent must be released before
#   the parent. A child storage returns all the blocks to parent when it is released 

proc ReleaseMemStorage*(storage: ptr ptr TMemStorage) {.cdecl, 
    importc: "cvReleaseMemStorage", dynlib: coredll.}
# Clears memory storage. This is the only way(!!!) (besides cvRestoreMemStoragePos)
#   to reuse memory allocated for the storage - cvClearSeq,cvClearSet ...
#   do not free any memory.
#   A child storage returns all the blocks to the parent when it is cleared 

proc ClearMemStorage*(storage: ptr TMemStorage) {.cdecl, 
    importc: "cvClearMemStorage", dynlib: coredll.}
# Remember a storage "free memory" position 

proc SaveMemStoragePos*(storage: ptr TMemStorage; pos: ptr TMemStoragePos) {.
    cdecl, importc: "cvSaveMemStoragePos", dynlib: coredll.}
# Restore a storage "free memory" position 

proc RestoreMemStoragePos*(storage: ptr TMemStorage; pos: ptr TMemStoragePos) {.
    cdecl, importc: "cvRestoreMemStoragePos", dynlib: coredll.}
# Allocates continuous buffer of the specified size in the storage 

proc MemStorageAlloc*(storage: ptr TMemStorage; size: csize): pointer {.cdecl, 
    importc: "cvMemStorageAlloc", dynlib: coredll.}
# Allocates string in memory storage 

proc MemStorageAllocString*(storage: ptr TMemStorage; thePtr: cstring; 
                            len: cint = - 1): TString {.cdecl, 
    importc: "cvMemStorageAllocString", dynlib: coredll.}
# Creates new empty sequence that will reside in the specified storage 

proc CreateSeq*(seq_flags: cint; header_size: csize; elem_size: csize; 
                storage: ptr TMemStorage): ptr TSeq {.cdecl, 
    importc: "cvCreateSeq", dynlib: coredll.}
# Changes default size (granularity) of sequence blocks.
#   The default size is ~1Kbyte 

proc SetSeqBlockSize*(seq: ptr TSeq; delta_elems: cint) {.cdecl, 
    importc: "cvSetSeqBlockSize", dynlib: coredll.}
# Adds new element to the end of sequence. Returns pointer to the element 

proc SeqPush*(seq: ptr TSeq; element: pointer = nil): ptr schar {.cdecl, 
    importc: "cvSeqPush", dynlib: coredll.}
# Adds new element to the beginning of sequence. Returns pointer to it 

proc SeqPushFront*(seq: ptr TSeq; element: pointer = nil): ptr schar {.cdecl, 
    importc: "cvSeqPushFront", dynlib: coredll.}
# Removes the last element from sequence and optionally saves it 

proc SeqPop*(seq: ptr TSeq; element: pointer = nil) {.cdecl, 
    importc: "cvSeqPop", dynlib: coredll.}
# Removes the first element from sequence and optioanally saves it 

proc SeqPopFront*(seq: ptr TSeq; element: pointer = nil) {.cdecl, 
    importc: "cvSeqPopFront", dynlib: coredll.}
const 
  FRONT* = 1
  BACK* = 0

# Adds several new elements to the end of sequence 

proc SeqPushMulti*(seq: ptr TSeq; elements: pointer; count: cint; 
                   in_front: cint = 0) {.cdecl, importc: "cvSeqPushMulti", 
    dynlib: coredll.}
# Removes several elements from the end of sequence and optionally saves them 

proc SeqPopMulti*(seq: ptr TSeq; elements: pointer; count: cint; 
                  in_front: cint = 0) {.cdecl, importc: "cvSeqPopMulti", 
                                        dynlib: coredll.}
# Inserts a new element in the middle of sequence.
#   cvSeqInsert(seq,0,elem) == cvSeqPushFront(seq,elem) 

proc SeqInsert*(seq: ptr TSeq; before_index: cint; element: pointer = nil): ptr schar {.
    cdecl, importc: "cvSeqInsert", dynlib: coredll.}
# Removes specified sequence element 

proc SeqRemove*(seq: ptr TSeq; index: cint) {.cdecl, importc: "cvSeqRemove", 
    dynlib: coredll.}
# Removes all the elements from the sequence. The freed memory
#   can be reused later only by the same sequence unless cvClearMemStorage
#   or cvRestoreMemStoragePos is called 

proc ClearSeq*(seq: ptr TSeq) {.cdecl, importc: "cvClearSeq", dynlib: coredll.}
# Retrieves pointer to specified sequence element.
#   Negative indices are supported and mean counting from the end
#   (e.g -1 means the last sequence element) 

proc GetSeqElem*(seq: ptr TSeq; index: cint): ptr schar {.cdecl, 
    importc: "cvGetSeqElem", dynlib: coredll.}
# Calculates index of the specified sequence element.
#   Returns -1 if element does not belong to the sequence 

proc SeqElemIdx*(seq: ptr TSeq; element: pointer; theBlock: ptr ptr TSeqBlock = nil): cint {.
    cdecl, importc: "cvSeqElemIdx", dynlib: coredll.}
# Initializes sequence writer. The new elements will be added to the end of sequence 

proc StartAppendToSeq*(seq: ptr TSeq; writer: ptr TSeqWriter) {.cdecl, 
    importc: "cvStartAppendToSeq", dynlib: coredll.}
# Combination of cvCreateSeq and cvStartAppendToSeq 

proc StartWriteSeq*(seq_flags: cint; header_size: cint; elem_size: cint; 
                    storage: ptr TMemStorage; writer: ptr TSeqWriter) {.cdecl, 
    importc: "cvStartWriteSeq", dynlib: coredll.}
# Closes sequence writer, updates sequence header and returns pointer
#   to the resultant sequence
#   (which may be useful if the sequence was created using cvStartWriteSeq))
#

proc EndWriteSeq*(writer: ptr TSeqWriter): ptr TSeq {.cdecl, 
    importc: "cvEndWriteSeq", dynlib: coredll.}
# Updates sequence header. May be useful to get access to some of previously
#   written elements via cvGetSeqElem or sequence reader 

proc FlushSeqWriter*(writer: ptr TSeqWriter) {.cdecl, 
    importc: "cvFlushSeqWriter", dynlib: coredll.}
# Initializes sequence reader.
#   The sequence can be read in forward or backward direction 

proc StartReadSeq*(seq: ptr TSeq; reader: ptr TSeqReader; reverse: cint = 0) {.
    cdecl, importc: "cvStartReadSeq", dynlib: coredll.}
# Returns current sequence reader position (currently observed sequence element) 

proc GetSeqReaderPos*(reader: ptr TSeqReader): cint {.cdecl, 
    importc: "cvGetSeqReaderPos", dynlib: coredll.}
# Changes sequence reader position. It may seek to an absolute or
#   to relative to the current position 

proc SetSeqReaderPos*(reader: ptr TSeqReader; index: cint; is_relative: cint = 0) {.
    cdecl, importc: "cvSetSeqReaderPos", dynlib: coredll.}
# Copies sequence content to a continuous piece of memory 

proc CvtSeqToArray*(seq: ptr TSeq; elements: pointer; slice: core.TSlice = WHOLE_SEQ): pointer {.
    cdecl, importc: "cvCvtSeqToArray", dynlib: coredll.}
# Creates sequence header for array.
#   After that all the operations on sequences that do not alter the content
#   can be applied to the resultant sequence 

proc MakeSeqHeaderForArray*(seq_type: cint; header_size: cint; elem_size: cint; 
                            elements: pointer; total: cint; seq: ptr TSeq; 
                            theBlock: ptr TSeqBlock): ptr TSeq {.cdecl, 
    importc: "cvMakeSeqHeaderForArray", dynlib: coredll.}
# Extracts sequence slice (with or without copying sequence elements) 

proc SeqSlice*(seq: ptr TSeq; slice: core.TSlice; storage: ptr TMemStorage = nil; 
               copy_data: cint = 0): ptr TSeq {.cdecl, importc: "cvSeqSlice", 
    dynlib: coredll.}
proc CloneSeq*(seq: ptr TSeq; storage: ptr TMemStorage = nil): ptr TSeq {.cdecl.} = 
  return SeqSlice(seq, WHOLE_SEQ, storage, 1)

# Removes sequence slice 

proc SeqRemoveSlice*(seq: ptr TSeq; slice: core.TSlice) {.cdecl, 
    importc: "cvSeqRemoveSlice", dynlib: coredll.}
# Inserts a sequence or array into another sequence 

proc SeqInsertSlice*(seq: ptr TSeq; before_index: cint; from_arr: ptr TArr) {.
    cdecl, importc: "cvSeqInsertSlice", dynlib: coredll.}
# a < b ? -1 : a > b ? 1 : 0 

type 
  TCmpFunc* = proc (a: pointer; b: pointer; userdata: pointer): cint {.cdecl.}

# Sorts sequence in-place given element comparison function 

proc SeqSort*(seq: ptr TSeq; func: TCmpFunc; userdata: pointer = nil) {.cdecl, 
    importc: "cvSeqSort", dynlib: coredll.}
# Finds element in a [sorted] sequence 

proc SeqSearch*(seq: ptr TSeq; elem: pointer; func: TCmpFunc; is_sorted: cint; 
                elem_idx: ptr cint; userdata: pointer = nil): ptr schar {.cdecl, 
    importc: "cvSeqSearch", dynlib: coredll.}
# Reverses order of sequence elements in-place 

proc SeqInvert*(seq: ptr TSeq) {.cdecl, importc: "cvSeqInvert", dynlib: coredll.}
# Splits sequence into one or more equivalence classes using the specified criteria 

proc SeqPartition*(seq: ptr TSeq; storage: ptr TMemStorage; 
                   labels: ptr ptr TSeq; is_equal: TCmpFunc; userdata: pointer): cint {.
    cdecl, importc: "cvSeqPartition", dynlib: coredll.}
#*********** Internal sequence functions ***********

proc ChangeSeqBlock*(reader: pointer; direction: cint) {.cdecl, 
    importc: "cvChangeSeqBlock", dynlib: coredll.}
proc CreateSeqBlock*(writer: ptr TSeqWriter) {.cdecl, 
    importc: "cvCreateSeqBlock", dynlib: coredll.}
# Creates a new set 

proc CreateSet*(set_flags: cint; header_size: cint; elem_size: cint; 
                storage: ptr TMemStorage): ptr TSet {.cdecl, 
    importc: "cvCreateSet", dynlib: coredll.}
# Adds new element to the set and returns pointer to it 

proc SetAdd*(set_header: ptr TSet; elem: ptr TSetElem = nil; 
             inserted_elem: ptr ptr TSetElem = nil): cint {.cdecl, 
    importc: "cvSetAdd", dynlib: coredll.}
# Fast variant of cvSetAdd 

discard """ proc SetNew*(set_header: ptr TSet): ptr TSetElem {.cdecl.} = 
  var elem: ptr TSetElem = set_header.free_elems
  if elem: 
    set_header.free_elems = elem.next_free
    elem.flags = elem.flags and SET_ELEM_IDX_MASK
    inc(set_header.active_count)
  else: 
    SetAdd(set_header, nil, cast[ptr ptr TSetElem](addr(elem)))
  return elem """

# Removes set element given its pointer 

discard """ proc SetRemoveByPtr*(set_header: ptr TSet; elem: pointer) {.cdecl.} = 
  var elem: ptr TSetElem = cast[ptr TSetElem](elem)
  assert(elem.flags >=
      0)                      #&& (elem->flags & CV_SET_ELEM_IDX_MASK) < set_header->total
  elem.next_free = set_header.free_elems
  elem.flags = (elem.flags and SET_ELEM_IDX_MASK) or SET_ELEM_FREE_FLAG
  set_header.free_elems = elem
  dec(set_header.active_count) """

# Removes element from the set by its index  

proc SetRemove*(set_header: ptr TSet; index: cint) {.cdecl, 
    importc: "cvSetRemove", dynlib: coredll.}
# Returns a set element by index. If the element doesn't belong to the set,
#   NULL is returned 
discard """ proc getSetElem*(set_header: ptr TSet; idx: cint): ptr TSetElem {.inline, cdecl.} = 
  var elem: ptr SetElem = cast[ptr TSetElem](cvGetSeqElem(
      cast[ptr TSeq](set_header), idx))
  return if elem and IS_SET_ELEM(elem): elem else: 0 """
# Removes all the elements from the set 

proc ClearSet*(set_header: ptr TSet) {.cdecl, importc: "cvClearSet", 
                                       dynlib: coredll.}
# Creates new graph 

proc CreateGraph*(graph_flags: cint; header_size: cint; vtx_size: cint; 
                  edge_size: cint; storage: ptr TMemStorage): ptr TGraph {.
    cdecl, importc: "cvCreateGraph", dynlib: coredll.}
# Adds new vertex to the graph 

proc GraphAddVtx*(graph: ptr TGraph; vtx: ptr TGraphVtx = nil; 
                  inserted_vtx: ptr ptr TGraphVtx = nil): cint {.cdecl, 
    importc: "cvGraphAddVtx", dynlib: coredll.}
# Removes vertex from the graph together with all incident edges 

proc GraphRemoveVtx*(graph: ptr TGraph; index: cint): cint {.cdecl, 
    importc: "cvGraphRemoveVtx", dynlib: coredll.}
proc GraphRemoveVtxByPtr*(graph: ptr TGraph; vtx: ptr TGraphVtx): cint {.cdecl, 
    importc: "cvGraphRemoveVtxByPtr", dynlib: coredll.}
# Link two vertices specifed by indices or pointers if they
#   are not connected or return pointer to already existing edge
#   connecting the vertices.
#   Functions return 1 if a new edge was created, 0 otherwise 

proc GraphAddEdge*(graph: ptr TGraph; start_idx: cint; end_idx: cint; 
                   edge: ptr TGraphEdge = nil; 
                   inserted_edge: ptr ptr TGraphEdge = nil): cint {.cdecl, 
    importc: "cvGraphAddEdge", dynlib: coredll.}
proc GraphAddEdgeByPtr*(graph: ptr TGraph; start_vtx: ptr TGraphVtx; 
                        end_vtx: ptr TGraphVtx; edge: ptr TGraphEdge = nil; 
                        inserted_edge: ptr ptr TGraphEdge = nil): cint {.cdecl, 
    importc: "cvGraphAddEdgeByPtr", dynlib: coredll.}
# Remove edge connecting two vertices 

proc GraphRemoveEdge*(graph: ptr TGraph; start_idx: cint; end_idx: cint) {.
    cdecl, importc: "cvGraphRemoveEdge", dynlib: coredll.}
proc GraphRemoveEdgeByPtr*(graph: ptr TGraph; start_vtx: ptr TGraphVtx; 
                           end_vtx: ptr TGraphVtx) {.cdecl, 
    importc: "cvGraphRemoveEdgeByPtr", dynlib: coredll.}
# Find edge connecting two vertices 

proc FindGraphEdge*(graph: ptr TGraph; start_idx: cint; end_idx: cint): ptr TGraphEdge {.
    cdecl, importc: "cvFindGraphEdge", dynlib: coredll.}
proc FindGraphEdgeByPtr*(graph: ptr TGraph; start_vtx: ptr TGraphVtx; 
                         end_vtx: ptr TGraphVtx): ptr TGraphEdge {.cdecl, 
    importc: "cvFindGraphEdgeByPtr", dynlib: coredll.}
const 
  GraphFindEdge* = FindGraphEdge
  GraphFindEdgeByPtr* = FindGraphEdgeByPtr

# Remove all vertices and edges from the graph 

proc ClearGraph*(graph: ptr TGraph) {.cdecl, importc: "cvClearGraph", 
                                      dynlib: coredll.}
# Count number of edges incident to the vertex 

proc GraphVtxDegree*(graph: ptr TGraph; vtx_idx: cint): cint {.cdecl, 
    importc: "cvGraphVtxDegree", dynlib: coredll.}
proc GraphVtxDegreeByPtr*(graph: ptr TGraph; vtx: ptr TGraphVtx): cint {.cdecl, 
    importc: "cvGraphVtxDegreeByPtr", dynlib: coredll.}
# Retrieves graph vertex by given index 

template GetGraphVtx*(graph, idx: expr): expr = 
  cast[ptr TGraphVtx](GetSetElem(cast[ptr TSet]((graph)), (idx)))

# Retrieves index of a graph vertex given its pointer 

# Retrieves index of a graph edge given its pointer 

template GraphGetVtxCount*(graph: expr): expr = 
  graph.active_count

template GraphGetEdgeCount*(graph: expr): expr = 
  graph.edges.active_count

const 
  GRAPH_VERTEX* = 1
  GRAPH_TREE_EDGE* = 2
  GRAPH_BACK_EDGE* = 4
  GRAPH_FORWARD_EDGE* = 8
  GRAPH_CROSS_EDGE* = 16
  GRAPH_ANY_EDGE* = 30
  GRAPH_NEW_TREE* = 32
  GRAPH_BACKTRACKING* = 64
  GRAPH_OVER* = - 1
  GRAPH_ALL_ITEMS* = - 1

# flags for graph vertices and edges 

const 
  GRAPH_ITEM_VISITED_FLAG* = (1 shl 30)

# #define  CV_IS_GRAPH_VERTEX_VISITED(vtx) \
#    (((CvGraphVtx*)(vtx))->flags & CV_GRAPH_ITEM_VISITED_FLAG) 
# #define  CV_IS_GRAPH_EDGE_VISITED(edge) \
#    (((CvGraphEdge*)(edge))->flags & CV_GRAPH_ITEM_VISITED_FLAG) 

const 
  GRAPH_SEARCH_TREE_NODE_FLAG* = (1 shl 29)
  GRAPH_FORWARD_EDGE_FLAG* = (1 shl 28)

type 
  TGraphScanner* {.pure, final.} = object 
    vtx*: ptr TGraphVtx       # current graph vertex (or current edge origin) 
    dst*: ptr TGraphVtx       # current graph edge destination vertex 
    edge*: ptr TGraphEdge     # current edge 
    graph*: ptr TGraph        # the graph 
    stack*: ptr TSeq          # the graph vertex stack 
    index*: cint              # the lower bound of certainly visited vertices 
    mask*: cint               # event mask 
  

# Creates new graph scanner. 

proc CreateGraphScanner*(graph: ptr TGraph; vtx: ptr TGraphVtx = nil; 
                         mask: cint = GRAPH_ALL_ITEMS): ptr TGraphScanner {.
    cdecl, importc: "cvCreateGraphScanner", dynlib: coredll.}
# Releases graph scanner. 

proc ReleaseGraphScanner*(scanner: ptr ptr TGraphScanner) {.cdecl, 
    importc: "cvReleaseGraphScanner", dynlib: coredll.}
# Get next graph element 

proc NextGraphItem*(scanner: ptr TGraphScanner): cint {.cdecl, 
    importc: "cvNextGraphItem", dynlib: coredll.}
# Creates a copy of graph 

proc CloneGraph*(graph: ptr TGraph; storage: ptr TMemStorage): ptr TGraph {.
    cdecl, importc: "cvCloneGraph", dynlib: coredll.}
#***************************************************************************************\
#                                     Drawing                                            *
#\***************************************************************************************
#***************************************************************************************\
#       Drawing functions work with images/matrices of arbitrary type.                   *
#       For color images the channel order is BGR[A]                                     *
#       Antialiasing is supported only for 8-bit image now.                              *
#       All the functions include parameter color that means rgb value (that may be      *
#       constructed with CV_RGB macro) for color images and brightness                   *
#       for grayscale images.                                                            *
#       If a drawn figure is partially or completely outside of the image, it is clipped.*
#\***************************************************************************************

template RGB*(r, g, b: expr): expr = 
  Scalar((b), (g), (r), 0)

const 
  FILLED* = - 1
  AA* = 16

# Draws 4-connected, 8-connected or antialiased line segment connecting two points 

proc Line*(img: ptr TArr; pt1: TPoint; pt2: TPoint; color: TScalar; 
           thickness: cint = 1; line_type: cint = 8; shift: cint = 0) {.cdecl, 
    importc: "cvLine", dynlib: coredll.}
# Draws a rectangle given two opposite corners of the rectangle (pt1 & pt2),
#   if thickness<0 (e.g. thickness == CV_FILLED), the filled box is drawn 

proc Rectangle*(img: ptr TArr; pt1: TPoint; pt2: TPoint; color: TScalar; 
                thickness: cint = 1; line_type: cint = 8; shift: cint = 0) {.
    cdecl, importc: "cvRectangle", dynlib: coredll.}
# Draws a rectangle specified by a CvRect structure 

proc RectangleR*(img: ptr TArr; r: TRect; color: TScalar; thickness: cint = 1; 
                 line_type: cint = 8; shift: cint = 0) {.cdecl, 
    importc: "cvRectangleR", dynlib: coredll.}
# Draws a circle with specified center and radius.
#   Thickness works in the same way as with cvRectangle 

proc Circle*(img: ptr TArr; center: TPoint; radius: cint; color: TScalar; 
             thickness: cint = 1; line_type: cint = 8; shift: cint = 0) {.cdecl, 
    importc: "cvCircle", dynlib: coredll.}
# Draws ellipse outline, filled ellipse, elliptic arc or filled elliptic sector,
#   depending on <thickness>, <start_angle> and <end_angle> parameters. The resultant figure
#   is rotated by <angle>. All the angles are in degrees 

proc Ellipse*(img: ptr TArr; center: TPoint; axes: TSize; angle: cdouble; 
              start_angle: cdouble; end_angle: cdouble; color: TScalar; 
              thickness: cint = 1; line_type: cint = 8; shift: cint = 0) {.
    cdecl, importc: "cvEllipse", dynlib: coredll.}
proc EllipseBox*(img: ptr TArr; box: TBox2D; color: TScalar; 
                 thickness: cint = 1; line_type: cint = 8; shift: cint = 0) {.
    cdecl.} = 
  var axes: TSize
  axes.width = math.Round(box.size.width.float * 5.0000000000000000e-01).cint
  axes.height = math.Round(box.size.height.float * 5.0000000000000000e-01).cint
  Ellipse(img, PointFrom32f(box.center), axes, box.angle, 0, 360, color, 
          thickness, line_type, shift)

# Fills convex or monotonous polygon. 

proc FillConvexPoly*(img: ptr TArr; pts: ptr TPoint; npts: cint; color: TScalar; 
                     line_type: cint = 8; shift: cint = 0) {.cdecl, 
    importc: "cvFillConvexPoly", dynlib: coredll.}
# Fills an area bounded by one or more arbitrary polygons 

proc FillPoly*(img: ptr TArr; pts: ptr ptr TPoint; npts: ptr cint; 
               contours: cint; color: TScalar; line_type: cint = 8; 
               shift: cint = 0) {.cdecl, importc: "cvFillPoly", dynlib: coredll.}
# Draws one or more polygonal curves 

proc PolyLine*(img: ptr TArr; pts: ptr ptr TPoint; npts: ptr cint; 
               contours: cint; is_closed: cint; color: TScalar; 
               thickness: cint = 1; line_type: cint = 8; shift: cint = 0) {.
    cdecl, importc: "cvPolyLine", dynlib: coredll.}
const 
  DrawRect* = Rectangle
  DrawLine* = Line
  DrawCircle* = Circle
  DrawEllipse* = Ellipse
  DrawPolyLine* = PolyLine

# Clips the line segment connecting *pt1 and *pt2
#   by the rectangular window
#   (0<=x<img_size.width, 0<=y<img_size.height). 

proc ClipLine*(img_size: TSize; pt1: ptr TPoint; pt2: ptr TPoint): cint {.cdecl, 
    importc: "cvClipLine", dynlib: coredll.}
# Initializes line iterator. Initially, line_iterator->ptr will point
#   to pt1 (or pt2, see left_to_right description) location in the image.
#   Returns the number of pixels on the line between the ending points. 

proc InitLineIterator*(image: ptr TArr; pt1: TPoint; pt2: TPoint; 
                       line_iterator: ptr TLineIterator; connectivity: cint = 8; 
                       left_to_right: cint = 0): cint {.cdecl, 
    importc: "cvInitLineIterator", dynlib: coredll.}
# Moves iterator to the next line point 

# basic font types 

const 
  FONT_HERSHEY_SIMPLEX* = 0
  FONT_HERSHEY_PLAIN* = 1
  FONT_HERSHEY_DUPLEX* = 2
  FONT_HERSHEY_COMPLEX* = 3
  FONT_HERSHEY_TRIPLEX* = 4
  FONT_HERSHEY_COMPLEX_SMALL* = 5
  FONT_HERSHEY_SCRIPT_SIMPLEX* = 6
  FONT_HERSHEY_SCRIPT_COMPLEX* = 7

# font flags 

const 
  FONT_ITALIC* = 16
  FONT_VECTOR0* = FONT_HERSHEY_SIMPLEX

# Font structure 

type 
  TFont* {.pure, final.} = object 
    nameFont*: cstring        #Qt:nameFont
    color*: TScalar           #Qt:ColorFont -> cvScalar(blue_component, green_component, red\_component[, alpha_component])
    font_face*: cint          #Qt: bool italic         /* =CV_FONT_* */
    ascii*: ptr cint          # font data and metrics 
    greek*: ptr cint
    cyrillic*: ptr cint
    hscale*: cfloat
    vscale*: cfloat
    shear*: cfloat            # slope coefficient: 0 - normal, >0 - italic 
    thickness*: cint          #Qt: weight               /* letters thickness */
    dx*: cfloat               # horizontal interval between letters 
    line_type*: cint          #Qt: PointSize
  

# Initializes font structure used further in cvPutText 

proc InitFont*(font: ptr TFont; font_face: cint; hscale: cdouble; 
               vscale: cdouble; shear: cdouble = 0; thickness: cint = 1; 
               line_type: cint = 8) {.cdecl, importc: "cvInitFont", 
                                      dynlib: coredll.}
proc Font*(scale: cdouble; thickness: cint = 1): TFont {.cdecl.} = 
  var font: TFont
  InitFont(addr(font), FONT_HERSHEY_PLAIN, scale, scale, 0, thickness, AA)
  return font

# Renders text stroke with specified font and color at specified location.
#   CvFont should be initialized with cvInitFont 

proc PutText*(img: ptr TArr; text: cstring; org: TPoint; font: ptr TFont; 
              color: TScalar) {.cdecl, importc: "cvPutText", dynlib: coredll.}
# Calculates bounding box of text stroke (useful for alignment) 

proc GetTextSize*(text_string: cstring; font: ptr TFont; text_size: ptr TSize; 
                  baseline: ptr cint) {.cdecl, importc: "cvGetTextSize", 
                                        dynlib: coredll.}
# Unpacks color value, if arrtype is CV_8UC?, <color> is treated as
#   packed color value, otherwise the first channels (depending on arrtype)
#   of destination scalar are set to the same value = <color> 

proc ColorToScalar*(packed_color: cdouble; arrtype: cint): TScalar {.cdecl, 
    importc: "cvColorToScalar", dynlib: coredll.}
# Returns the polygon points which make up the given ellipse.  The ellipse is define by
#   the box of size 'axes' rotated 'angle' around the 'center'.  A partial sweep
#   of the ellipse arc can be done by spcifying arc_start and arc_end to be something
#   other than 0 and 360, respectively.  The input array 'pts' must be large enough to
#   hold the result.  The total number of points stored into 'pts' is returned by this
#   function. 

proc Ellipse2Poly*(center: TPoint; axes: TSize; angle: cint; arc_start: cint; 
                   arc_end: cint; pts: ptr TPoint; delta: cint): cint {.cdecl, 
    importc: "cvEllipse2Poly", dynlib: coredll.}
# Draws contour outlines or filled interiors on the image 

proc DrawContours*(img: ptr TArr; contour: ptr TSeq; external_color: TScalar; 
                   hole_color: TScalar; max_level: cint; thickness: cint = 1; 
                   line_type: cint = 8; offset: TPoint = Point(0, 0)) {.cdecl, 
    importc: "cvDrawContours", dynlib: coredll.}
# Does look-up transformation. Elements of the source array
#   (that should be 8uC1 or 8sC1) are used as indexes in lutarr 256-element table 

proc LUT*(src: ptr TArr; dst: ptr TArr; lut: ptr TArr) {.cdecl, 
    importc: "cvLUT", dynlib: coredll.}
#****************** Iteration through the sequence tree ****************

type 
  TTreeNodeIterator* {.pure, final.} = object 
    node*: pointer
    level*: cint
    max_level*: cint


proc InitTreeNodeIterator*(tree_iterator: ptr TTreeNodeIterator; first: pointer; 
                           max_level: cint) {.cdecl, 
    importc: "cvInitTreeNodeIterator", dynlib: coredll.}
proc NextTreeNode*(tree_iterator: ptr TTreeNodeIterator): pointer {.cdecl, 
    importc: "cvNextTreeNode", dynlib: coredll.}
proc PrevTreeNode*(tree_iterator: ptr TTreeNodeIterator): pointer {.cdecl, 
    importc: "cvPrevTreeNode", dynlib: coredll.}
# Inserts sequence into tree with specified "parent" sequence.
#   If parent is equal to frame (e.g. the most external contour),
#   then added contour will have null pointer to parent. 

proc InsertNodeIntoTree*(node: pointer; parent: pointer; frame: pointer) {.
    cdecl, importc: "cvInsertNodeIntoTree", dynlib: coredll.}
# Removes contour from tree (together with the contour children). 

proc RemoveNodeFromTree*(node: pointer; frame: pointer) {.cdecl, 
    importc: "cvRemoveNodeFromTree", dynlib: coredll.}
# Gathers pointers to all the sequences,
#   accessible from the <first>, to the single sequence 

proc TreeToNodeSeq*(first: pointer; header_size: cint; storage: ptr TMemStorage): ptr TSeq {.
    cdecl, importc: "cvTreeToNodeSeq", dynlib: coredll.}
# The function implements the K-means algorithm for clustering an array of sample
#   vectors in a specified number of classes 

const 
  KMEANS_USE_INITIAL_LABELS* = 1

discard """ proc KMeans2*(samples: ptr TArr; cluster_count: cint; labels: ptr TArr; 
              termcrit: TTermCriteria; attempts: cint = 1; rng: ptr RNG = 0; 
              flags: cint = 0; centers: ptr TArr = 0; 
              compactness: ptr cdouble = 0): cint {.cdecl, importc: "cvKMeans2", 
    dynlib: coredll.} """
#***************************************************************************************\
#                                    System functions                                    *
#\***************************************************************************************
# Add the function pointers table with associated information to the IPP primitives list 

proc RegisterModule*(module_info: ptr TModuleInfo): cint {.cdecl, 
    importc: "cvRegisterModule", dynlib: coredll.}
# Loads optimized functions from IPP, MKL etc. or switches back to pure C code 

proc UseOptimized*(on_off: cint): cint {.cdecl, importc: "cvUseOptimized", 
    dynlib: coredll.}
# Retrieves information about the registered modules and loaded optimized plugins 

proc GetModuleInfo*(module_name: cstring; version: cstringArray; 
                    loaded_addon_plugins: cstringArray) {.cdecl, 
    importc: "cvGetModuleInfo", dynlib: coredll.}
type 
  TAllocFunc* = proc (size: csize; userdata: pointer): pointer {.cdecl.}
  TFreeFunc* = proc (pptr: pointer; userdata: pointer): cint {.cdecl.}

# Set user-defined memory managment functions (substitutors for malloc and free) that
#   will be called by cvAlloc, cvFree and higher-level functions (e.g. cvCreateImage) 

proc SetMemoryManager*(alloc_func: TAllocFunc = nil; free_func: TFreeFunc = nil; 
                       userdata: pointer = nil) {.cdecl, 
    importc: "cvSetMemoryManager", dynlib: coredll.}
type 
  TiplCreateImageHeader* = proc (a2: cint; a3: cint; a4: cint; a5: cstring; 
                                 a6: cstring; a7: cint; a8: cint; a9: cint; 
                                 a10: cint; a11: cint; a12: ptr TIplROI; 
                                 a13: ptr TIplImage; a14: pointer; 
                                 a15: ptr TIplTileInfo): ptr TIplImage {.cdecl, 
      stdcall.}
  TiplAllocateImageData* = proc (a2: ptr TIplImage; a3: cint; a4: cint) {.
      cdecl, stdcall.}
  TiplDeallocate* = proc (a2: ptr TIplImage; a3: cint) {.cdecl, stdcall.}
  TiplCreateROI* = proc (a2: cint; a3: cint; a4: cint; a5: cint; a6: cint): ptr TIplROI {.
      cdecl, stdcall.}
  TiplCloneImage* = proc (a2: ptr TIplImage): ptr TIplImage {.cdecl, stdcall.}

# Makes OpenCV use IPL functions for IplImage allocation/deallocation 

proc SetIPLAllocators*(create_header: TiplCreateImageHeader; 
                       allocate_data: TiplAllocateImageData; 
                       deallocate: TiplDeallocate; create_roi: TiplCreateROI; 
                       clone_image: TiplCloneImage) {.cdecl, 
    importc: "cvSetIPLAllocators", dynlib: coredll.}
template TURN_ON_IPL_COMPATIBILITY*(): expr = 
  SetIPLAllocators(iplCreateImageHeader, iplAllocateImage, iplDeallocate, 
                   iplCreateROI, iplCloneImage)

#***************************************************************************************\
#                                    Data Persistence                                    *
#\***************************************************************************************
#********************************* High-level functions *******************************
# opens existing or creates new file storage 

proc OpenFileStorage*(filename: cstring; memstorage: ptr TMemStorage; 
                      flags: cint; encoding: cstring = nil): ptr TFileStorage {.
    cdecl, importc: "cvOpenFileStorage", dynlib: coredll.}
# closes file storage and deallocates buffers 

proc ReleaseFileStorage*(fs: ptr ptr TFileStorage) {.cdecl, 
    importc: "cvReleaseFileStorage", dynlib: coredll.}
# returns attribute value or 0 (NULL) if there is no such attribute 

proc AttrValue*(attr: ptr TAttrList; attr_name: cstring): cstring {.cdecl, 
    importc: "cvAttrValue", dynlib: coredll.}
# starts writing compound structure (map or sequence) 

proc StartWriteStruct*(fs: ptr TFileStorage; name: cstring; struct_flags: cint; 
                       type_name: cstring = nil; 
                       attributes: TAttrList = AttrList()) {.cdecl, 
    importc: "cvStartWriteStruct", dynlib: coredll.}
# finishes writing compound structure 

proc EndWriteStruct*(fs: ptr TFileStorage) {.cdecl, importc: "cvEndWriteStruct", 
    dynlib: coredll.}
# writes an integer 

proc WriteInt*(fs: ptr TFileStorage; name: cstring; value: cint) {.cdecl, 
    importc: "cvWriteInt", dynlib: coredll.}
# writes a floating-point number 

proc WriteReal*(fs: ptr TFileStorage; name: cstring; value: cdouble) {.cdecl, 
    importc: "cvWriteReal", dynlib: coredll.}
# writes a string 

proc WriteString*(fs: ptr TFileStorage; name: cstring; str: cstring; 
                  quote: cint = 0) {.cdecl, importc: "cvWriteString", 
                                     dynlib: coredll.}
# writes a comment 

proc WriteComment*(fs: ptr TFileStorage; comment: cstring; eol_comment: cint) {.
    cdecl, importc: "cvWriteComment", dynlib: coredll.}
# writes instance of a standard type (matrix, image, sequence, graph etc.)
#   or user-defined type 

proc Write*(fs: ptr TFileStorage; name: cstring; thePtr: pointer; 
            attributes: TAttrList = AttrList()) {.cdecl, importc: "cvWrite", 
    dynlib: coredll.}
# starts the next stream 

proc StartNextStream*(fs: ptr TFileStorage) {.cdecl, 
    importc: "cvStartNextStream", dynlib: coredll.}
# helper function: writes multiple integer or floating-point numbers 

proc WriteRawData*(fs: ptr TFileStorage; src: pointer; len: cint; dt: cstring) {.
    cdecl, importc: "cvWriteRawData", dynlib: coredll.}
# returns the hash entry corresponding to the specified literal key string or 0
#   if there is no such a key in the storage 

proc GetHashedKey*(fs: ptr TFileStorage; name: cstring; len: cint = - 1; 
                   create_missing: cint = 0): ptr TStringHashNode {.cdecl, 
    importc: "cvGetHashedKey", dynlib: coredll.}
# returns file node with the specified key within the specified map
#   (collection of named nodes) 

proc GetRootFileNode*(fs: ptr TFileStorage; stream_index: cint = 0): ptr TFileNode {.
    cdecl, importc: "cvGetRootFileNode", dynlib: coredll.}
# returns file node with the specified key within the specified map
#   (collection of named nodes) 

proc GetFileNode*(fs: ptr TFileStorage; map: ptr TFileNode; 
                  key: ptr TStringHashNode; create_missing: cint = 0): ptr TFileNode {.
    cdecl, importc: "cvGetFileNode", dynlib: coredll.}
# this is a slower version of cvGetFileNode that takes the key as a literal string 

proc GetFileNodeByName*(fs: ptr TFileStorage; map: ptr TFileNode; name: cstring): ptr TFileNode {.
    cdecl, importc: "cvGetFileNodeByName", dynlib: coredll.}
proc ReadInt*(node: ptr TFileNode; default_value: cint = 0): cint {.cdecl.} = 
  return
    if not node.isNil:
      default_value
    else:
      if NODE_IS_INT(node.tag):
        node.data.i
      else:
        if NODE_IS_REAL(node.tag):
          math.Round(node.data.f).cint
        else: 0x7FFFFFFF

proc ReadIntByName*(fs: ptr TFileStorage; map: ptr TFileNode; name: cstring; 
                    default_value: cint = 0): cint {.cdecl.} = 
  return ReadInt(GetFileNodeByName(fs, map, name), default_value)

# CV_INLINE double cvReadReal( const CvFileNode* node, double default_value CV_DEFAULT(0.0) )
#{
#    return !node ? default_value :
#        CV_NODE_IS_INT(node->tag) ? (double)node->data.i :
#        CV_NODE_IS_REAL(node->tag) ? node->data.f : 1e300;
#} 

discard """ proc ReadRealByName*(fs: ptr TFileStorage; map: ptr TFileNode; name: cstring; 
                     default_value: cdouble = 0.0000000000000000e+00): cdouble {.
    cdecl.} = 
  return ReadReal(GetFileNodeByName(fs, map, name), default_value) """

discard """ proc ReadString*(node: ptr TFileNode; default_value: cstring = nil): cstring {.
    cdecl.} = 
  return if not node: default_value else: if NODE_IS_STRING(node.tag): node.data.str.thePtr else: 0 """

discard """ proc ReadStringByName*(fs: ptr TFileStorage; map: ptr TFileNode; name: cstring; 
                       default_value: cstring = nil): cstring {.cdecl.} = 
  return ReadString(GetFileNodeByName(fs, map, name), default_value) """

# decodes standard or user-defined object and returns it 

proc Read*(fs: ptr TFileStorage; node: ptr TFileNode; 
           attributes: ptr TAttrList = nil): pointer {.cdecl, importc: "cvRead", 
    dynlib: coredll.}
# decodes standard or user-defined object and returns it 

proc ReadByName*(fs: ptr TFileStorage; map: ptr TFileNode; name: cstring; 
                 attributes: ptr TAttrList = nil): pointer {.cdecl.} = 
  return Read(fs, GetFileNodeByName(fs, map, name), attributes)

# starts reading data from sequence or scalar numeric node 

proc StartReadRawData*(fs: ptr TFileStorage; src: ptr TFileNode; 
                       reader: ptr TSeqReader) {.cdecl, 
    importc: "cvStartReadRawData", dynlib: coredll.}
# reads multiple numbers and stores them to array 

proc ReadRawDataSlice*(fs: ptr TFileStorage; reader: ptr TSeqReader; 
                       count: cint; dst: pointer; dt: cstring) {.cdecl, 
    importc: "cvReadRawDataSlice", dynlib: coredll.}
# combination of two previous functions for easier reading of whole sequences 

proc ReadRawData*(fs: ptr TFileStorage; src: ptr TFileNode; dst: pointer; 
                  dt: cstring) {.cdecl, importc: "cvReadRawData", 
                                 dynlib: coredll.}
# writes a copy of file node to file storage 

proc WriteFileNode*(fs: ptr TFileStorage; new_node_name: cstring; 
                    node: ptr TFileNode; embed: cint) {.cdecl, 
    importc: "cvWriteFileNode", dynlib: coredll.}
# returns name of file node 

proc GetFileNodeName*(node: ptr TFileNode): cstring {.cdecl, 
    importc: "cvGetFileNodeName", dynlib: coredll.}
#********************************** Adding own types **********************************

proc RegisterType*(info: ptr TTypeInfo) {.cdecl, importc: "cvRegisterType", 
    dynlib: coredll.}
proc UnregisterType*(type_name: cstring) {.cdecl, importc: "cvUnregisterType", 
    dynlib: coredll.}
proc FirstType*(): ptr TTypeInfo {.cdecl, importc: "cvFirstType", 
                                   dynlib: coredll.}
proc FindType*(type_name: cstring): ptr TTypeInfo {.cdecl, 
    importc: "cvFindType", dynlib: coredll.}
proc TypeOf*(struct_ptr: pointer): ptr TTypeInfo {.cdecl, importc: "cvTypeOf", 
    dynlib: coredll.}
# universal functions 

proc Release*(struct_ptr: ptr pointer) {.cdecl, importc: "cvRelease", 
    dynlib: coredll.}
proc Clone*(struct_ptr: pointer): pointer {.cdecl, importc: "cvClone", 
    dynlib: coredll.}
# simple API for reading/writing data 

proc Save*(filename: cstring; struct_ptr: pointer; name: cstring = nil; 
           comment: cstring = nil; attributes: TAttrList = AttrList()) {.cdecl, 
    importc: "cvSave", dynlib: coredll.}
proc Load*(filename: cstring; memstorage: ptr TMemStorage = nil; 
           name: cstring = nil; real_name: cstringArray = nil): pointer {.cdecl, 
    importc: "cvLoad", dynlib: coredll.}
#********************************** Measuring Execution Time **************************
# helper functions for RNG initialization and accurate time measurement:
#   uses internal clock counter on x86 

proc GetTickCount*(): int64 {.cdecl, importc: "cvGetTickCount", dynlib: coredll.}
proc GetTickFrequency*(): cdouble {.cdecl, importc: "cvGetTickFrequency", 
                                    dynlib: coredll.}
#********************************** CPU capabilities **********************************

const 
  CPU_NONE* = 0
  CPU_MMX* = 1
  CPU_SSE* = 2
  CPU_SSE2* = 3
  CPU_SSE3* = 4
  CPU_SSSE3* = 5
  CPU_SSE4_1* = 6
  CPU_SSE4_2* = 7
  CPU_POPCNT* = 8
  CPU_AVX* = 10
  HARDWARE_MAX_FEATURE* = 255

proc CheckHardwareSupport*(feature: cint): cint {.cdecl, 
    importc: "cvCheckHardwareSupport", dynlib: coredll.}
#********************************** Multi-Threading ***********************************
# retrieve/set the number of threads used in OpenMP implementations 

proc GetNumThreads*(): cint {.cdecl, importc: "cvGetNumThreads", dynlib: coredll.}
proc SetNumThreads*(threads: cint = 0) {.cdecl, importc: "cvSetNumThreads", 
    dynlib: coredll.}
# get index of the thread being executed 

proc GetThreadNum*(): cint {.cdecl, importc: "cvGetThreadNum", dynlib: coredll.}
#********************************* Error Handling *************************************
# Get current OpenCV error status 

proc GetErrStatus*(): cint {.cdecl, importc: "cvGetErrStatus", dynlib: coredll.}
# Sets error status silently 

proc SetErrStatus*(status: cint) {.cdecl, importc: "cvSetErrStatus", 
                                   dynlib: coredll.}
const 
  ErrModeLeaf* = 0            # Print error and exit program 
  ErrModeParent* = 1          # Print error and continue 
  ErrModeSilent* = 2          # Don't print and continue 

# Retrives current error processing mode 

proc GetErrMode*(): cint {.cdecl, importc: "cvGetErrMode", dynlib: coredll.}
# Sets error processing mode, returns previously used mode 

proc SetErrMode*(mode: cint): cint {.cdecl, importc: "cvSetErrMode", 
                                     dynlib: coredll.}
# Sets error status and performs some additonal actions (displaying message box,
# writing message to stderr, terminating application etc.)
# depending on the current error mode 

proc Error*(status: cint; func_name: cstring; err_msg: cstring; 
            file_name: cstring; line: cint) {.cdecl, importc: "cvError", 
    dynlib: coredll.}
# Retrieves textual description of the error given its code 

proc ErrorStr*(status: cint): cstring {.cdecl, importc: "cvErrorStr", 
                                        dynlib: coredll.}
# Retrieves detailed information about the last error occured 

proc GetErrInfo*(errcode_desc: cstringArray; description: cstringArray; 
                 filename: cstringArray; line: ptr cint): cint {.cdecl, 
    importc: "cvGetErrInfo", dynlib: coredll.}
# Maps IPP error codes to the counterparts from OpenCV 

proc ErrorFromIppStatus*(ipp_status: cint): cint {.cdecl, 
    importc: "cvErrorFromIppStatus", dynlib: coredll.}
type 
  TErrorCallback* = proc (status: cint; func_name: cstring; err_msg: cstring; 
                          file_name: cstring; line: cint; userdata: pointer): cint {.
      cdecl.}

# Assigns a new error-handling function 

proc RedirectError*(error_handler: TErrorCallback; userdata: pointer = nil; 
                    prev_userdata: ptr pointer = nil): TErrorCallback {.cdecl, 
    importc: "cvRedirectError", dynlib: coredll.}
#
# Output to:
# cvNulDevReport - nothing
# cvStdErrReport - console(fprintf(stderr,...))
# cvGuiBoxReport - MessageBox(WIN32)
# 

proc NulDevReport*(status: cint; func_name: cstring; err_msg: cstring; 
                   file_name: cstring; line: cint; userdata: pointer): cint {.
    cdecl, importc: "cvNulDevReport", dynlib: coredll.}
proc StdErrReport*(status: cint; func_name: cstring; err_msg: cstring; 
                   file_name: cstring; line: cint; userdata: pointer): cint {.
    cdecl, importc: "cvStdErrReport", dynlib: coredll.}
proc GuiBoxReport*(status: cint; func_name: cstring; err_msg: cstring; 
                   file_name: cstring; line: cint; userdata: pointer): cint {.
    cdecl, importc: "cvGuiBoxReport", dynlib: coredll.}