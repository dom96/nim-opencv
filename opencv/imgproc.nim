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
    imgprocdll* = "opencv_imgproc(249|).dll"
elif defined(macosx): 
  const 
    imgprocdll* = "libopencv_imgproc.dylib"
else: 
  const 
    imgprocdll* = "libopencv_imgproc.so"
include opencv/imgproc/iptypes


#********************** Background statistics accumulation ****************************
# Adds image to accumulator 

proc Acc*(image: ptr TArr; sum: ptr TArr; mask: ptr TArr = nil) {.cdecl, 
    importc: "cvAcc", dynlib: imgprocdll.}
# Adds squared image to accumulator 

proc SquareAcc*(image: ptr TArr; sqsum: ptr TArr; mask: ptr TArr = nil) {.cdecl, 
    importc: "cvSquareAcc", dynlib: imgprocdll.}
# Adds a product of two images to accumulator 

proc MultiplyAcc*(image1: ptr TArr; image2: ptr TArr; acc: ptr TArr; 
                  mask: ptr TArr = nil) {.cdecl, importc: "cvMultiplyAcc", 
    dynlib: imgprocdll.}
# Adds image to accumulator with weights: acc = acc*(1-alpha) + image*alpha 

proc RunningAvg*(image: ptr TArr; acc: ptr TArr; alpha: cdouble; 
                 mask: ptr TArr = nil) {.cdecl, importc: "cvRunningAvg", 
    dynlib: imgprocdll.}
#***************************************************************************************\
#                                    Image Processing                                    *
#\***************************************************************************************
# Copies source 2D array inside of the larger destination array and
#   makes a border of the specified type (IPL_BORDER_*) around the copied area. 

proc CopyMakeBorder*(src: ptr TArr; dst: ptr TArr; offset: TPoint; 
                     bordertype: cint; value: TScalar = ScalarAll(0)) {.cdecl, 
    importc: "cvCopyMakeBorder", dynlib: imgprocdll.}
# Smoothes array (removes noise) 

proc Smooth*(src: ptr TArr; dst: ptr TArr; smoothtype: cint = GAUSSIAN; 
             size1: cint = 3; size2: cint = 0; sigma1: cdouble = 0; 
             sigma2: cdouble = 0) {.cdecl, importc: "cvSmooth", 
                                    dynlib: imgprocdll.}
# Convolves the image with the kernel 

proc Filter2D*(src: ptr TArr; dst: ptr TArr; kernel: ptr TMat; 
               anchor: TPoint = Point(- 1, - 1)) {.cdecl, importc: "cvFilter2D", 
    dynlib: imgprocdll.}
# Finds integral image: SUM(X,Y) = sum(x<X,y<Y)I(x,y) 

proc Integral*(image: ptr TArr; sum: ptr TArr; sqsum: ptr TArr = nil; 
               tilted_sum: ptr TArr = nil) {.cdecl, importc: "cvIntegral", 
    dynlib: imgprocdll.}
#
#   Smoothes the input image with gaussian kernel and then down-samples it.
#   dst_width = floor(src_width/2)[+1],
#   dst_height = floor(src_height/2)[+1]
#

proc PyrDown*(src: ptr TArr; dst: ptr TArr; filter: cint = GAUSSIAN_5x5) {.
    cdecl, importc: "cvPyrDown", dynlib: imgprocdll.}
#
#   Up-samples image and smoothes the result with gaussian kernel.
#   dst_width = src_width*2,
#   dst_height = src_height*2
#

proc PyrUp*(src: ptr TArr; dst: ptr TArr; filter: cint = GAUSSIAN_5x5) {.cdecl, 
    importc: "cvPyrUp", dynlib: imgprocdll.}
# Builds pyramid for an image 

proc CreatePyramid*(img: ptr TArr; extra_layers: cint; rate: cdouble; 
                    layer_sizes: ptr TSize = nil; bufarr: ptr TArr = nil; 
                    calc: cint = 1; filter: cint = GAUSSIAN_5x5): ptr ptr TMat {.
    cdecl, importc: "cvCreatePyramid", dynlib: imgprocdll.}
# Releases pyramid 

proc ReleasePyramid*(pyramid: ptr ptr ptr TMat; extra_layers: cint) {.cdecl, 
    importc: "cvReleasePyramid", dynlib: imgprocdll.}
# Filters image using meanshift algorithm 

