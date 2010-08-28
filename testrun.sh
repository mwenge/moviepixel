  cd ~/stuff/Movie-Metapixel/metapixel-1.0.2;
  for ((cnt=10000; cnt < 30000 ; cnt+=100))
  do
    imgtmp=000000000${cnt}
    imgstring=${imgtmp:(-9)}
    echo $imgstring
    ./metapixel --metapixel --width=25 --height=12 --frames=100 --distance=5 \
    --moviemode --search=global \
    ../Images/imagesfullsize/output-$imgstring.jpg testout.png --library \
    ../Images/images-metapixellib-25x12
  done


#rename
  ((cnt=0));for file in `ls`;
  do
    ((cnt+=1))
    imgtmp=000000000${cnt}
    imgstring=${imgtmp:(-9)}
    mv $file output-$imgstring.png
  done
