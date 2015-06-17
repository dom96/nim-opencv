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
    imgprocdll* = "(lib|)opencv_imgproc(249|231)d.dll"
elif defined(macosx): 
  const 
    imgprocdll* = "libopencv_imgproc.dylib"
else: 
  const 
    imgprocdll* = "libopencv_imgproc.so"
include opencv/imgproc/iptypes


#********************** Background statistics accumulation ****************************
# Adds image to accumulator 

proc acc*(image: ptr TArr; sum: ptr TArr; mask: ptr TArr = nil) {.cdecl, 
    importc: "cvAcc", dynlib: imgprocdll.}
# Adds squared image to accumulator 

proc squareAcc*(image: ptr TArr; sqsum: ptr TArr; mask: ptr TArr = nil) {.cdecl, 
    importc: "cvSquareAcc", dynlib: imgprocdll.}
# Adds a product of two images to accumulator 

proc multiplyAcc*(image1: ptr TArr; image2: ptr TArr; acc: ptr TArr; 
                  mask: ptr TArr = nil) {.cdecl, importc: "cvMultiplyAcc", 
    dynlib: imgprocdll.}
# Adds image to accumulator with weights: acc = acc*(1-alpha) + image*alpha 

proc runningAvg*(image: ptr TArr; acc: ptr TArr; alpha: cdouble; 
                 mask: ptr TArr = nil) {.cdecl, importc: "cvRunningAvg", 
    dynlib: imgprocdll.}
#***************************************************************************************\
#                                    Image Processing                                    *
#\***************************************************************************************
# Copies source 2D array inside of the larger destination array and
#   makes a border of the specified type (IPL_BORDER_*) around the copied area. 

proc copyMakeBorder*(src: ptr TArr; dst: ptr TArr; offset: TPoint; 
                     bordertype: cint; value: TScalar = scalarAll(0)) {.cdecl, 
    importc: "cvCopyMakeBorder", dynlib: imgprocdll.}
# Smoothes array (removes noise) 

proc smooth*(src: ptr TArr; dst: ptr TArr; smoothtype: cint = GAUSSIAN; 
             size1: cint = 3; size2: cint = 0; sigma1: cdouble = 0; 
             sigma2: cdouble = 0) {.cdecl, importc: "cvSmooth", 
                                    dynlib: imgprocdll.}
# Convolves the image with the kernel 

proc filter2D*(src: ptr TArr; dst: ptr TArr; kernel: ptr TMat; 
               anchor: TPoint = point(- 1, - 1)) {.cdecl, importc: "cvFilter2D", 
    dynlib: imgprocdll.}
# Finds integral image: SUM(X,Y) = sum(x<X,y<Y)I(x,y) 

proc integral*(image: ptr TArr; sum: ptr TArr; sqsum: ptr TArr = nil; 
               tiltedSum: ptr TArr = nil) {.cdecl, importc: "cvIntegral", 
    dynlib: imgprocdll.}
#
#   Smoothes the input image with gaussian kernel and then down-samples it.
#   dst_width = floor(src_width/2)[+1],
#   dst_height = floor(src_height/2)[+1]
#

proc pyrDown*(src: ptr TArr; dst: ptr TArr; filter: cint = GAUSSIAN_5x5) {.
    cdecl, importc: "cvPyrDown", dynlib: imgprocdll.}
#
#   Up-samples image and smoothes the result with gaussian kernel.
#   dst_width = src_width*2,
#   dst_height = src_height*2
#

proc pyrUp*(src: ptr TArr; dst: ptr TArr; filter: cint = GAUSSIAN_5x5) {.cdecl, 
    importc: "cvPyrUp", dynlib: imgprocdll.}
# Builds pyramid for an image 

proc createPyramid*(img: ptr TArr; extraLayers: cint; rate: cdouble; 
                    layerSizes: ptr TSize = nil; bufarr: ptr TArr = nil; 
                    calc: cint = 1; filter: cint = GAUSSIAN_5x5): ptr ptr TMat {.
    cdecl, importc: "cvCreatePyramid", dynlib: imgprocdll.}
# Releases pyramid 

proc releasePyramid*(pyramid: ptr ptr ptr TMat; extraLayers: cint) {.cdecl, 
    importc: "cvReleasePyramid", dynlib: imgprocdll.}
# Filters image using meanshift algorithm 

