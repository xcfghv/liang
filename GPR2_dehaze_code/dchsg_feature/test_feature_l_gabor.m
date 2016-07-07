function test_feature_l_gabor()
tic
im=imread('yellowmountain.jpg');
im_t=imread('yellowmountain_trans.bmp');
seg=importdata('yellowmountain_Seg3.mat');

grayimg=rgb2gray(im);
gim=im2double(grayimg);

stage = 3;             %�����˲�������
orientation = 8;
N = 32;
freq = [0.05 4];
flag = 0;
j = sqrt(-1);

im_t=double(im_t);
[h w dim]=size(im);
Newgabor=zeros(h,w,stage*orientation+14);
hsvmap=rgb2hsv(im);
Newgabor(:,:,1)=hsvmap(:,:,1)*255;
Newgabor(:,:,2)=dark_channel(im,1);
Newgabor(:,:,3)=dark_channel(im,4);
Newgabor(:,:,4)=dark_channel(im,7);
Newgabor(:,:,5)=dark_channel(im,10);
Newgabor(:,:,6)=local_max_contrast_new(im,1);
Newgabor(:,:,7)=local_max_contrast_new(im,4);
Newgabor(:,:,8)=local_max_contrast_new(im,7);
Newgabor(:,:,9)=local_max_contrast_new(im,10);
Newgabor(:,:,10)=local_max_saturation(im,1);
Newgabor(:,:,11)=local_max_saturation(im,4);
Newgabor(:,:,12)=local_max_saturation(im,7);
Newgabor(:,:,13)=local_max_saturation(im,10);

for s = 1:stage,
    for n = 1:orientation,
        [Gr,Gi] = Gabor(N,[s n],freq,[stage orientation],flag);
         Eim = filter2(Gr,gim); % Even filter result
         Oim = filter2(Gi,gim);  % Odd filter result
         Aim = sqrt(Eim.^2 + Oim.^2);  % Amplitude 
         Newgabor(:,:,(s-1)*orientation+n+13)=Aim;
    end;
end;

Newgabor(:,:,stage*orientation+14)=im_t;
Newgabor=double(Newgabor)/255;
max_vector=max(max(seg));
H_gabor=zeros(max_vector,stage*orientation+14);
for i=1:max_vector
        [rs ss vs]=find(seg==i);
        for j=1:stage*orientation+14
            H_gabor(i,j)=mean(Newgabor(sub2ind(size(Newgabor),rs,ss,vs*j)));
        end
end
save('yellowmountain_dchs14710_gabor_3.mat','H_gabor');
toc