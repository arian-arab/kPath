import numpy as np
from numpy import linalg as LA
import matplotlib.pyplot as plt
import cv2

def rotation_matrix(axis, theta):
    axis = axis/LA.norm(axis)
    a = axis[0]
    b = axis[1]
    c = axis[2]
    Sin = np.sin(theta)
    Cos = np.cos(theta)
    return np.array([[Cos+a*a*(1-Cos),a*b*(1-Cos)-c*Sin,a*c*(1-Cos)+b*Sin],[a*b*(1-Cos)+c*Sin,Cos+b*b*(1-Cos),b*c*(1-Cos)-a*Sin],[a*c*(1-Cos)-b*Sin,b*c*(1-Cos)+a*Sin,Cos+c*c*(1-Cos)]])

def find_kpath(dft, G, kPathCartesian, Theta, Tilt, Phi):
    Thetar=rotation_matrix([0,1,0],Theta*np.pi/180)
    Tiltr=rotation_matrix([1,0,0],Tilt*np.pi/180)
    Phir=rotation_matrix([0,0,1],Phi*np.pi/180)    

    ThetaTiltPhi=np.matmul(np.matmul(Thetar,Phir),Tiltr)    
    InvGThetaTiltPhi=np.matmul(LA.inv(G),ThetaTiltPhi)    

    kPathRotated=np.zeros((InvGThetaTiltPhi.shape[0],3,kPathCartesian.shape[1]))
    kPathRotated=np.matmul(InvGThetaTiltPhi,kPathCartesian)

    kPathRotated[kPathRotated<0]=kPathRotated[kPathRotated<0]+np.ceil(np.absolute(kPathRotated[kPathRotated<0]))
    kPathRotated[kPathRotated>1]=kPathRotated[kPathRotated>1]-np.floor(np.absolute(kPathRotated[kPathRotated>1]))
    kPathRotated=np.ceil(kPathRotated*dft.shape[0])-1;

    Final=dft[kPathRotated.astype(int)[0,:],kPathRotated.astype(int)[1,:],kPathRotated.astype(int)[2,:],:]
    return Final

#TaAs Reciprocal Lattice Units
g1=np.array([0,1.82927253615337,0.539746182216269])
g2=np.array([1.82927253615337,0,0.539746182216269])
g3=np.array([1.82927253615337,1.82927253615337,0])
G = np.transpose(np.array([g1,g2,g3]))
del g1,g2,g3
dft = np.load('TaAs.npy') # DFT calculations of TaAs

################# Parameters and Configuration ################
detector_angles=np.arange(-10,10,0.1, dtype=np.float32)
PhotonEnergy=500 #eV
WorkFunction=0 #eV
InnerPotential=0 #eV
IncidenceAngle=90 # degrees
r=0.5124*np.sqrt(PhotonEnergy-WorkFunction+InnerPotential)
PhotonMomentum=0.506*(PhotonEnergy/1000)
kPathCartesian=np.zeros((3,detector_angles.shape[0]))
kPathCartesian[0,:]=np.array(r*np.sin(detector_angles*(np.pi/180))-PhotonMomentum*np.cos(IncidenceAngle*(np.pi/180)))
kPathCartesian[1,:]=np.array(0)
kPathCartesian[2,:]=np.array(r*np.cos(detector_angles*(np.pi/180)))
del IncidenceAngle, r, PhotonMomentum, PhotonEnergy, WorkFunction, InnerPotential


################# Energy Bands (rotating sample along x-direction, tilt measurements) ################
bands = []
tilts = np.arange(-10,10,0.1)
for tilt in tilts:    
    bands.append(find_kpath(dft, G, kPathCartesian, Theta = 0, Tilt = tilt, Phi = 0))
bands = np.array(bands)
del tilt

############### k_path along x-direction ############### 
fig, ax = plt.subplots()
for j in range(bands.shape[-1]):
    ax.plot(detector_angles[:-4], np.convolve(bands[100][:,j], np.ones(5)/5, mode='valid'), c = 'k')
ax.set_xlabel('Detector Angles')
ax.set_ylabel('Energies')
ax.set_title('Tilt = '+str(np.round(tilts[100],2)))  
plt.show()
del j, fig, ax

############### isoenergy kx-ky surface ###############
energy = 12
energy_window = 0.1
fig, ax = plt.subplots()
surface = np.zeros((bands.shape[0],bands.shape[1]))    
for i in range(bands.shape[2]):
    indices = np.where((bands[:,:,i]>=energy-energy_window) & (bands[:,:,i]<=energy+energy_window))
    surface[indices[0],indices[1]] += 1
smoothed_surface = cv2.GaussianBlur(surface, (5, 5), 0) 
plt.imshow(smoothed_surface, cmap = 'gray', extent=[detector_angles.min(), detector_angles.max(), tilts.min(), tilts.max()], origin="lower")
plt.show()
del i, fig, ax, energy, energy_window













######### Run  codes below only to obtain videos and figures in the README file #########
################# Plot Videos in ReadMe file ###################
################# Plot Videos in ReadMe file ###################
################# Plot Videos in ReadMe file ###################

