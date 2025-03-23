function experiment_geometry = set_experiment_geometry()
input_values = inputdlg({'Analyzer Theta'},'Experimental Geometry',1,{'0'});
if isempty(input_values)==1
    experiment_geometry = 0;
else
    experiment_geometry=str2double(input_values{1});   
end