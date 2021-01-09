import numpy as np
import cv2
import os
import random
import pickle


DIRECTORY = r'D:\DataSet\Garbage classification\Garbage classification'
CATEGORIES = ['cardboard','glass','metal','paper','plastic','trash']

data = []

for category in CATEGORIES:
    path = os.path.join(DIRECTORY, category)
    for img in os.listdir(path):
        img_path = os.path.join(path, img)
        label = CATEGORIES.index(category)
        arr = cv2.imread(img_path,cv2.IMREAD_UNCHANGED)
        new_arr = cv2.resize(arr, (100,100))
        data.append([new_arr, label])
random.shuffle(data)

train_images=[]
train_labels=[]

for features,labels in data:
    train_images.append(features)
    train_labels.append(labels)

train_images=np.array(train_images)
train_labels=np.array(train_labels)

pickle.dump(train_images, open('train_images.pkl', 'wb'))
pickle.dump(train_labels, open('train_labels.pkl', 'wb'))

