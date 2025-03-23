function arpes_image_data = load_arpes_image()
[file,path] = uigetfile('*.txt','Select the ARPES image','MultiSelect','off');
if file==0
    arpes_image_data = 0;
else    
    arpes_image_data = dlmread(fullfile(path,file));
end
end