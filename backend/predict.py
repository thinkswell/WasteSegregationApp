import os
import cv2
import keras
import numpy as np

model = keras.models.load_model('WasteSegregation.model')
CATEGORIES = ['cardboard', 'glass', 'metal', 'paper', 'plastic', 'trash']


def result(directory):
    for filename in os.listdir(directory):
        dest = os.path.join(directory, filename)
        prediction = model.predict([image(dest)])
        print(filename, CATEGORIES[prediction.argmax()])
        return CATEGORIES[prediction.argmax()]


def image(path):
    img = cv2.imread(path)
    new_arr = cv2.resize(img, (100, 100))
    new_arr = np.array(new_arr)
    new_arr = new_arr.reshape(-1, 100, 100, 3)
    return new_arr
