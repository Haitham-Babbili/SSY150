clc, close all, clear all
N=5;
A=randint(N,N,[2,10]) %N-by-N, random array of integers
% % -----------------------------------------
Z=zigzag2dto1d(A)   % zig-zag
B=dezigzag1dto2d(Z) % de zig-zag
% % --------------------------------------------
isequal(A,B)

% % This program or any other program(s) supplied with it do not provide
% % any warranty direct or implied. This program is free to use for
% % non-commerical purpose only. For any other usage contact with author.
% % Kindly reference the author.
% % Thanking you.
% % @ Copyright M Khan
% % Email: mak2000sw@yahoo.com 
% % http://www.geocities.com/mak2000sw/
