%% Example #1:
wheel_OBJ =  bh_wheel_toy_CLS(0.3, 0.1);

figure();
  hax(1) = subplot(2,2,1);  wheel_OBJ.plot_3D(hax(1));
  hax(2) = subplot(2,2,2);  wheel_OBJ.plot_XY(hax(2));  
  hax(3) = subplot(2,2,3);  wheel_OBJ.plot_XZ(hax(3));  
  hax(4) = subplot(2,2,4);  wheel_OBJ.plot_YZ(hax(4));  
%--------------------------------------------------------------------------
[X,Y,Z] = wheel_OBJ.get_B_XYZ();
   
   a = 45*pi/180;

agRb = [cos(a),  -sin(a),  0;
        sin(a),   cos(a),  0;
             0,        0,  1; ];

new_XYZ = agRb * [X';
                  Y';
                  Z' ];

wheel_OBJ = wheel_OBJ.set_G_XYZ(new_XYZ(1,:)', new_XYZ(2,:)', new_XYZ(3,:)');
%-------------------------------------------------------------------------- 
   figure();
      hax(1) = subplot(2,2,1);  wheel_OBJ.plot_3D(hax(1));
      hax(2) = subplot(2,2,2);  wheel_OBJ.plot_XY(hax(2));  
      hax(3) = subplot(2,2,3);  wheel_OBJ.plot_XZ(hax(3));  
      hax(4) = subplot(2,2,4);  wheel_OBJ.plot_YZ(hax(4));  

%% Example #2:  Define the ACTIVE rotation sequence and ANIMATE
% We'd like to subject the vehicle to a series of rotations applied to
% a body fixed co-ordinate frame attached to the vehicle.
%
% Assume that we apply these 3 successive rotations in the following order:
%
% # R1Z occurs 1st about the LOCAL *Z* body axis $(\phi)$, aka *YAW*
% # R2Y occurs 2nd about the LOCAL *Y* body axis $(\theta)$, aka *PITCH*
% # R3X occurs 3rd about the LOCAL *X* body axis $(\theta)$, aka *ROLL*

degs_roll = 0;
degs_yaw  = 360; %90; 
degs_pitch= 0; %70;

arot_OBJ  = bh_rot_active_B2G_CLS({'D1Z', 'D2Y', 'D3X'}, ...
                                  [degs_yaw, degs_pitch, degs_roll], ...
                                  'DEGREES');

       
% create the wheel
wheel_OBJ = bh_wheel_toy_CLS(0.3, 0.1);

% Let's ANIMATE
figure();
hax = axes;

veh_OBJ = wheel_OBJ.rotate_and_animate(arot_OBJ, hax);

desc_str = arot_OBJ.get_description();
title(hax, desc_str);
