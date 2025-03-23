function k_path_plot(k_x,detector_angles,energies,final,arpes_image_data,parameters,complete,experiment_geometry)
clf(figure(10000))
set(gcf,'name','kPath plot','NumberTitle','off','color','w','menubar','none','toolbar','none')

subplot(1,2,1)
axtoolbar(gca,{'zoomin','zoomout','restoreview','rotate'});
if isempty(arpes_image_data)~=1
    det_ang_arpes = linspace(detector_angles(1),detector_angles(end),size(arpes_image_data,2));
    det_eng_arpes = linspace(energies(1),energies(end),size(arpes_image_data,1));
    imagesc('xdata',det_ang_arpes,'ydata',det_eng_arpes,'cdata',arpes_image_data,'AlphaData',1)
    colormap(jet)
    xlim([min(det_ang_arpes) max(det_ang_arpes)])
    ylim([min(det_eng_arpes) max(det_eng_arpes)])    
    invert_arpes=uimenu('Text','Invert ARPES image');
    uimenu(invert_arpes,'Text','Invert ARPES image left-righ','ForegroundColor','k','CallBack',@invert_arpes_lr);
    uimenu(invert_arpes,'Text','Invert ARPES image up-down','ForegroundColor','k','CallBack',@invert_arpes_ud);
    uimenu(invert_arpes,'Text','Transpose ARPES image','ForegroundColor','k','CallBack',@transpose_arpes);
end

    function invert_arpes_lr(~,~,~)
        arpes_image_data = fliplr(arpes_image_data);
        close(figure(10000))
        k_path_plot(k_x,detector_angles,energies,final,arpes_image_data,parameters,complete,experiment_geometry)
    end

    function invert_arpes_ud(~,~,~)
        arpes_image_data = fliplr(arpes_image_data);
        close(figure(10000))
        k_path_plot(k_x,detector_angles,energies,final,arpes_image_data,parameters,complete,experiment_geometry)
    end

    function transpose_arpes(~,~,~)
        arpes_image_data = arpes_image_data';
        close(figure(10000))
        k_path_plot(k_x,detector_angles,energies,final,arpes_image_data,parameters,complete,experiment_geometry)
    end

hold on
if isempty(final)~=1
    plot(detector_angles,final,'color','r','LineWidth',0.8)    
    xlim([min(detector_angles) max(detector_angles)])
    ylim([min(energies) max(energies)])
end

line([detector_angles(1) detector_angles(end)],[0 0],'LineStyle','--','color','b','LineWidth',1.5)
line([0 0],[min(energies) max(energies)],'LineStyle','--','color','b','LineWidth',1.5)
set(gca,'TickLength',[0.02 0.02],'FontName','TimesNewRoman','FontSize',12,'TickLabelInterpreter','latex','box','on')
ylabel('Energy (eV)','interpreter','latex');
xlabel('Detector Angles','interpreter','latex');
title({'',[['$\theta  =$',num2str(parameters{13,1})],', ',['$\phi=$',num2str(parameters{14,1})],', ',['$\beta_{Tilt}=$',num2str(parameters{15,1})],', ',['$h\vartheta=$',num2str(parameters{16,1}),'eV'],', ',['$\theta_{inc}=$',num2str(parameters{9,1}-parameters{13,1})],', ',['$\theta_{stretch}=$',num2str(parameters{11,1})],', ',['$E_{stretch}=$',num2str(parameters{12,1})]],''},'interpreter','latex','fontsize',14);

