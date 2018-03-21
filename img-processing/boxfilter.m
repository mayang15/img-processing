function rect_f = boxfilter(rect)
[row, col] = size(rect);
rect_f = zeros(row, col);
for x = 1:row
    for y = 1:col
        if (x-1>0) && (x+1<row) && (y-1>0) &&(y+1<col)
            rect_f(x,y) = (rect(x,y) + rect(x-1,y) + rect(x+1,y) + rect(x,y-1) + rect(x,y+1)) / 5;
        else
            rect_f(x,y) = rect(x,y);
        end            
    end
end
end