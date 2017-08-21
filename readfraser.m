% Read and combine Fraser River discharge
%
% Usage: 
%     [mtime, f] = readfraser(t_initial)
%
% Input:
%     t_initial - the beginning time
%
% Output:
%     mtime - matlabtime for ttl
%     f     - Fraser River discharge
%
% Chuning Wang
% 2015/02/11

function [mtime, f] = readfraser(t_initial)

if nargin < 1
    t_initial = datenum([1995 01 01 00 00 00]);
elseif nargin == 1
    t_initial = datenum(t_initial);
else
    error('Too many Input arguments')
end

workdir = 'data/fraserHistorical/';

f = [];

for i = 1980:2012
    fra = dlmread([workdir 'fraser' num2str(i) '.txt'],'\t',1,1);
    fra(fra == 0) = NaN;
    fra = fra(:); fra(isnan(fra)) = [];
    f = [f; fra];
end

fid = fopen([workdir 'fraser2013-14.txt']);
f1314 = textscan(fid,'%s %f','headerlines',1,'delimiter','\t');
fclose(fid);
mt1 = datenum(f1314{1},'yyyy-mm-dd HH:MM:SS');
mt2 = floor(mt1(1)):1:floor(mt1(end-1)); mt2 = mt2';
f2  = NaN(size(mt2));
for iter = 1:length(mt2)
    msk = mt1>=mt2(iter) & mt1<mt2(iter)+1;
    f2(iter) = nanmean(f1314{2}(msk));
end

f = [f; f2];

mtime = datenum([1980 01 01 00 00 00]):1:datenum([2012 12 31 00 00 00]);
mtime = mtime(:);
mtime = [mtime; mt2];

msk   = mtime>=t_initial;
f     = f(msk);
mtime = mtime(msk);

% Deal with NaNs
msk    = find(isnan(f));
f(msk) = (f(msk+1)+f(msk-1))/2;

% save('data/fraser.mat','mtime','f')

end