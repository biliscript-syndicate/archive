/*17Main Akari       */
var playerState = Player.state;
if (playerState == 'playing')
    Player.pause();
	var Akari = Global._get( "__akari" );
	Akari.stop();
	//导入命名空间 + 简写
	Akari.Utilities.Factory.extend( this, Akari.Utilities );
	Akari.Utilities.Factory.extend( this, Akari.Display );
	Akari.Utilities.Factory.extend( this, Akari.Display.Text );
	Akari.Utilities.Factory.extend( this, Akari.Animation );

var TTTComp = Composition({
  width : 1280,
  height : 720,

  startTime : 0,
  duration : 909000,

  layers :
  [
  Layer({
	  source : Solid({width : 1280 ,height : 720 ,color : 0 }),
	  inPoint : 134000,
	  outPoint : 136000,
	  properties : 
	  {
		alpha : KeyframesBind(
			{
				keyframes :
				[
					Keyframe({ time : 134000, value : 0, interpolation : Interpolation.linear }),
					Keyframe({ time : 134400, value : 0.92 , interpolation : Interpolation.hold })
				]
			})
	  }
	}),
Layer({
	  source : ($G._("TTT.Shapes")).Pic["logo"],
	  inPoint : 134000,
	  outPoint : 136000,
	  properties : 
	  {
	  	scaleX : 1.4,
	  	scaleY : 1.4,
	  	x : 170,
	  	y : 150,
		alpha : KeyframesBind(
			{
				keyframes :
				[
					Keyframe({ time : 134000, value : 0, interpolation : Interpolation.linear }),
					Keyframe({ time : 134400, value : 1, interpolation : Interpolation.linear })							
				]
			})
	  }
	}),
	  Layer({
			  source : Solid({width : 1280 ,height : 720 ,color : 0xffffff }),
			  inPoint : 135600,
			  outPoint : 142000,
			  properties : 
			  {
				alpha : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 135600, value : 0, interpolation : Interpolation.linear }),
							Keyframe({ time : 136000, value : 1 , interpolation : Interpolation.hold }),
							Keyframe({ time : 141400, value : 1, interpolation : Interpolation.linear }),
							Keyframe({ time : 142000, value : 0, interpolation : Interpolation.linear })
						]
					})
			  }
			}),
Layer({
	  source : ($G._("TTT.Shapes")).Pic["p77"],
	  inPoint : 135600,
	  outPoint : 142000,
	  properties : 
	  {
		alpha : KeyframesBind(
			{
				keyframes :
				[
					Keyframe({ time : 135600, value : 0, interpolation : Interpolation.linear }),
					Keyframe({ time : 136000, value : 1 , interpolation : Interpolation.linear }),
					Keyframe({ time : 141400, value : 1, interpolation : Interpolation.linear }),
					Keyframe({ time : 142000, value : 0, interpolation : Interpolation.linear })							
				]
			})
	  }
	}),
	  Layer({
			  source : Solid({width : 1280 ,height : 720 ,color : 0xffffff }),
			  inPoint : 454000,
			  outPoint : 460000,
			  properties : 
			  {
				alpha : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 454000, value : 0, interpolation : Interpolation.linear }),
							Keyframe({ time : 454400, value : 1 , interpolation : Interpolation.hold }),
							Keyframe({ time : 459600, value : 1, interpolation : Interpolation.linear }),
							Keyframe({ time : 460000, value : 0, interpolation : Interpolation.linear })
						]
					})
			  }
			}),
Layer({
	  source : ($G._("TTT.Shapes")).Pic["p88"],
	  inPoint : 454000,
	  outPoint : 460000,
	  properties : 
	  {
		alpha : KeyframesBind(
			{
				keyframes :
				[
					Keyframe({ time : 454000, value : 0, interpolation : Interpolation.linear }),
					Keyframe({ time : 454400, value : 1 , interpolation : Interpolation.linear }),
					Keyframe({ time : 459600, value : 1, interpolation : Interpolation.linear }),
					Keyframe({ time : 460000, value : 0, interpolation : Interpolation.linear })							
				]
			})
	  }
	})
  ]
	});
var mainComp = MainComposition(
{
  width : 1280,
  height : 720,

  startTime : 0,
  duration : 909000,

  layers :
  [
	DynamicSourceLayer(
	{
	  provider : Global._( "___bw3_snw_maincomp"),
	  inPoint : 550500,
	  outPoint : 550500 + 109400
	}),
	DynamicSourceLayer(
	{
	  provider : Global._( "ED.MainComp") ,
	  inPoint : 659000,
	  outPoint : 659000 + 250000
	}),
	  	DynamicSourceLayer(
	{
	  provider : TTTComp ,
	  inPoint : 0,
	  outPoint : 909000
	})
  ]
});

Akari.execute(mainComp);

if (playerState == 'playing')
{
	Player.play();
	($G._("loading")).changeT("All Done!\n");
	($G._("loading")).remove();
	//$$.appendLog('20%...');
};