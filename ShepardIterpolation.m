%Construct Spectrum map using grid interpolation in 2D
%Author: Shirley
%Date: 2016/9/8

function ShepardIterpolation()

%[Xq, Yq, Vq] = griddata(X,Y,V, xq, yq,v4);
% Interpolate a 2D scattered data set over a uniform grid
       xy = -2.5 + 5*gallery('uniformdata',[200 2],0);
       x = xy(:,1); y = xy(:,2);
       v = x.*exp(-x.^2-y.^2);
       [xq,yq] = meshgrid(-2:.2:2, -2:.2:2);
       vq = griddata(x,y,v,xq,yq,'v4');
       mesh(xq,yq,vq), hold on, plot3(x,y,v,'o'), hold off
%        
%        Example 2:
       % Interpolate a 3D data set over a grid in the x-y (z=0) plane
%        xyz = -1 + 2*gallery('uniformdata',[5000 3],0);
%        x = xyz(:,1); y = xyz(:,2); z = xyz(:,3);
%        v = x.^2 + y.^2 + z.^2;
%        d = -0.8:0.05:0.8;
%        [xq,yq,zq] = meshgrid(d,d,0);
%        vq = griddata(x,y,z,v,xq,yq,zq);
%        surf(xq,yq,vq);
 
       
end