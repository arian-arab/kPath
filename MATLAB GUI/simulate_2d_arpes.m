function simulate_2d_arpes(dft_data,parameters,experiment_geometry)
input_values = listdlg('PromptString','','SelectionMode','single','ListString',{'tilt','photon energy'});
if isempty(input_values)~=1
    par_variable = parameters;    
    if input_values==1
        variable = parameters{15,2}:parameters{15,3}:parameters{15,4};
        f = waitbar(0,'calculating ARPES image');
        for i =1:length(variable)
            par_variable{14,1} = variable(i);
            [~,detector_angles,~,final] = k_path_calculator(dft_data,par_variable,experiment_geometry);            
            data_3d(:,:,i) = final; 
            waitbar(i/length(variable),f,'calculating ARPES image')
        end
        close(f)
        photon_energy=parameters{16,1};
        work_function=parameters{8,1};
        incidence_angle=parameters{9,1}-parameters{13,1};
        electron_momentum=0.5124.*((photon_energy-work_function).^(1/2));
        photon_momentum=0.506*(photon_energy./1000);
        [X,Y] = meshgrid(detector_angles,variable);
        kx=electron_momentum*sind(X)+photon_momentum*cosd(incidence_angle);
        ky=electron_momentum*cosd(X).*sind(Y);     
        selection = 1;
    end
    
    if input_values == 2
        variable = parameters{16,2}:parameters{16,3}:parameters{16,4};
        f = waitbar(0,'calculating ARPES image');
        for i =1:length(variable)
            par_variable{14,1} = variable(i);
            [~,detector_angles,~,final] = k_path_calculator(dft_data,par_variable,experiment_geometry);            
            data_3d(:,:,i) = final;
            waitbar(i/length(variable),f,'calculating ARPES image')
        end
        close(f)
        work_function=parameters{8,1};
        incidence_angle=parameters{9,1};
        inner_potential=parameters{7,1};
        [X,Y] = meshgrid(detector_angles,variable);
        electron_momentum=0.5124.*((Y-work_function).^(1/2));
        photon_momentum=0.506*(Y./1000);
        kx=electron_momentum.*sind(X)+photon_momentum*cosd(incidence_angle);
        ky=0.5124.*(((Y-work_function).*cosd(X).*cosd(X)+inner_potential).^(1/2))-photon_momentum*sind(incidence_angle);        
        selection = 2;
    end
    plot_2d_arpes(data_3d,X,Y,kx,ky,selection)
end
end

function plot_2d_arpes(data_3d,X,Y,kx,ky,selection)
fig = figure();
set(gcf,'name','ARPES 2D plot','NumberTitle','off','color','w','units','normalized','position',[0.4 0.3 0.4 0.6],'menubar','none','toolbar','none')

energy_step_value = 0.1;
values = linspace(min(data_3d(:)),max(data_3d(:)),1000);    
slider_step=[1/(length(values)-1),1];
slider = uicontrol('style','slider','units','normalized','position',[0.2,0,0.7,0.05],'min',values(1),'max',values(end),'sliderstep',slider_step,'value',values(1),'Callback',{@slider_callback});
energy = uicontrol('style','edit','units','normalized','position',[0,0,0.1,0.05],'string',num2str(min(data_3d(:))),'Callback',{@energy_callback});
energy_step = uicontrol('style','edit','units','normalized','position',[0.1,0,0.1,0.05],'string','0.1','Callback',{@energy_step_callback});
play = uicontrol('style','pushbutton','units','normalized','position',[0.9,0,0.1,0.05],'string','play','Callback',{@play_callback});
pause = uicontrol('style','pushbutton','units','normalized','position',[-0.9,0,0.1,0.05],'string','pause','Callback',{@pause_callback});
pause_call = 0;
energy_value = values(1);

