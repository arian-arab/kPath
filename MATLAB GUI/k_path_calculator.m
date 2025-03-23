function [k_x,detector_angles,energies,final] = k_path_calculator(dft_data,parameters,experiment_geometry)

g1=[parameters{3,2};parameters{3,3};parameters{3,4}]*parameters{6,1};
g2=[parameters{4,2};parameters{4,3};parameters{4,4}]*parameters{6,1};
g3=[parameters{5,2};parameters{5,3};parameters{5,4}]*parameters{6,1};
G=[g1,g2,g3];
theta = parameters{13,1}+experiment_geometry;
phi = parameters{14,1};
tilt = parameters{15,1};
incidence_angle = parameters{9,1}-parameters{13,1};
photon_energy = parameters{16,1};
work_function = parameters{8,1};
inner_potential = parameters{7,1};
detector_angles = parameters{11,1}.*(parameters{1,2}:parameters{1,3}:parameters{1,4});
energies=parameters{12,1}*(parameters{2,2}:parameters{2,3}:parameters{2,4})+parameters{10,1};
photon_momentum = 0.506*(photon_energy/1000);
r=0.5124*sqrt(photon_energy-work_function);
k_path_length=r*deg2rad(abs(detector_angles(end)-detector_angles(1)));
k_path_meshsize=ceil(k_path_length*100/norm(g1));
k_path_span=detector_angles(1):(detector_angles(end)-detector_angles(1))/((k_path_meshsize-1)):detector_angles(end);
kPathCartesian(1,:)=r*sind(k_path_span)+photon_momentum*cosd(incidence_angle);
kPathCartesian(2,:)=0;
kPathCartesian(3,:)=0.5124*sqrt(((photon_energy-work_function).*cosd(k_path_span).*cosd(k_path_span))+inner_potential)-photon_momentum*sind(incidence_angle);
k_x=kPathCartesian(1,1):(kPathCartesian(1,end)-kPathCartesian(1,1))/(size(detector_angles,2)-1):kPathCartesian(1,end);
k_path_rotated=rotationmatrix(phi,[0 0 1])*rotationmatrix(-tilt,[1 0 0])*rotationmatrix(-theta,[0 1 0])*kPathCartesian;

if isempty(dft_data)~=1    
    k=G\k_path_rotated;
    k=k-floor(k);
    k=ceil(k*size(dft_data,1));
    k(k==0)=1;
    BZNum=k(1,:)+(k(2,:)-1)*size(dft_data,1)+(k(3,:)-1)*size(dft_data,1)*size(dft_data,2);
    dft_dataReshaped=reshape(dft_data,[size(dft_data,1)*size(dft_data,2)*size(dft_data,3),size(dft_data,4)]);
    DataAlongkPath=dft_dataReshaped(BZNum,:);
    DataAlongkPath=reshape(DataAlongkPath,[size(kPathCartesian,2),size(dft_data,4)]);
    for i=1:size(DataAlongkPath,2)
        DataAlongkPath(:,i)=smooth(DataAlongkPath(:,i));
    end
    final=interp1(k_path_span,DataAlongkPath,detector_angles);
else
    final = [];
end
end