proc pyrMeanShiftFiltering*(src: ptr TArr; dst: ptr TArr; sp: cdouble; 
                            sr: cdouble; maxLevel: cint = 1; termcrit: TTermCriteria = termCriteria(
    TERMCRIT_ITER + TERMCRIT_EPS, 5, 1)) {.cdecl, 
    importc: "cvPyrMeanShiftFiltering", dynlib: imgprocdll.}
# Segments image using seed "markers" 

proc watershed*(image: ptr TArr; markers: ptr TArr) {.cdecl, 
    importc: "cvWatershed", dynlib: imgprocdll.}
# Calculates an image derivative using generalized Sobel
#   (aperture_size = 1,3,5,7) or Scharr (aperture_size = -1) operator.
#   Scharr can be used only for the first dx or dy derivative 

proc sobel*(src: ptr TArr; dst: ptr TArr; xorder: cint; yorder: cint; 
            apertureSize: cint = 3) {.cdecl, importc: "cvSobel", 
                                       dynlib: imgprocdll.}
# Calculates the image Laplacian: (d2/dx + d2/dy)I 

proc laplace*(src: ptr TArr; dst: ptr TArr; apertureSize: cint = 3) {.cdecl, 
    importc: "cvLaplace", dynlib: imgprocdll.}
# Converts input array pixels from one color space to another 

proc cvtColor*(src: ptr TArr; dst: ptr TArr; code: cint) {.cdecl, 
    importc: "cvCvtColor", dynlib: imgprocdll.}
# Resizes image (input array is resized to fit the destination array) 

proc resize*(src: ptr TArr; dst: ptr TArr; interpolation: cint = INTER_LINEAR) {.
    cdecl, importc: "cvResize", dynlib: imgprocdll.}
# Warps image with affine transform 

proc warpAffine*(src: ptr TArr; dst: ptr TArr; mapMatrix: ptr TMat; 
                 flags: cint = INTER_LINEAR + WARP_FILL_OUTLIERS; 
                 fillval: TScalar = scalarAll(0)) {.cdecl, 
    importc: "cvWarpAffine", dynlib: imgprocdll.}
# Computes affine transform matrix for mapping src[i] to dst[i] (i=0,1,2) 

proc getAffineTransform*(src: ptr TPoint2D32f; dst: ptr TPoint2D32f; 
                         mapMatrix: ptr TMat): ptr TMat {.cdecl, 
    importc: "cvGetAffineTransform", dynlib: imgprocdll.}
# Computes rotation_matrix matrix 

proc rotationMatrix2D*(center: TPoint2D32f; angle: cdouble; scale: cdouble; 
                       mapMatrix: ptr TMat): ptr TMat {.cdecl, 
    importc: "cv2DRotationMatrix", dynlib: imgprocdll.}
# Warps image with perspective (projective) transform 

proc warpPerspective*(src: ptr TArr; dst: ptr TArr; mapMatrix: ptr TMat; 
                      flags: cint = INTER_LINEAR + WARP_FILL_OUTLIERS; 
                      fillval: TScalar = scalarAll(0)) {.cdecl, 
    importc: "cvWarpPerspective", dynlib: imgprocdll.}
# Computes perspective transform matrix for mapping src[i] to dst[i] (i=0,1,2,3) 

proc getPerspectiveTransform*(src: ptr TPoint2D32f; dst: ptr TPoint2D32f; 
                              mapMatrix: ptr TMat): ptr TMat {.cdecl, 
    importc: "cvGetPerspectiveTransform", dynlib: imgprocdll.}
# Performs generic geometric transformation using the specified coordinate maps 

proc remap*(src: ptr TArr; dst: ptr TArr; mapx: ptr TArr; mapy: ptr TArr; 
            flags: cint = INTER_LINEAR + WARP_FILL_OUTLIERS; 
            fillval: TScalar = scalarAll(0)) {.cdecl, importc: "cvRemap", 
    dynlib: imgprocdll.}
# Converts mapx & mapy from floating-point to integer formats for cvRemap 

proc convertMaps*(mapx: ptr TArr; mapy: ptr TArr; mapxy: ptr TArr; 
                  mapalpha: ptr TArr) {.cdecl, importc: "cvConvertMaps", 
                                        dynlib: imgprocdll.}
# Performs forward or inverse log-polar image transform 

