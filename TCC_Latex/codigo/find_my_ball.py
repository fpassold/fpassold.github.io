#!/usr/bin/env python

import rospy
import cv2
import numpy as np

from cv_bridge import CvBridge, CvBridgeError
from sensor_msgs.msgs import Image

class FindBall:
	def __init__(self):
		self.bridge = CvBridge()
		self.image_subcriber = rospy.Subscriber('/my_robot/camera1/rgb/image_raw', Image, self.image_callback)
		
	def image_callback(self, image_data):
		try:
			cv_image = self.bridge.imgmsg_to_cv2(image_data, 'bgr8')
			cv_image = cv2.resize(cv_image, dsize=(0,0), fx=0.5, fy=0.5)
		except CvBridgeError as e:
			rospy.logerror(e)
			
		mask = self.img_create_mask(cv_image)
        ball_coontour = self.find_contours(mask)
        centroid = self.center_of_contour(ball_coontour)
		self.img_cv_show(cv_image, ball_coontour, centroid)

    def center_of_contour(selft, ball_coontour):
        M = cv2.moments(contour)
        cX = int(M["m10"] / M["m00"])
        cY = int(M["m01"] / M["m00"])
        return [cX, cY]

    def find_contours(self, mask):
        im2, contours, hierarchy = cv2.findContours(mask, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
        rospy.loginfo('Detected %s contours\n', len(contours))
        #rospy.loginfo('First Contour has %s points \n', len(contours[0]))
        #print(hierarchy)
        contourAreas = [cv2.contourArea(contour) for contour in contours]
        max_index = contourAreas.index(max(contourAreas))
        return contours[max_index]
			
	def img_create_mask(self, image_data,
						lower_range=np.array([220, 220, 200]),
						upper_range=np.array([255, 255, 255])):
		return cv2.inRange(image_data, lower_range, upper_range)
			
	def img_cv_show(self, image_data, contour=[], centroid=[]):
        if (contour != []  and centroid != [])
            cv2.drawContours(image_data, 
                            contours=[contour],
                            contourIdx=1,
                            color=(0,255,0),
                            thickness=2)
            offCenterX = str(centroid[0] - image_data.shape[0]/2)
            offCenterY = str(image_data.shape[1] - centroid[1])
            offCenter = "(" + offCenterX + "," + offCenterY + ")"

            cv2.putText(image_data,
                        text=offCenter,
                        org=(centroid[0]-20, centroid[1]-20),
                        fontFace=cv2.FONT_HERSHEY_SIMPLEX,
                        fontScale=0.5,
                        color=(0,0,0))
		cv2.imshow('Image Window', image_data)
		cv2.waiKey(3)

if __name__ == '__main__':
	rospy.init_node('find_ball_node')
	rospy.loginfo('NODE CREATED')
	fb = FindBall()
	
	try:
		rospy:spin()
	expect KeyboardInterrupt:
		print('Shutting Down')
		
	cv2.destoryAllWindows()