#!/bin/csh
 foreach tag (full wide narrow diff)
  convert +append seattle.$tag.png newyork.$tag.png moscow.$tag.png out1.png
  convert +append losangeles.$tag.png newdelhi.$tag.png manila.$tag.png out2.png
  convert +append mexicocity.$tag.png nairobi.$tag.png jakarta.$tag.png out3.png 
  convert -append out1.png out2.png out3.png $tag.png
  end
