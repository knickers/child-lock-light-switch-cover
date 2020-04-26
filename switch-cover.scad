FN = 48;  // 48, 96
TL = 0.3; // Tolerance
KH = 20;  // Knob Height
CH = 2;   // Chamfer
H = 67;   // Box inside height
W = 35;   // Box inside width
S = 100;  // Screw distance
WALL = 3;   // Wall Thickness

module flexiCut() {
	h = KH + 2;
	r = (W + WALL) / 2;
	a = 25; // Angle for quadrant 3
	b = 5; // Angle for notch cutters
	translate([0, 0, -1])
	union() {
		difference() {
			// Outer
			cylinder(r=r-WALL, h=h, $fn=FN);

			// Inner
			cylinder(r=r-WALL-WALL, h=h*2+1, $fn=FN, center=true);

			translate([0, 0, -1]) {
				// Cut off quadrant 1
				rotate([0, 0, b]) cube([r, r, h+2]);
				// Cut off quadrant 2
				rotate([0, 0, 89]) cube([r, r, h+2]);
				// Cut off some quadrant 3
				rotate([0, 0, 90+a]) cube([r, r, h+2]);
			}

			// Right rounder
			rotate([0, 0, b])
				translate([r-WALL-WALL/2, -WALL/2, -1])
					difference() {
						translate([-WALL, 0, -2])
							cube([WALL, WALL, h+4]);
						cylinder(r=WALL/2, h=h+2, $fn=FN/3);
					}
		};

		// Left rounder
		rotate([0,0,a])
			translate([-r+WALL+WALL/2, 0, 0])
				cylinder(r=WALL/2, h=h, $fn=FN/3);

		// Upper right notch cutter
		rotate([0, 0, b])
			translate([r-WALL-WALL, -WALL, 0]) {
				translate([WALL/2, 0, 0])
					cube([WALL*2, WALL, h]); // Horizontal line
				difference() { // Upper right quarter pipe
					translate([WALL*1.5, 0, 0])
						cube([WALL, WALL*1.5, h]);
					translate([WALL*3/2, WALL*1.5, -1])
						cylinder(r=WALL/2, h=h+2, $fn=FN/3);
				}
			}

		// Striaght right notch cutter
		/*
		translate([r-WALL-WALL/2, -WALL/2, 0])
			cube([WALL*2, WALL, h]);
		*/

		// Lower right notch cutter
		rotate([0, 0, -b])
			translate([r-WALL-WALL, 0, 0])
				difference() {
					translate([WALL/2, -WALL/2, 0])
						cube([WALL*2, WALL, h]);
					translate([WALL*3/2, -WALL/2, -1])
						cylinder(r=WALL/2, h=h+2, $fn=FN/3);
				}

		/*
		rotate([0, 0, -10])
			translate([r-WALL/2, 0, 0])
				difference() {
					translate([0, 0, KH/2])
						cube([WALL*2, WALL*2, KH], center=true);
					translate([0, -WALL-1, KH/2])
						cube([WALL*2+1, WALL*2+2, KH+2], center=true);
					cylinder(r=WALL/2, h=KH+1, $fn=FN/3);
				}
		*/
	}
}

module knob() {
	r = (W + WALL)/ 2;
	backCutAngle = 30;

	difference() {
		// Outer surface
		cylinder(r=r, h=KH, $fn=FN);

		// Chamfer
		/*
		translate([0, 0, KH - CH])
			difference() {
				// Main
				cylinder(r=r, h=CH, $fn=FN);

				// Inner
				cylinder(r=r-CH, h=CH*2, $fn=FN);

				// Curve
				torus(ri=CH, ro=r-CH, $fni=FN/4, $fno=FN);
			};
		*/

		// Flexible cutouts
		flexiCut();

		rotate([0,0,180])
			flexiCut();
	}
}
/*
flexiCut();
*/
knob();
