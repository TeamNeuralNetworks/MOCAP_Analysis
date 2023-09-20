function in_params_1 = merge_params_obj(in_params_1,in_params_2)
    %% Fuse in_params_2 into in_params_1
    fieldNames = fieldnames(in_params_2);
    for i = 1:size(fieldNames,1)
        in_params_1.(fieldNames{i}) = in_params_2.(fieldNames{i});
    end 
end