proc logPolar*(src: ptr TArr; dst: ptr TArr; center: TPoint2D32f; m: cdouble; 
               flags: cint = INTER_LINEAR + WARP_FILL_OUTLIERS) {.cdecl, 
    importc: "cvLogPolar", dynlib: imgprocdll.}
# Performs forward or inverse linear-polar image transform 

proc linearPolar*(src: ptr TArr; dst: ptr TArr; center: TPoint2D32f; 
                  maxRadius: cdouble; 
                  flags: cint = INTER_LINEAR + WARP_FILL_OUTLIERS) {.cdecl, 
    importc: "cvLinearPolar", dynlib: imgprocdll.}
# Transforms the input image to compensate lens distortion 

proc undistort2*(src: ptr TArr; dst: ptr TArr; cameraMatrix: ptr TMat; 
                 distortionCoeffs: ptr TMat; newCameraMatrix: ptr TMat = nil) {.
    cdecl, importc: "cvUndistort2", dynlib: imgprocdll.}
# Computes transformation map from intrinsic camera parameters
#   that can used by cvRemap 

proc initUndistortMap*(cameraMatrix: ptr TMat; distortionCoeffs: ptr TMat; 
                       mapx: ptr TArr; mapy: ptr TArr) {.cdecl, 
    importc: "cvInitUndistortMap", dynlib: imgprocdll.}
# Computes undistortion+rectification map for a head of stereo camera 

proc initUndistortRectifyMap*(cameraMatrix: ptr TMat; distCoeffs: ptr TMat; 
                              r: ptr TMat; newCameraMatrix: ptr TMat; 
                              mapx: ptr TArr; mapy: ptr TArr) {.cdecl, 
    importc: "cvInitUndistortRectifyMap", dynlib: imgprocdll.}
# Computes the original (undistorted) feature coordinates
#   from the observed (distorted) coordinates 

proc undistortPoints*(src: ptr TMat; dst: ptr TMat; cameraMatrix: ptr TMat; 
                      distCoeffs: ptr TMat; r: ptr TMat = nil; p: ptr TMat = nil) {.
    cdecl, importc: "cvUndistortPoints", dynlib: imgprocdll.}
# creates structuring element used for morphological operations 

proc createStructuringElementEx*(cols: cint; rows: cint; anchorX: cint; 
                                 anchorY: cint; shape: cint; 
                                 values: ptr cint = nil): ptr TIplConvKernel {.
    cdecl, importc: "cvCreateStructuringElementEx", dynlib: imgprocdll.}
# releases structuring element 

proc releaseStructuringElement*(element: ptr ptr TIplConvKernel) {.cdecl, 
    importc: "cvReleaseStructuringElement", dynlib: imgprocdll.}
# erodes input image (applies minimum filter) one or more times.
#   If element pointer is NULL, 3x3 rectangular element is used 

proc erode*(src: ptr TArr; dst: ptr TArr; element: ptr TIplConvKernel = nil; 
            iterations: cint = 1) {.cdecl, importc: "cvErode", 
                                    dynlib: imgprocdll.}
# dilates input image (applies maximum filter) one or more times.
#   If element pointer is NULL, 3x3 rectangular element is used 

proc dilate*(src: ptr TArr; dst: ptr TArr; element: ptr TIplConvKernel = nil; 
             iterations: cint = 1) {.cdecl, importc: "cvDilate", 
                                     dynlib: imgprocdll.}
# Performs complex morphological transformation 

proc morphologyEx*(src: ptr TArr; dst: ptr TArr; temp: ptr TArr; 
                   element: ptr TIplConvKernel; operation: cint; 
                   iterations: cint = 1) {.cdecl, importc: "cvMorphologyEx", 
    dynlib: imgprocdll.}
# Calculates all spatial and central moments up to the 3rd order 

proc moments*(arr: ptr TArr; moments: ptr TMoments; binary: cint = 0) {.cdecl, 
    importc: "cvMoments", dynlib: imgprocdll.}
# Retrieve particular spatial, central or normalized central moments 

proc getSpatialMoment*(moments: ptr TMoments; xOrder: cint; yOrder: cint): cdouble {.
    cdecl, importc: "cvGetSpatialMoment", dynlib: imgprocdll.}
proc getCentralMoment*(moments: ptr TMoments; xOrder: cint; yOrder: cint): cdouble {.
    cdecl, importc: "cvGetCentralMoment", dynlib: imgprocdll.}