proc PyrMeanShiftFiltering*(src: ptr TArr; dst: ptr TArr; sp: cdouble; 
                            sr: cdouble; max_level: cint = 1; termcrit: TTermCriteria = TermCriteria(
    TERMCRIT_ITER + TERMCRIT_EPS, 5, 1)) {.cdecl, 
    importc: "cvPyrMeanShiftFiltering", dynlib: imgprocdll.}
# Segments image using seed "markers" 

proc Watershed*(image: ptr TArr; markers: ptr TArr) {.cdecl, 
    importc: "cvWatershed", dynlib: imgprocdll.}
# Calculates an image derivative using generalized Sobel
#   (aperture_size = 1,3,5,7) or Scharr (aperture_size = -1) operator.
#   Scharr can be used only for the first dx or dy derivative 

proc Sobel*(src: ptr TArr; dst: ptr TArr; xorder: cint; yorder: cint; 
            aperture_size: cint = 3) {.cdecl, importc: "cvSobel", 
                                       dynlib: imgprocdll.}
# Calculates the image Laplacian: (d2/dx + d2/dy)I 

proc Laplace*(src: ptr TArr; dst: ptr TArr; aperture_size: cint = 3) {.cdecl, 
    importc: "cvLaplace", dynlib: imgprocdll.}
# Converts input array pixels from one color space to another 

proc CvtColor*(src: ptr TArr; dst: ptr TArr; code: cint) {.cdecl, 
    importc: "cvCvtColor", dynlib: imgprocdll.}
# Resizes image (input array is resized to fit the destination array) 

proc Resize*(src: ptr TArr; dst: ptr TArr; interpolation: cint = INTER_LINEAR) {.
    cdecl, importc: "cvResize", dynlib: imgprocdll.}
# Warps image with affine transform 

proc WarpAffine*(src: ptr TArr; dst: ptr TArr; map_matrix: ptr TMat; 
                 flags: cint = INTER_LINEAR + WARP_FILL_OUTLIERS; 
                 fillval: TScalar = ScalarAll(0)) {.cdecl, 
    importc: "cvWarpAffine", dynlib: imgprocdll.}
# Computes affine transform matrix for mapping src[i] to dst[i] (i=0,1,2) 

proc GetAffineTransform*(src: ptr TPoint2D32f; dst: ptr TPoint2D32f; 
                         map_matrix: ptr TMat): ptr TMat {.cdecl, 
    importc: "cvGetAffineTransform", dynlib: imgprocdll.}
# Computes rotation_matrix matrix 

proc RotationMatrix2D*(center: TPoint2D32f; angle: cdouble; scale: cdouble; 
                       map_matrix: ptr TMat): ptr TMat {.cdecl, 
    importc: "cv2DRotationMatrix", dynlib: imgprocdll.}
# Warps image with perspective (projective) transform 

proc WarpPerspective*(src: ptr TArr; dst: ptr TArr; map_matrix: ptr TMat; 
                      flags: cint = INTER_LINEAR + WARP_FILL_OUTLIERS; 
                      fillval: TScalar = ScalarAll(0)) {.cdecl, 
    importc: "cvWarpPerspective", dynlib: imgprocdll.}
# Computes perspective transform matrix for mapping src[i] to dst[i] (i=0,1,2,3) 

proc GetPerspectiveTransform*(src: ptr TPoint2D32f; dst: ptr TPoint2D32f; 
                              map_matrix: ptr TMat): ptr TMat {.cdecl, 
    importc: "cvGetPerspectiveTransform", dynlib: imgprocdll.}
# Performs generic geometric transformation using the specified coordinate maps 

proc Remap*(src: ptr TArr; dst: ptr TArr; mapx: ptr TArr; mapy: ptr TArr; 
            flags: cint = INTER_LINEAR + WARP_FILL_OUTLIERS; 
            fillval: TScalar = ScalarAll(0)) {.cdecl, importc: "cvRemap", 
    dynlib: imgprocdll.}
# Converts mapx & mapy from floating-point to integer formats for cvRemap 

proc ConvertMaps*(mapx: ptr TArr; mapy: ptr TArr; mapxy: ptr TArr; 
                  mapalpha: ptr TArr) {.cdecl, importc: "cvConvertMaps", 
                                        dynlib: imgprocdll.}
# Performs forward or inverse log-polar image transform 

