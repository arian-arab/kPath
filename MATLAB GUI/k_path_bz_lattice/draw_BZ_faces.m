function draw_BZ_faces(faces, offset, color, line_style)
    %use: draw_BZ(G, offset, color, line_style)
    %G: 3x3 matrix of the reciprocal lattice vectors in each column
    %offset: position of Gamma, default: [0 0 0]
    %colour default: 'black'
    %line_style default: '-'

    if(nargin < 2)
        offset = [0 0 0];
    end
    if(nargin < 3)
        color = 'black';
    end
    if(nargin < 4)
        line_style = '-';
    end

    itf = 1;
    while(itf <= size(faces,2))
        faces(itf).corners = unique(round(faces(itf).corners*1000)/1000, 'rows');
        v_ref = mean(faces(itf).corners,1); %sort counter clockwise
        not_done = 1;
        while(not_done)
            not_done = 0;
            for itn = 1:size(faces(itf).corners,1)-1
                v1 = faces(itf).corners(itn,:);
                v2 = faces(itf).corners(itn+1, :);

                if(dot(v_ref, cross(v1, v2-v1)) < 0)
                    faces(itf).corners(itn,:) = v2;
                    faces(itf).corners(itn+1, :) = v1;
                    not_done = 1;
                end
            end
        end
        if(size(faces(itf).corners, 1) < 3)
            faces(itf) = [];
        else
            itf = itf+1;
        end
    end





    for itf = 1:size(faces,2)
        corners = [faces(itf).corners' faces(itf).corners(1,:)'];
        for itc = 1:size(corners,2)
            corners(:,itc) =  (corners(:,itc) +offset');
        end
        
        plot_path(corners, 1, color, line_style);
        hold on;
    end

end
