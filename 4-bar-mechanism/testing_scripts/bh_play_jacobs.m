clear my_numeric

my_numeric.L1 = 0.4;
my_numeric.L2 = 1;
my_numeric.L3 = 0.4;
my_numeric.L4 = 1;
my_numeric.theta_rad = pi/6;
%Let's plot the machine - NOTE the 2 possible machine configurations, 
%which correspond to the  and  roots discussed earlier.
OBJ_kin = bh_4bar_kin_CLS(my_numeric.L1, my_numeric.L2, ...
                          my_numeric.L3, my_numeric.L4, my_numeric.theta_rad);
OBJ_kin.plot();

%Extract the link angles - we'll use the configuration where the 
% initial value of PHI is positive
[phi_rad, alpha_rad] = OBJ_kin.get_phi_alpha(my_numeric.theta_rad)

% set up a list to process
theta_deg_list = 30:1:360;
theta_rad_list = deg2rad(theta_deg_list);
phi_rad_list   = zeros(size(theta_rad_list));
alpha_rad_list = zeros(size(theta_rad_list));

N_steps = length(theta_rad_list) - 1;

phi_rad_list(1)   = theta_rad_list(1);  %phi_rad;
alpha_rad_list(1) = 0; %alpha_rad;


for kk=1:N_steps
   theta_start =  theta_rad_list(kk);
   theta_end   =  theta_rad_list(kk+1);
   delta_theta = theta_end - theta_start;
   
   
   the_theta = theta_rad_list(kk);
   the_phi   = phi_rad_list(kk);
   the_alpha = alpha_rad_list(kk);
   
   [E_dphi_dtheta, E_dalpha_dtheta] = ...
       calc_phi_alpha_jacobs(my_numeric.L1,my_numeric.L2,my_numeric.L3, ...
                             the_theta, the_phi, the_alpha);
    
   phi_rad_list(kk+1)   = phi_rad_list(kk) + E_dphi_dtheta*delta_theta;
   alpha_rad_list(kk+1) = alpha_rad_list(kk) + E_dalpha_dtheta*delta_theta;
    
end

figure;
subplot(2,1,1);  plot(   rad2deg(alpha_rad_list), '-r'  );
subplot(2,1,2);  plot(   rad2deg(phi_rad_list),   '-b'  );