proc LogPolar*(src: ptr TArr; dst: ptr TArr; center: TPoint2D32f; M: cdouble; 
               flags: cint = INTER_LINEAR + WARP_FILL_OUTLIERS) {.cdecl, 
    importc: "cvLogPolar", dynlib: imgprocdll.}
# Performs forward or inverse linear-polar image transform 

proc LinearPolar*(src: ptr TArr; dst: ptr TArr; center: TPoint2D32f; 
                  maxRadius: cdouble; 
                  flags: cint = INTER_LINEAR + WARP_FILL_OUTLIERS) {.cdecl, 
    importc: "cvLinearPolar", dynlib: imgprocdll.}
# Transforms the input image to compensate lens distortion 

proc Undistort2*(src: ptr TArr; dst: ptr TArr; camera_matrix: ptr TMat; 
                 distortion_coeffs: ptr TMat; new_camera_matrix: ptr TMat = nil) {.
    cdecl, importc: "cvUndistort2", dynlib: imgprocdll.}
# Computes transformation map from intrinsic camera parameters
#   that can used by cvRemap 

proc InitUndistortMap*(camera_matrix: ptr TMat; distortion_coeffs: ptr TMat; 
                       mapx: ptr TArr; mapy: ptr TArr) {.cdecl, 
    importc: "cvInitUndistortMap", dynlib: imgprocdll.}
# Computes undistortion+rectification map for a head of stereo camera 

proc InitUndistortRectifyMap*(camera_matrix: ptr TMat; dist_coeffs: ptr TMat; 
                              R: ptr TMat; new_camera_matrix: ptr TMat; 
                              mapx: ptr TArr; mapy: ptr TArr) {.cdecl, 
    importc: "cvInitUndistortRectifyMap", dynlib: imgprocdll.}
# Computes the original (undistorted) feature coordinates
#   from the observed (distorted) coordinates 

proc UndistortPoints*(src: ptr TMat; dst: ptr TMat; camera_matrix: ptr TMat; 
                      dist_coeffs: ptr TMat; R: ptr TMat = nil; P: ptr TMat = nil) {.
    cdecl, importc: "cvUndistortPoints", dynlib: imgprocdll.}
# creates structuring element used for morphological operations 

proc CreateStructuringElementEx*(cols: cint; rows: cint; anchor_x: cint; 
                                 anchor_y: cint; shape: cint; 
                                 values: ptr cint = nil): ptr TIplConvKernel {.
    cdecl, importc: "cvCreateStructuringElementEx", dynlib: imgprocdll.}
# releases structuring element 

proc ReleaseStructuringElement*(element: ptr ptr TIplConvKernel) {.cdecl, 
    importc: "cvReleaseStructuringElement", dynlib: imgprocdll.}
# erodes input image (applies minimum filter) one or more times.
#   If element pointer is NULL, 3x3 rectangular element is used 

proc Erode*(src: ptr TArr; dst: ptr TArr; element: ptr TIplConvKernel = nil; 
            iterations: cint = 1) {.cdecl, importc: "cvErode", 
                                    dynlib: imgprocdll.}
# dilates input image (applies maximum filter) one or more times.
#   If element pointer is NULL, 3x3 rectangular element is used 

proc Dilate*(src: ptr TArr; dst: ptr TArr; element: ptr TIplConvKernel = nil; 
             iterations: cint = 1) {.cdecl, importc: "cvDilate", 
                                     dynlib: imgprocdll.}
# Performs complex morphological transformation 

proc MorphologyEx*(src: ptr TArr; dst: ptr TArr; temp: ptr TArr; 
                   element: ptr TIplConvKernel; operation: cint; 
                   iterations: cint = 1) {.cdecl, importc: "cvMorphologyEx", 
    dynlib: imgprocdll.}
# Calculates all spatial and central moments up to the 3rd order 

proc Moments*(arr: ptr TArr; moments: ptr TMoments; binary: cint = 0) {.cdecl, 
    importc: "cvMoments", dynlib: imgprocdll.}
# Retrieve particular spatial, central or normalized central moments 

proc GetSpatialMoment*(moments: ptr TMoments; x_order: cint; y_order: cint): cdouble {.
    cdecl, importc: "cvGetSpatialMoment", dynlib: imgprocdll.}
proc GetCentralMoment*(moments: ptr TMoments; x_order: cint; y_order: cint): cdouble {.
    cdecl, importc: "cvGetCentralMoment", dynlib: imgprocdll.}
