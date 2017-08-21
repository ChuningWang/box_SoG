% Get total river discharge using regression.
%
% The total river discharge is regressed with 2 major rivers: Fraser River
% and Englishman River.
%
% F_total = a*F_fraser+b*F_englishman+c;
%
% Usage: 
%     [mt,ttl, b] = get_river(t_initial)
%
% Input:
%     t_initial - the beginning time of regression
%
% Output:
%     mt  - matlabtime for ttl
%     ttl - total river discharge
%     b   - regression coefficients
%
% Chuning Wang
% 2015/02/11

function [mt,ttl, b] = get_river(t_initial)

if nargin < 1
    t_initial = datenum([1995 01 01 00 00 00]);
elseif nargin == 1
    t_initial = datenum(t_initial);
else
    error('Too many Input arguments')
end

%% Scale Fraser and Englishman River discharge to the total flux into SoG
% IMPORTANT - this whole section is no longer needed. The regression is
% already done, and the results is documented in detail in Appendix B of my
% thesis.

% [mt_frs, frs] = readfraser([1980 01 01 00 00 00]);
% [mt_eng, eng] = readenglishman([1980 01 01 00 00 00]);
% % Here I use a 14 day filter to smooth englishman river discharge to remove
% % those crazy 'spikes' in the series.
% 
% eng = smooth(eng,14);
% 
% % All other rivers (watersheds), monthly
% rivers.runoff = load('/ocean/cnwang/ferry/data/others/river_all.txt'); % km^3
% rivers.name = {'Bute','Caamano','EVI_N','EVI_S','Fraser','Hakai',...
%                'Howe','JdF','Jervis','Knight','Nass','Puget','HG_Dixon',...
%                'HG_East','HG_West','Skagit','Skeena','Stikine','Toba',...
%                'WC','WVI','Columbia'};
% % river run into SoG:
% % rivers.SoG = [4, 5, 7, 9, 12, 16, 19]; % Including Skagit & Puget
% rivers.SoG = [4, 5, 7, 9, 19]; % Without Skagit & Puget
% 
% % rivers.name(rivers.SoG)
% 
% %% Monthly Average
% 
% kk = 0;
% frs_m = NaN(372,1);
% eng_m = NaN(372,1);
% tt = NaN(372,1);
% 
% for i = 1980:2010
%     for j = 1:12
%         kk = kk+1;
%         msk = mt_frs>datenum([i j 01 00 00 00]) & mt_frs<datenum([i j+1 01 00 00 00]);
%         frs_m(kk) = mean(frs(msk));
%         eng_m(kk) = mean(eng(msk));
%         tt(kk) = datenum([i j 01 00 00 00]);
%     end
% end
% 
% ttl_m = sum(rivers.runoff(rivers.SoG,:)); % km^3
% 
% m2d = [31 28 31 30 31 30 31 31 30 31 30 31];
% 
% ttl_m = ttl_m*1000^3./(repmat(m2d,1,31)*24*60*60);
% 
% b = regress(ttl_m',[frs_m,eng_m,ones(size(eng_m))]); % Regression
% 
% % save river_regress
% 

%% Use regression to generate a time series of total flux into SoG

[mt_frs, frs] = readfraser(t_initial);
[~,      eng] = readenglishman(t_initial);

% Here I use a 14 day filter to smooth englishman river discharge to remove
% those crazy 'spikes' in the series.

eng = smooth(eng,14);

% Use regression to get total flux
b = [1.11, 18.80, 1651.7];
ttl = [frs,eng,ones(size(frs))]*b';
mt = mt_frs;

end




