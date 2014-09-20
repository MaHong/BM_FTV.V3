function output = movie_series
    %1-趋近刺激类型 1,2,3
    %2-change 0,1
    %3-记忆项个数 4
    code_series = {'104','114','204','214','304','314'};
    code_series = repmat(code_series,1,32);
    output = GenerateSequence(code_series,48);
end