clear;
clc;

% Ask for user input and then read image into a 3D matrix A
imgFile = input("Enter the name of the image you want to encrypt: ", "s");
A = imread(imgFile);

% Display original image
figure("Name", "Original Image");
clf 
image(A);

[rows,cols,depth] = size(A);

fprintf("A has rows = %d\tcols = %d\tdepth = %d\n", rows,cols,depth);

% Write numbers from my_random_numbers.txt to RAND_matrix
RAND_matrix = zeros(rows,cols,depth);

% Store txt file in 2D matrix
temp_matrix = readmatrix("my_random_numbers.txt");

% Remove the last column which is a NaN column
[temp_rows, temp_cols] = size(temp_matrix);
temp_matrix(:,temp_cols) = [];

% Variables used to navigate through temp_matrix 
current_row = 1;
current_col = 1;

% Iterate through and assign values in the RAND_matrix
for depths = 1:depth
    for row = 1:rows
        for col = 1:cols

            % If temp matrix has less columns, check for bounds and go to
            % next row and restart at column 1
            if current_col > temp_cols-1
                current_col = 1;
                current_row = current_row + 1;
            end

            RAND_matrix(row,col,depths) = temp_matrix(current_row,current_col);

            % Move to next col in temp_matrix
            current_col = current_col + 1; 

        end
    end
end

A_encrypted = zeros(rows,cols,depth);
A_decrypted = zeros(rows,cols,depth);
bit_result = zeros(1,8);

% If op = 1, encrypt A matrix
% If op = 2, decrypt A_encrypted matrix
for op = 1:2

    if op == 1
        fprintf("Encrypting Image...\n");
    else
        fprintf("Decrypting Image...\n");
    end
    
    % Iterate through each element in A, RAND, and encrypted matrix
    for d = 1:depth
        for r = 1:rows
            for c = 1:cols

                % Convert each element in RAND or encrypted matrix to decimal
                if op == 1
                    decimalA = A(r,c,d); 
                else
                    decimal_encrypt = A_encrypted(r,c,d);
                end

                decimalRAND = RAND_matrix(r,c,d);
    
                % Convert decimal to 8 bit vector
                if op == 1
                    binaryA = dec2bin(decimalA,8);
                else
                    binaryEncrypt = dec2bin(decimal_encrypt,8);
                end
               
                binaryRAND = dec2bin(decimalRAND,8);
        
                % XOR each bit 
                for bit = 1:8
                    % Convert values from string to num and before XOR them
                    % together
                    if op == 1
                        bit_result(bit) = xor(str2num(binaryA(bit)),str2num(binaryRAND(bit)));
                    else
                        bit_result(bit) = xor(str2num(binaryEncrypt(bit)),str2num(binaryRAND(bit)));
                    end
                end
                
                % Convert bit_result to a string array, then join into 1
                % string, then convert from binary to decimal
                dec_result = bin2dec(join(string(bit_result)));
    
                %fprintf("Decimal result = %d\n", dec_result);

                % Assign encrypted or decrypted decimal result in
                % respective matrix
                if op == 1
                    A_encrypted(r,c,d) = dec_result;
                else
                    A_decrypted(r,c,d) = dec_result;
                end
    
            end
        end
    end

    % Display encrypted image or decrypted image
    if op == 1
        fprintf("Encryption Complete\n\n");
        figure("Name", "Encrypted Image");
        clf;
        image(uint8(A_encrypted));
    else
        fprintf("Decryption Complete\n\n");
        figure("Name", "Decrypted Image");
        clf;
        image(uint8(A_decrypted));
    end
end

fprintf("PROGRAM FINISHED\n");