proc getNormalizedCentralMoment*(moments: ptr TMoments; xOrder: cint; 
                                 yOrder: cint): cdouble {.cdecl, 
    importc: "cvGetNormalizedCentralMoment", dynlib: imgprocdll.}
# Calculates 7 Hu's invariants from precalculated spatial and central moments 

proc getHuMoments*(moments: ptr TMoments; huMoments: ptr THuMoments) {.cdecl, 
    importc: "cvGetHuMoments", dynlib: imgprocdll.}
#********************************** data sampling *************************************
# Fetches pixels that belong to the specified line segment and stores them to the buffer.
#   Returns the number of retrieved points. 

proc sampleLine*(image: ptr TArr; pt1: TPoint; pt2: TPoint; buffer: pointer; 
                 connectivity: cint = 8): cint {.cdecl, importc: "cvSampleLine", 
    dynlib: imgprocdll.}
# Retrieves the rectangular image region with specified center from the input array.
# dst(x,y) <- src(x + center.x - dst_width/2, y + center.y - dst_height/2).
# Values of pixels with fractional coordinates are retrieved using bilinear interpolation

proc getRectSubPix*(src: ptr TArr; dst: ptr TArr; center: TPoint2D32f) {.cdecl, 
    importc: "cvGetRectSubPix", dynlib: imgprocdll.}
# Retrieves quadrangle from the input array.
#    matrixarr = ( a11  a12 | b1 )   dst(x,y) <- src(A[x y]' + b)
#                ( a21  a22 | b2 )   (bilinear interpolation is used to retrieve pixels
#                                     with fractional coordinates)
#

proc getQuadrangleSubPix*(src: ptr TArr; dst: ptr TArr; mapMatrix: ptr TMat) {.
    cdecl, importc: "cvGetQuadrangleSubPix", dynlib: imgprocdll.}
# Measures similarity between template and overlapped windows in the source image
#   and fills the resultant image with the measurements 

proc matchTemplate*(image: ptr TArr; templ: ptr TArr; result: ptr TArr; 
                    theMethod: cint) {.cdecl, importc: "cvMatchTemplate", 
                                    dynlib: imgprocdll.}
# Computes earth mover distance between
#   two weighted point sets (called signatures) 

proc calcEMD2*(signature1: ptr TArr; signature2: ptr TArr; distanceType: cint; 
               distanceFunc: TDistanceFunction = nil; 
               costMatrix: ptr TArr = nil; flow: ptr TArr = nil; 
               lowerBound: ptr cfloat = nil; userdata: pointer = nil): cfloat {.
    cdecl, importc: "cvCalcEMD2", dynlib: imgprocdll.}
#***************************************************************************************\
#                              Contours retrieving                                       *
#\***************************************************************************************
# Retrieves outer and optionally inner boundaries of white (non-zero) connected
#   components in the black (zero) background 

proc findContours*(image: ptr TArr; storage: ptr TMemStorage; 
                   firstContour: ptr ptr TSeq; 
                   headerSize: cint = sizeof(TContour).cint; mode: cint = RETR_LIST; 
                   theMethod: cint = CHAIN_APPROX_SIMPLE; 
                   offset: TPoint = point(0, 0)): cint {.cdecl, 
    importc: "cvFindContours", dynlib: imgprocdll.}
# Initalizes contour retrieving process.
#   Calls cvStartFindContours.
#   Calls cvFindNextContour until null pointer is returned
#   or some other condition becomes true.
#   Calls cvEndFindContours at the end. 

proc startFindContours*(image: ptr TArr; storage: ptr TMemStorage; 
                        headerSize: cint = sizeof(TContour).cint; 
                        mode: cint = RETR_LIST; 
                        theMethod: cint = CHAIN_APPROX_SIMPLE; 
                        offset: TPoint = point(0, 0)): TContourScanner {.cdecl, 
    importc: "cvStartFindContours", dynlib: imgprocdll.}
# Retrieves next contour 

proc findNextContour*(scanner: TContourScanner): ptr TSeq {.cdecl, 
    importc: "cvFindNextContour", dynlib: imgprocdll.}
# Substitutes the last retrieved contour with the new one
#   (if the substitutor is null, the last retrieved contour is removed from the tree) 

proc substituteContour*(scanner: TContourScanner; newContour: ptr TSeq) {.
    cdecl, importc: "cvSubstituteContour", dynlib: imgprocdll.}
