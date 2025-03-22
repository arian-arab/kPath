# kPath (Software to Simulate Angle-Resolved Photoelectron Spectroscopy Experiments-ARPES)

The Python code and the MATLAB GUI in this package seperately simulates ARPES measurements using Density Functional Theory (DFT) calculations.

As an example, DFT calculations for the material TaAs is provided. The reciprocal lattice units are given and the DFT calculations are provided in a NumPy array of size (51*51*51*22) wherein the 51 dimensions are the k_x, k_y, and k_z in the reciprocal space and 22 are the number of bands, i.e., at each point in the reciprocal space; energies from 22 bands are calculated. As a result in an ARPES experiment, using the experimaental parameters and geometry (photon energy, incidence angle, and the orientations of the sample), a one-dimensional path in the reciprocal space (k-path) can be constructed and the energies for each of the 22 bands along the k-path can be obtained.

For example, at the photon energy of 500 eV and incidence angle of 90 degress (assuming no contribution to the k_x component of the electron energies due to photon momemntum) with an experimental geometry of 0 tilt, 0 phi, and 0 theta degrees, 22 line plots along the k-path can be obtianed which are plotted here:

![Fig2](https://github.com/user-attachments/assets/15d23aa1-8d72-4f73-a392-270e3da334d0)


![tilt_video-ezgif com-video-to-gif-converter (1)](https://github.com/user-attachments/assets/06ef0eed-afd8-4d7c-b58c-a8c21dd8455e)

![Figure_1](https://github.com/user-attachments/assets/246cae76-b6ed-4e3e-a129-4fffa28a02f8)

![kxky_video](https://github.com/user-attachments/assets/a8e19839-5d35-4088-9a73-d084a0374d82)
