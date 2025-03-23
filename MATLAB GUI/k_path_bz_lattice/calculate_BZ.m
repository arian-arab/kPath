function faces = calculate_BZ(G)
factor = 100 / min([norm(G(:,1)), norm(G(:,2)), norm(G(:,3))]);
G=G*factor;
faces = [];
    for it1 = -1:1
        for it2 = -1:1
            for it3 = -1:1
                if (not(sum([it1 it2 it3] == 0) == 3))
                    faces(end+1).vec = 0.5*(G * [it1;it2;it3])';
                    if(not(faces(end).vec(1) ==0))
                        vn1 = cross(faces(end).vec, [0 1 0]);
                    else
                        vn1 = cross(faces(end).vec, [1 0 0]);
                    end
                    
                    vn2 = cross(faces(end).vec,vn1);
                    fac = 2 * norm(G);
                    vn1 = fac * vn1/norm(vn1);
                    vn2 = fac * vn2/norm(vn2);
                    faces(end).corners = [ faces(end).vec-vn1-vn2; faces(end).vec-vn1+vn2; faces(end).vec+vn1+vn2; faces(end).vec+vn1-vn2 ];
                    
                    v_ref = mean(faces(end).corners,1); %sort counter clockwise
                    not_done = 1;
                    while(not_done)
                        not_done = 0;
                        for itn = 1:size(faces(end).corners,1)-1
                            v1 = faces(end).corners(itn,:);
                            v2 = faces(end).corners(itn+1, :);

                            if(dot(v_ref, cross(v1, v2-v1)) < 0)
                                faces(end).corners(itn,:) = v2;
                                faces(end).corners(itn+1, :) = v1;
                                not_done = 1;
                            end
                        end
                    end
                    
                end
            end
        end
    end

    itf1 = 1;

    while (itf1 <= size(faces,2))
        itf2 = 1;
        
        deleted = 0;
        while (itf2 <= size(faces,2))
            if(not(itf1 == itf2))
                outside_corners_index=[];
                for itc = 1: size(faces(itf1).corners,1)
                    corner = faces(itf1).corners(itc,:);
                    vec = faces(itf2).vec;
                    if(dot(vec/norm(vec), corner) > norm(vec))
                        outside_corners_index(end+1) = itc;
                    end
                end
                
                if(size(outside_corners_index, 2) == size(faces(itf1).corners, 1)) % face is entirely outside BZ
                    faces(itf1) = [];
                    deleted = 1;
                    break;
                    
                elseif(not(isempty(outside_corners_index)))
                    while(not(isempty(find(outside_corners_index == 1)))) %sort corners, so first corner is inside BZ
                        outside_corners_index = sort(cycl(outside_corners_index+1, size(faces(itf1).corners,1)));
                        faces(itf1).corners = [ faces(itf1).corners(end,:); faces(itf1).corners(1:(end-1),:)];
                    end
                    
                    
                    
                    for first_or_last = 1:2
                        noc = size(faces(itf1).corners, 1);
                        if(first_or_last == 1)
                            p1 = faces(itf1).corners(outside_corners_index(1),:);
                            p2 = faces(itf1).corners(cycl(outside_corners_index(1)-1, noc),:);
                        else 
                            p1 = faces(itf1).corners(outside_corners_index(end),:);
                            p2 = faces(itf1).corners(cycl(outside_corners_index(end)+1, noc),:);
                        end
                        %find intersection of line with plane
                        equation1 = [vec/norm(vec) norm(vec)]; %plane
                        vn1 = cross(p1, p2-p1);
                        vn2 = cross(p2-p1, vn1);
                        vn1 = vn1/norm(vn1);
                        vn2 = vn2/norm(vn2);
                        equation2 = [vn1 dot(p1, vn1)];
                        equation3 = [vn2 dot(p1, vn2)];
                        M_eq = [equation1(1:3); equation2(1:3); equation3(1:3)];
                        V_eq = [equation1(4); equation2(4); equation3(4)];
                        inv_M_eq = inv(M_eq);
                        if(norm(inv_M_eq) < 5 * norm(G))
                        
                            sol = (inv(M_eq) * V_eq)';
                            if(isnan(sol) | norm(sol) > 5000)
                                'strange solution'
                            end

                            
                            if(first_or_last == 1)
                                insert_at = outside_corners_index(1);
                                faces(itf1).corners = [faces(itf1).corners(1:insert_at-1,:); sol; faces(itf1).corners(insert_at:end,:)];
                                for itocm = 1:size(outside_corners_index,2)
                                    if(outside_corners_index(itocm) >= insert_at)
                                        outside_corners_index(itocm) = outside_corners_index(itocm) + 1;
                                    end
                                end
                                %faces(itf1).corners( cycl(outside_corners_index(1)- 1, size(faces(itf1).corners,1)),: ) = sol;
                                %outside_corners_index(1) = [];
                            else
                                insert_at = outside_corners_index(end);
                                faces(itf1).corners = [faces(itf1).corners(1:insert_at-1,:); sol; faces(itf1).corners(insert_at:end,:)];
                                for itocm = 1:size(outside_corners_index,2)
                                    if(outside_corners_index(itocm) >= insert_at)
                                        outside_corners_index(itocm) = outside_corners_index(itocm) + 1;
                                    end
                                end
                            end

                            if(first_or_last == 2)
                                for itoc = size(outside_corners_index,2) : -1 : 1
                                    faces(itf1).corners(outside_corners_index(itoc),:) = [];
                                end
                            end
                        end
                    end
                end
                faces(itf1).corners = unique(round(faces(itf1).corners*1000)/1000, 'rows');
                v_ref = mean(faces(itf1).corners,1); %sort counter clockwise
                not_done = 1;
                while(not_done)
                    not_done = 0;
                    for itn = 1:size(faces(itf1).corners,1)-1
                        v1 = faces(itf1).corners(itn,:);
                        v2 = faces(itf1).corners(itn+1, :);

                        if(dot(v_ref, cross(v1, v2-v1)) < 0)
                            faces(itf1).corners(itn,:) = v2;
                            faces(itf1).corners(itn+1, :) = v1;
                            not_done = 1;
                        end
                    end
                end
                
            end
            itf2 = itf2+1;
        end
        if(not(deleted))
            itf1 = itf1+1;
        end
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
        faces(itf).corners = faces(itf).corners/factor;
        faces(itf).vec = faces(itf).vec/factor;
    end

end
