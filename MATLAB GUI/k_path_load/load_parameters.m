function parameters = load_parameters()
[file,path] = uigetfile('*.mat','Select Your DFT Calculation','MultiSelect','off');
if file==0
    parameters = [{'',0,1,10};{'',0,1,100};{'',1,0,0};{'',0,1,0};{'',0,0,1};{1,'','',''};{0,'','',''};{0,'','',''};{20,'','',''};{0,'','',''};{1,'','',''};{1,'','',''};{0,-90,0,90};{0,-90,0,90};{0,-90,0,90};{400,100,5,1000}];
else    
    temp = load(fullfile(path,file));    
    parameters = temp.Parameters;
end
end