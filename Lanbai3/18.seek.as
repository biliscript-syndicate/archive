/*18加载不成功的seek    */
if( !$G._("op_exists") || !$G._("ED.FontLast") || !$G._("ED.Shapes") || !$G._("ED.Shapes_1") || !$G._("ED.Shapes3") )
Player.seek(0);
if ( !$G._("TTT.Shapes") || !$G._("___bw3_snw_maincomp") || !$G._("isLoaded_sis1") || !$G._("isLoaded_sis2") || !$G._("isLoaded_sis3") || !$G._("isLoaded_sis4") || !$G._("isLoaded_sis5") || !$G._("isLoaded_sis6") )
Player.seek(0);

($G._("loading")).remove();