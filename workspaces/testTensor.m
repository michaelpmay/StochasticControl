clear all
addpath classes/tensorpackage/
a=[1,2,3;4,5,6;7,8,9];
A=(a)
B(:,:,1)=a;
B(:,:,2)=a;
B(:,:,3)=a;
C(:,:,:,1)=B;
C(:,:,:,2)=B;
A=Tensor(A);
B=Tensor(B);
C=Tensor(C);
AB=B.outer(C);
M=A.multiply(A,[2],[1]);
M.getElements;