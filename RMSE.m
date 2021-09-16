function err = RMSE(signal1, signal2)

err = sum((signal1 - signal2).^2)/length(signal1);  
err = sqrt(err);                                    

end

