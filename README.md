# MATLAB-Propeller-Generator
Automated MATLAB based propeller prototype generator using OpenProp, producing blade geometry that can be viewed in Ansys SpaceClaim or SolidWorks.  Can be used for meshing for further CFD analysis however requires repairing of the surface. These occur due to small continuity gaps caused MATLAB precision.

This script generates a surface mesh of the propeller, it does not generate a volumetric mesh which is needed for CFD analysis. However, volumetric meshing can be done through spaceclaim once the "holes" are fixed through software such as Ansys Spaceclaim.
It also serves as a means to make a quick and easy draft and meshing rather than a full functioning CAD based model.

## Features
1. Automatic propeller geometry generation from input
2. Blade and Hub surface generation
3. Includes nacelle generation that uses a tangent ogive curve based approximation (1.5 exponential)
4. Exports to a STL file that can be imported as a graphic into SolidWorks for further CAD or CFD applications such as Ansys Spaceclaim for hole patching and CFD analysis

## In progress
- IGES or STEP export for futher CAD improvements and 3D printing
- Watertight surface generation
- Solid body export

## Limitations
- OpenProp only utilises 6-series NACA aerofoils since they favor laminar flow regions and low drag. Hence, the foils can not be changed much. However, the shape and design can be modified through the thickness distribution variable: t0oc0 and defining the blade twist distribution using VARING


## Files included
- Input example file for an EDF type propeller generation
- Main Script file that utilises the input and the OpenProp SourceCode file





## Steps to Use
1. Download the .m files from this repository
2. Download the OpenProp files from https://www.epps.com/openprop and extract the files
3. Find the SourceCode folder and place it within the same folder as the .m files from this repo
4. Open MATLAB and set the source to the folder containing the .m files and OpenProp SourceCode
5. Set the input parameters in openProp_inputs.m before running STL_PropGenerator.m
6. Upon running the main script file (STL_PropGenerator), the design windows from OpenProp are displayed, these can be closed and the STL file will be present in the folder with rest of the files
7. The STL file can be loaded into SolidWorks or SpaceClaim directly.
