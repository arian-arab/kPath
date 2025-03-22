# kPath (Software to Simulate Angle-Resolved Photoelectron Spectroscopy Experiments-ARPES)

The Python code and the MATLAB GUI in this package seperately simulates ARPES measurements using Density Functional Theory (DFT) calculations.

As an example, DFT calculations for the material TaAs is provided. The reciprocal lattice units are given and the DFT calculations are provided in a NumPy array of size (51*51*51*22) wherein the 51 dimensions are the k_x, k_y, and k_z in the reciprocal space and 22 are the number of bands, i.e., at each point in the reciprocal space; energies from 22 bands are calculated. As a result in an ARPES experiment, using the experimaental parameters and geometry (photon energy, incidence angle, and the orientations of the sample), a one-dimensional path in the reciprocal space (k-path) can be constructed and the energies for each of the 22 bands along the k-path can be obtained.

For example, at the photon energy of 500 eV and incidence angle of 90 degress (assuming no contribution to the k_x component of the electron energies due to photon momemntum) with an experimental geometry of 0 tilt, 0 phi, and 0 theta degrees, 22 line plots along the k-path can be obtianed which are plotted here:

![Fig2](https://github.com/user-attachments/assets/15d23aa1-8d72-4f73-a392-270e3da334d0)

In the next step by rotating the sample along the y-axis (i.e. taking measurements by tilting the sample) we can obtain these bands along different k-path corresponding to different tilt values. Here as an example we rotate the sample by introducing tilt angles from -10 to 10 degress in steps of 0.1 degress:

![tilt_video](https://github.com/user-attachments/assets/d6c9cd29-b6e3-41f3-9ab1-581d974c0756)

All these 22 bands for each of the tils can be plotted in a 3-dimensional plot to better visualize the 22 bands along different k-paths:

![Fig1](https://github.com/user-attachments/assets/32feb07d-6d82-47a0-beb2-46b21a32f255)

The tilt in the above corresnpods to the k_y component. As a result by sclicing planes along the k_x-k_y direction we can obtain isoeneergetic surfaces hence resolve the ARPES image along the x and y components of the reciprocal space:

![isoenergy](https://github.com/user-attachments/assets/9e645fdb-af88-4c05-b536-dc56a92b022a)