proc GetNormalizedCentralMoment*(moments: ptr TMoments; x_order: cint; 
                                 y_order: cint): cdouble {.cdecl, 
    importc: "cvGetNormalizedCentralMoment", dynlib: imgprocdll.}
# Calculates 7 Hu's invariants from precalculated spatial and central moments 

proc GetHuMoments*(moments: ptr TMoments; hu_moments: ptr THuMoments) {.cdecl, 
    importc: "cvGetHuMoments", dynlib: imgprocdll.}
#********************************** data sampling *************************************
# Fetches pixels that belong to the specified line segment and stores them to the buffer.
#   Returns the number of retrieved points. 

proc SampleLine*(image: ptr TArr; pt1: TPoint; pt2: TPoint; buffer: pointer; 
                 connectivity: cint = 8): cint {.cdecl, importc: "cvSampleLine", 
    dynlib: imgprocdll.}
# Retrieves the rectangular image region with specified center from the input array.
# dst(x,y) <- src(x + center.x - dst_width/2, y + center.y - dst_height/2).
# Values of pixels with fractional coordinates are retrieved using bilinear interpolation

proc GetRectSubPix*(src: ptr TArr; dst: ptr TArr; center: TPoint2D32f) {.cdecl, 
    importc: "cvGetRectSubPix", dynlib: imgprocdll.}
# Retrieves quadrangle from the input array.
#    matrixarr = ( a11  a12 | b1 )   dst(x,y) <- src(A[x y]' + b)
#                ( a21  a22 | b2 )   (bilinear interpolation is used to retrieve pixels
#                                     with fractional coordinates)
#

proc GetQuadrangleSubPix*(src: ptr TArr; dst: ptr TArr; map_matrix: ptr TMat) {.
    cdecl, importc: "cvGetQuadrangleSubPix", dynlib: imgprocdll.}
# Measures similarity between template and overlapped windows in the source image
#   and fills the resultant image with the measurements 

proc MatchTemplate*(image: ptr TArr; templ: ptr TArr; result: ptr TArr; 
                    theMethod: cint) {.cdecl, importc: "cvMatchTemplate", 
                                    dynlib: imgprocdll.}
# Computes earth mover distance between
#   two weighted point sets (called signatures) 

proc CalcEMD2*(signature1: ptr TArr; signature2: ptr TArr; distance_type: cint; 
               distance_func: TDistanceFunction = nil; 
               cost_matrix: ptr TArr = nil; flow: ptr TArr = nil; 
               lower_bound: ptr cfloat = nil; userdata: pointer = nil): cfloat {.
    cdecl, importc: "cvCalcEMD2", dynlib: imgprocdll.}
#***************************************************************************************\
#                              Contours retrieving                                       *
#\***************************************************************************************
# Retrieves outer and optionally inner boundaries of white (non-zero) connected
#   components in the black (zero) background 

proc FindContours*(image: ptr TArr; storage: ptr TMemStorage; 
                   first_contour: ptr ptr TSeq; 
                   header_size: cint = sizeof(TContour).cint; mode: cint = RETR_LIST; 
                   theMethod: cint = CHAIN_APPROX_SIMPLE; 
                   offset: TPoint = Point(0, 0)): cint {.cdecl, 
    importc: "cvFindContours", dynlib: imgprocdll.}
# Initalizes contour retrieving process.
#   Calls cvStartFindContours.
#   Calls cvFindNextContour until null pointer is returned
#   or some other condition becomes true.
#   Calls cvEndFindContours at the end. 

proc StartFindContours*(image: ptr TArr; storage: ptr TMemStorage; 
                        header_size: cint = sizeof(TContour).cint; 
                        mode: cint = RETR_LIST; 
                        theMethod: cint = CHAIN_APPROX_SIMPLE; 
                        offset: TPoint = Point(0, 0)): TContourScanner {.cdecl, 
    importc: "cvStartFindContours", dynlib: imgprocdll.}
# Retrieves next contour 

proc FindNextContour*(scanner: TContourScanner): ptr TSeq {.cdecl, 
    importc: "cvFindNextContour", dynlib: imgprocdll.}
# Substitutes the last retrieved contour with the new one
#   (if the substitutor is null, the last retrieved contour is removed from the tree) 

proc SubstituteContour*(scanner: TContourScanner; new_contour: ptr TSeq) {.
    cdecl, importc: "cvSubstituteContour", dynlib: imgprocdll.}