plot_arpes(data_3d,X,Y,kx,ky,energy_value,energy_step_value,selection)

    function slider_callback(~,~,~) 
        energy_value = slider.Value;
        energy.String = num2str(energy_value); 
        plot_arpes(data_3d,X,Y,kx,ky,energy_value,energy_step_value,selection)
    end

    function energy_callback(~,~,~)
        energy_value = str2double(energy.String); 
        if energy_value>max(data_3d(:))
            energy_value = max(data_3d(:));
        end
        if energy_value<min(data_3d(:))
            energy_value = min(data_3d(:));
        end       
        slider.Value = energy_value;
        energy.String = energy_value;          
        plot_arpes(data_3d,X,Y,kx,ky,energy_value,energy_step_value,selection)
    end

    function energy_step_callback(~,~,~)
        energy_step_value = str2double(energy_step.String);
        plot_arpes(data_3d,X,Y,kx,ky,energy_value,energy_step_value,selection)
    end

    function play_callback(~,~,~)        
        play.Position = [-0.9,0,0.1,0.05];
        pause.Position = [0.9,0,0.1,0.05];
        pause_call = 0;
        slider_value = slider.Value;
        [~,start] = min(abs(values - slider_value));
        for k = start: length(values)            
            if pause_call == 0
                slider.Value = values(k);
                energy.String = values(k); 
                plot_arpes(data_3d,X,Y,kx,ky,values(k),energy_step_value,selection)
                drawnow
            end
        end
    end

    function pause_callback(~,~,~)
        play.Position = [0.9,0,0.1,0.05];
        pause.Position = [-0.9,0,0.1,0.05];
        pause_call = 1;
        slider_value = round(slider.Value);  
        plot_arpes(data_3d,X,Y,kx,ky,slider_value,energy_step_value,selection)
    end

    function plot_arpes(data_3d,X,Y,kx,ky,E,dE,selection)       
        data_wanted=data_3d<=E+dE & data_3d>=E;  
        data_wanted=abs(sum(data_wanted,2));
        data_wanted=permute(data_wanted,[3,1,2]);
        data_wanted(data_wanted==0) = NaN;
        
        cla(gca);
        surf(kx,ky,data_wanted,'linestyle','none')
        view(0,90)              
        xlim([min(kx(:)) max(kx(:))])
        ylim([min(ky(:)) max(ky(:))]) 
        title({['Energy = ',num2str(E),' : ',num2str(E+dE)],'','',''},'interpreter','latex','fontsize',14) 
        set(gca,'XColor','r','YColor','r','TickDir','out','TickLength',[0.02 0.02],'FontName','TimesNewRoman','FontSize',12,'TickLabelInterpreter','latex','units','normalized','position',[0.17 0.2 0.7 0.7])
        if selection == 1
            xlabel('$k_{x} (\AA^{-1}) $','interpreter','latex','fontsize',18)
            ylabel('$k_{y} (\AA^{-1})$','interpreter','latex','fontsize',18)
        else
            xlabel('$k_{x} (\AA^{-1})$','interpreter','latex','fontsize',18)
            ylabel('$k_{z} (\AA^{-1})$','interpreter','latex','fontsize',18)
        end
        
%         axes('units','normalized','position',[0.17 0.2 0.7 0.7],'XAxisLocation','Top','YAxisLocation','Right','Color','none');        
%         xlim([min(X(:)) max(X(:))])
%         ylim([min(Y(:)) max(Y(:))])
%         set(gca,'XColor','b','YColor','b','TickDir','out','TickLength',[0.02 0.02],'FontName','TimesNewRoman','FontSize',12,'TickLabelInterpreter','latex','units','normalized','position',[0.17 0.2 0.7 0.7])
%          if selection == 1
%             xlabel('$Detector Angles$','interpreter','latex','fontsize',18)
%             ylabel('$Tilt$','interpreter','latex','fontsize',18)
%         else
%             xlabel('$Detector Angles$','interpreter','latex','fontsize',18)
%             ylabel('$Photon Energy$','interpreter','latex','fontsize',18)
%          end        
    end
end