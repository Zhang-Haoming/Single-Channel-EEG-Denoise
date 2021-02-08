function [s] = cmd_progress_bar(front_text, current_index, max_index)
%CMD_PROGRESS_BAR Summary of this function goes here
%   Detailed explanation goes here
    total_bar_num = 20;
    if(max_index <= total_bar_num)
        rep_num = round(total_bar_num/max_index);
        bar_text = repmat('=',1,rep_num);
        bar_flag = 1;
    else
        bar_text = '=';
        bar_flag = ceil(max_index/total_bar_num);
    end
    
    percent_done = 100 * current_index / max_index;
    previous_percent_done = 100 * (current_index-1) / max_index;
    previous_perc_msg = ['>',num2str(previous_percent_done,'%3.1f'), '%%'];
    perc_msg = ['>',num2str(percent_done,'%3.1f'), '%%'];
    s_previous_perc_msg = sprintf(previous_perc_msg);
    backspace_len = length(s_previous_perc_msg);
    backspace_matrix = repmat(sprintf('\b'), 1, backspace_len);

    if(current_index == 1)
        s = [front_text,': |', perc_msg];
        fprintf(s);
    elseif(current_index > 1 && current_index < max_index)
        if(rem(current_index, bar_flag) == 0)
            s = [backspace_matrix, bar_text, perc_msg];
            fprintf(s);
        else
            s = [backspace_matrix, perc_msg];
            fprintf(s);
        end
    else
        if(rem(current_index, bar_flag) == 0)
            s = [backspace_matrix, bar_text, perc_msg, '\n'];
            fprintf(s);
        else
            s = [backspace_matrix, perc_msg, '\n'];
            fprintf(s);
        end
    end
end

