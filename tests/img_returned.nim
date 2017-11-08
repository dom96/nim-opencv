import opencv/core, opencv/highgui, opencv/imgproc
import os

const
  fileName = "qr_nim.png"

proc showIt(titl: string, img: ptr TArr, delay = 1000) =
  showImage(titl, img)
  discard waitKey(delay.cint)   # wait delay millisecs if key not pressed
  destroyAllWindows()

proc main() =
  if not fileName.fileExists(): quit("[Error] Cannot find test file: " & fileName)
  var
    img_colr = loadImage(fileName, 1)
    img_gray = loadImage(fileName, 0)
    img_tst = repeat(img_gray)
  assert addr(img_tst) != addr(img_gray)
  var img_merge = merge(img_gray, img_gray, img_gray, img_gray)
  assert img_merge.nChannels == 4
  var img_merge2 = merge(img_gray, img_gray, img_gray)
  assert img_merge2.nChannels == 3
  var img_scale = bitwiseNot(convertScaleAbs(img_gray, 0.5, 0))
  showImage("Gray Image", img_gray)
  showIt("Scaled Image", img_scale)

  var img_cmb = cloneImage(img_gray)
  copyMakeBorder(img_gray, img_cmb, point(0,0), 0, scalar(0,0,255,0))
  showImage("Gray CopyMakeBorder Image", img_cmb)
  showIt("Gray Image", img_gray)    # img_gray unchanged?

  var img_smooth = smooth(img_gray)
  showIt("Smooth Gray Image", img_smooth)

  discard integral32S(img_gray)
  discard integral32F(img_gray)

  var img_pyrDn = pyrDown(img_gray)
  showImage("Gray Image", img_gray)
  showIt("PyrDown Gray Image", img_pyrDn)

  var img_pyrUp = pyrUp(img_gray)
  showImage("Gray Image", img_gray)
  showIt("PyrUp Gray Image", img_pyrUp)

  var img_pyrMSF = pyrMeanShiftFiltering(img_colr, 10, 5)
  showImage("Color Image", img_colr)
  showIt("PyrMeanShiftFiltr Color Image", img_pyrMSF)

  var img_sobel = sobel(img_colr)
  showImage("Color Image", img_colr)
  showIt("Sobel Color Image", img_sobel)

  var img_laplace = laplace(img_colr)
  showImage("Color Image", img_colr)
  showIt("Laplace Color Image", img_laplace)

  var img_resize = resize(img_colr, 1.5, 2.0)
  showImage("Color Image", img_colr)
  showIt("Resize Color Image (1.5 x 2.0)", img_resize)

  var img_flip = convertImage(img_colr, CVTIMG_FLIP)
  img_flip = convertImage(img_flip, CVTIMG_SWAP_RB)
  showImage("Color Image", img_colr)
  showIt("Flip Color Image (swapped RB)", img_flip)

main()
