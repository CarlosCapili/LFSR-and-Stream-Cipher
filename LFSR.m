close all;
clear;
clc;
format bank

% -- Initial Parameters -- %
bit = 22; % Number of bits in the LFSR
period = (2^bit) - 1;
numofbytes = floor(period/8);

% -- Operational Parameters -- %
% create a row vector of 22 representing the various bits in LFSR [S0, S1, S2..., S20, S21]
S = zeros(1, bit);
S(1,1) = 1;
S_initial = S;
DATA_OUT = [];
period_practical = 0
% -- LFSR Random Number Generation -- %
while true
    % store the important values of bit 1 and bit 21 and 22 for XOR
    b1_initial = S(1, 1); % value being moved out
    b22_initial = S(1, bit); % value of 22 before passing through XOR

    % shift all bits left
    S(1,1:bit-1) = S(1,2:bit);

    % perform XOR operations manually
    S(1,bit) = b1_initial;
    S(1,bit-1) = xor(b1_initial, b22_initial);

    % append b1_initial (output) to vector DATA_OUT
    DATA_OUT(end+1) = b1_initial;
    
    % This will calculate the period of the LFSR 
    period_practical = period_practical + 1;
    
    if (S == S_initial)
        fprintf("We are done - state vector S = S_initial \n");
        break;
    end
end

% Append these integers to an external file
DATA_OUT = transpose(DATA_OUT);
fid = fopen("my_random_numbers.txt", "w");

[Row,Col] = size(DATA_OUT);
byte = [];
final_final = [];
count = 1;
for ax = 1:Row
    byte(end+1) = DATA_OUT(ax);
    mod8 = mod(ax, 8);

    if mod8 == 0
        if count == 16
            fprintf(fid, '\n');
            count = 0;
        end
        fprintf(fid,"%3g, ", bin2dec(sprintf('%d', byte)));
        final_final(end+1) = bin2dec(sprintf('%d', byte));
        count = count + 1;
        byte = [];
    end
end

% -- Consecutive 0-runs -- %
DATA_OUT0 = transpose(DATA_OUT);
DATA_OUT0 = sprintf('%d',DATA_OUT0);
t1 = textscan(DATA_OUT0,'%s','delimiter','1','multipleDelimsAsOne',1); % Read consecutive 0s using 1s as delimeters to "split" array and measure resulting lengths
d = t1{:}; % Convert the resulting t1 array from a single cell array to a normal cell array
data = cellfun('length', d); % Measure the length of each run and assign the value to a data array
[number_times0 run_length0] = hist(data, [1:max(data)]); % Use the histogram function to determine the number of occurences for each length
cond_prob0 = [];
exp_prob0 = [];
for z = 1:run_length0(end)
    cond_prob0(end+1) = number_times0(z)/sum(number_times0); % Calculate conditional probability with current results
    exp_prob0(end+1) = (0.5)^run_length0(z); % Calculates theoretical probability if numbers were truly random
end


% -- Consecutive 1-runs -- %
DATA_OUT1 = transpose(DATA_OUT);
DATA_OUT1 = sprintf('%d',DATA_OUT1);
t1 = textscan(DATA_OUT1,'%s','delimiter','0','multipleDelimsAsOne',1);
d = t1{:};
data = cellfun('length', d);
[number_times1 run_length1] = hist(data, [1:max(data)]);
cond_prob1 = [];
exp_prob1 = [];
for z = 1:run_length1(end)
    cond_prob1(end+1) = number_times1(z)/sum(number_times1);
    exp_prob1(end+1) = (0.5)^run_length1(z);
end

run0table = [run_length0; number_times0; cond_prob0; exp_prob0];
run1table = [run_length1; number_times1; cond_prob1; exp_prob1];

% -- COMMENT THESE OUT BEFORE RUNNING UNLESS BIT VALUE AT THE START IS
% -- REDUCED AND YOUR COMPUTER IS FAST ENOUGH. THIS WILL TAKE SOME TIME
%{
disp('A1 answer is:')
disp(DATA_OUT)
disp('----------------')
disp('A3 answer is:')
disp('my_random_numbers.txt file in current directory OR final_final variable')
disp('----------------')
disp('A5 answer is:')
disp(run0table)
disp('----------------')
disp('A6 answer is:')
disp(run1table)
%}
% --- END -- %