# Releases contour scanner and returns pointer to the first outer contour 

proc EndFindContours*(scanner: ptr TContourScanner): ptr TSeq {.cdecl, 
    importc: "cvEndFindContours", dynlib: imgprocdll.}
# Approximates a single Freeman chain or a tree of chains to polygonal curves 

proc ApproxChains*(src_seq: ptr TSeq; storage: ptr TMemStorage; 
                   theMethod: cint = CHAIN_APPROX_SIMPLE; parameter: cdouble = 0; 
                   minimal_perimeter: cint = 0; recursive: cint = 0): ptr TSeq {.
    cdecl, importc: "cvApproxChains", dynlib: imgprocdll.}
# Initalizes Freeman chain reader.
#   The reader is used to iteratively get coordinates of all the chain points.
#   If the Freeman codes should be read as is, a simple sequence reader should be used 

proc StartReadChainPoints*(chain: ptr TChain; reader: ptr TChainPtReader) {.
    cdecl, importc: "cvStartReadChainPoints", dynlib: imgprocdll.}
# Retrieves the next chain point 

proc ReadChainPoint*(reader: ptr TChainPtReader): TPoint {.cdecl, 
    importc: "cvReadChainPoint", dynlib: imgprocdll.}
#***************************************************************************************\
#                            Contour Processing and Shape Analysis                       *
#\***************************************************************************************
# Approximates a single polygonal curve (contour) or
#   a tree of polygonal curves (contours) 

proc ApproxPoly*(src_seq: pointer; header_size: cint; storage: ptr TMemStorage; 
                 theMethod: cint; eps: cdouble; recursive: cint = 0): ptr TSeq {.
    cdecl, importc: "cvApproxPoly", dynlib: imgprocdll.}
# Calculates perimeter of a contour or length of a part of contour 

proc ArcLength*(curve: pointer; slice: core.TSlice = WHOLE_SEQ; is_closed: cint = - 1): cdouble {.
    cdecl, importc: "cvArcLength", dynlib: imgprocdll.}
proc ContourPerimeter*(contour: pointer): cdouble {.inline, cdecl.} = 
  return ArcLength(contour, WHOLE_SEQ, 1)

# Calculates contour boundning rectangle (update=1) or
#   just retrieves pre-calculated rectangle (update=0) 

proc BoundingRect*(points: ptr TArr; update: cint = 0): TRect {.cdecl, 
    importc: "cvBoundingRect", dynlib: imgprocdll.}
# Calculates area of a contour or contour segment 

proc ContourArea*(contour: ptr TArr; slice: core.TSlice = WHOLE_SEQ; 
                  oriented: cint = 0): cdouble {.cdecl, 
    importc: "cvContourArea", dynlib: imgprocdll.}
# Finds minimum area rotated rectangle bounding a set of points 

proc MinAreaRect2*(points: ptr TArr; storage: ptr TMemStorage = nil): TBox2D {.
    cdecl, importc: "cvMinAreaRect2", dynlib: imgprocdll.}
# Finds minimum enclosing circle for a set of points 

proc MinEnclosingCircle*(points: ptr TArr; center: ptr TPoint2D32f; 
                         radius: ptr cfloat): cint {.cdecl, 
    importc: "cvMinEnclosingCircle", dynlib: imgprocdll.}
# Compares two contours by matching their moments 

proc MatchShapes*(object1: pointer; object2: pointer; theMethod: cint; 
                  parameter: cdouble = 0): cdouble {.cdecl, 
    importc: "cvMatchShapes", dynlib: imgprocdll.}
# Calculates exact convex hull of 2d point set 

proc ConvexHull2*(input: ptr TArr; hull_storage: pointer = nil; 
                  orientation: cint = CLOCKWISE; return_points: cint = 0): ptr TSeq {.
    cdecl, importc: "cvConvexHull2", dynlib: imgprocdll.}
# Checks whether the contour is convex or not (returns 1 if convex, 0 if not) 

proc CheckContourConvexity*(contour: ptr TArr): cint {.cdecl, 
    importc: "cvCheckContourConvexity", dynlib: imgprocdll.}
# Finds convexity defects for the contour 

proc ConvexityDefects*(contour: ptr TArr; convexhull: ptr TArr; 
                       storage: ptr TMemStorage = nil): ptr TSeq {.cdecl, 
    importc: "cvConvexityDefects", dynlib: imgprocdll.}
