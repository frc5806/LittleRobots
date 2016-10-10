module InterlockingPlate(width, height, botT, topT, leftT, rightT, bottomOffset=0) {
	numBT = width*2;
	numLR = height*2;
	difference() {
		square([width,height]);

		if(bottomOffset == 0) for(i=[width*botT/numBT:width*2/numBT:width-.01]) translate([i,-0.01,0]) square([width/numBT-kerf,thickness-kerf_2+.01]);
		else for(i=[width*botT/numBT:width*2/numBT:width-.01]) translate([i,bottomOffset+kerf_2,0]) square([width/numBT-kerf,thickness-kerf+.01]);
		for(i=[width*topT/numBT:width*2/numBT:width-.01]) translate([i,height-thickness+kerf_2,0]) square([width/numBT-kerf,thickness+.01]);
		for(i=[height*leftT/numLR:height*2/numLR:height-.01]) translate([-0.01,i,0]) square([thickness+.01-kerf_2,height/numLR-kerf]);
		for(i=[height*rightT/numLR:height*2/numLR:height-.01]) translate([width-thickness+kerf_2,i,0]) square([thickness+.01,height/numLR-kerf]);
	}
}
