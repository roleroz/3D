SortingBox_Base_Width = 405;
SortingBox_Base_Depth = 305;
SortingBox_Base_Height = 40;
SortingBox_Hinge_StartHeight = 5;
SortingBox_Hinge_Height = 40;
SortingBox_Hinge_Width = 45;
SortingBox_Hinge_Depth = 16;
SortingBox_Hinge_DistanceFromBorder = 23;
SortingBox_Top_ExtraWidth = 8;
SortingBox_Top_ExtraDepth = 11;
SortingBox_Top_Height = 15;
SortingBox_Top_Width = SortingBox_Base_Width + 2 * SortingBox_Top_ExtraWidth;
SortingBox_Top_Depth = SortingBox_Base_Depth + 2 * SortingBox_Top_ExtraDepth;

module _SortingBoxHinge(XPosition) {
  translate([XPosition, 0, SortingBox_Hinge_StartHeight]) {
    cube([SortingBox_Hinge_Width,
          SortingBox_Hinge_Depth,
          SortingBox_Hinge_Height]);
  }
}

module SortingBox() {
  translate([-SortingBox_Top_ExtraWidth, 0, 0]) {
    cube([SortingBox_Top_Width, SortingBox_Top_Depth, SortingBox_Top_Height]);
    translate([SortingBox_Top_ExtraWidth,
               SortingBox_Top_ExtraDepth,
               -SortingBox_Base_Height]) {
      cube([SortingBox_Base_Width,
            SortingBox_Base_Depth,
            SortingBox_Base_Height]);
      translate([0, SortingBox_Base_Depth, 0]) {
        _SortingBoxHinge(SortingBox_Hinge_DistanceFromBorder);
        _SortingBoxHinge((SortingBox_Base_Width - SortingBox_Hinge_Width) / 2);
        _SortingBoxHinge(SortingBox_Base_Width -
                             SortingBox_Hinge_DistanceFromBorder -
                             SortingBox_Hinge_Width);
      }
    }
  }
}

