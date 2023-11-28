#!/bin/csh
 foreach tag (full wide narrow diff)
  convert +append seattle.$tag.jun.png newyork.$tag.jun.png moscow.$tag.jun.png out1.jun.png
  convert +append losangeles.$tag.jun.png newdelhi.$tag.jun.png manila.$tag.jun.png out2.jun.png
  convert +append mexicocity.$tag.jun.png nairobi.$tag.jun.png jakarta.$tag.jun.png out3.jun.png 
  convert -append out1.jun.png out2.jun.png out3.jun.png $tag.jun.png
  end
