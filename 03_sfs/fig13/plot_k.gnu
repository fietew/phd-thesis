plot 'alpha_'.ARG1.'.dat' binary matrix with image,\
  'k_'.ARG1.'.txt' u ($1-$4*0.5*vlen):($2-$5*0.5*vlen):($4*vlen):($5*vlen) with vectors head size 0.1,20,60 ls 101,\
  'array.txt' @array_continuous
