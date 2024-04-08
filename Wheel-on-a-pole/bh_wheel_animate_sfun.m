function bh_wheel_animate_sfun(block)
%==========================================================================
% WHEEL on a tower ANIMATION
%==========================================================================
% 
%     Dialogue PARAMETERS:
%       1.) Sample time  (secs)
%       2.) Wheel radius (m)
%       3.) Rod length   (m)
% 
%     Block INPUTS:
%       1.) YAW angle (radians)
%       2.) PITCH angle (radians)
%   
%==========================================================================

%%
%% The setup method is used to set up the basic attributes of the
%% S-function such as ports, parameters, etc. Do not add any other
%% calls to the main body of the function.
%%
setup(block);

%endfunction

%% Function: setup ===================================================
%% Abstract:
%%   Set up the basic characteristics of the S-function block such as:
%%   - Input ports
%%   - Output ports
%%   - Dialog parameters
%%   - Options
%%
%%   Required         : Yes
%%   C-Mex counterpart: mdlInitializeSizes
%%
function setup(block)

% Register number of ports
block.NumInputPorts  = 2;
block.NumOutputPorts = 0;

% Setup port properties to be inherited or dynamic
block.SetPreCompInpPortInfoToDynamic;
block.SetPreCompOutPortInfoToDynamic;

% Override input port properties
block.InputPort(1).Dimensions        = 1;
block.InputPort(1).DatatypeID  = 0;  % double
block.InputPort(1).Complexity  = 'Real';
block.InputPort(1).DirectFeedthrough = true;

block.InputPort(2).Dimensions        = 1;
block.InputPort(2).DatatypeID  = 0;  % double
block.InputPort(2).Complexity  = 'Real';
block.InputPort(2).DirectFeedthrough = true;


% Register parameters
block.NumDialogPrms     = 3;

% Register sample times
%  [0 offset]            : Continuous sample time
%  [positive_num offset] : Discrete sample time
%
%  [-1, 0]               : Inherited sample time
%  [-2, 0]               : Variable sample time
Ts = block.DialogPrm(1).Data;
block.SampleTimes = [Ts 0];

% Specify the block simStateCompliance. The allowed values are:
%    'UnknownSimState', < The default setting; warn and assume DefaultSimState
%    'DefaultSimState', < Same sim state as a built-in block
%    'HasNoSimState',   < No sim state
%    'CustomSimState',  < Has GetSimState and SetSimState methods
%    'DisallowSimState' < Error out when saving or restoring the model sim state
block.SimStateCompliance = 'DefaultSimState';

%% -----------------------------------------------------------------
%% The MATLAB S-function uses an internal registry for all
%% block methods. You should register all relevant methods
%% (optional and required) as illustrated below. You may choose
%% any suitable name for the methods and implement these methods
%% as local functions within the same file. See comments
%% provided for each function for more information.
%% -----------------------------------------------------------------

block.RegBlockMethod('PostPropagationSetup',    @DoPostPropSetup);
block.RegBlockMethod('InitializeConditions', @InitializeConditions);
block.RegBlockMethod('Start', @Start);
block.RegBlockMethod('Outputs', @Outputs);     % Required
block.RegBlockMethod('Terminate', @Terminate); % Required

%end setup

%%
%% PostPropagationSetup:
%%   Functionality    : Setup work areas and state variables. Can
%%                      also register run-time methods here
%%   Required         : No
%%   C-Mex counterpart: mdlSetWorkWidths
%%
function DoPostPropSetup(block)
block.NumDworks = 0;
  

%%
%% InitializeConditions:
%%   Functionality    : Called at the start of simulation and if it is 
%%                      present in an enabled subsystem configured to reset 
%%                      states, it will be called when the enabled subsystem
%%                      restarts execution to reset the states.
%%   Required         : No
%%   C-MEX counterpart: mdlInitializeConditions
%%
function InitializeConditions(block)

%end InitializeConditions


%%
%% Start:
%%   Functionality    : Called once at start of model execution. If you
%%                      have states that should be initialized once, this 
%%                      is the place to do it.
%%   Required         : No
%%   C-MEX counterpart: mdlStart
%%
function Start(block)
wheel_radius = block.DialogPrm(2).Data;
rod_len      = block.DialogPrm(3).Data;

%hax       = axes;
hax(1) = subplot(1,2,1);
hax(2) = subplot(1,2,2);

wheel_OBJ = bh_wheel_toy_CLS(wheel_radius, rod_len);

bh_UD_T.hax = hax;
bh_UD_T.wheel_OBJ = wheel_OBJ;

set_param(block.BlockHandle,'UserData', bh_UD_T)

%end Start

%%
%% Outputs:
%%   Functionality    : Called to generate block outputs in
%%                      simulation step
%%   Required         : Yes
%%   C-MEX counterpart: mdlOutputs
%%
function Outputs(block)

bh_UD_T = get_param(block.BlockHandle,'UserData');
hax = bh_UD_T.hax;
wheel_OBJ = bh_UD_T.wheel_OBJ;

if(~all(ishghandle(hax)))
    % have changed my mind ... don't even try to plot
    return
    
    hax(1) = subplot(1,2,1);
    hax(2) = subplot(1,2,2);
    bh_UD_T.hax = hax;
    set_param(block.BlockHandle,'UserData', bh_UD_T);
end

yaw_rad   = block.InputPort(1).Data;
pitch_rad = block.InputPort(2).Data;

arot_OBJ  = bh_rot_active_B2G_CLS({'D1Z', 'D2Y', 'D3X'}, ...
                                  [yaw_rad, pitch_rad, 0], ...
                                  'RADIANS');

%% Now apply this ACTIVE rotation sequence to the vehicle

% get each of the active rotation matrices
aR1 = arot_OBJ.get_active_R1();
aR2 = arot_OBJ.get_active_R2();
aR3 = arot_OBJ.get_active_R3();

% chain them together in the correct ACTIVE order
aR1R2R3 = aR1 * aR2 * aR3;

% get the B frame geometry data of the vehicle
[X,Y,Z] = wheel_OBJ.get_B_XYZ();
v_mat   = [ X(:), Y(:), Z(:) ]';  % a 3xN matrix

% now apply the complete ACTIVE rotation matrix to our vehicle data
new_XYZ = aR1R2R3 * v_mat;

% store this new rotated vehicle data
wheel_OBJ =  wheel_OBJ.set_G_XYZ(new_XYZ(1,:)', new_XYZ(2,:)', new_XYZ(3,:)');

% 3D plot the new rotated vehicle
wheel_OBJ.plot_3D(hax(1));

% plot the PLAN view
wheel_OBJ.plot_XY(hax(2));

% save the WHEEL object
bh_UD_T.wheel_OBJ = wheel_OBJ;

set_param(block.BlockHandle,'UserData', bh_UD_T)


%end Outputs

%%
%% Terminate:
%%   Functionality    : Called at the end of simulation for cleanup
%%   Required         : Yes
%%   C-MEX counterpart: mdlTerminate
%%
function Terminate(block)

%end Terminate

