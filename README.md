# MATLAB-Propeller-Generator
Automated MATLAB based propeller generator using OpenProp, producing watertight hub and blade geometry that is ready for CFD meshing and analysis. Tested in Ansys. 


This script generates a surface mesh of the propeller, it does not generate a volumetric mesh which is needed for CFD analysis. However, volumetric meshing can be easily done through software such as Ansys Spaceclaim.



## Features
1. Automatic propeller geometry generation from input
2. Watertight hub and blade surfaces
3. Includes nacelle generation that uses a tangent ogive curve based approximation (1.5 exponential)
4. Auto exports to a STL file that can be imported into SolidWorks for further CAD or CFD applications such as Ansys Spaceclaim for volumetric

## Files included
- Input example file for an EDF type propeller generation
- Main Script file that utilises the input and the OpenProp SourceCode file
