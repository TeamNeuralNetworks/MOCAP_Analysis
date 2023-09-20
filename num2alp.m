%% Convert a numeric value to an Excel-like column identifier
% 	This function converts a numerical column value to a string of letters
%   representing Excel-like column identifiers (e.g., 'A', 'Z', 'AA', 'AZ', 'BA'...).
%
% -------------------------------------------------------------------------
%% Syntax:
% 	alphabet = num2alp(numcol)
%
% -------------------------------------------------------------------------
%% Inputs:
% 	numcol(Double):
% 		The numeric value representing the column in Excel-like numbering. 
%       The function supports numbers 1, 2, ..., 702, 703, ... up to any 
%       large number.
%
% -------------------------------------------------------------------------
%% Outputs:
% 	alphabet(Char) DATA TYPE
% 		The Excel-like column identifier, e.g., 'A', 'Z', 'AA', 'AZ', 'BA'.
%       It is a string containing one to three letters, depending on the 
%       input 'numcol'.
%
% -------------------------------------------------------------------------
%% Extra Notes:
%
% * This function is specifically designed for Excel-like column numbering 
%   where 'A' is 1, 'Z' is 26, 'AA' is 27, 'AZ' is 52, 'BA' is 53, etc.
% * The function does not handle invalid or negative input and assumes the 
%   user provides a valid positive integer.
%
% -------------------------------------------------------------------------
%% Examples:
% * Convert number 1 to 'A'
% 	alphabet = num2alp(1);  % Output is 'A'
%
% * Convert number 26 to 'Z'
% 	alphabet = num2alp(26); % Output is 'Z'
%
% * Convert number 27 to 'AA'
% 	alphabet = num2alp(27); % Output is 'AA'
%
% -------------------------------------------------------------------------
%% Author(s):
%   Antoine Valera
%
% -------------------------------------------------------------------------
%                               Notice
%
% Notice Content will be added later. Leave a blank line here.
% -------------------------------------------------------------------------
% Revision Date:
% 	19-09-2023
% -------------------------------------------------------------------------
% See also: 
%   
%
% TODO : Optional section. Future developments could include error-handling 
%        for invalid or negative input.


function alphabet = num2alp(numcol)
    %% Initialize the alphabet array and variables for first, second, and third letters
    % The 'letters' array contains all the possible letters that can be part
    % of a column name in Excel. We also initialize the variables that will hold
    % the indices of these letters.
    letters = ['Z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', ...
               'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', ...
               'X', 'Y'];
    first  = [];
    second = [];
    third  = mod(numcol, 26); % Determine the last letter based on the mod operation

    %% Calculate the first letter if numcol is greater than 702
    % If numcol is greater than 702, we need to calculate which letter will be
    % the first in the sequence.
    if numcol > 702
        first = mod(floor((numcol - 703) / 676) + 1, 26);
    end

    %% Calculate the second letter if numcol is greater than 26
    % If numcol is greater than 26, we need to calculate which letter will be
    % the second in the sequence.
    if numcol > 26
        second = mod(floor((numcol - 27) / 26) + 1, 26);
    end

    %% Generate the final output 'alphabet'
    % Using the indices 'first', 'second', and 'third', we generate the final
    % output string 'alphabet'.
    alphabet = [letters(first + 1), letters(second + 1), letters(third + 1)];
end
