function save_parameters(parameters)
[file,path] = uiputfile('.mat','Save Parameters Values');
if file~=0
    Parameters = parameters;
    save(fullfile(path,file),'Parameters');
end