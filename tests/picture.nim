import opencv/core, opencv/highgui, opencv/imgproc
import os

const
  fileName = "qr_nim.png"
  fileName2 = "qr_box_template.png"

proc showIt(titl: string, img: ptr TArr, delay = 1000) =
  showImage(titl, img)
  discard waitKey(delay.cint)   # wait delay millisecs if key not pressed
  destroyAllWindows()

proc main() =
  if not fileName.fileExists(): quit("[Error] Cannot find test file: " & fileName)
  var
    img_colr = loadImage(fileName, 1)
    img_gray = loadImage(fileName, 0)
    img_box = loadImage(fileName2, 0)

  showIt("Color Image", img_colr)
  showIt("Gray Image", img_gray)

  # red, thickness=5 (dimensions set by img_box)
  let red = scalar(0,0,255,0)
  rectangle(img_colr, point(0,0), point(img_box.width, img_box.height), red, 5)
  showIt("Color Image Rectangle", img_colr)

  var img_laplace = cloneImage(img_gray)
  laplace(img_gray, img_laplace)
  showIt("Laplace transformed image", img_laplace)

  canny(img_gray, img_laplace, 0.8, 1.0, 3)
  showIt("Canny transformed image", img_laplace)
main()