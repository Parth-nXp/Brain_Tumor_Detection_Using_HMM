


function [from, to]= find_largest_decreasing_segment(score,scale)

hf_scale=round(scale/2);

ext_score = [ones(hf_scale,1)*score(1); score(:); ones(hf_scale,1)*score(end)];
N = length(score);
reg_minmax = zeros(N,1); 

for n=1:N,
    if min(ext_score(n:n+2*hf_scale))==score(n),
        reg_minmax(n)=-1;
    elseif max(ext_score(n:n+2*hf_scale))==score(n),
        reg_minmax(n)=1;
    end
end

n=1;
count = 0;
while n <N-1;
    while reg_minmax(n)<1 && n<N-1,
        n = n + 1;
    end
    m=n;
    n = n+1;
    while reg_minmax(n)==0 && n<N,
        n=n+1;
    end
    if reg_minmax(n)==-1
        count = count + 1;
        thisarea(count) = 0.5*(score(m)-score(n))*(n-m);
        from(count)=m;
        to(count)=n;
    end
end
[thisarea,ind] = sort(thisarea,'descend');
from(:) = from(ind);
to(:) = to(ind);