cakeHeight = 6;
top_height = 2.5;
logo_height = 5;
corner_heigth = 9;
holder_width = 4.5;
corner_width = 0.8;
embossed_height = 18;
cleaner_height = 20;


holder_height = 10;
scale = 0.24;

// Switch between Text and Logo
print_text_logo = false;

print_logo_stamp = false;
print_logo_stamp_guided_outline = false;
print_logo_stamp_guided = true;
print_logo_cleaner = true;
print_conrer_cutter = true;
print_logo_cutter = true;
print_support = false;

flipForPrint = false;

print_size_preview = false;
preview_w = 65;
preview_h = 65;
preview_x = 3.5;
preview_y = 3.5;

module mainSection() {};


// calculated
logo_extrude = top_height + logo_height;
corner_extrude = corner_heigth + top_height;
move_to_top_base = corner_extrude - top_height;
move_to_top_text = corner_extrude - logo_extrude;

centerOnPlate = false;
dpi = 70;
convex = 10;

logoFile = getLogoFile();
baseFile = getBaseFile();
supportFile = getSupportFile();


function getLogoFile() =
(print_text_logo ? "ITS-CC-Logo-Icon.svg" : "ITS-CC-Text-Icon.svg");
function getBaseFile() =
(print_text_logo ? "ITS-CC-Text-Base.svg" : "ITS-CC-Logo-Base.svg");
function getSupportFile() =
(print_text_logo ? "ITS-CC-Text-Support.svg" : "ITS-CC-Logo-Support.svg");


gap_cleaance = 0.3;
dough_gap = 0.5;



flipForPrint(print_conrer_cutter){
    cookie_cutter(baseFile, top_height);
}

flipForPrint(print_logo_stamp_guided_outline, 270){
    logoCutGuidedOutLine();
}

flipForPrint(print_logo_cutter, 180){
    logoCut();
}

flipForPrint(print_logo_stamp_guided, 180){
    logoCutGuided();
}

module logoCutGuided() {
    guide_height = corner_extrude - cakeHeight - dough_gap;
    translate([0, 0, moveToTop(guide_height)])
        base(guide_height, -gap_cleaance);
    logo(corner_extrude, 0);
}


module logoCutGuidedOutLine() {
    guide_height = corner_extrude - cakeHeight - dough_gap;
    difference() {
        translate([0, 0, moveToTop(guide_height)])
            base(guide_height, -gap_cleaance);
        logo(corner_extrude, 0);
    }
    border(logoFile, corner_width, corner_extrude); // logo
}

if (print_logo_cleaner) {
    if (flipForPrint) {
        translate([0, 0, corner_extrude])
            logoCleaner();
    } else {
        logoCleaner();
    }
}


module embossedLogo() {
    color("DarkBlue")
        translate([0, 0, moveToTop(embossed_height)])
            difference() {
                base(embossed_height, -gap_cleaance);
                logo(embossed_height, 0);
            }
}


function moveToTop(height) = -(height - corner_extrude);


module logoCut() {
    cookie_cutter(logoFile, logo_extrude);
}


if (print_logo_stamp)
embossedLogo();

module logoCleaner() {
    translate([0, 0, moveToTop(cleaner_height)])
        color("red")
            union() {
                logo(cleaner_height, -gap_cleaance);
                hull()
                    logo(top_height, -gap_cleaance);
            }
}

module logo(height, offsetDelta) {
    importSvg(logoFile, height, offsetDelta) ;
}

module base(height, offsetDelta) {
    importSvg(baseFile, height, offsetDelta) ;
}

if (print_support) {
    support();
}

module support() {
    color("RosyBrown")
        linear_extrude(height = top_height, center = centerOnPlate, convexity = convex)
            scale([scale, scale, scale])
                import(file = supportFile, center = centerOnPlate, dpi = dpi);
}


module border(fileName, width, height) {
    difference() {
        color("red")
            importSvg(fileName, height, width) ;
        color("green")
            importSvg(fileName, height, 0) ;
    }
}

module importSvg(fileName, height, offsetDelta) {
    linear_extrude(height = height, center = centerOnPlate, convexity = convex)
        offset(delta = offsetDelta)
            scale([scale, scale, scale])
                import(file = fileName, center = centerOnPlate, dpi = dpi);
}


module cookie_cutter(fileName, height) {
    color("DarkOrange")
        union() {
            translate([0, 0, move_to_top_base])
                border(fileName, holder_width, top_height); // holder
            border(fileName, corner_width, corner_extrude); // cutter
        }
}


if (print_size_preview) {
    translate([preview_x, -(((preview_w)) + preview_y), 0])
        size_preview();
}

module size_preview() {
    color("OrangeRed")
        linear_extrude(height = 2, center = false, convexity = convex)
            square(size = [preview_w, preview_h], center = false);
}

module flipForPrint(print, rotation = 0, flipDegree = 180) {
    if (print) {
        if (flipForPrint) {
            rotate([flipDegree, 0, rotation])
                translate([0, 0, -corner_extrude])
                    children();
        } else {
            children();
        }
    }
} 


