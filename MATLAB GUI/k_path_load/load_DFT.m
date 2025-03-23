function dft_data = load_DFT()
[file,path] = uigetfile('*.mat','Select Your DFT Calculation','MultiSelect','off');
if file==0
    dft_data = [];
else
    dft_data = load(fullfile(path,file));
    dft_data = dft_data.Data;
    msgbox('DFT Data Successfully Loaded');
end
end