# Fits ellipse into a set of 2d points 

proc FitEllipse2*(points: ptr TArr): TBox2D {.cdecl, importc: "cvFitEllipse2", 
    dynlib: imgprocdll.}
# Finds minimum rectangle containing two given rectangles 

proc MaxRect*(rect1: ptr TRect; rect2: ptr TRect): TRect {.cdecl, 
    importc: "cvMaxRect", dynlib: imgprocdll.}
# Finds coordinates of the box vertices 

proc BoxPoints*(box: TBox2D; pt: array[0..4 - 1, TPoint2D32f]) {.cdecl, 
    importc: "cvBoxPoints", dynlib: imgprocdll.}
# Initializes sequence header for a matrix (column or row vector) of points -
#   a wrapper for cvMakeSeqHeaderForArray (it does not initialize bounding rectangle!!!) 

proc PointSeqFromMat*(seq_kind: cint; mat: ptr TArr; 
                      contour_header: ptr TContour; theBlock: ptr TSeqBlock): ptr TSeq {.
    cdecl, importc: "cvPointSeqFromMat", dynlib: imgprocdll.}
# Checks whether the point is inside polygon, outside, on an edge (at a vertex).
#   Returns positive, negative or zero value, correspondingly.
#   Optionally, measures a signed distance between
#   the point and the nearest polygon edge (measure_dist=1) 

proc PointPolygonTest*(contour: ptr TArr; pt: TPoint2D32f; measure_dist: cint): cdouble {.
    cdecl, importc: "cvPointPolygonTest", dynlib: imgprocdll.}
#***************************************************************************************\
#                                  Histogram functions                                   *
#\***************************************************************************************
# Creates new histogram 

proc CreateHist*(dims: cint; sizes: ptr cint; theType: cint; 
                 ranges: ptr ptr cfloat = nil; uniform: cint = 1): ptr THistogram {.
    cdecl, importc: "cvCreateHist", dynlib: imgprocdll.}
# Assignes histogram bin ranges 

proc SetHistBinRanges*(hist: ptr THistogram; ranges: ptr ptr cfloat; 
                       uniform: cint = 1) {.cdecl, 
    importc: "cvSetHistBinRanges", dynlib: imgprocdll.}
# Creates histogram header for array 

proc MakeHistHeaderForArray*(dims: cint; sizes: ptr cint; hist: ptr THistogram; 
                             data: ptr cfloat; ranges: ptr ptr cfloat = nil; 
                             uniform: cint = 1): ptr THistogram {.cdecl, 
    importc: "cvMakeHistHeaderForArray", dynlib: imgprocdll.}
# Releases histogram 

proc ReleaseHist*(hist: ptr ptr THistogram) {.cdecl, importc: "cvReleaseHist", 
    dynlib: imgprocdll.}
# Clears all the histogram bins 

proc ClearHist*(hist: ptr THistogram) {.cdecl, importc: "cvClearHist", 
                                        dynlib: imgprocdll.}
# Finds indices and values of minimum and maximum histogram bins 

proc GetMinMaxHistValue*(hist: ptr THistogram; min_value: ptr cfloat; 
                         max_value: ptr cfloat; min_idx: ptr cint = nil; 
                         max_idx: ptr cint = nil) {.cdecl, 
    importc: "cvGetMinMaxHistValue", dynlib: imgprocdll.}
# Normalizes histogram by dividing all bins by sum of the bins, multiplied by <factor>.
#   After that sum of histogram bins is equal to <factor> 

proc NormalizeHist*(hist: ptr THistogram; factor: cdouble) {.cdecl, 
    importc: "cvNormalizeHist", dynlib: imgprocdll.}
# Clear all histogram bins that are below the threshold 

proc ThreshHist*(hist: ptr THistogram; threshold: cdouble) {.cdecl, 
    importc: "cvThreshHist", dynlib: imgprocdll.}
# Compares two histogram 

proc CompareHist*(hist1: ptr THistogram; hist2: ptr THistogram; theMethod: cint): cdouble {.
    cdecl, importc: "cvCompareHist", dynlib: imgprocdll.}
# Copies one histogram to another. Destination histogram is created if
#   the destination pointer is NULL 

proc CopyHist*(src: ptr THistogram; dst: ptr ptr THistogram) {.cdecl, 
    importc: "cvCopyHist", dynlib: imgprocdll.}
