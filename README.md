train-detector
==============

This repository contains scripts that will help train a license plate detector for a particular region.  Your trained region detector can then be used in OpenALPR.

The license plate region detector uses the Local Binary Pattern (LBP) algorithm.  In order to train the detector, you will need many positive and negative images.  This repository already contains a collection of negative images.  You will need to add your own positive images.

To get started, you will first need many cropped plate images containing positive license plate matches.  Please see the "eu" positive image folder in this repository to understand the types of plate images required.

The [Plate Tagger Utility](https://github.com/openalpr/plate_tagger)  is helpful to tag the plate locations.  After tagging the plates you can run the "crop_plates.py" function to extract the crops from the input images at your target aspect ratio.

After you've collected many (hundreds to thousands) of positive plate images, the next step is to train the detector.  First you must configure the training script to use the correct dimensions.

Edit the prep.py script and change the WIDTH, HEIGHT, and COUNTRY variables to match the country that you are training.  The width and height should be proportional to the plate size (slightly larger is OK).  A total pixel area of around 650 seems to work best.  Also, adjust the path to your OpenCV libraries, if that needs to be changed.

Once you are ready to start training, enter the following commands:

  - rm ./out/*    (clear the out folder in case it has data from previous runs)
  - ./prep.py neg
  - ./prep.py pos
  - ./prep.py train
  - Copy the output from the above command onto the command line.  You should adjust the numStages to a smaller value (usually 12 stages works well, but it will depend on your input images).  You may also need to adjust the numPos value to a smaller number in order to complete the training.


Copy the out/cascade.xml file to your OpenALPR runtime directory (runtime_data/region/[countrycode].xml).  You should now be able to use the region for plate detection.


Droste notes
===============
We've created a Dockerfile that allows building a container for training and makes the process much easier. You can build the container by running:
`docker build -t 2park-train-detector .`

After that you can run the container:
`docker run --rm -ti -v $(pwd):/train-detector 2park-train-detector`

This will put you inside of the container and then in order to perform the training you will need to:
```
cd train-detector
python prep.py neg
python prep.py pos
python prep.py train
```

By default this is configured to train 2-line HK plates. If you want to train something else you will need to modify the prep.py file according to the instructions above.

For Mac users, if you want to be able to see the results of the python prep.py showpos command, you can do the following instead of running the `docker run` command above:
```
brew cask install xquartz
open -a XQuartz
```

Open the XQuartz Preferences and check both security settings

```
ip=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
xhost + $ip
docker run --privileged --rm -ti -e DISPLAY=$ip:0 -v /tmp/.X11-unix:/tmp/.X11-unix -v $(pwd):/train-detector 2park-train-detector
```
