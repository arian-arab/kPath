function plot_path(path, basis, color, line_style)
    % use: plot_path(path, basis, color, line_style)
    % path is array of 3D column vectors
    % eg path = [A B ...]; with A = [1;0;0] ...
    % basis is 3x3 matrix
    % coordinates of A are B*A
    
    % default basis = 1
    % default color = 'black'
    % default line_style = '-'
    
    if(nargin <= 3)
        line_style = '-';
    end
    if(nargin <= 2)
        color = 'black';
    end
    
    if(nargin == 1)
        basis =1;
    end
    coordinates = [];
    for it = 1: size(path,2)
        coordinates(end+1,:) = (basis * path(:,it))';
    end
    plot3(coordinates(:,1), coordinates(:,2), coordinates(:,3),line_style, 'color', color,'linewidth',2);
end