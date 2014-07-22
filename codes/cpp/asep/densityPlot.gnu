set terminal wxt size 1000, 500 enhanced font 'Verdana,15' persist  
# here you specify the figure size (100, 500), and the font size is 15

# how do you want your figure to look!
set title "ASEP: Plot of density with lattice site"
set style line 1 lc rgb '#8b1a0e' pt 6 ps 1 lt 1 lw 2    
set key bottom right
set xlabel "Lattice site"
set ylabel "Density (x)"
set grid
# now plot
plot "./testData.txt" u 1:2 t 'density on the site' w lp ls 1