# Calculates bayesian probabilistic histograms
#   (each or src and dst is an array of <number> histograms 

proc CalcBayesianProb*(src: ptr ptr THistogram; number: cint; 
                       dst: ptr ptr THistogram) {.cdecl, 
    importc: "cvCalcBayesianProb", dynlib: imgprocdll.}
# Calculates array histogram 

proc CalcArrHist*(arr: ptr ptr TArr; hist: ptr THistogram; accumulate: cint = 0; 
                  mask: ptr TArr = nil) {.cdecl, importc: "cvCalcArrHist", 
    dynlib: imgprocdll.}
proc CalcHist*(image: ptr ptr TIplImage; hist: ptr THistogram; 
               accumulate: cint = 0; mask: ptr TArr = nil) {.inline, cdecl.} = 
  CalcArrHist(cast[ptr ptr TArr](image), hist, accumulate, mask)

# Calculates back project 

proc CalcArrBackProject*(image: ptr ptr TArr; dst: ptr TArr; 
                         hist: ptr THistogram) {.cdecl, 
    importc: "cvCalcArrBackProject", dynlib: imgprocdll.}
template CalcBackProject*(image, dst, hist: expr): expr = 
  CalcArrBackProject(cast[ptr ptr TArr](image), dst, hist)

# Does some sort of template matching but compares histograms of
#   template and each window location 

proc CalcArrBackProjectPatch*(image: ptr ptr TArr; dst: ptr TArr; range: TSize; 
                              hist: ptr THistogram; theMethod: cint; 
                              factor: cdouble) {.cdecl, 
    importc: "cvCalcArrBackProjectPatch", dynlib: imgprocdll.}
template CalcBackProjectPatch*(image, dst, range, hist, theMethod, factor: expr): expr = 
  CalcArrBackProjectPatch(cast[ptr ptr TArr](image), dst, range, hist, theMethod, 
                          factor)

# calculates probabilistic density (divides one histogram by another) 

proc CalcProbDensity*(hist1: ptr THistogram; hist2: ptr THistogram; 
                      dst_hist: ptr THistogram; scale: cdouble = 255) {.cdecl, 
    importc: "cvCalcProbDensity", dynlib: imgprocdll.}
# equalizes histogram of 8-bit single-channel image 

proc EqualizeHist*(src: ptr TArr; dst: ptr TArr) {.cdecl, 
    importc: "cvEqualizeHist", dynlib: imgprocdll.}
# Applies distance transform to binary image 

proc DistTransform*(src: ptr TArr; dst: ptr TArr; distance_type: cint = DIST_L2; 
                    mask_size: cint = 3; mask: ptr cfloat = nil; 
                    labels: ptr TArr = nil; labelType: cint = DIST_LABEL_CCOMP) {.
    cdecl, importc: "cvDistTransform", dynlib: imgprocdll.}
# Applies fixed-level threshold to grayscale image.
#   This is a basic operation applied before retrieving contours 

proc Threshold*(src: ptr TArr; dst: ptr TArr; threshold: cdouble; 
                max_value: cdouble; threshold_type: cint): cdouble {.cdecl, 
    importc: "cvThreshold", dynlib: imgprocdll.}
# Applies adaptive threshold to grayscale image.
#   The two parameters for methods CV_ADAPTIVE_THRESH_MEAN_C and
#   CV_ADAPTIVE_THRESH_GAUSSIAN_C are:
#   neighborhood size (3, 5, 7 etc.),
#   and a constant subtracted from mean (...,-3,-2,-1,0,1,2,3,...) 

proc AdaptiveThreshold*(src: ptr TArr; dst: ptr TArr; max_value: cdouble; 
                        adaptive_method: cint = ADAPTIVE_THRESH_MEAN_C; 
                        threshold_type: cint = THRESH_BINARY; 
                        block_size: cint = 3; param1: cdouble = 5) {.cdecl, 
    importc: "cvAdaptiveThreshold", dynlib: imgprocdll.}
# Fills the connected component until the color difference gets large enough 

proc FloodFill*(image: ptr TArr; seed_point: TPoint; new_val: TScalar; 
                lo_diff: TScalar = ScalarAll(0); 
                up_diff: TScalar = ScalarAll(0); comp: ptr TConnectedComp = nil; 
                flags: cint = 4; mask: ptr TArr = nil) {.cdecl, 
    importc: "cvFloodFill", dynlib: imgprocdll.}