# Releases contour scanner and returns pointer to the first outer contour 

proc endFindContours*(scanner: ptr TContourScanner): ptr TSeq {.cdecl, 
    importc: "cvEndFindContours", dynlib: imgprocdll.}
# Approximates a single Freeman chain or a tree of chains to polygonal curves 

proc approxChains*(srcSeq: ptr TSeq; storage: ptr TMemStorage; 
                   theMethod: cint = CHAIN_APPROX_SIMPLE; parameter: cdouble = 0; 
                   minimalPerimeter: cint = 0; recursive: cint = 0): ptr TSeq {.
    cdecl, importc: "cvApproxChains", dynlib: imgprocdll.}
# Initalizes Freeman chain reader.
#   The reader is used to iteratively get coordinates of all the chain points.
#   If the Freeman codes should be read as is, a simple sequence reader should be used 

proc startReadChainPoints*(chain: ptr TChain; reader: ptr TChainPtReader) {.
    cdecl, importc: "cvStartReadChainPoints", dynlib: imgprocdll.}
# Retrieves the next chain point 

proc readChainPoint*(reader: ptr TChainPtReader): TPoint {.cdecl, 
    importc: "cvReadChainPoint", dynlib: imgprocdll.}
#***************************************************************************************\
#                            Contour Processing and Shape Analysis                       *
#\***************************************************************************************
# Approximates a single polygonal curve (contour) or
#   a tree of polygonal curves (contours) 

proc approxPoly*(srcSeq: pointer; headerSize: cint; storage: ptr TMemStorage; 
                 theMethod: cint; eps: cdouble; recursive: cint = 0): ptr TSeq {.
    cdecl, importc: "cvApproxPoly", dynlib: imgprocdll.}
# Calculates perimeter of a contour or length of a part of contour 

proc arcLength*(curve: pointer; slice: core.TSlice = Whole_Seq; isClosed: cint = - 1): cdouble {.
    cdecl, importc: "cvArcLength", dynlib: imgprocdll.}
proc contourPerimeter*(contour: pointer): cdouble {.inline, cdecl.} = 
  return arcLength(contour, Whole_Seq, 1)

# Calculates contour boundning rectangle (update=1) or
#   just retrieves pre-calculated rectangle (update=0) 

proc boundingRect*(points: ptr TArr; update: cint = 0): TRect {.cdecl, 
    importc: "cvBoundingRect", dynlib: imgprocdll.}
# Calculates area of a contour or contour segment 

proc contourArea*(contour: ptr TArr; slice: core.TSlice = Whole_Seq; 
                  oriented: cint = 0): cdouble {.cdecl, 
    importc: "cvContourArea", dynlib: imgprocdll.}
# Finds minimum area rotated rectangle bounding a set of points 

proc minAreaRect2*(points: ptr TArr; storage: ptr TMemStorage = nil): TBox2D {.
    cdecl, importc: "cvMinAreaRect2", dynlib: imgprocdll.}
# Finds minimum enclosing circle for a set of points 

proc minEnclosingCircle*(points: ptr TArr; center: ptr TPoint2D32f; 
                         radius: ptr cfloat): cint {.cdecl, 
    importc: "cvMinEnclosingCircle", dynlib: imgprocdll.}
# Compares two contours by matching their moments 

proc matchShapes*(object1: pointer; object2: pointer; theMethod: cint; 
                  parameter: cdouble = 0): cdouble {.cdecl, 
    importc: "cvMatchShapes", dynlib: imgprocdll.}
# Calculates exact convex hull of 2d point set 

proc convexHull2*(input: ptr TArr; hullStorage: pointer = nil; 
                  orientation: cint = CLOCKWISE; returnPoints: cint = 0): ptr TSeq {.
    cdecl, importc: "cvConvexHull2", dynlib: imgprocdll.}
# Checks whether the contour is convex or not (returns 1 if convex, 0 if not) 

proc checkContourConvexity*(contour: ptr TArr): cint {.cdecl, 
    importc: "cvCheckContourConvexity", dynlib: imgprocdll.}
# Finds convexity defects for the contour 

proc convexityDefects*(contour: ptr TArr; convexhull: ptr TArr; 
                       storage: ptr TMemStorage = nil): ptr TSeq {.cdecl, 
    importc: "cvConvexityDefects", dynlib: imgprocdll.}
