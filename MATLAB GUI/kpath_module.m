function kpath_module()
addpath([pwd,'\k_path_load']);
addpath([pwd,'\k_path_bz_lattice']);

dft_data = [];
arpes_image_data = [];
experiment_geometry = 0;
figure()
set(gcf,'name','kPath (ARPES Simulation)','NumberTitle','off','color','w','units','normalized','position',[0.3 0.2 0.35 0.6],'menubar','none','toolbar','none')

file_menu=uimenu('Text','File');
uimenu(file_menu,'Text','Load DFT','ForegroundColor','k','CallBack',@load_dft_callback);
uimenu(file_menu,'Text','Load Parameters','ForegroundColor','k','CallBack',@load_parameters_callback);
uimenu(file_menu,'Text','Save Parameters','ForegroundColor','k','CallBack',@save_parameters_callback);
uimenu(file_menu,'Text','Load ARPES image','ForegroundColor','k','CallBack',@load_arpes_image_callback);

experiment_geometry_menu=uimenu('Text','Experiment Geometry');
uimenu(experiment_geometry_menu,'Text','Set Experiment Geometry','ForegroundColor','k','CallBack',@set_experiment_geometry_callback);

plot_menu=uimenu('Text','Plot');
uimenu(plot_menu,'Text','Plot k-path','ForegroundColor','k','CallBack',@plot_k_path_callback);
uimenu(plot_menu,'Text','Plot BZ k-path','ForegroundColor','k','CallBack',@plot_bz_kpath_callback);
 
simulate_menu=uimenu('Text','Simulation');
uimenu(simulate_menu,'Text','Simulate 2-D ARPES','ForegroundColor','k','CallBack',@simulate_2d_arpes_callback);

help_menu=uimenu('Text','Help');
uimenu(help_menu,'Text','k-Path Equations and Geometry','ForegroundColor','k','CallBack',@help_callback);

row_names = {'detector angle','detector energy','g1','g2','g3','BZ stretch','inner potential(eV)','work function (eV)','incidence angle','energy offset','detector angle stretch','detector energy stretch','theta','phi','tilt','photon energy(eV)'};
column_names = {'value','start','step','finish'};
parameters = [{'',0,1,10};{'',0,1,100};{'',1,0,0};{'',0,1,0};{'',0,0,1};{1,'','',''};{0,'','',''};{0,'','',''};{20,'','',''};{0,'','',''};{1,'','',''};{1,'','',''};{0,-90,0,90};{0,-90,0,90};{0,-90,0,90};{400,100,5,1000}];
parameters_table = uitable('data',parameters,'units','normalized','position',[0,0,1,1],'FontSize',12,'ColumnName',column_names,'RowName',row_names,'CellEditCallback',@table_callback,'ColumnEditable',true);

    function load_dft_callback(~,~,~)        
        dft_data = load_DFT();
    end

    function load_parameters_callback(~,~,~)        
        parameters_table.Data = load_parameters();
    end

    function save_parameters_callback(~,~,~)        
        save_parameters(parameters_table.Data);
    end

    function load_arpes_image_callback(~,~,~)        
        arpes_image_data = load_arpes_image();
        [k_x,detector_angles,energies,final] = k_path_calculator(dft_data,parameters_table.Data,experiment_geometry);
        k_path_plot(k_x,detector_angles,energies,final,arpes_image_data,parameters_table.Data,0,experiment_geometry);
    end

    function table_callback(~,~,~)
        parameters_table.Data = table_callback_inside(parameters_table.Data);
        [k_x,detector_angles,energies,final] = k_path_calculator(dft_data,parameters_table.Data,experiment_geometry);
        k_path_plot(k_x,detector_angles,energies,final,arpes_image_data,parameters_table.Data,0,experiment_geometry);        
    end

    function plot_bz_kpath_callback(~,~,~)        
        plot_bz_kpath(parameters_table.Data,experiment_geometry,1)
    end

    function set_experiment_geometry_callback(~,~,~)
        experiment_geometry = set_experiment_geometry();
        plot_bz_kpath(parameters_table.Data,experiment_geometry,0)
    end

    function simulate_2d_arpes_callback(~,~,~)
        if isempty(dft_data)~=1
            simulate_2d_arpes(dft_data,parameters_table.Data,experiment_geometry)
        end
    end

    function help_callback(~,~,~)
        figure()
        set(gcf,'name','k-path equations','NumberTitle','off','color','w','menubar','none','toolbar','none')        
        imshow('k_path.jpg')
    end

    function plot_k_path_callback(~,~,~)
        parameters_table.Data = table_callback_inside(parameters_table.Data);
        [k_x,detector_angles,energies,final] = k_path_calculator(dft_data,parameters_table.Data,experiment_geometry);
        k_path_plot(k_x,detector_angles,energies,final,arpes_image_data,parameters_table.Data,0,experiment_geometry);        
    end
end