import times, strutils, os

import opencv/imgproc, opencv/highgui, opencv/core

# http://opencv.willowgarage.com/wiki/CameraCapture

when isMainModule:
  var capture = captureFromCam(CAP_ANY)
  if capture == nil:
    quit("Capture is null")
  echo setCaptureProperty(capture, CAP_PROP_FRAME_WIDTH, 640)
  echo setCaptureProperty(capture, CAP_PROP_FRAME_HEIGHT, 480)
  echo setCaptureProperty(capture, CAP_PROP_FPS, 10)
  # Create window
  echo namedWindow("testwindow", WINDOW_AUTOSIZE)
  # Show the image captured from the camera
  while true:
    # Get one frame
    var frame = queryFrame(capture)
    if frame == nil:
      quit("Frame is null.")
    showImage("testwindow", frame)

    # Do NOT release the frame!
    # If ESC key pressed, Key=0x10001B under OpenCV 0.9.7(linux version),
    # remove higher bits using AND operator.
    if (waitKey(1) and 255) == 27: break
  releaseCapture(addr(capture))
  destroyWindow("testwindow")