subplot(1,2,2)
axtoolbar(gca,{'zoomin','zoomout','restoreview','rotate'});
hold on
g1=[parameters{3,2};parameters{3,3};parameters{3,4}]*parameters{6,1};
g2=[parameters{4,2};parameters{4,3};parameters{4,4}]*parameters{6,1};
g3=[parameters{5,2};parameters{5,3};parameters{5,4}]*parameters{6,1};
G=[g1,g2,g3];
theta = parameters{13,1}+experiment_geometry;
phi = parameters{14,1};
tilt = parameters{15,1};
incidence_angle = parameters{9,1};
photon_energy = parameters{16,1};
work_function = parameters{8,1};
inner_potential = parameters{7,1};
detector_angles = parameters{11,1}.*(parameters{1,2}:parameters{1,3}:parameters{1,4});
photon_momentum = 0.506*(photon_energy/1000);
r=0.5124*sqrt(photon_energy-work_function);
kPathCartesian(1,:)=r*sind(detector_angles)+photon_momentum*cosd(parameters{9,1}-parameters{13,1});
kPathCartesian(2,:)=0;
kPathCartesian(3,:)=0.5124*sqrt(((photon_energy-work_function).*cosd(detector_angles).*cosd(detector_angles))+inner_potential)-photon_momentum*sind(incidence_angle);
k_path=rotationmatrix(phi,[0 0 1])*rotationmatrix(-tilt,[1 0 0])*rotationmatrix(-(theta),[0 1 0])*kPathCartesian;
Diff=k_path(:,end)-k_path(:,1);
kPathLength=sqrt(Diff(1).^2+Diff(2).^2+Diff(3).^2);
plot3(k_path(1,:),k_path(2,:),k_path(3,:),'r','linewidth',1.5)
plot_cone(k_path)
plot_detector(experiment_geometry)
plot_x_ray(incidence_angle)
plot_sample(theta,tilt,phi)
%plot_recirocal_lattice_unit_vectors(g1,g2,g3)
uicontrol('style','pushbutton','units','normalized','position',[0.8 0.92 0.2 0.08],'string','k-path coordinates','callback',{@save_coordinates})

%--------DRAW BZ---------------%
faces=calculate_BZ(G);
draw_BZ_faces(faces,[0 0 0],'b')

