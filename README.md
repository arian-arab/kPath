# kPath (Software to Simulate Angle-Resolved Photoelectron Spectroscopy Experiments-ARPES)

This package includes Python code and a MATLAB GUI that independently simulate ARPES measurements using Density Functional Theory (DFT) calculations.

As an example, DFT calculations for the material TaAs are provided. The reciprocal lattice units are defined, and the DFT results are stored in a NumPy array of size (51×51×51×22). Here, the three 51-dimensional components represent the x, y, and z components in the reciprocal space while the 22 corresponds to the number of bands, meaning that at each point in reciprocal space, the energies of 22 bands are computed.

In an ARPES experiment, using experimental parameters and geometry (such as photon energy, incidence angle, and sample orientation), a one-dimensional path in reciprocal space (k-path) can be defined. The corresponding energies for each of the 22 bands along this k-path can then be extracted. For instance, at a photon energy of 500 eV and an incidence angle of 90 degrees (assuming no contribution to the x component of electron energies from photon momentum), with an experimental setup of 0° tilt, 0° phi, and 0° theta, 22 line plots along the k-path can be obtained and are shown here:

<div align="center">
<img src=https://github.com/user-attachments/assets/15d23aa1-8d72-4f73-a392-270e3da334d0>
</div>

The geometry and equations used to determine the k-path in reciprocal space are illustrated in the figure below:

<div align="center">
<img src=https://github.com/user-attachments/assets/b392dca6-3898-4847-a2c5-dfe43290922f>
</div>

In the next step, by rotating the sample along the x-axis (i.e., tilting the sample during measurements), we can capture these bands along different k-paths corresponding to various tilt angles. As an example, we introduce tilt angles ranging from -10 to 10 degrees in increments of 0.1 degrees.

<div align="center">
<img src=https://github.com/user-attachments/assets/d6c9cd29-b6e3-41f3-9ab1-581d974c0756>
</div>

All 22 bands for each tilt angle can be visualized in a 3D plot, providing a clearer representation of how the bands evolve along different k-paths.

<div align="center">
<img src=https://github.com/user-attachments/assets/c1514d49-d6a3-4ea1-9bfd-6f837bf7a057>
</div>

The tilt mentioned above corresponds to the y component (by rotating the k-path along the x-axis). As a result, by slicing planes along the x-y direction, we can obtain isoenergetic surfaces, allowing us to resolve the ARPES image along the x and y components of reciprocal space:

<div align="center">
<img src=https://github.com/user-attachments/assets/c479c9f5-6ae7-4177-8a90-6196c0bfdde9>
</div>

<div align="center">
<img src=https://github.com/user-attachments/assets/c5dc02df-f15f-46e1-88b3-6613a44f95a5>
</div>

