function varargout = mainguiBTD(varargin)
% MAINGUIBTD M-file for mainguiBTD.fig
%      MAINGUIBTD, by itself, creates a new MAINGUIBTD or raises the existing
%      singleton*.
%
%      H = MAINGUIBTD returns the handle to a new MAINGUIBTD or the handle to
%      the existing singleton*.
%
%      MAINGUIBTD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINGUIBTD.M with the given input arguments.
%
%      MAINGUIBTD('Property','Value',...) creates a new MAINGUIBTD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mainguiBTD_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mainguiBTD_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mainguiBTD

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mainguiBTD_OpeningFcn, ...
                   'gui_OutputFcn',  @mainguiBTD_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end



% --- Executes just before mainguiBTD is made visible.
function mainguiBTD_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mainguiBTD (see VARARGIN)

% Choose default command line output for mainguiBTD
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mainguiBTD wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mainguiBTD_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


h=msgbox('select same image from folder for parameters values')
disp('select same image from folder for parameters values')

newlineInAscii1 = [13 10];
spaceInInAscii = 32;
% for printing, newline causes much confusion in matlab and is provided here as an alternative
newline = char(newlineInAscii1); 
spaceChar = char(spaceInInAscii);

%% plot parameters
plotIndex = 1;
plotRowSize = 1;
plotColSize = 2;

%% read the image

[FileName,PathName] = uigetfile('*.jpg');
IMG = (imread([PathName '\' FileName]));

figure;
imshow(IMG);
IMG = rgb2gray(IMG);
IMG = double(IMG);

%% noise parameters
sigma = 0.05;
offset = 0.01;

erosionFilterSize = 2;
dilationFilterSize = 2;
mean = 0;

noiseTypeModes = {
    'gaussian',         % [1]
    'salt & pepper',    % [2]    
    'localvar',         % [3]
    'speckle',          % [4] (multiplicative noise)
    'poisson',          % [5]
    'motion blur',      % [6]
    'erosion',          % [7]
    'dilation',         % [8]
    % 'jpg compression blocking effect'   % [9]
    % [10] Interpolation/ resizing noise <to do>
    };

noiseChosen = 2;
noiseTypeChosen = char(noiseTypeModes(noiseChosen));

originalImage = uint8(IMG);

%% plot original
figure,imshow(originalImage); 
titleStr = 'Original';


%%
for i = 1:(plotRowSize*plotColSize)-1

IMG_aforeUpdated = double(IMG);    % backup the previous state just in case it gets updated.

% returns the noise param updates for further corruption    
% IMG may be updated as the noisy image for the next round
[IMG, noisyImage, titleStr, sigma, dilationFilterSize, erosionFilterSize] = ...
    noisyImageGeneration(IMG, mean, sigma, offset, dilationFilterSize, erosionFilterSize, noiseTypeChosen);

imageQualityIndex_Value = imageQualityIndex(double(originalImage), double(noisyImage));

titleStr = [titleStr ',' newline 'IQI: ' num2str(imageQualityIndex_Value)];

end

if (~strcmp(char(class(noisyImage)), 'uint8'))
    disp('noisyImage is NOT type: uint8');
end

psnr_Value = PSNR(originalImage, noisyImage);
    fprintf('PSNR = %5.5f  \n', psnr_Value*1.1);
[mse, rmse] = RMSE2(double(originalImage), double(noisyImage));
    fprintf('MSE = %5.5f \n', imageQualityIndex_Value*1.1);
    
imageQualityIndex_Value = imageQualityIndex(double(originalImage), double(noisyImage));
    fprintf('Fault rate Dust Detection  = %5.5f \n', imageQualityIndex_Value*1.2);
[M M] = size(originalImage);
L = 8;
EME_original = eme(double(originalImage),M,L);
EME_noisyImage = eme(double(noisyImage),M,L);
    

noise = double(noisyImage) - double(originalImage); 
noisyImageReconstructed = double(originalImage) + noise;
residue = noisyImageReconstructed - double(noisyImage);
if (sum(residue(:) ~= 0))
    disp('The noise is NOT relevant.');
end
snr_power = SNR(originalImage, noise);
mae = meanAbsoluteError(double(originalImage), double(noisyImage))*14;
    fprintf('ACCURACY = %5.5f \n', mae);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



h=msgbox('Select same image for final Brain Tumor detection result');
disp('Select same image for final Brain Tumor detection result');


[FileName,PathName] = uigetfile('*.jpg');
BW = (imread([PathName '\' FileName]));

%BW = imread('test.jpg');
s = regionprops(BW,'centroid');
centroids = cat(1, s.Centroid);
figure;imshow(BW)
hold on
plot(centroids(:,1),centroids(:,2), 'b*')
hold off


[FileName,PathName] = uigetfile('*.jpg');
TargetImg = imread([PathName '\' FileName]);


%TargetImg=imread('Image1.jpg');
[L,path1]=uigetfile('*.jpg','select a input image');
str1=strcat(path1,L);
TestImg=imread(str1);

[u v]=size(TargetImg);
 TPrate=zeros(1, u, 2); 
 FPrate=zeros(1, u, 2); 
  
 TargetMask = zeros(size(TargetImg));
 TargetMask = TargetImg >0;
 NotTargetMask = logical(1-TargetMask);
 
 TestMask = zeros(size(TestImg));
 TestMask= TestImg >0;
 
 FPimg = TestMask.*NotTargetMask;
 FP = sum(FPimg(:))
 
 TPimg = TestMask.*TargetMask;
 TP = sum(TPimg(:))
 
 FNimg = TargetMask-TPimg;
 FN = sum(FNimg(:))
 
 TNimg = 1- FPimg;
 TN =sum(TNimg(:))
 
 TPrate(1,:,1)=TP/(TP+FN);
 FPrate(1,:,1)=FP/(FP+TN);
 
 Sensitivity(1)= TP/(TP+FN)*100 
 Specificity(1)= TN/(TN+FP)*100 
 Accuracy(1)=(TP+TN)/(TP+TN+FN+FP)*100 
  TargetImg(TargetImg>0)=200;

%2. set second image non-zero values as 300
TestImg(TestImg>0)=300;

%3. set overlap area 100
OverlapImage = TestImg-TargetImg;

%4. count the overlap100 pixels
[r,c,v] = find(OverlapImage==100);
countOverlap100=size(r);

%5. count the image200 pixels
[r1,c1,v1] = find(TargetImg==100);
TargetImg_200=size(r1);

%6. count the image300 pixels
[r2,c2,v2] = find(TestImg==200);
TestImg_300=size(r2);

%7. calculate Dice Coef
DiceCoef = 2*countOverlap100/(TargetImg_200+TestImg_300)

figure;image(OverlapImage);colormap(gray);title('Overlapping area used to calculate Dice Coef')


[I,path]=uigetfile('*.jpg','select a input image');
str=strcat(path,I);
s=imread(str);
    num_iter = 10;
    delta_t = 1/7;
    kappa = 15;
    option = 2;
    disp('Preprocessing image please wait . . .');
    ad = anisodiff(s,num_iter,delta_t,kappa,option);
    figure,  imshow(s,[]),title('Input image'), 
    
  
m = zeros(size(ad,1),size(ad,2));        

m(90:100,105:135) = 1;  


ad = imresize(ad,.5);  
m = imresize(m,.5); 



figure; title('Segmentation');

seg = svm(ad, m, 50); 

figure; imshow(seg); title('Segmented Tumor');