if complete == 1
    for i = 1:length(faces)
        z_step(i) = max(faces(i).corners(:,3));
    end
    z_step = 2*max(z_step);
    z_max=max(k_path(3,:));
    for i=1:ceil((z_max-z_step/2)/z_step)
        sols=ProblemSolverBZ(G',[0 0 i*z_step]);
        draw_BZ_faces(faces,sols,'k','--');
    end
    text(0,0,z_max+z_step/2,strcat(num2str(ceil((z_max-z_step/2)/z_step)),'th BZ'),'color','r','interpreter','latex','fontsize',18)
    
    Num=floor(kPathLength/(min([norm(g1),norm(g2),norm(g3)])/2));
    Step=round(size(k_path,2)/Num);
    sols=ProblemSolverBZ(G',k_path(:,1)');
    draw_BZ_faces(faces,sols,'b');
    for i=2:Num+1
        solsm=sols;
        k=Step*(i-1);
        if k<size(k_path,2)
            P=k_path(:,k)';
        else
            P=k_path(:,end)';
        end
        sols=ProblemSolverBZ(G',P);
        if solsm(1)==sols(1) && solsm(2)==sols(2) && solsm(3)==sols(3)
            continue
        else
            draw_BZ_faces(faces,sols,'b','-');
        end
    end
end
%--------DRAW BZ---------------%
mArrow3([0 0 0],[0 0 kPathLength/5],'color','k','stemWidth',kPathLength/200);
mArrow3([0 0 0],[kPathLength/5 0 0],'color','k','stemWidth',kPathLength/200);
mArrow3([0 0 0],[0 kPathLength/5 0],'color','k','stemWidth',kPathLength/200);
text(kPathLength/(4.5),0,0,'X')
text(0,kPathLength/(4.5),0,'Y')
text(0,0,kPathLength/(4.5),'Z')
axis equal tight off
view(-150,40)

    function save_coordinates(~,~,~)
        [file,path] = uiputfile('*.txt');
        if file~=0
            dlmwrite(fullfile(path,file),k_path')
        end
    end
end

function plot_recirocal_lattice_unit_vectors(g1,g2,g3)
g1 = g1';g2 = g2'; g3 = g3';
x1=[0,0,0];
x1(2,:)=g1;

x2=[0,0,0];
x2(2,:)=g2;

x3=[0,0,0];
x3(2,:)=g3;

x4=g1;
x4(2,:)=g1+g2;

x5=g1;
x5(2,:)=g1+g3;

x6=g2;
x6(2,:)=g1+g2;

x7=g2;
x7(2,:)=g2+g3;

x8=g3;
x8(2,:)=g1+g3;

x9=g3;
x9(2,:)=g2+g3;

x10=g1+g2;
x10(2,:)=g1+g2+g3;

x11=g1+g3;
x11(2,:)=g1+g2+g3;

x12=g2+g3;
x12(2,:)=g1+g2+g3;

hold on
plot3(x1(:,1),x1(:,2),x1(:,3),'k','linewidth',1);
plot3(x2(:,1),x2(:,2),x2(:,3),'k','linewidth',1);
plot3(x3(:,1),x3(:,2),x3(:,3),'k','linewidth',1);
plot3(x4(:,1),x4(:,2),x4(:,3),'k','linewidth',1);
plot3(x5(:,1),x5(:,2),x5(:,3),'k','linewidth',1);
plot3(x6(:,1),x6(:,2),x6(:,3),'k','linewidth',1);
plot3(x7(:,1),x7(:,2),x7(:,3),'k','linewidth',1);
plot3(x8(:,1),x8(:,2),x8(:,3),'k','linewidth',1);
plot3(x9(:,1),x9(:,2),x9(:,3),'k','linewidth',1);
plot3(x10(:,1),x10(:,2),x10(:,3),'k','linewidth',1);
plot3(x11(:,1),x11(:,2),x11(:,3),'k','linewidth',1);
plot3(x12(:,1),x12(:,2),x12(:,3),'k','linewidth',1);
end

function plot_sample(theta,tilt,phi)
line1(1,:)=-0.5:0.1:0.5;line1(2,:)=0.5;line1(3,:)=0;
line2(1,:)=-0.5:0.1:0.5;line2(2,:)=-0.5;line2(3,:)=0;
line3(2,:)=-0.5:0.1:0.5;line3(1,:)=-0.5;line3(3,:)=0;
line4(2,:)=-0.5:0.1:0.5;line4(1,:)=0.5;line4(3,:)=0;
line1rot=rotationmatrix(phi,[0 0 1])*rotationmatrix(tilt,[1 0 0])*rotationmatrix(theta,[0 1 0])*line1;
line2rot=rotationmatrix(phi,[0 0 1])*rotationmatrix(tilt,[1 0 0])*rotationmatrix(theta,[0 1 0])*line2;
line3rot=rotationmatrix(phi,[0 0 1])*rotationmatrix(tilt,[1 0 0])*rotationmatrix(theta,[0 1 0])*line3;
line4rot=rotationmatrix(phi,[0 0 1])*rotationmatrix(tilt,[1 0 0])*rotationmatrix(theta,[0 1 0])*line4;
plot3(line1rot(1,:),line1rot(2,:),line1rot(3,:),'r','linewidth',1.5)
plot3(line2rot(1,:),line2rot(2,:),line2rot(3,:),'r','linewidth',1.5)
plot3(line3rot(1,:),line3rot(2,:),line3rot(3,:),'r','linewidth',1.5)
plot3(line4rot(1,:),line4rot(2,:),line4rot(3,:),'r','linewidth',1.5)
end

function plot_x_ray(incidence_angle)
x_ray(1,:)=-2:0.1:0;x_ray(2,:)=0;x_ray(3,:)=0;
x_ray_rotated=rotationmatrix(incidence_angle,[0 1 0])*x_ray;
plot3(x_ray_rotated(1,:),x_ray_rotated(2,:),x_ray_rotated(3,:),'g','linewidth',1.5)
text(min(x_ray_rotated(1,:)),0,max(x_ray_rotated(3,:)),'$x_{ray}$','interpreter','latex','fontsize',18,'color','g')
end

function plot_detector(experiment_geometry)
detector(1,:)=2*sind(-20:0.1:20);detector(2,:)=0;detector(3,:)=3*cosd(-20:0.1:20);
detector_rotated=rotationmatrix(-experiment_geometry,[0 1 0])*detector;
plot3(detector_rotated(1,:),detector_rotated(2,:),detector_rotated(3,:),'k','linewidth',1.5)
text(0,0,3.2,'detector','interpreter','latex','fontsize',14)
end

function plot_cone(k_path)
m = [1 size(k_path,2)];
for i=1:2
    plot3([0 k_path(1,m(i))],[0 k_path(2,m(i))],[0 k_path(3,m(i))],'r')
end
end