#pip install GPSPhoto
import os

os.chdir('C:\\Users\\my_personal_profile\\image_folder')
image_list = os.listdir()
image_list = [a for a in image_list if a.endswith('jpg')]

print(image_list)
from GPSPhoto import gpsphoto

for a in image_list: 
  data = gpsphoto.getGPSData(os.getcwd() + f'\\{a}')
  print(data)
