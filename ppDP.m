function [path, cost] = ppDP(rewards,I,state,finalstate)
if state == finalstate
    path = [finalstate];
    cost = 0;
else
    fromk = find(I(state,:)==-1);    % Find paths starting with intersection state
    num_fromk = size(fromk,2);       % number of paths starting with intersection k
    temp_reward = rewards(fromk);
    temp_cost = zeros(1, num_fromk);
    temp_nstate = zeros(1, num_fromk);
    for i = 1:num_fromk
        temp_nstate(i) = find(I(:,fromk(i))==1);
        [~, cc] = ppDP(rewards,I,temp_nstate(i),finalstate); 
        temp_cost(i) = cc + temp_reward(i);
    end
    [MM, II] = min(temp_cost);
    cost = MM;
    [pp, ~] = ppDP(rewards,I,temp_nstate(II),finalstate);
    path = [state pp];
end
end

