import cv2


def cv_show(name,img):
  cv2.imshow(name,img)
  key = cv2.waitKey(0)
  if key & 0xFF == ord('q'):
    cv2.destroyAllWindows()