set terminal wxt size 1500, 500 enhanced font 'Verdana,15' persist  
# here you specify the figure size (100, 500), and the font size is 15

set multiplot layout 1,2  
# how do you want your figure to look!
set title ""
set style line 1 lc rgb '#8b1a0e' pt 6 ps 1 lt 1 lw 2    
set key bottom right
set grid
# now plot
plot "./testData.txt" u 1:2 t '' w lp ls 1

binwidth=5
bin(x,width)=width*floor(x/width)


set style data histograms
unset key
binwidth = 0.001
bin(x,width) = width*floor(x/width)
set style fill transparent solid 0.7 border -1
plot './testData.txt' using 3:(1) smooth freq with boxes lc rgb '#348AB#348ABDtle



unset multiplot
