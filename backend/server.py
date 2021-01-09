import os
import shutil
import uuid
import uvicorn
import config
import json
import predict
from typing import List
from pathlib import Path
from fastapi.responses import HTMLResponse
from fastapi import FastAPI, File, UploadFile

with open('plastic.json', 'r') as f:
    plasticJson = json.load(f)
with open('papercard.json', 'r') as f:
    papercardJson = json.load(f)
with open('glass.json', 'r') as f:
    glassJson = json.load(f)

app = FastAPI()


@app.get('/api/')
def main():
    return {'message': 'Welcome to our server!'}


@app.post("/api/image/")
async def uploadImage(file: UploadFile = File(...)):
    location = f"image/{file.filename}"
    with open(location, "wb+") as fobj:
        fobj.write(file.file.read())
    fileN = predict.result(r'./image/image.jpg')
    if fileN == "paper" or fileN == "cardboard":
        rJson = papercardJson
    if fileN == "glass":
        rJson = glassJson
    if fileN == "plastic":
        rJson = plasticJson

        # return {"msg": f"file {file.filename} saved at location {location}"}
    return {"length": len(papercardJson), "type": fileN, "data": rJson}
