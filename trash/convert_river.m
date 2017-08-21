clc; clear; close all
data = csvread('data/river_all.csv', 1, 1);
river = zeros(41*12, 22);
for i=1:41
    for j=1:22
        river(12*(i-1)+1:12*(i-1)+12, j) = data(22*(i-1)+j, 3:end)*data(22*(i-1)+j, 2);
    end
end
