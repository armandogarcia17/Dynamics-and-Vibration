function bh_4bar_startup()
    
    %  Add some folders to the MATLAB search path
    p = mfilename('fullpath');
    [folder,name,ext] = fileparts(p);

    addpath([folder],                               '-begin');
     addpath(fullfile(folder, 'PICS_4bar_DO_NOT_DELETE'), '-begin');   

    % echo the first few elements of our search path
    sp             = path;
    TGT_SPLIT_CHAR = pathsep;
    C              = strsplit(sp, TGT_SPLIT_CHAR);
    
    fprintf('\n %s', repmat('*',1,50) );
    fprintf('\n Just added the following folders to the ');
    fprintf('\n HEAD of your search path: \n');
    fprintf('\n    ---> %s', C{1:2});
    fprintf('\n %s', repmat('*',1,50) );
    fprintf('\n ... we are finished HERE ---> %s\n',mfilename);
        
    % assert that we have a new enough version to run this demo
    % R2017a is the minimum release and corresponds to MATLAB 
    % version 9.2
    MIN_required_ML_version = '9.1';
    if(verLessThan('MATLAB',MIN_required_ML_version))
          % inform the user that he needs a NEWER release and then exit
          error('###_ERROR:  you need at least R2017a to run this demo');
    end
    
    % and if we've made it this far, then launch the Tutorial app
    bh_4bar_demo_launcher_app();
    
end
%_#########################################################################

