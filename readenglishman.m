% Read and combine Englishman River discharge
%
% Usage: 
%     [mtime, e] = readenglishman(t_initial)
%
% Input:
%     t_initial - the beginning time
%
% Output:
%     mtime - matlabtime for ttl
%     e     - Englishman River discharge
%
% Chuning Wang
% 2015/02/11

function [mtime, e] = readenglishman(t_initial)

if nargin < 1
    t_initial = datenum([1995 01 01 00 00 00]);
elseif nargin == 1
    t_initial = datenum(t_initial);
else
    error('Too many Input arguments')
end

workdir = 'data/englishmanHistorical/';

e = [];

for i = 1980:2012
    eng = dlmread([workdir 'eng' num2str(i) '.txt'],'\t',1,1);
    eng(eng == 0) = NaN;
    eng = eng(:); eng(isnan(eng)) = [];
    e = [e; eng];
end

fid = fopen([workdir 'eng2013-14.txt']);
e1314 = textscan(fid,'%s %f','headerlines',1,'delimiter','\t');
fclose(fid);
mt1 = datenum(e1314{1},'yyyy-mm-dd HH:MM:SS');
mt2 = floor(mt1(1)):1:floor(mt1(end-1)); mt2 = mt2';
e2  = NaN(size(mt2));
for iter = 1:length(mt2)
    msk = mt1>=mt2(iter) & mt1<mt2(iter)+1;
    e2(iter) = nanmean(e1314{2}(msk));
end

e = [e; e2];

mtime = datenum([1980 01 01 00 00 00]):1:datenum([2012 12 31 00 00 00]);
mtime = mtime(:);
mtime = [mtime; mt2];

msk   = mtime>=t_initial;
e     = e(msk);
mtime = mtime(msk);

% Deal with NaNs
msk    = find(isnan(e));
e(msk) = (e(msk+1)+e(msk-1))/2;

% save('data/englishman.mat','mtime','f')

end