# Fits ellipse into a set of 2d points 

proc fitEllipse2*(points: ptr TArr): TBox2D {.cdecl, importc: "cvFitEllipse2", 
    dynlib: imgprocdll.}
# Finds minimum rectangle containing two given rectangles 

proc maxRect*(rect1: ptr TRect; rect2: ptr TRect): TRect {.cdecl, 
    importc: "cvMaxRect", dynlib: imgprocdll.}
# Finds coordinates of the box vertices 

proc boxPoints*(box: TBox2D; pt: array[0..4 - 1, TPoint2D32f]) {.cdecl, 
    importc: "cvBoxPoints", dynlib: imgprocdll.}
# Initializes sequence header for a matrix (column or row vector) of points -
#   a wrapper for cvMakeSeqHeaderForArray (it does not initialize bounding rectangle!!!) 

proc pointSeqFromMat*(seqKind: cint; mat: ptr TArr; 
                      contourHeader: ptr TContour; theBlock: ptr TSeqBlock): ptr TSeq {.
    cdecl, importc: "cvPointSeqFromMat", dynlib: imgprocdll.}
# Checks whether the point is inside polygon, outside, on an edge (at a vertex).
#   Returns positive, negative or zero value, correspondingly.
#   Optionally, measures a signed distance between
#   the point and the nearest polygon edge (measure_dist=1) 

proc pointPolygonTest*(contour: ptr TArr; pt: TPoint2D32f; measureDist: cint): cdouble {.
    cdecl, importc: "cvPointPolygonTest", dynlib: imgprocdll.}
#***************************************************************************************\
#                                  Histogram functions                                   *
#\***************************************************************************************
# Creates new histogram 

proc createHist*(dims: cint; sizes: ptr cint; theType: cint; 
                 ranges: ptr ptr cfloat = nil; uniform: cint = 1): ptr THistogram {.
    cdecl, importc: "cvCreateHist", dynlib: imgprocdll.}
# Assignes histogram bin ranges 

proc setHistBinRanges*(hist: ptr THistogram; ranges: ptr ptr cfloat; 
                       uniform: cint = 1) {.cdecl, 
    importc: "cvSetHistBinRanges", dynlib: imgprocdll.}
# Creates histogram header for array 

proc makeHistHeaderForArray*(dims: cint; sizes: ptr cint; hist: ptr THistogram; 
                             data: ptr cfloat; ranges: ptr ptr cfloat = nil; 
                             uniform: cint = 1): ptr THistogram {.cdecl, 
    importc: "cvMakeHistHeaderForArray", dynlib: imgprocdll.}
# Releases histogram 

proc releaseHist*(hist: ptr ptr THistogram) {.cdecl, importc: "cvReleaseHist", 
    dynlib: imgprocdll.}
# Clears all the histogram bins 

proc clearHist*(hist: ptr THistogram) {.cdecl, importc: "cvClearHist", 
                                        dynlib: imgprocdll.}
# Finds indices and values of minimum and maximum histogram bins 

proc getMinMaxHistValue*(hist: ptr THistogram; minValue: ptr cfloat; 
                         maxValue: ptr cfloat; minIdx: ptr cint = nil; 
                         maxIdx: ptr cint = nil) {.cdecl, 
    importc: "cvGetMinMaxHistValue", dynlib: imgprocdll.}
# Normalizes histogram by dividing all bins by sum of the bins, multiplied by <factor>.
#   After that sum of histogram bins is equal to <factor> 

proc normalizeHist*(hist: ptr THistogram; factor: cdouble) {.cdecl, 
    importc: "cvNormalizeHist", dynlib: imgprocdll.}
# Clear all histogram bins that are below the threshold 

proc threshHist*(hist: ptr THistogram; threshold: cdouble) {.cdecl, 
    importc: "cvThreshHist", dynlib: imgprocdll.}
# Compares two histogram 

proc compareHist*(hist1: ptr THistogram; hist2: ptr THistogram; theMethod: cint): cdouble {.
    cdecl, importc: "cvCompareHist", dynlib: imgprocdll.}
# Copies one histogram to another. Destination histogram is created if
#   the destination pointer is NULL 

proc copyHist*(src: ptr THistogram; dst: ptr ptr THistogram) {.cdecl, 
    importc: "cvCopyHist", dynlib: imgprocdll.}
