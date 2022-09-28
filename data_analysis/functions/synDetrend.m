function [params,synFun,full_model] = synDetrend(f,P,nPeaks,fitType,startPointsFile)
    if(nargin<3)
        nPeaks = 3;
    elseif(~isnumeric(nPeaks) || nPeaks>4)
        error('nPeaks must be an integer less than 3')
    end
    if(nargin<4)
        fitType = 'exp2';
    elseif(~strcmp(fitType,'exp2') && ~strcmp(fitType,'lorenz'))
        error('fitType must be either ''exp2'' or ''lorenz''')
    end
    if(nargin<5)
        startPointsFile = 'x';
    end
    myPath = strrep(fileparts(mfilename('fullpath')),'\','/');
    fileName = 'temp';
    file0 = strrep(fullfile(myPath,[fileName '.csv']),'\','/');
    pyFunction = fullfile(myPath,'detrending.py');
    f = f(:);
    if(size(P,1)==1)
        P = P(:);
    end
    csvwrite(file0,[f,P]);
    cmd = ['python ' pyFunction ' ' file0 ' ' fitType ' ' int2str(nPeaks) ' ' startPointsFile];
    [err,file] = system(cmd);
    if(err)
        error(file)
    end
    params = csvread(file);
    [full_model,synFun] = fittingmodel(fitType);
end
