function x_ref=similarpatches(centermost_patch,wholewindow)
    l2_norm=zeros((31-7+1)*(31-7+1),1);
    count=1;
    patchsize=7;
    x_ref1=zeros(49,size(l2_norm,1));
    x_ref=zeros(49,200);
    for i=1:(31-patchsize+1) 
        for j=1:(31-patchsize+1)
            variable=wholewindow(i:(i+6),j:(j+6));
            orignal=centermost_patch(1:7,1:7);
            x_ref1(:,count)=reshape(variable,1,[])';
            size(orignal);
            size(variable);
            l2_norm(count,1) = sum(sum((orignal(:)-variable(:)).^2));
            count=count+1;
        end
    end
    [B,I] = sort(l2_norm);
    for i=1:200
        x_ref(:,i)=x_ref1(:,I(i));
    end
end

