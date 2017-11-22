# OCR using Kohonen Card
SIGMA205 Project

Optical Character Recognition based on Kohonen Map

SIGMA 205 Project Report







Chen Wei, Victor Clement
Instructed by Pr. Laurence Likforman





June 2017
 
 
1 Introduction
Optical character recognition (OCR) is an important research field for pattern recognition. It aims to converting images of typed, handwritten or printed text into machine-encoded text.

Self-Organizing Map (Kohonen Map) is one typical approach in the domain of machine learning. It is an artificial neural network that uses unsupervised learning to project a set of multidimensional data into restrained number of dimensions.

In order to apply the Kohonen map, the characters should be firstly summarised into characteristic data sets. In our work those data set are moments of the character images normalized by the root mean square so that the values are all in a similar range.

We are equipped with a set of training data for whose labels are known and a set of test data extracted from characters images of lower quality. Our objective is to apply the Kohonen algorithm to project the data into lower dimension, and try to classify the test data based on the training model in lower dimension.
