function psnr_Value = PSNR(A,B)

if (size(A) ~= size(B))
   error('The size of the 2 matrix are unequal')

   psnr_Value = NaN;
   return; 
elseif (A == B)
   disp('Images are identical: PSNR has infinite value')

   psnr_Value = Inf;
   return;   
else

    maxValue = double(max(A(:)));

    mseImage = (double(A) - double(B)) .^ 2;
    [rows columns] = size(A);
    
    mse = sum(mseImage(:)) / (rows * columns);

    psnr_Value = 10 * log10( 256^2 / mse);
end


end 