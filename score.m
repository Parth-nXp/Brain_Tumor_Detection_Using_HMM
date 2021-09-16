function BC_diff_TD = score(Im,RefI,ImMask,RefIMask,starti,endi,fact)

BC_diff_TD  = zeros(endi-starti+1,1);

minval = max(min(Im(:)),min(RefI(:)));
maxval = min(max(Im(:)),max(RefI(:)));
offset=15;
xbins = (minval:fact:maxval);
for i = starti:endi,
    
    Tmp = Im(1:i,:);
    H_leftTop = hist(Tmp(ImMask(1:i,:)),xbins);
    clear Tmp;
    
    Tmp = RefI(1:i,:);
    H_rightTop = hist(Tmp(RefIMask(1:i,:)),xbins);
    clear Tmp;

    Tmp = Im(i:end,:);
    H_leftBottom = hist(Tmp(ImMask(i:end,:)),xbins);
    clear Tmp;

    Tmp = RefI(i:end,:);
    H_rightBottom = hist(Tmp(RefIMask(i:end,:)),xbins);
    clear Tmp;

    % normalize the histograms
    H_leftTop = H_leftTop / (sum(H_leftTop)+eps);
    H_rightTop = H_rightTop / (sum(H_rightTop)+eps);
    H_leftBottom = H_leftBottom / (sum(H_leftBottom)+eps);
    H_rightBottom = H_rightBottom / (sum(H_rightBottom)+eps);

    % compute BCs
    BC_Top = sum(sqrt(H_leftTop .* H_rightTop));
    BC_Bottom = sum(sqrt(H_leftBottom .* H_rightBottom));

    % compute difference of BCs
    if i<=starti+offset,
        BC_diff_TD(i-starti+1) = -BC_Bottom;
        if i==starti+offset,
            BC_diff_TD(1:i-starti+1) = BC_diff_TD(1:i-starti+1) + BC_Top;
        end
    elseif i>=endi-offset,
        if i==endi-offset,
            to_subs = BC_Bottom;
        end
        BC_diff_TD(i-starti+1) = BC_Top-to_subs;
    else
        BC_diff_TD(i-starti+1) = BC_Top-BC_Bottom;
    end
end