function [IMG, noisyImage, titleStr, sigmaUpdated, dilationFilterSizeUpdated, erosionFilterSizeUpdated] = ...
    noisyImageGeneration(IMG, mean, sigma, offset, dilationFilterSize, erosionFilterSize, noiseType)

newlineInAscii1 = [13 10];
spaceInInAscii = 32;
newline = char(newlineInAscii1); 
spaceChar = char(spaceInInAscii);

noiseTypeModes = {
    'gaussian',
    'salt & pepper',    
    'localvar',
    'speckle',
    'poisson',
    'motion blur',
    'erosion',
    'dilation',
    'jpg compression blocking effect'
    };

switch (lower(noiseType))
    case char(noiseTypeModes(1))
noisyImage = imnoise(uint8(IMG),'gaussian', mean, sigma);
titleStr = ['Noisy image using Gaussian white noise', newline, 'with sigma =',num2str(sigma)];            
sigma = sigma + offset;   

    case char(noiseTypeModes(2))
noisyImage = imnoise(uint8(IMG), 'salt & pepper', sigma);
titleStr = ['Noisy image using Salt & Pepper noise', newline, 'with sigma =',num2str(sigma)]; 
sigma = sigma + offset;    

    case char(noiseTypeModes(3))    
imageMask = abs(sigma*randn(size(IMG))); % non-negative    
titleStr = ['Noisy image using Gaussian white noise ', newline, '(with noise mask) sigma =',num2str(sigma)]; 
noisyImage  = imnoise(uint8(IMG), 'localvar', imageMask);
sigma = sigma + offset;  

    case char(noiseTypeModes(4))
noisyImage  = imnoise(uint8(IMG), 'speckle', sigma);
titleStr = ['Noisy Image using multiplicative noise', newline, 'with sigma = ', num2str(sigma)];
sigma = sigma + offset;  

    case char(noiseTypeModes(5))
noisyImage  = imnoise(uint8(IMG), 'poisson');   
titleStr = ['Noisy Image using poisson'];
IMG = noisyImage;

    case char(noiseTypeModes(6))
PSF = fspecial('motion', 500*sigma, (500*sigma)-5); 
noisyImage = imfilter(IMG, PSF, 'symmetric','conv'); % 'conv', 'circular');
titleStr = ['Noisy Image using motion noise', newline, 'with sigma = ', num2str(sigma)];
sigma = sigma + offset; 

    case char(noiseTypeModes(7))  
erosionFilter = ones(erosionFilterSize, erosionFilterSize);
noisyImage = imerode(IMG, erosionFilter);
titleStr = ['Noisy image using Erosion with filter', newline, 'size =',num2str(erosionFilterSize)];
erosionFilterSize = erosionFilterSize + 1;

    case char(noiseTypeModes(8))
dilationFilter = ones(dilationFilterSize, dilationFilterSize);
noisyImage = imerode(IMG, dilationFilter);
titleStr = ['Noisy image using Dilation with filter', newline, 'size =',num2str(dilationFilterSize)];
dilationFilterSize = dilationFilterSize + 1;

    case char(noiseTypeModes(9))
       dilationFilterSize = 9;
outputFolder = 'outputFiles';
outputFileTarget = 'tmp.jpg';
mkdir(outputFolder);
outputFileTarget = strcat(outputFolder, '\', outputFileTarget);
imwrite(IMG/255, outputFileTarget, 'quality', dilationFilterSize);
noisyImage = double(imread(outputFileTarget));
titleStr = ['Noisy image using jpg compression blocking effect,', newline, 'blocking factor =',num2str(dilationFilterSize)];
IMG = noisyImage;
delete(outputFileTarget);


end % END of noise type choice

sigmaUpdated = sigma;
dilationFilterSizeUpdated = dilationFilterSize;
erosionFilterSizeUpdated = erosionFilterSize;

end

