function RotationMatrix=rotationmatrix(Angle,Vector)
Norm=Vector./norm(Vector);
RotationMatrix=[cosd(Angle)+Norm(1,1)^2*(1-cosd(Angle)) Norm(1,1)*Norm(1,2)*(1-cosd(Angle))-Norm(1,3)*sind(Angle) Norm(1,1)*Norm(1,3)*(1-cosd(Angle))+Norm(1,2)*sind(Angle);
        Norm(1,1)*Norm(1,2)*(1-cosd(Angle))+Norm(1,3)*sind(Angle) cosd(Angle)+Norm(1,2)^2*(1-cosd(Angle)) Norm(1,2)*Norm(1,3)*(1-cosd(Angle))-Norm(1,1)*sind(Angle);
        Norm(1,1)*Norm(1,3)*(1-cosd(Angle))-Norm(1,2)*sind(Angle) Norm(1,2)*Norm(1,3)*(1-cosd(Angle))+Norm(1,1)*sind(Angle) cosd(Angle)+Norm(1,3)^2*(1-cosd(Angle))];
end