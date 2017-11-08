import opencv/core, opencv/highgui, opencv/imgproc
import os, strutils

const
  fileName = "qr_nim.png"
  fileName2 = "qr_box_template.png"
  Threshold = 0.8               # change from 0.5 to 0.95 to check detection accuracy
  Red = scalar(0,0,255,0)
  LineThick = 3

proc showIt(titl: string, img: ptr TArr, delay = 1000) =
  showImage(titl, img)
  discard waitKey(delay.cint)   # wait delay millisecs if key not pressed
  destroyAllWindows()

proc where(img: ImgPtr, threshhold: float): seq[TPoint] =
  # eliminate the values below threshold,
  # and return significant points
  result = @[]
  for y in 0..<img.height:
    for x in 0..<img.width:
      if img[x, y] >= threshhold:
        result.add(point(x,y))

proc main() =
  if not fileName.fileExists(): quit("[Error] Cannot find test file: " & fileName)
  var
    img_colr = loadImage(fileName, 1)
    img_gray = loadImage(fileName, 0)
    img_box = loadImage(fileName2, 0)
    res = matchTemplate(img_gray, img_box, TM_CCOEFF_NORMED)  # values are -1.0 to 1.0

  # zero all values below the Threshold to make detection simpler
  res = threshold(res, Threshold, 1.0, THRESH_BINARY)
  #stdout.write("Matched locations: ")
  for p in res.where(Threshold):
    #stdout.write("($1,$2) " % [$p.x, $p.y])
    rectangle(img_colr, p, point(p.x + img_box.width, p.y + img_box.height), Red, LineThick)
  showIt("Box location", img_colr)

main()