################# Plot Energy Bands All Together ################
fig = plt.figure(figsize=(8, 6))
ax = fig.add_subplot(111, projection='3d')
for i in range(bands.shape[-1]):
    for j in range(bands.shape[0]):   
        if j%2==0:
            ax.plot(detector_angles,bands[j,:,i], zs=tilts[j], zdir='y', c = 'k', alpha = 0.5, linewidth = 0.1)
ax.set_xlabel('Detector Angles')
ax.set_ylabel('Tilts')
ax.set_zlabel('Energies')
plt.show()


################# Plot Energy Bands ################
frame_width = 640
frame_height = 480
output_video = 'output_video.avi'
fourcc = cv2.VideoWriter_fourcc(*'XVID')  # Video codec
video_writer = cv2.VideoWriter(output_video, fourcc, 20.0, (frame_width, frame_height))
for i in range(len(tilts)):
    print(tilts[i])
    fig, ax = plt.subplots()   
    for j in range(bands.shape[-1]):
        ax.plot(detector_angles[:-4], np.convolve(bands[i][:,j], np.ones(5)/5, mode='valid'), c = 'k')
    ax.set_xlabel('Detector Angles')
    ax.set_ylabel('Energies')
    ax.set_title('Tilt = '+str(np.round(tilts[i],2)))    
    fig.canvas.draw()
    img = np.frombuffer(fig.canvas.tostring_rgb(), dtype=np.uint8)
    img = img.reshape(fig.canvas.get_width_height()[::-1] + (3,))  # Reshape to image       
    img_resized = cv2.resize(img, (frame_width, frame_height))       
    video_writer.write(img_resized)        
    plt.close(fig)
video_writer.release()

################# Plot Energy Bands All Together Video ################
frame_width = 640
frame_height = 480
energy_window = 0.05
X, Y = np.meshgrid(detector_angles, tilts)
output_video = 'output_video.avi'
fourcc = cv2.VideoWriter_fourcc(*'XVID')  # Video codec
video_writer = cv2.VideoWriter(output_video, fourcc, 20.0, (frame_width, frame_height))
for energy in np.arange(5,15+energy_window,energy_window):
    print(energy)    
    fig, ax = plt.subplots(subplot_kw={"projection": "3d"})
    for i in range(bands.shape[-1]):
        for j in range(bands.shape[0]):
            if j%2==0:          
                ax.plot(detector_angles, bands[j,:,i], zs=tilts[j], zdir='y', c = 'k', alpha = 0.5, linewidth = 0.1)
    surface = np.zeros((bands.shape[0],bands.shape[1]))    
    for i in range(bands.shape[2]):
        indices = np.where((bands[:,:,i]>=energy-energy_window) & (bands[:,:,i]<=energy+energy_window))
        surface[indices[0],indices[1]] += 1
    smoothed_surface = cv2.GaussianBlur(surface, (5, 5), 0)
    Z = energy+np.zeros(X.shape)
    colors = plt.cm.gray(smoothed_surface)
    colors[..., -1] = 0.3
    ax.plot_surface(X, Y, Z, facecolors=colors, shade=False)
    ax.set_xlabel('Detector Angles')
    ax.set_ylabel('Tilts')
    ax.set_zlabel('Energies')
    ax.set_title('Energy = '+str("{:.2f}".format(np.round(energy,2))))    
    fig.canvas.draw()
    img = np.frombuffer(fig.canvas.tostring_rgb(), dtype=np.uint8)
    img = img.reshape(fig.canvas.get_width_height()[::-1] + (3,))  # Reshape to image
    img_resized = cv2.resize(img, (frame_width, frame_height))  
    video_writer.write(img_resized)
    plt.close(fig)
video_writer.release()

################# Plot kx-ky Surface ################
frame_width = 640
frame_height = 480
energy_window = 0.05
output_video = 'output_video.avi'
fourcc = cv2.VideoWriter_fourcc(*'XVID')  # Video codec
video_writer = cv2.VideoWriter(output_video, fourcc, 20.0, (frame_width, frame_height))
for energy in np.arange(5,15+energy_window,energy_window):
    surface = np.zeros((bands.shape[0],bands.shape[1]))    
    for i in range(bands.shape[2]):
        indices = np.where((bands[:,:,i]>=energy-energy_window) & (bands[:,:,i]<=energy+energy_window))
        surface[indices[0],indices[1]] += 1
    smoothed_surface = cv2.GaussianBlur(surface, (5, 5), 0)    
    fig, ax = plt.subplots()    
    ax.imshow(smoothed_surface, cmap = 'gray', extent=[detector_angles.min(), detector_angles.max(), tilts.min(), tilts.max()], origin="lower")
    ax.set_xlabel('Detector Angles')
    ax.set_ylabel('Tilts')
    ax.set_title('Energy = '+str("{:.2f}".format(np.round(energy,2))))
    fig.canvas.draw()
    img = np.frombuffer(fig.canvas.tostring_rgb(), dtype=np.uint8)
    img = img.reshape(fig.canvas.get_width_height()[::-1] + (3,))  # Reshape to image
    img_resized = cv2.resize(img, (frame_width, frame_height))  
    video_writer.write(img_resized)
    plt.close(fig)
video_writer.release()
