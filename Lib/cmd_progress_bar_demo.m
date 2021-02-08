clear;clc;
reverseStr = '';
NUM = 20;
file = 'log.txt';
fid = fopen(file, 'w');
for idx = 1 : NUM
    % Do some computation here...
    pause(0.05);
    % Display the progress
    % percentDone = 100 * idx / 15;
    % msg = ['Calculating: |', repmat('=', 1, idx), '>',num2str(percentDone,'%3.1f'), '%%'];
    % fprintf([reverseStr, msg]);
    % 
    % reverseStr = repmat(sprintf('\b'), 1, length(msg));
    s = cmd_progress_bar('Calculating', idx, NUM);
    fprintf(fid, s);
end

NUM = 20;
for idx = 1 : NUM
    % Do some computation here...
    pause(0.05);
    % Display the progress
    % percentDone = 100 * idx / 15;
    % msg = ['Calculating: |', repmat('=', 1, idx), '>',num2str(percentDone,'%3.1f'), '%%'];
    % fprintf([reverseStr, msg]);
    % 
    % reverseStr = repmat(sprintf('\b'), 1, length(msg));
    s = cmd_progress_bar('Calculating', idx, NUM);
    fprintf(fid, s);
end

NUM = 20;
for idx = 1 : NUM
    % Do some computation here...
    pause(0.05);
    % Display the progress
    % percentDone = 100 * idx / 15;
    % msg = ['Calculating: |', repmat('=', 1, idx), '>',num2str(percentDone,'%3.1f'), '%%'];
    % fprintf([reverseStr, msg]);
    % 
    % reverseStr = repmat(sprintf('\b'), 1, length(msg));
    s = cmd_progress_bar('Calculating', idx, NUM);
    fprintf(fid, s);
end
fclose(fid);