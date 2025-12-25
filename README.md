# MATLAB-Propeller-Generator

I made this script since I could not find a way for a quick and easy way to prototype various designs of propellers for a fixed wing UAV project I am doing, with this script, I am able to view it in SolidWorks or Ansys SpaceClaim to further refine my design. 

Automated MATLAB based propeller prototype generator using OpenProp, producing blade geometry that can be viewed in Ansys SpaceClaim or SolidWorks.  Can be used for meshing for further CFD analysis however requires repairing of the surface patches. These occur due to high curvature of triangles which surf2patch struggles to join.

This script generates a surface mesh of the propeller, it does not generate a volumetric mesh which is needed for CFD analysis. However, volumetric meshing can be done through spaceclaim once the "surface patches" are fixed through software such as Ansys Spaceclaim (warning: may be time consuming depending on the model).
It also serves as a means to make a quick and easy draft and meshing rather than a full functioning CAD based model.

## Features
1. Automatic propeller geometry generation from input
2. Blade and Hub surface generation
3. Includes nacelle generation that uses a tangent ogive curve based approximation (1.5 exponential, power law)
4. Exports to a STL file that can be imported as a graphic into SolidWorks for further CAD or CFD applications such as Ansys Spaceclaim for surface  patching and CFD analysis

## In progress
- Solid body export -> using either an export to IGES or SolidWorks api to loft the 2d curves.
- Watertight surface generation

## Limitations
- OpenProp only utilises 6-series NACA aerofoils since they favor laminar flow regions and low drag. Hence, the foils can not be changed much. However, the shape and design can be modified through the thickness distribution variable: t0oc0 and defining the blade twist distribution using VARING
- OpenProp also defines each blade's leading edge starting point at the same uniform location, this causes overlap and not very manufacture-able geometry
- Surfaces are not fully joined due to high curvature of triangles, surf2patch issue hence SolidWorks does not view this as a complete solid
- Due to the concave shape at the trailing surface of the blade has missing faces due to the curvature of triangles (surf2patch)
- The use of mathematical assembly (by joining lists of vertices and faces) causes the parts to touch but not be a complete assembly, hence these are all individual parts that remain close

## Files included
- Input example file for an EDF type propeller generation
- Main Script file that utilises the input and the OpenProp SourceCode file
- An EDF style propeller based on the inputs defined in the respective file

## Steps to Use
1. Download the .m files from this repository
2. Download the OpenProp files from https://www.epps.com/openprop and extract the files
3. Find the SourceCode folder and place it within the same folder as the .m files from this repo
4. Open MATLAB and set the source to the folder containing the .m files and OpenProp SourceCode
5. Set the input parameters in openProp_inputs.m before running STL_PropGenerator.m
6. Upon running the main script file (STL_PropGenerator), the design windows from OpenProp are displayed, these can be closed and the STL file will be present in the folder with rest of the files
7. The STL file can be loaded into SolidWorks or SpaceClaim directly.

## Example EDF prop created:
<img width="853" height="698" alt="image" src="https://github.com/user-attachments/assets/4bbe4450-9688-4afd-88a9-68a3ab37bee0" />

