function bh_rolling_wheel_animate_sfun(block)
%==========================================================================
% ROLLING wheel ANIMATION
%==========================================================================
% 
%     Dialogue PARAMETERS:
%       1.) Sample time  (secs)
%       2.) Wheel radius (m)
%       3.) X axis display limits
%       4.) Y axis display limits
%       5.) tf_create_gif (a logical)
%
%     Block INPUTS:
%       1.) ang_vec = [phi, theta, psi] (radians)
%       2.) CG_pos  = [X,Y,Z]           (m)
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
block.InputPort(1).Dimensions        = 3;
block.InputPort(1).DatatypeID  = 0;  % double
block.InputPort(1).Complexity  = 'Real';
block.InputPort(1).DirectFeedthrough = true;

block.InputPort(2).Dimensions        = 3;
block.InputPort(2).DatatypeID  = 0;  % double
block.InputPort(2).Complexity  = 'Real';
block.InputPort(2).DirectFeedthrough = true;


% Register parameters
block.NumDialogPrms     = 5;

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
wheel_radius  = block.DialogPrm(2).Data;
my_XLIM       = block.DialogPrm(3).Data;
my_YLIM       = block.DialogPrm(4).Data;
tf_create_gif = block.DialogPrm(5).Data;

hfig = figure();
hax  = axes();

wheel_OBJ = bh_rolling_wheel_toy_CLS(wheel_radius, hax);
wheel_OBJ = wheel_OBJ.plot_birth();

bh_UD_T.wheel_OBJ = wheel_OBJ;
axis(hax, 'equal');

xlim(hax, my_XLIM);
ylim(hax, my_YLIM);
zlim(hax, [0, 2*wheel_radius]);



tmp_sys          = get_param(block.BlockHandle,'Parent')
tmp_name         = get_param(tmp_sys,"Name");
bh_UD_T.gif_name = tmp_name + ".gif";
bh_UD_T.im_CE    = {};

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
wheel_OBJ = bh_UD_T.wheel_OBJ;

if(~ishghandle(wheel_OBJ.hax))
    %  ... don't even try to plot
    return
end

angs_list   = block.InputPort(1).Data;
CG_XYZ      = block.InputPort(2).Data;

wheel_OBJ = wheel_OBJ.plot(angs_list, CG_XYZ);
drawnow;

% save the WHEEL object
bh_UD_T.wheel_OBJ = wheel_OBJ;

% should we collect images of the animation for a GIF
tf_create_gif = block.DialogPrm(5).Data;
if(  true==tf_create_gif          && ...
     length(bh_UD_T.im_CE)<1000   && ...
     ishghandle(wheel_OBJ.hax)  )
    
%         hfig                 = wheel_OBJ.hax.Parent;       
%         frame                = getframe(hfig);
        
        frame                = getframe(wheel_OBJ.hax);
        bh_UD_T.im_CE{end+1} = frame2im(frame);
end

set_param(block.BlockHandle,'UserData', bh_UD_T)

%end Outputs

%%
%% Terminate:
%%   Functionality    : Called at the end of simulation for cleanup
%%   Required         : Yes
%%   C-MEX counterpart: mdlTerminate
%%
function Terminate(block)
bh_UD_T = get_param(block.BlockHandle,'UserData');
im            = bh_UD_T.im_CE;

im = im(1:3:end);

% should we collect images of the animation for a GIF
tf_create_gif = block.DialogPrm(5).Data;
if(true==tf_create_gif)
    filename = bh_UD_T.gif_name; % Specify the output file name
    nImages = length(im);
    
    wf = waitbar(0,'Please wait...', ...
                  "Name", "Creating GIF file");
    
    
    for idx = 1:nImages
        [A,map] = rgb2ind(im{idx},256);
        if idx == 1
            %imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',0.001);
            imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',0);
        else
            imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0);
        end
        
        tmp_str = "GIF file:   " + filename;
        tmp_str = replace(tmp_str, "_", "\_");
        waitbar(idx/nImages,wf, tmp_str);
        
    end
end
%end Terminate

