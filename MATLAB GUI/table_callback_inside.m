function parameters = table_callback_inside(parameters)
if parameters{1,3}<=0
    parameters{1,3}=1;
end
if parameters{2,3}<=0
    parameters{2,3}=1;
end

if parameters{1,4}<parameters{1,2}
    parameters{1,4}=parameters{1,2}+1;
end
if parameters{2,4}<parameters{2,2}
    parameters{2,4}=parameters{2,2}+1;
end

if parameters{1,2}>parameters{1,4}
    parameters{1,2}=parameters{1,4}-1;
end

if parameters{2,2}>parameters{2,4}
    parameters{2,2}=parameters{2,4}-1;
end

if parameters{13,1}<parameters{13,2}
    parameters{13,1}=parameters{13,2};
end
if parameters{13,1}>parameters{13,4}
    parameters{13,1}=parameters{13,4};
end

if parameters{14,1}<parameters{14,2}
    parameters{14,1}=parameters{14,2};
end
if parameters{14,1}>parameters{14,4}
    parameters{14,1}=parameters{14,4};
end

if parameters{15,1}<parameters{15,2}
    parameters{15,1}=parameters{15,2};
end
if parameters{15,1}>parameters{15,4}
    parameters{15,1}=parameters{15,4};
end

if parameters{16,1}<parameters{16,2}
    parameters{16,1}=parameters{16,2};
end
if parameters{16,1}>parameters{16,4}
    parameters{16,1}=parameters{16,4};
end
end