# Calculates bayesian probabilistic histograms
#   (each or src and dst is an array of <number> histograms 

proc calcBayesianProb*(src: ptr ptr THistogram; number: cint; 
                       dst: ptr ptr THistogram) {.cdecl, 
    importc: "cvCalcBayesianProb", dynlib: imgprocdll.}
# Calculates array histogram 

proc calcArrHist*(arr: ptr ptr TArr; hist: ptr THistogram; accumulate: cint = 0; 
                  mask: ptr TArr = nil) {.cdecl, importc: "cvCalcArrHist", 
    dynlib: imgprocdll.}
proc calcHist*(image: ptr ptr TIplImage; hist: ptr THistogram; 
               accumulate: cint = 0; mask: ptr TArr = nil) {.inline, cdecl.} = 
  calcArrHist(cast[ptr ptr TArr](image), hist, accumulate, mask)

# Calculates back project 

proc calcArrBackProject*(image: ptr ptr TArr; dst: ptr TArr; 
                         hist: ptr THistogram) {.cdecl, 
    importc: "cvCalcArrBackProject", dynlib: imgprocdll.}
template calcBackProject*(image, dst, hist: expr): expr = 
  CalcArrBackProject(cast[ptr ptr TArr](image), dst, hist)

# Does some sort of template matching but compares histograms of
#   template and each window location 

proc calcArrBackProjectPatch*(image: ptr ptr TArr; dst: ptr TArr; range: TSize; 
                              hist: ptr THistogram; theMethod: cint; 
                              factor: cdouble) {.cdecl, 
    importc: "cvCalcArrBackProjectPatch", dynlib: imgprocdll.}
template calcBackProjectPatch*(image, dst, range, hist, theMethod, factor: expr): expr = 
  CalcArrBackProjectPatch(cast[ptr ptr TArr](image), dst, range, hist, theMethod, 
                          factor)

# calculates probabilistic density (divides one histogram by another) 

proc calcProbDensity*(hist1: ptr THistogram; hist2: ptr THistogram; 
                      dstHist: ptr THistogram; scale: cdouble = 255) {.cdecl, 
    importc: "cvCalcProbDensity", dynlib: imgprocdll.}
# equalizes histogram of 8-bit single-channel image 

proc equalizeHist*(src: ptr TArr; dst: ptr TArr) {.cdecl, 
    importc: "cvEqualizeHist", dynlib: imgprocdll.}
# Applies distance transform to binary image 

proc distTransform*(src: ptr TArr; dst: ptr TArr; distanceType: cint = DIST_L2; 
                    maskSize: cint = 3; mask: ptr cfloat = nil; 
                    labels: ptr TArr = nil; labelType: cint = DIST_LABEL_CCOMP) {.
    cdecl, importc: "cvDistTransform", dynlib: imgprocdll.}
# Applies fixed-level threshold to grayscale image.
#   This is a basic operation applied before retrieving contours 

proc threshold*(src: ptr TArr; dst: ptr TArr; threshold: cdouble; 
                maxValue: cdouble; thresholdType: cint): cdouble {.cdecl, 
    importc: "cvThreshold", dynlib: imgprocdll.}
# Applies adaptive threshold to grayscale image.
#   The two parameters for methods CV_ADAPTIVE_THRESH_MEAN_C and
#   CV_ADAPTIVE_THRESH_GAUSSIAN_C are:
#   neighborhood size (3, 5, 7 etc.),
#   and a constant subtracted from mean (...,-3,-2,-1,0,1,2,3,...) 

proc adaptiveThreshold*(src: ptr TArr; dst: ptr TArr; maxValue: cdouble; 
                        adaptiveMethod: cint = ADAPTIVE_THRESH_MEAN_C; 
                        thresholdType: cint = THRESH_BINARY; 
                        blockSize: cint = 3; param1: cdouble = 5) {.cdecl, 
    importc: "cvAdaptiveThreshold", dynlib: imgprocdll.}
# Fills the connected component until the color difference gets large enough 

proc floodFill*(image: ptr TArr; seedPoint: TPoint; newVal: TScalar; 
                loDiff: TScalar = scalarAll(0); 
                upDiff: TScalar = scalarAll(0); comp: ptr TConnectedComp = nil; 
                flags: cint = 4; mask: ptr TArr = nil) {.cdecl, 
    importc: "cvFloodFill", dynlib: imgprocdll.}