#***************************************************************************************\
#                                  Feature detection                                     *
#\***************************************************************************************
# Runs canny edge detector 

proc Canny*(image: ptr TArr; edges: ptr TArr; threshold1: cdouble; 
            threshold2: cdouble; aperture_size: cint = 3) {.cdecl, 
    importc: "cvCanny", dynlib: imgprocdll.}
# Calculates constraint image for corner detection
#   Dx^2 * Dyy + Dxx * Dy^2 - 2 * Dx * Dy * Dxy.
#   Applying threshold to the result gives coordinates of corners 

proc PreCornerDetect*(image: ptr TArr; corners: ptr TArr; 
                      aperture_size: cint = 3) {.cdecl, 
    importc: "cvPreCornerDetect", dynlib: imgprocdll.}
# Calculates eigen values and vectors of 2x2
#   gradient covariation matrix at every image pixel 

proc CornerEigenValsAndVecs*(image: ptr TArr; eigenvv: ptr TArr; 
                             block_size: cint; aperture_size: cint = 3) {.cdecl, 
    importc: "cvCornerEigenValsAndVecs", dynlib: imgprocdll.}
# Calculates minimal eigenvalue for 2x2 gradient covariation matrix at
#   every image pixel 

proc CornerMinEigenVal*(image: ptr TArr; eigenval: ptr TArr; block_size: cint; 
                        aperture_size: cint = 3) {.cdecl, 
    importc: "cvCornerMinEigenVal", dynlib: imgprocdll.}
# Harris corner detector:
#   Calculates det(M) - k*(trace(M)^2), where M is 2x2 gradient covariation matrix for each pixel 

proc CornerHarris*(image: ptr TArr; harris_responce: ptr TArr; block_size: cint; 
                   aperture_size: cint = 3; k: cdouble = 4.0000000000000001e-02) {.
    cdecl, importc: "cvCornerHarris", dynlib: imgprocdll.}
# Adjust corner position using some sort of gradient search 

proc FindCornerSubPix*(image: ptr TArr; corners: ptr TPoint2D32f; count: cint; 
                       win: TSize; zero_zone: TSize; criteria: TTermCriteria) {.
    cdecl, importc: "cvFindCornerSubPix", dynlib: imgprocdll.}
# Finds a sparse set of points within the selected region
#   that seem to be easy to track 

proc GoodFeaturesToTrack*(image: ptr TArr; eig_image: ptr TArr; 
                          temp_image: ptr TArr; corners: ptr TPoint2D32f; 
                          corner_count: ptr cint; quality_level: cdouble; 
                          min_distance: cdouble; mask: ptr TArr = nil; 
                          block_size: cint = 3; use_harris: cint = 0; 
                          k: cdouble = 4.0000000000000001e-02) {.cdecl, 
    importc: "cvGoodFeaturesToTrack", dynlib: imgprocdll.}
# Finds lines on binary image using one of several methods.
#   line_storage is either memory storage or 1 x <max number of lines> CvMat, its
#   number of columns is changed by the function.
#   method is one of CV_HOUGH_*;
#   rho, theta and threshold are used for each of those methods;
#   param1 ~ line length, param2 ~ line gap - for probabilistic,
#   param1 ~ srn, param2 ~ stn - for multi-scale 

proc HoughLines2*(image: ptr TArr; line_storage: pointer; theMethod: cint; 
                  rho: cdouble; theta: cdouble; threshold: cint; 
                  param1: cdouble = 0; param2: cdouble = 0): ptr TSeq {.cdecl, 
    importc: "cvHoughLines2", dynlib: imgprocdll.}
# Finds circles in the image 

proc HoughCircles*(image: ptr TArr; circle_storage: pointer; theMethod: cint; 
                   dp: cdouble; min_dist: cdouble; param1: cdouble = 100; 
                   param2: cdouble = 100; min_radius: cint = 0; 
                   max_radius: cint = 0): ptr TSeq {.cdecl, 
    importc: "cvHoughCircles", dynlib: imgprocdll.}
# Fits a line into set of 2d or 3d points in a robust way (M-estimator technique) 

proc FitLine*(points: ptr TArr; dist_type: cint; param: cdouble; reps: cdouble; 
              aeps: cdouble; line: ptr cfloat) {.cdecl, importc: "cvFitLine", 
    dynlib: imgprocdll.}
