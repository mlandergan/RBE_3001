%% Computes a running average 
% Uses a window size of 5
function out = runavg(valuesTransposed)

x = valuesTransposed(1,1);
y = valuesTransposed(1,4);
z = valuesTransposed(1,7);

% Uses a persistent variable to hold the window over multiple function
% calls
persistent history;

%Init history
if(size(history,1)==0)
    history = NaN(1,15);
end

% Make room for new value
history = circshift(history, 3);
history(1,1) = x;
history(1,2) = y;
history(1,3) = z;


xsum = sum(history(1:3:15), 'omitnan');
ysum = sum(history(2:3:15), 'omitnan');
zsum = sum(history(3:3:15), 'omitnan');

cursize = 0;
% Gets size of window so that average will compute correctly when there
% aren't 5 data points yet
for i =1:15
    if ~isnan(history(1,i))
        cursize = cursize + 1;
    end
end
% Compute average of the current window
out = [(xsum/(cursize/3)), (ysum/(cursize/3)), (zsum/(cursize/3))];
end

    