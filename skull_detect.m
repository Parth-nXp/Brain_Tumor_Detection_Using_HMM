function [M,I]=skull_detect(I)

I(1:end,1)=0; I(1:end,end)=0; I(1,1:end)=0; I(end,1:end)=0;
J = imfill(I,'holes');

K = im2bw(J/max(J(:)), 0.3* graythresh(J/max(J(:))));

[L,N] = bwlabel(K);
maxa = 0; maxi=0;
for i=1:N,
    a = sum(sum(L==i));
    if a>maxa,
        maxa=a;
        maxi=i;
    end
end
L = double((L==maxi));
figure,imagesc(L),colormap(gray);axis image; drawnow;

STATS = regionprops(L,'all');
STATS.Centroid;
x0 = round(STATS.Centroid(1));
y0 = round(STATS.Centroid(2));

[h,w] = size(I);
temp = I(y0-min(y0,h-y0)+1:y0+min(y0,h-y0),x0-min(x0,w-x0)+1:x0+min(x0,w-x0));
clear I;
I = temp;
clear temp;
temp = L(y0-min(y0,h-y0)+1:y0+min(y0,h-y0),x0-min(x0,w-x0)+1:x0+min(x0,w-x0));
L = temp;
clear temp;

STATS.Orientation;
if STATS.Orientation<0,
    M = imrotate(L,-90-STATS.Orientation);
    I = imrotate(I,-90-STATS.Orientation);
else
    M = imrotate(L,90-STATS.Orientation);
    I = imrotate(I,90-STATS.Orientation);
end
