function [path, cost] = ppR(rewards,I,state)
if state == 1
    path = [1];
    cost = 0;
else
    tok = find(I(state,:)==1);    % Find paths ending with intersection k
    num_tok = size(tok,2);    % number of paths ending with intersection k
    temp_reward = rewards(tok);
    temp_cost = zeros(1, num_tok);
    temp_pstate = zeros(1, num_tok);
    for i = 1:num_tok
        temp_pstate(i) = find(I(:,tok(i))==-1);
        [~, cc] = ppR(rewards,I,temp_pstate(i)); 
        temp_cost(i) = cc + temp_reward(i);
    end
    [MM, II] = min(temp_cost);
    cost = MM;
    [pp, ~] = ppR(rewards,I,temp_pstate(II));
    path = [pp state];
end
end