#***************************************************************************************\
#                                  Feature detection                                     *
#\***************************************************************************************
# Runs canny edge detector 

proc canny*(image: ptr TArr; edges: ptr TArr; threshold1: cdouble; 
            threshold2: cdouble; apertureSize: cint = 3) {.cdecl, 
    importc: "cvCanny", dynlib: imgprocdll.}
# Calculates constraint image for corner detection
#   Dx^2 * Dyy + Dxx * Dy^2 - 2 * Dx * Dy * Dxy.
#   Applying threshold to the result gives coordinates of corners 

proc preCornerDetect*(image: ptr TArr; corners: ptr TArr; 
                      apertureSize: cint = 3) {.cdecl, 
    importc: "cvPreCornerDetect", dynlib: imgprocdll.}
# Calculates eigen values and vectors of 2x2
#   gradient covariation matrix at every image pixel 

proc cornerEigenValsAndVecs*(image: ptr TArr; eigenvv: ptr TArr; 
                             blockSize: cint; apertureSize: cint = 3) {.cdecl, 
    importc: "cvCornerEigenValsAndVecs", dynlib: imgprocdll.}
# Calculates minimal eigenvalue for 2x2 gradient covariation matrix at
#   every image pixel 

proc cornerMinEigenVal*(image: ptr TArr; eigenval: ptr TArr; blockSize: cint; 
                        apertureSize: cint = 3) {.cdecl, 
    importc: "cvCornerMinEigenVal", dynlib: imgprocdll.}
# Harris corner detector:
#   Calculates det(M) - k*(trace(M)^2), where M is 2x2 gradient covariation matrix for each pixel 

proc cornerHarris*(image: ptr TArr; harrisResponce: ptr TArr; blockSize: cint; 
                   apertureSize: cint = 3; k: cdouble = 4.0000000000000001e-02) {.
    cdecl, importc: "cvCornerHarris", dynlib: imgprocdll.}
# Adjust corner position using some sort of gradient search 

proc findCornerSubPix*(image: ptr TArr; corners: ptr TPoint2D32f; count: cint; 
                       win: TSize; zeroZone: TSize; criteria: TTermCriteria) {.
    cdecl, importc: "cvFindCornerSubPix", dynlib: imgprocdll.}
# Finds a sparse set of points within the selected region
#   that seem to be easy to track 

proc goodFeaturesToTrack*(image: ptr TArr; eigImage: ptr TArr; 
                          tempImage: ptr TArr; corners: ptr TPoint2D32f; 
                          cornerCount: ptr cint; qualityLevel: cdouble; 
                          minDistance: cdouble; mask: ptr TArr = nil; 
                          blockSize: cint = 3; useHarris: cint = 0; 
                          k: cdouble = 4.0000000000000001e-02) {.cdecl, 
    importc: "cvGoodFeaturesToTrack", dynlib: imgprocdll.}
# Finds lines on binary image using one of several methods.
#   line_storage is either memory storage or 1 x <max number of lines> CvMat, its
#   number of columns is changed by the function.
#   method is one of CV_HOUGH_*;
#   rho, theta and threshold are used for each of those methods;
#   param1 ~ line length, param2 ~ line gap - for probabilistic,
#   param1 ~ srn, param2 ~ stn - for multi-scale 

proc houghLines2*(image: ptr TArr; lineStorage: pointer; theMethod: cint; 
                  rho: cdouble; theta: cdouble; threshold: cint; 
                  param1: cdouble = 0; param2: cdouble = 0): ptr TSeq {.cdecl, 
    importc: "cvHoughLines2", dynlib: imgprocdll.}
# Finds circles in the image 

proc houghCircles*(image: ptr TArr; circleStorage: pointer; theMethod: cint; 
                   dp: cdouble; minDist: cdouble; param1: cdouble = 100; 
                   param2: cdouble = 100; minRadius: cint = 0; 
                   maxRadius: cint = 0): ptr TSeq {.cdecl, 
    importc: "cvHoughCircles", dynlib: imgprocdll.}
# Fits a line into set of 2d or 3d points in a robust way (M-estimator technique) 

proc fitLine*(points: ptr TArr; distType: cint; param: cdouble; reps: cdouble; 
              aeps: cdouble; line: ptr cfloat) {.cdecl, importc: "cvFitLine", 
    dynlib: imgprocdll.}
