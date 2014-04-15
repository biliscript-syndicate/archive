/*9蓝白ED主合成            
	 * by MianTang - 2013
	 *
	 * CC-3.0
	 */
/*if($G._("ED.MainComp"))
stopExecution();//只为Error1009*/
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
	var ForceMB = Akari.Display.Effects.ForceMotionBlur;
	var TrackMatte  = Akari.Display.Effects.TrackMatte ;

	var ForceMB = Akari.Display.Effects.ForceMotionBlur;
	var TrackMatte  = Akari.Display.Effects.TrackMatte ;

	var ED = {};
	ED.Shapes = $G._("ED.Shapes");
	ED.Shapes_1 = $G._("ED.Shapes_1");
	ED.FontLast = $G._("ED.FontLast");
	ED.Shapes3 = $G._("ED.Shapes3");

	ED.ShowComp = {};
	var LogoShapes = ED.Shapes.LogoShapes;

	var getRandomHex = function(){
				var cr = Math.random() * 255;
				var cg = Math.random() * 255;
				var cb = Math.random() * 255;
				return cr << 16 ^ cg  << 8 ^ cb;
			};

	/*----------------以下共有?个合成。：BGComp是背景BGComp2是把音叉的镶边单独拿了出来放在顶层遮盖用，LastWordComp是最后六句话， LogoCompEx是最后的logo动画------------*/
	ED.ShowComp.BGComp = Composition(
	{
		  width : 1280,
		  height : 720,

		  startTime : 0,
		  duration : 16000,

		  layers :
		  [ 
		  Layer(
		  {
			inPoint : 0,
			outPoint : 16000,
			source : Solid({ width : 1280, height : 720 , color : 0xcccccc })
		  }),
		  Factory.replicate( Layer, 12, function(  )
		  {
			var shp = Shape();
			shp.graphics.beginFill( getRandomHex() );
			shp.graphics.drawCircle( 0, 0, 100);
			shp.graphics.endFill();
			var randomX = Math.random() * 1280;
			var randomY = Math.random() * 720;

			return [{
			  source : shp,
			  inPoint : 0,
			  outPoint : 16000,
			  properties :
			  {
				filters : [ $.createBlurFilter(64, 64, 2) ],
				blendMode : "add",
				scaleX : Math.random() * 0.4 + 1.8,
				scaleY : Binder.Link({ name : "scaleX" }),
				x : randomX,
				y : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 0, value : randomY, interpolation : Interpolation.linear }),
				  Keyframe({ time : 3000, value : randomY + Math.random() * (Math.random() < 0.5? 700 : -700) , interpolation : Interpolation.linear }),
				  Keyframe({ time : 6000, value : randomY, interpolation : Interpolation.linear }),
				  Keyframe({ time : 9000, value : randomY + Math.random() * (Math.random() < 0.5? 700 : -700) , interpolation : Interpolation.linear }),
				  Keyframe({ time : 12000, value : randomY, interpolation : Interpolation.linear }),
				  Keyframe({ time : 16000, value : randomY + Math.random() * (Math.random() < 0.5? 700 : -700) , interpolation : Interpolation.linear }),
				]
				})
			  }
			}];
		  })
		  ]
		});

	ED.ShowComp.BGComp2 = Composition(
		{
		  width : 1280,
		  height : 720,

		  startTime : 0,
		  duration : 16000,

		  layers :
		  [ 
		Layer(
		{
			inPoint : 0,
			outPoint : 16000,
			source : function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0x23b1f3);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }()
		  }),//以下三角形滚动
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(400,180,Math.PI/6,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.5,0],[0,144],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([213,-40,-46,40,313,123,215,-41]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 0, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : -1280 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(400,180,Math.PI/6,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.5,0],[0,144],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([213,-40,-46,40,313,123,215,-41]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 1280, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : 0 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(400,180,Math.PI/6,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.5,0],[0,144],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([213,-40,-46,40,313,123,215,-41]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 2560, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : 1280 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(650,250,Math.PI/3,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.4,0],[0,255],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([75,-31,287,115,667,-50,75,-31]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 0, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : -2560 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(650,250,Math.PI/3,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.4,0],[0,255],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([75,-31,287,115,667,-50,75,-31]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 1280, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : -1280 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(650,250,Math.PI/3,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.4,0],[0,255],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([75,-31,287,115,667,-50,75,-31]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 2560, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : 0 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(650,250,Math.PI/3,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.4,0],[0,255],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([75,-31,287,115,667,-50,75,-31]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 3840, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : 1280 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(500,250,Math.PI/3*2,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.4,0],[0,255],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([533,-86,472,183,933,58,530,-86]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 0, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : -1920 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(500,250,Math.PI/3*2,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.4,0],[0,255],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([533,-86,472,183,933,58,530,-86]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 1280, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : -640 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(500,250,Math.PI/3*2,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.4,0],[0,255],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([533,-86,472,183,933,58,530,-86]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 1920, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : 0 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(500,350,Math.PI/4*3,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.4,0],[0,255],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([752,-96,876,209,959,-61,751,-97]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 0, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : -5120 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(500,350,Math.PI/4*3,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.4,0],[0,255],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([752,-96,876,209,959,-61,751,-97]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 1280, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : -3840 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(500,350,Math.PI/4*3,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.4,0],[0,255],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([752,-96,876,209,959,-61,751,-97]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 2560, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : -2560 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(500,350,Math.PI/4*3,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.4,0],[0,255],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([752,-96,876,209,959,-61,751,-97]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 3840, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : -1280 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(500,350,Math.PI/4*3,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.4,0],[0,255],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([752,-96,876,209,959,-61,751,-97]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 5120, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : 0 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(2000,200,Math.PI/4,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.5,0.3],[0,255],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([1228,-56,541,97,1261,100,1228,-55]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 0, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : -840 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(2000,200,Math.PI/4,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.5,0.3],[0,255],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([1228,-56,541,97,1261,100,1228,-55]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 1340, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : 500 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(600,250,Math.PI/4,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.5,0.1],[0,255],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2,2]),$.toNumberVector([38,-50,232,130,584,128,376,-65,41,-49]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				y : 640,
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 0, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : -1280 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(600,250,Math.PI/4,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.5,0.1],[0,255],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2,2]),$.toNumberVector([38,-50,232,130,584,128,376,-65,41,-49]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				y : 640,
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 1280, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : 0 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(800,200,-Math.PI/4,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.4,0.1],[0,255],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([-23,69,712,-12,742,101,-23,70]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				y : 640,
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 0, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : -1920 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(800,200,-Math.PI/4,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.4,0.1],[0,255],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([-23,69,712,-12,742,101,-23,70]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				y : 640,
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 1280, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : -640 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(800,200,-Math.PI/4,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.4,0.1],[0,255],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([-23,69,712,-12,742,101,-23,70]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				y : 640,
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 2560, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : 640 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(600,180,Math.PI/3,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.5,0],[0,255],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([629,127,907,-16,1111,124,629,127]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				y : 640,
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 0, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : -1440 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(600,180,Math.PI/3,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.5,0],[0,255],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([629,127,907,-16,1111,124,629,127]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				y : 640,
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 720, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : -720 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(600,180,Math.PI/3,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.5,0],[0,255],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([629,127,907,-16,1111,124,629,127]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				y : 640,
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 1440, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : 0 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(400,300,Math.PI/3*2,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.5,0],[0,255],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([971,-86,1004,169,1256,86,974,-86]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				y : 640,
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 0, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : -3840 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(400,300,Math.PI/3*2,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.5,0],[0,255],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([971,-86,1004,169,1256,86,974,-86]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				y : 640,
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 1280, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : -2560 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(400,300,Math.PI/3*2,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.5,0],[0,255],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([971,-86,1004,169,1256,86,974,-86]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				y : 640,
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 2560, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : -1280 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(400,300,Math.PI/3*2,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.5,0],[0,255],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([971,-86,1004,169,1256,86,974,-86]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				y : 640,
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 3840, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : 0 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(700,300,Math.PI/5,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.5,0],[0,255],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([1082,-87,798,188,1319,36,1082,-85]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				y : 640,
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 1280, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : -3840 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(700,300,Math.PI/5,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.5,0],[0,255],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([1082,-87,798,188,1319,36,1082,-85]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				y : 640,
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 1280, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : -3840 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(700,300,Math.PI/5,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.5,0],[0,255],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([1082,-87,798,188,1319,36,1082,-85]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				y : 640,
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 2560, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : -2560 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(700,300,Math.PI/5,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.5,0],[0,255],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([1082,-87,798,188,1319,36,1082,-85]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				y : 640,
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 3840, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : -1280 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(700,300,Math.PI/5,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.5,0],[0,255],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([1082,-87,798,188,1319,36,1082,-85]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				y : 640,
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 5120, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : 0 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(400,300,Math.PI/5*3,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.5,0],[0,255],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([462,-89,633,166,778,-81,463,-89]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				y : 640,
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 0, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : -2560 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(400,300,Math.PI/5*3,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.5,0],[0,255],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([462,-89,633,166,778,-81,463,-89]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				y : 640,
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 1280, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : -1280 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		}),
		TrackMatte({
			  layer :  Layer(
			{
			  source :  function(){
				var tragle=Shape();
				var mtrx=$.createMatrix();
				mtrx.createGradientBox(400,300,Math.PI/5*3,0,0);
				tragle.graphics.beginGradientFill("linear",[0x82d2f7,0xFFFFFF],[0.5,0],[0,255],mtrx,"pad");
				tragle.graphics.drawPath( $.toIntVector([1,2,2,2]),$.toNumberVector([462,-89,633,166,778,-81,463,-89]));
				tragle.graphics.endFill();
				return tragle;
			  }(),
			  inPoint : 0,
			  outPoint : 16000,
			  properties : 
			  {
				y : 640,
				x : KeyframesBind(
					{
						keyframes :
						[
							Keyframe({ time : 0, value : 2560, interpolation : Interpolation.linear }),
							Keyframe({ time : 16000, value : 0 , interpolation : Interpolation.linear }),
						]
					})
			  }
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRect( 0, 0, 1280, 80);
			  shp2.graphics.drawRect( 0, 640, 1280, 80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 16000
			})
		})
		  ]
		});

	ED.ShowComp.LastWordComp = Composition(
		{
		  width : 1280,
		  height : 720,

		  startTime : 201500,
		  duration : 227130 - 201500,

		  layers :
		  [
			DynamicVectorTextLayer(
		  {
			font : ED.FontLast.PartStaff,
			inPoint : 201500,
			outPoint : 227130,

			properties :
			{
			  x : 640,
			  y : 360,
			  "transform.colorTransform" : Color.rgbToTransformTint( [ 1, 0, 0, 0 ] ),
			  "@filter" : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 201700, value : 32 }),
				  Keyframe({ time : 201800, value : 0, interpolation : Interpolation.hold }),
				  Keyframe({ time : 206500, value : 1 }),
				  Keyframe({ time : 207000, value : 32 }),
				  Keyframe({ time : 207100, value : 0, interpolation : Interpolation.hold }),
				  Keyframe({ time : 211800, value : 1 }),
				  Keyframe({ time : 212300, value : 32 }),
				  Keyframe({ time : 212400, value : 0, interpolation : Interpolation.hold }),
				  Keyframe({ time : 217100, value : 1 }),
				  Keyframe({ time : 217600, value : 32 }),
				  Keyframe({ time : 217700, value : 0, interpolation : Interpolation.hold }),
				  Keyframe({ time : 222200, value : 1 }),
				  Keyframe({ time : 222800, value : 32 }),
				  Keyframe({ time : 222900, value : 0, interpolation : Interpolation.hold }),
				  Keyframe({ time : 226830, value : 1 }),
				  Keyframe({ time : 227130, value : 32 })
				]
			 }),
			  filters : Binder.Link(
			  {
				name : "@filter",
				linkFunc : function()
				{
			   //   var tempColor = [0xfc];
				  return function( v )
				  {
					return [ $.createBlurFilter( v, v, 1 ) ];
				  };
				}()
			  }),

			  alpha : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 201500, value : 0 }),
				  Keyframe({ time : 201800, value : 1, interpolation : Interpolation.hold }),
				  Keyframe({ time : 206500, value : 1 }),
				  Keyframe({ time : 206800, value : 0 }),
				  Keyframe({ time : 207100, value : 1, interpolation : Interpolation.hold }),
				  Keyframe({ time : 211800, value : 1 }),
				  Keyframe({ time : 212100, value : 0 }),
				  Keyframe({ time : 212400, value : 1, interpolation : Interpolation.hold }),
				  Keyframe({ time : 217100, value : 1 }),
				  Keyframe({ time : 217400, value : 0 }),
				  Keyframe({ time : 217700, value : 1, interpolation : Interpolation.hold }),
				  Keyframe({ time : 222500, value : 1 }),
				  Keyframe({ time : 222800, value : 0 }),
				  Keyframe({ time : 222900, value : 1, interpolation : Interpolation.hold }),
				  Keyframe({ time : 226830, value : 1 }),
				  Keyframe({ time : 227130, value : 0 })
				]
			  })
			},

			textProperties : 
			{
			  horizontalAlign : "center",
			  verticalAlign : "center",
			  fontSize : 48,
			  text : KeyframesBind(
			  {
				keyframes :
				[
				//  Keyframe({ time : 191250, value : "我们用独特的方式", interpolation : Interpolation.hold }),
				 // Keyframe({ time : 196250, value : "创造出自己心中的梦想", interpolation : Interpolation.hold }),
				  Keyframe({ time : 201500, value : "我们用自己的方式传递着热情", interpolation : Interpolation.hold }),
				  Keyframe({ time : 206800, value : "无论弹幕类型，无论技术高低", interpolation : Interpolation.hold }),
				  Keyframe({ time : 212100, value : "只要有爱，人人都是弹幕君", interpolation : Interpolation.hold }),
				  Keyframe({ time : 217400, value : "感谢大家一直以来对弹幕君的支持", interpolation : Interpolation.hold }),
				  Keyframe({ time : 222700, value : "我们来年再见", interpolation : Interpolation.hold })
				]
			  }),

			  letterSpacing : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 201500, value : 0 }),
				  Keyframe({ time : 206790, value : 10, interpolation : Interpolation.hold }),
				  Keyframe({ time : 206800, value : 0 }),
				  Keyframe({ time : 212090, value : 10, interpolation : Interpolation.hold }),
				  Keyframe({ time : 212100, value : 0 }),
				  Keyframe({ time : 217390, value : 10, interpolation : Interpolation.hold }),
				  Keyframe({ time : 217400, value : 0 }),
				  Keyframe({ time : 222690, value : 10, interpolation : Interpolation.hold }),
				  Keyframe({ time : 222700, value : 0 }),
				  Keyframe({ time : 227130, value : 10, interpolation : Interpolation.hold })
			
				]
			  })
			}
		  })
		  ]
		}
	  );

	var logoComp = Composition(
		{
		  width : 1280,
		  height : 720,

		  startTime : 0,
		  duration : 250000 - 227630,

		  layers :
		  [ 
		Layer({
				source : Anchor({source : LogoShapes["blue"] , x : 98, y : 214}) ,
			  inPoint : 0,
			  outPoint : 250000 - 227630,
		  // DisplayObject属性
			 properties :
			 {
			  y : 363,
			   x :  KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 0, value : 526 , interpolation : Interpolation.hold }),
				  Keyframe({ time : 2000, value : 526 , interpolation : Interpolation.linear }),
				  Keyframe({ time : 5000, value : 410, interpolation : Interpolation.cubic.easeOut  }),
				  Keyframe({ time : 6500, value : 526 ,  interpolation : Interpolation.cubic.easeOut })
				]
			  }),
				"colorT" : KeyframesBind(
						  {
							keyframes :
							[
							  Keyframe({ time : 0, value : [0x51, 0x76 , 0xBA] , interpolation : Interpolation.dimension( Interpolation.hold )}),
							  Keyframe({ time : 2000, value : [0x51, 0x76 , 0xBA] , interpolation : Interpolation.dimension( Interpolation.cubic.easeInOut )}),
							  Keyframe({ time : 6500, value : [0x51, 0x76 , 0xBA], interpolation : Interpolation.dimension( Interpolation.cubic.easeInOut )}),
							  Keyframe({ time : 7000, value : [0x72, 0x72 , 0x72], interpolation : Interpolation.dimension( Interpolation.cubic.easeInOut )}),
							  Keyframe({ time : 7500, value : [0x51, 0x76 , 0xBA] , interpolation : Interpolation.dimension( Interpolation.cubic.easeInOut )})
							]
						  }),
				"transform.colorTransform" : Binder.Link(
						  {
							name : "colorT",
							linkFunc : function( value, time )
							{
							  var ct = $.createColorTransform();
				  ct.color = Utils.rgb( value[0] , value[1], value[2]);
					//D93231 -5A76BA     
				  return ct;
							}
						  })
			 }
			 }),

		 
			Layer(
			{
			  source : Anchor({source : LogoShapes["red"] , x : 163, y : 54}) ,
			  inPoint : 0,
			  outPoint : 250000 - 227630,
		  // DisplayObject属性
			 properties :
			 {
			  x :  KeyframesBind(
			  {
				keyframes :
				[ 
				  Keyframe({ time : 0, value : 591 , interpolation : Interpolation.hold }),
				  Keyframe({ time : 2000, value : 591 , interpolation : Interpolation.linear }),
				  Keyframe({ time : 5000, value : 548, interpolation : Interpolation.cubic.easeOut  }),
				  Keyframe({ time : 6500, value : 812 ,  interpolation : Interpolation.cubic.easeOut })
				]
			  }),
			  y : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 0, value : 528 , interpolation : Interpolation.hold }),
				  Keyframe({ time : 2000, value : 528 , interpolation : Interpolation.linear }),
				  Keyframe({ time : 5000, value : 580, interpolation : Interpolation.cubic.easeOut  }),
				  Keyframe({ time : 6500, value : 457 ,  interpolation : Interpolation.cubic.easeOut })
				]
			  }),
			  rotationX : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 0, value : 0 , interpolation : Interpolation.linear }),
				  Keyframe({ time : 2000, value : 0 , interpolation : Interpolation.linear }),
				  Keyframe({ time : 5000, value : 0, interpolation : Interpolation.cubic.easeOut  }),
				  Keyframe({ time : 6500, value : 180 ,  interpolation : Interpolation.cubic.easeOut })
				]
			  }),
			  rotationZ : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 0, value : 0 , interpolation : Interpolation.linear }),
				   Keyframe({ time : 2000, value : 0 , interpolation : Interpolation.linear }),
				  Keyframe({ time : 5000, value : 0, interpolation : Interpolation.cubic.easeOut  }),
				  Keyframe({ time : 6500, value : 45 ,  interpolation : Interpolation.cubic.easeOut })
				]
			  }),
				"colorT" : KeyframesBind(
						  {
							keyframes :
							[
							  Keyframe({ time : 0, value : [0xD9,0x32,0x31] , interpolation : Interpolation.dimension( Interpolation.hold )}),
							  Keyframe({ time : 6500, value : [0xD9,0x32,0x31] , interpolation : Interpolation.dimension( Interpolation.cubic.easeInOut )}),
							  Keyframe({ time : 7000, value : [0x72, 0x72 , 0x72], interpolation : Interpolation.dimension( Interpolation.cubic.easeInOut )}),
							  Keyframe({ time : 7500, value : [0x51, 0x76 , 0xBA] , interpolation : Interpolation.dimension( Interpolation.cubic.easeInOut )})
							]
						  }),
				"transform.colorTransform" : Binder.Link(
						  {
							name : "colorT",
							linkFunc : function( value, time )
							{
							   var ct = $.createColorTransform();
				  ct.color = Utils.rgb( value[0] , value[1], value[2]);
					//D93231 -5A76BA     
				  return ct;
							}
						  })
			 }
			}),
		  Layer(
			{
			  source : Anchor({source : LogoShapes["yellow"] , x : 108, y : 63}) ,
			  inPoint : 0,
			  outPoint : 250000 - 227630,
		  // DisplayObject属性
			 properties :
			 {
			  x :  KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 0, value : 644.6 , interpolation : Interpolation.linear }),
				  Keyframe({ time : 2000, value : 644.6 , interpolation : Interpolation.linear }),
				  Keyframe({ time : 5000, value : 644.6, interpolation : Interpolation.cubic.easeOut  }),
				  Keyframe({ time : 6500, value : 690 ,  interpolation : Interpolation.cubic.easeOut })
				]
			  }),
			  y : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 0, value : 429.2 , interpolation : Interpolation.linear }),
				  Keyframe({ time : 2000, value : 429.2 , interpolation : Interpolation.linear }),
				  Keyframe({ time : 5000, value : 429.2, interpolation : Interpolation.cubic.easeOut  }),
				  Keyframe({ time : 6500, value : 259 ,  interpolation : Interpolation.cubic.easeOut })
				]
			  }),
			  rotationZ : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 0, value : 0 , interpolation : Interpolation.linear }),
				   Keyframe({ time : 2000, value : 0 , interpolation : Interpolation.linear }),
				  Keyframe({ time : 5000, value : 0, interpolation : Interpolation.cubic.easeOut  }),
				  Keyframe({ time : 6500, value : 135 ,  interpolation : Interpolation.cubic.easeOut })
				]
			  }),
				"colorT" : KeyframesBind(
						  {
							keyframes :
							[
							  Keyframe({ time : 0, value : [0xF5, 0xE3 , 0x4F] , interpolation : Interpolation.dimension( Interpolation.hold )}),
							  Keyframe({ time : 2000, value : [0xF5, 0xE3 , 0x4F] , interpolation : Interpolation.dimension( Interpolation.hold )}),
							  Keyframe({ time : 6500, value : [0xF5, 0xE3 , 0x4F], interpolation : Interpolation.dimension( Interpolation.cubic.easeInOut )}),
							  Keyframe({ time : 7000, value : [0x72, 0x72 , 0x72], interpolation : Interpolation.dimension( Interpolation.cubic.easeInOut )}),
							  Keyframe({ time : 7500, value : [0x51, 0x76 , 0xBA] , interpolation : Interpolation.dimension( Interpolation.cubic.easeInOut )})
							]
						  }),
				"transform.colorTransform" : Binder.Link(
						  {
							name : "colorT",
							linkFunc : function( value, time )
							{
							  var ct = $.createColorTransform();
				  ct.color = Utils.rgb( value[0] , value[1], value[2]);
					//0xF5E34F   
				  return ct;
							}
						  })
			 }
			}),
	Layer(
			{
			  source : Anchor({source : LogoShapes["dark"] , x : 107.5, y : 110}) ,
			  inPoint : 0,
			  outPoint : 250000 - 227630,
		  // DisplayObject属性
			 properties :
			 {
			  x :  KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 0, value : 753.9 , interpolation : Interpolation.linear }),
				  Keyframe({ time : 2000, value : 753.9 , interpolation : Interpolation.linear }),
				  Keyframe({ time : 5000, value : 838.9, interpolation : Interpolation.cubic.easeOut  }),
				  Keyframe({ time : 6500, value : 810 ,  interpolation : Interpolation.cubic.easeOut })
				]
			  }),
			  y : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 0, value : 368.3 , interpolation : Interpolation.linear }),
				  Keyframe({ time : 2000, value : 368.3 , interpolation : Interpolation.linear }),
				  Keyframe({ time : 5000, value : 368.3, interpolation : Interpolation.cubic.easeOut  }),
				  Keyframe({ time : 6500, value : 227.3 ,  interpolation : Interpolation.cubic.easeOut })
				]
			  }),
			  rotationZ : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 0, value : 0 , interpolation : Interpolation.hold }),
				  Keyframe({ time : 2000, value : 0 , interpolation : Interpolation.hold }),
				  Keyframe({ time : 5000, value : 0, interpolation : Interpolation.cubic.easeOut  }),
				  Keyframe({ time : 6500, value : 45 ,  interpolation : Interpolation.cubic.easeOut })
				]
			  }),
			   alpha : KeyframesBind(
						  {
							keyframes :
							[
							  Keyframe({ time : 6500, value : 1, interpolation : Interpolation.linear}),
							  Keyframe({ time : 7000, value : 0, interpolation : Interpolation.hold}),
							  Keyframe({ time : 13000, value : 0, interpolation : Interpolation.linear}),
							  Keyframe({ time : 15000, value : 1, interpolation : Interpolation.linear})
							]
						  })
			 }
			}),
	Layer(
			{
			  source : Anchor({source : LogoShapes["green"] , x : 53, y : 108.5}) ,
			  inPoint : 0,
			  outPoint : 250000 - 227630,
		  // DisplayObject属性
			 properties :
			 {
			  x :  KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 0, value : 807 , interpolation : Interpolation.linear }),
				  Keyframe({ time : 2000, value : 807 , interpolation : Interpolation.linear }),
				  Keyframe({ time : 5000, value : 919, interpolation : Interpolation.cubic.easeOut  }),
				  Keyframe({ time : 6500, value : 850 ,  interpolation : Interpolation.cubic.easeOut })
				]
			  }),
			  y : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 0, value : 258.4 , interpolation : Interpolation.linear }),
				   Keyframe({ time : 2000, value : 258.4 , interpolation : Interpolation.linear }),
				  Keyframe({ time : 5000, value : 196.4, interpolation : Interpolation.cubic.easeOut  }),
				  Keyframe({ time : 6500, value : 341,  interpolation : Interpolation.cubic.easeOut })
				]
			  }),
			  rotationY : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 0, value : 0 , interpolation : Interpolation.linear }),
				   Keyframe({ time : 2000, value : 0 , interpolation : Interpolation.linear }),
				  Keyframe({ time : 5000, value : 0, interpolation : Interpolation.cubic.easeOut  }),
				  Keyframe({ time : 6500, value : -180 ,  interpolation : Interpolation.cubic.easeOut })
				]
			  }),
			  rotationZ : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 0, value : 0 , interpolation : Interpolation.hold }),
				  Keyframe({ time : 2000, value : 0 , interpolation : Interpolation.hold }),
				  Keyframe({ time : 5000, value : 0, interpolation : Interpolation.cubic.easeOut  }),
				  Keyframe({ time : 6500, value : -45 ,  interpolation : Interpolation.cubic.easeOut })
				]
			  }),
			   alpha : KeyframesBind(
						  {
							keyframes :
							[
							  Keyframe({ time : 6500, value : 1, interpolation : Interpolation.linear}),
							  Keyframe({ time : 7000, value : 0, interpolation : Interpolation.linear})
							]
						  })
			 }
			}),
	Layer(
			{
			  source : Anchor({source : LogoShapes["white"] , x : 217, y : 91.5}) ,
			  inPoint : 0,
			  outPoint : 250000 - 227630,
		  // DisplayObject属性
			 properties :
			 {
			  x :  KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 0, value : 645.7 , interpolation : Interpolation.hold }),
				  Keyframe({ time : 2000, value : 645.7 , interpolation : Interpolation.linear }),
				  Keyframe({ time : 5000, value : 645.7, interpolation : Interpolation.cubic.easeOut  }),
				  Keyframe({ time : 6500, value : 670 ,  interpolation : Interpolation.cubic.easeOut })
				]
			  }),
			  y : KeyframesBind(
			  {
				keyframes :
				[
				Keyframe({ time : 0, value : 241.5 , interpolation : Interpolation.hold }),
				  Keyframe({ time : 2000, value : 241.5 , interpolation : Interpolation.linear }),
				  Keyframe({ time : 5000, value : 175.5, interpolation : Interpolation.cubic.easeOut  }),
				  Keyframe({ time : 6500, value : 520,  interpolation : Interpolation.cubic.easeOut })
				]
			  }),
			  rotationX : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 2000, value : 0 , interpolation : Interpolation.hold }),
				  Keyframe({ time : 5000, value : 0, interpolation : Interpolation.cubic.easeOut  }),
				  Keyframe({ time : 6500, value : 180 ,  interpolation : Interpolation.cubic.easeOut })
				]
			  }),
			   alpha : KeyframesBind(
						  {
							keyframes :
							[
							  Keyframe({ time : 6500, value : 1, interpolation : Interpolation.linear}),
							  Keyframe({ time : 7000, value : 0, interpolation : Interpolation.linear})
							]
						  })
			 }
			}),
	Layer(
			{
			  source : Anchor({source : LogoShapes["sharp"] , x : 218, y : 116.5}) ,
			  inPoint : 0,
			  outPoint : 250000 - 227630,
		  // DisplayObject属性
			 properties :
			 {
			  x : 674,
			  y : 515,
			   alpha : KeyframesBind(
						  {
							keyframes :
							[
							  Keyframe({ time : 6500, value : 0, interpolation : Interpolation.linear}),
							  Keyframe({ time : 7000, value : 1, interpolation : Interpolation.linear})
							]
						  })
			 }
			}),
	Layer(
			{
			  source : Anchor({source : LogoShapes["purple"] , x : 149, y : 153}) ,
			  inPoint : 0,
			  outPoint : 250000 - 227630,
		  // DisplayObject属性
			 properties :
			 {
			  x :  KeyframesBind(
			  {
				keyframes :
				[
				Keyframe({ time : 0, value : 794.5 , interpolation : Interpolation.hold }),
				  Keyframe({ time : 2000, value : 794.5 , interpolation : Interpolation.linear }),
				  Keyframe({ time : 5000, value : 904.5, interpolation : Interpolation.cubic.easeOut  }),
				  Keyframe({ time : 6500, value : 578 ,  interpolation : Interpolation.cubic.easeOut })
				]
			  }),
			  y : KeyframesBind(
			  {
				keyframes :
				[ Keyframe({ time : 0, value : 519.4 , interpolation : Interpolation.hold }),
				  Keyframe({ time : 2000, value : 519.4 , interpolation : Interpolation.linear }),
				  Keyframe({ time : 5000, value : 570.4, interpolation : Interpolation.cubic.easeOut  }),
				  Keyframe({ time : 6500, value : 210.5,  interpolation : Interpolation.cubic.easeOut })
				]
			  }),
			  rotationZ : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 2000, value : 0 , interpolation : Interpolation.hold }),
				  Keyframe({ time : 5000, value : 0, interpolation : Interpolation.cubic.easeOut  }),
				  Keyframe({ time : 6500, value : 45 ,  interpolation : Interpolation.cubic.easeOut })
				]
			  }),
			   alpha : KeyframesBind(
						  {
							keyframes :
							[
							  Keyframe({ time : 6500, value : 1, interpolation : Interpolation.linear}),
							  Keyframe({ time : 7000, value : 0, interpolation : Interpolation.linear})
							]
						  })
			 }
			})

		  ]
		});

	ED.ShowComp.logoCompEx = Composition(
	  {
		  width : 1280,
		  height : 720,

		  startTime : 0,
		  duration : 250000 - 227630,

		  layers :
		  [
			DynamicSourceLayer(
			{
			  provider : logoComp ,
			  inPoint : 0,
			  outPoint : 250000 - 227630,
			  properties : 
			  {
				scaleX : KeyframesBind(
						  {
							keyframes :
							[
							  Keyframe({ time : 6500, value : 1, interpolation : Interpolation.hold}),
							  Keyframe({ time : 9000, value : 1, interpolation : Interpolation.cubic.easeIn}),
							  Keyframe({ time : 13000, value : 0.8, interpolation : Interpolation.hold})
							]
						  }),
				scaleY : Binder.Link({name : "scaleX"}),
				x : KeyframesBind(
						  {
							keyframes :
							[
							  Keyframe({ time : 6500, value : 0, interpolation : Interpolation.hold}),
							  Keyframe({ time : 9000, value : 0, interpolation : Interpolation.cubic.easeIn}),
							  Keyframe({ time : 13000, value : -120, interpolation : Interpolation.hold})
							]
						  }),
				y : KeyframesBind(
						  {
							keyframes :
							[
							  Keyframe({ time : 6500, value : 0, interpolation : Interpolation.hold}),
							  Keyframe({ time : 9000, value : 0, interpolation : Interpolation.cubic.easeIn}),
							  Keyframe({ time : 13000, value : 50, interpolation : Interpolation.hold})
							]
						  }),
				alpha : KeyframesBind(
						  {
							keyframes :
							[
							  Keyframe({ time : 0, value : 0, interpolation : Interpolation.linear}),
							  Keyframe({ time : 600, value : 1, interpolation : Interpolation.hold})
							]
						  })
			  }
			}),
			Layer(
			{
			  source : LogoShapes["words"],
			  inPoint : 0,
			  outPoint : 250000 - 227630,
			  properties : 
			  {
				x : 232,
				y : 170,
				scaleX : 1.3,
				scaleY : 1.3,
				alpha :
				  KeyframesBind(
						  {
							keyframes :
							[
							  Keyframe({ time : 13000, value : 0, interpolation : Interpolation.linear}),
							  Keyframe({ time : 13500, value : 1})
							]
						  })
			  }
			  })
		  ]
	}
	);

	//这里是第一部分的合成，其中包括了4张图形的运动。
ED.ShowComp.Part1 = 
Composition({
			width : 1280,
		  height : 720,

		  startTime : 21000,
		  duration : 250000-21000,
		   layers :
		  [
		  	Layer(
			{
			  source :  ED.Shapes.Part1["p1"] ,//这张是姐姐笑
			  inPoint : 22200,
			  outPoint : 27200,
			  properties : 
			  {
			  	x : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 22200 , value : 100, interpolation : Interpolation.linear }),
				  Keyframe({ time : 27200, value : 160, interpolation : Interpolation.linear  })
				  ]
				}),
			  	y : 0,
			  	alpha : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 22200 , value : 0, interpolation : Interpolation.linear }),
				  Keyframe({ time :  22500, value : 1, interpolation : Interpolation.hold }),
				  Keyframe({ time : 26800, value : 1, interpolation : Interpolation.linear }),
				  Keyframe({ time : 27200, value : 0, interpolation : Interpolation.linear })
				  ]
				})
			  }
			}),
		 	DynamicVectorTextLayer(
			{
				font : ED.FontLast.PartLyric,
				inPoint : 21000,
				outPoint : 27200,

				properties :
				{
					y : 360,
			  	alpha : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 22200 , value : 0, interpolation : Interpolation.linear }),
				  Keyframe({ time :  22500, value : 1, interpolation : Interpolation.hold }),
				  Keyframe({ time : 26800, value : 1, interpolation : Interpolation.linear }),
				  Keyframe({ time : 27200, value : 0, interpolation : Interpolation.linear })
				  ]
				}),
			  	x : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 22200 , value : 840, interpolation : Interpolation.linear }),
				  Keyframe({ time : 27200, value : 800, interpolation : Interpolation.linear  })
				  ]
				}),
					filters :[$.createGlowFilter(0xFFFFFF,1.0,12,12,6)]
			 	},
			 	textProperties : 
				{				  
				  fontSize : 40,
				  text : "如果你笑著----",
				  glyphFillColor:0,
				  horizontalAlign : "center",
				  verticalAlign : "center"
				}	
			}),
		  Layer(
			{
			  source :  ED.Shapes.Part1["p2"] ,//这张是弟弟笑，有新修改，需要重新生成
			  inPoint : 27200,
			  outPoint : 32500,
			  properties : 
			  {
			  	x : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 27200 , value : 800, interpolation : Interpolation.linear }),
				  Keyframe({ time : 32500, value : 740, interpolation : Interpolation.linear  })
				  ]
				}),
			  	y : 35,
			  	alpha : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 27200 , value : 0, interpolation : Interpolation.linear }),
				  Keyframe({ time :  27500, value : 1, interpolation : Interpolation.hold }),
				  Keyframe({ time : 32200, value : 1, interpolation : Interpolation.linear }),
				  Keyframe({ time : 32500, value : 0, interpolation : Interpolation.linear })
				  ]
				})
			  }
			}),
		 	DynamicVectorTextLayer(
			{
				font : ED.FontLast.PartLyric,
				inPoint : 27200,
				outPoint : 32500,

				properties :
				{
					y : 360,
			  	alpha : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 27200 , value : 0, interpolation : Interpolation.linear }),
				  Keyframe({ time :  27500, value : 1, interpolation : Interpolation.hold }),
				  Keyframe({ time : 32200, value : 1, interpolation : Interpolation.linear }),
				  Keyframe({ time : 32500, value : 0, interpolation : Interpolation.linear })
				  ]
				}),
			  	x : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 27200 , value : 400, interpolation : Interpolation.linear }),
				  Keyframe({ time : 32500, value : 440, interpolation : Interpolation.linear  })
				  ]
				}),
					filters :[$.createGlowFilter(0xFFFFFF,1.0,12,12,6)]
			 	},
			 	textProperties : 
				{				  
				  fontSize : 40,
				  text : "我也會變得想笑",
				  glyphFillColor:0,
				  horizontalAlign : "center",
				  verticalAlign : "center"
				}	
			}),
		Layer(
			{
			  source :  ED.Shapes.Part1["p3_1"] ,//这张是弟弟哭，这里我拆开来的
			  inPoint : 32500,
			  outPoint : 42100,
			  properties : 
			  {
			  	scaleX :KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 32500 , value : 1.25, interpolation : Interpolation.linear }),
				  Keyframe({ time : 37500 , value : 1.30, interpolation : Interpolation.linear  }),
				  Keyframe({ time : 38500, value : 1.33, interpolation : Interpolation.linear  }),
				  Keyframe({ time : 39500, value : 1.30, interpolation : Interpolation.linear  }),
				   Keyframe({ time : 42100, value :1.25, interpolation : Interpolation.linear  })
				  ]
				}),
			  		scaleY : Binder.Link({name : "scaleX"}),//这里的意思是，scaleY使用scaleX相同的关键帧函数，如上
			  	x : -200,
			  	y : KeyframesBind({
				keyframes :
				[
					Keyframe({ time : 32500 , value : -40, interpolation : Interpolation.linear }),
				  Keyframe({ time : 37500 , value : 80, interpolation : Interpolation.linear }),
				   Keyframe({ time : 42100, value :400, interpolation : Interpolation.linear  })
				  ]
				}),
			  	alpha : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 32500 , value : 0, interpolation : Interpolation.linear }),
				  Keyframe({ time : 32800, value : 1, interpolation : Interpolation.hold }),
				  Keyframe({ time : 41800, value : 1, interpolation : Interpolation.linear }),
				  Keyframe({ time : 42100, value : 0, interpolation : Interpolation.linear })
				  ]
				})
			  }
			}),
		 	DynamicVectorTextLayer(
			{
				font : ED.FontLast.PartLyric,
				inPoint : 32500,
				outPoint : 37500,

				properties :
				{
					y : 360,
			  	alpha : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 32500 , value : 0, interpolation : Interpolation.linear }),
				  Keyframe({ time : 32800, value : 1, interpolation : Interpolation.hold }),
				  Keyframe({ time : 37200, value : 1, interpolation : Interpolation.linear }),
				  Keyframe({ time : 37500, value : 0, interpolation : Interpolation.linear })
				  ]
				}),
			  	x : 640,
					filters :[$.createGlowFilter(0xFFFFFF,1.0,12,12,6)]
			 	},
			 	textProperties : 
				{				  
				  fontSize : 44,
				  text : "如果你哭泣----",
				  glyphFillColor:0,
				  horizontalAlign : "center",
				  verticalAlign : "center",
			letterSpacing : KeyframesBind(
          {
            keyframes :
            [
              Keyframe({ time : 32500, value : 0, interpolation : Interpolation.linear }),
              Keyframe({ time : 37500, value : 10, interpolation : Interpolation.linear})
      ]
          })
				}	
			}),
				Layer(
			{
			  source :  ED.Shapes.Part1["p3_2"] ,//这里是姐姐摸头，坐标是在一起的。所以这层Layer和上面那层两个可以使用相同的关键帧
			  inPoint : 37500,
			  outPoint : 42100,
			  properties : 
			  {
			  	scaleX :KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 37500 , value : 1.30, interpolation : Interpolation.linear  }),
				  Keyframe({ time : 38500, value : 1.33, interpolation : Interpolation.linear  }),
				  Keyframe({ time : 39500, value : 1.30, interpolation : Interpolation.linear  }),
				   Keyframe({ time : 42100, value :1.25, interpolation : Interpolation.linear  })
				  ]
				}),
			  		scaleY : Binder.Link({name : "scaleX"}),
			  	y : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 37500 , value : 80 -350, interpolation : Interpolation.linear }),
				   Keyframe({ time : 42100, value :400 -350, interpolation : Interpolation.linear  })
				  ]
				}),
			  	x : -200,
			  	alpha : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 37500 , value : 0, interpolation : Interpolation.linear }),
				  Keyframe({ time : 37800, value : 1, interpolation : Interpolation.hold }),
				  Keyframe({ time : 41800, value : 1, interpolation : Interpolation.linear }),
				  Keyframe({ time : 42100, value : 0, interpolation : Interpolation.linear })
				  ]
				})
			  }
			}),

		 	DynamicVectorTextLayer(
			{
				font : ED.FontLast.PartLyric,
				inPoint : 37500,
				outPoint : 42100,

				properties :
				{
					y : 360,
			  	alpha : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 37500 , value : 0, interpolation : Interpolation.linear }),
				  Keyframe({ time : 37800, value : 1, interpolation : Interpolation.hold }),
				  Keyframe({ time : 41800, value : 1, interpolation : Interpolation.linear }),
				  Keyframe({ time : 42100, value : 0, interpolation : Interpolation.linear })
				  ]
				}),
			  	x : 640,
					filters :[$.createGlowFilter(0xFFFFFF,1.0,12,12,6)]
			 	},
			 	textProperties : 
				{				  
				  fontSize : 44,
				  text : "我也會潸然淚下",
				  glyphFillColor:0,
				  horizontalAlign : "center",
				  verticalAlign : "center",
			letterSpacing : KeyframesBind(
          {
            keyframes :
            [
              Keyframe({ time : 37500, value : 0, interpolation : Interpolation.linear }),
              Keyframe({ time : 42100, value : 10, interpolation : Interpolation.linear})
      ]
          })
				}	
			}),
	//中间插一句，难理解的表情：小电视，难理解的话语：菊花
	//42100,//45000 47200
DynamicVectorTextLayer(
{
	font : ED.FontLast.PartLyric,
	inPoint : 42100,
	outPoint : 45000,

	properties :
	{
		y : 360,
  	alpha : KeyframesBind(
  {
	keyframes :
	[
	  Keyframe({ time : 42100 , value : 0, interpolation : Interpolation.linear }),
	  Keyframe({ time :  42400, value : 1, interpolation : Interpolation.hold }),
	  Keyframe({ time : 44700, value : 1, interpolation : Interpolation.linear }),
	  Keyframe({ time : 45000, value : 0, interpolation : Interpolation.linear })
	  ]
	}),
  	x : KeyframesBind(
  {
	keyframes :
	[
	  Keyframe({ time : 42100 , value : 280, interpolation : Interpolation.linear }),
	  Keyframe({ time : 45000, value : 320, interpolation : Interpolation.linear  })
	  ]
	}),
		filters :[$.createGlowFilter(0xFFFFFF,1.0,12,12,6)]
 	},
 	textProperties : 
	{				  
	  fontSize : 44,
	  text : "困擾的表情",
	  glyphFillColor:0,
	  horizontalAlign : "center",
	  verticalAlign : "center"
	}	
}),
 	DynamicVectorTextLayer(
{
	font : ED.FontLast.PartLyric,
	inPoint : 45000,
	outPoint : 47200,

	properties :
	{
		y : 360,
  	alpha : KeyframesBind(
  {
	keyframes :
	[
	  Keyframe({ time : 45000 , value : 0, interpolation : Interpolation.linear }),
	  Keyframe({ time :  45300, value : 1, interpolation : Interpolation.hold }),
	  Keyframe({ time : 46900, value : 1, interpolation : Interpolation.linear }),
	  Keyframe({ time : 47200, value : 0, interpolation : Interpolation.linear })
	  ]
	}),
  	x : KeyframesBind(
  {
	keyframes :
	[
	  Keyframe({ time : 45000 , value : 980, interpolation : Interpolation.linear }),
	  Keyframe({ time : 47200, value : 940, interpolation : Interpolation.linear  })
	  ]
	}),
		filters :[$.createGlowFilter(0xFFFFFF,1.0,12,12,6)]
 	},
 	textProperties : 
	{				  
	  fontSize : 44,
	  text : "難懂的話語",
	  glyphFillColor:0,
	  horizontalAlign : "center",
	  verticalAlign : "center"
	}	
}),
	Layer(
			{
			  source :  ED.Shapes.Part1["p4"] ,//这里是双子拍手，第一部分的最后一张。话说，这种弟弟的头实在是不好看
			  inPoint : 47200,//45000 47200
			  outPoint : 52700,
			  properties : 
			  {
			  	x : -530,
			  	y :  KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 47200, value : -200, interpolation : Interpolation.linear }),
				  Keyframe({ time : 52700, value : 0, interpolation : Interpolation.linear })
				  ]
				}),
			  	scaleX :  KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 47200, value : 1.9, interpolation : Interpolation.linear }),
				  Keyframe({ time : 52700, value : 1.86, interpolation : Interpolation.linear })
				  ]
				}),
			  	scaleY : Binder.Link({name : "scaleX"}),
			  	alpha : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 47200, value : 0, interpolation : Interpolation.linear }),
				  Keyframe({ time : 47500, value : 1, interpolation : Interpolation.linear }),
				  Keyframe({ time : 52400, value : 1, interpolation : Interpolation.linear }),
				  Keyframe({ time : 52700, value : 0, interpolation : Interpolation.linear })
				  ]
				})
			  }
			}),
		 	DynamicVectorTextLayer(
			{
				font : ED.FontLast.PartLyric,
				inPoint : 47200,
				outPoint : 52700,

				properties :
				{
					y : 360,
			  	alpha : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 47200, value : 0, interpolation : Interpolation.linear }),
				  Keyframe({ time : 47500, value : 1, interpolation : Interpolation.linear }),
				  Keyframe({ time : 52400, value : 1, interpolation : Interpolation.linear }),
				  Keyframe({ time : 52700, value : 0, interpolation : Interpolation.linear })

				  ]
				}),
			  	x : 640,
					//filters :[$.createGradientGlowFilter(1,0,[0xffb6c1,0xfefefe], [1,1],[0,255],10,10,32)]
					filters :[$.createGlowFilter(0xFFFFFF,1.0,12,12,6)]
					//blendMode : "multiply"
			 	},
			 	textProperties : 
				{				  
				  fontSize : 42,
				  text : "可以先放在一邊讓我們歡笑一下嗎",
				  glyphFillColor:0,
				  horizontalAlign : "center",
				  verticalAlign : "center",
			letterSpacing : KeyframesBind(
          {
            keyframes :
            [
              Keyframe({ time : 47200, value : 0, interpolation : Interpolation.linear }),
              Keyframe({ time : 52700, value : 10, interpolation : Interpolation.linear})
      ]
          })
				}	
			})
		  ]
	});

//part2 文字合成(现移动至原part3)
ED.ShowComp.part2_word=
Composition(
{
	width : 1280,
	height : 720,

	startTime : 106000,
	duration : 250000-106000,

	layers :
	[
		DynamicVectorTextLayer(
		{
			font : ED.FontLast.PartLyric,
			inPoint : 106000,
			outPoint : 137000,

			properties :
			{
			  x : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 106000, value : 930-100, interpolation : Interpolation.linear }),
				  Keyframe({ time : 112000, value : 890-100, interpolation : Interpolation.linear}),				 				 
				  Keyframe({ time : 112010, value : 930-100, interpolation : Interpolation.linear}),
				  Keyframe({ time : 117000, value : 890-100, interpolation : Interpolation.linear}),
				  Keyframe({ time : 117010, value : 930-100, interpolation : Interpolation.linear }),
				  Keyframe({ time : 122000, value : 890-100, interpolation : Interpolation.linear }),
				  Keyframe({ time : 122010, value : 930-100, interpolation : Interpolation.linear }),
				  Keyframe({ time : 126700, value : 890-100, interpolation : Interpolation.linear }),
				  Keyframe({ time : 126710, value : 830-100, interpolation : Interpolation.linear }),
				  Keyframe({ time : 137000, value : 790-100, interpolation : Interpolation.linear })
				]
			  }),
			  y :
			   KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 106000, value : 540, interpolation : Interpolation.hold }),
				  Keyframe({ time : 126710, value : 520, interpolation : Interpolation.hold })
				]
			  }),

			  filters :[$.createGlowFilter(0xFFFFFF,1.0,12,12,6)],
			  alpha : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 106000, value : 0 }),
				  Keyframe({ time : 106500, value : 1, interpolation : Interpolation.hold }),
				  Keyframe({ time : 111500, value : 1 }),
				  Keyframe({ time : 112000, value : 0 }),
				  Keyframe({ time : 112500, value : 1, interpolation : Interpolation.hold }),
				  Keyframe({ time : 116500, value : 1 }),
				  Keyframe({ time : 117000, value : 0 }),
				  Keyframe({ time : 117500, value : 1, interpolation : Interpolation.hold }),
				  Keyframe({ time : 121500, value : 1 }),
				  Keyframe({ time : 122000, value : 0 }),
				  Keyframe({ time : 122500, value : 1, interpolation : Interpolation.hold }),
				  Keyframe({ time : 126200, value : 1 }),
				  Keyframe({ time : 126700, value : 0 }),
				  Keyframe({ time : 127200, value : 1, interpolation : Interpolation.hold }),
				  Keyframe({ time : 136500, value : 1 }),
				  Keyframe({ time : 137000, value : 0 })
				]
			  })
			},

			textProperties : 
			{
				fontSize:36,
				glyphFillColor : 0,
				text : KeyframesBind(
			 	{
					keyframes :
					[
					  Keyframe({ time : 106000, value : "會因為贊美而快樂", interpolation : Interpolation.hold   }),
					  Keyframe({ time : 112000, value : "也會因為一些事生氣", interpolation : Interpolation.hold   }),
					  Keyframe({ time : 117000, value : "會因為出問題而困擾", interpolation : Interpolation.hold  }),
					  Keyframe({ time : 122000, value : "也會因為誤解而苦惱", interpolation : Interpolation.hold  }),
					  Keyframe({ time : 126700, value : "但無論如何 \n我們只想傳達簡單的心意", interpolation : Interpolation.hold   })
					]
			 	})
			}
		})
	]
});

//part2 图像合成（现part3)
ED.ShowComp.Part2 = 
Composition(
{
	width : 1280,
	height : 720,

	startTime: 106000,
	duration: 250000-106000,

	layers :
	[
		Layer(
		{
			source :  ED.Shapes_1.Part2["sector_1"] ,
			inPoint: 106000,
			outPoint: 112000,

			properties :
			{
				x: KeyframesBind(
			  	{
					keyframes :
					[
				  		Keyframe({ time : 106000 , value : -100, interpolation : Interpolation.linear }),
				 		Keyframe({ time : 112000, value : -50, interpolation : Interpolation.hold })
				  	]
				}),
				y: 192,
				scaleX: 1.85,
				scaleY: 1.85,
				alpha : KeyframesBind(
			  	{
					keyframes :
					[
				  		Keyframe({ time : 106000 , value : 0, interpolation : Interpolation.linear }),
				 		Keyframe({ time : 106500, value : 1, interpolation : Interpolation.hold }),
				  		Keyframe({ time : 111500, value : 1, interpolation : Interpolation.linear }),
				  		Keyframe({ time : 112000, value : 0, interpolation : Interpolation.linear })
				  	]
				})
			}
		}),

		Layer(
		{
			source :  ED.Shapes_1.Part2["sector_2"] ,
			inPoint: 112000,
			outPoint: 117000,

			properties :
			{
				x: KeyframesBind(
			  	{
					keyframes :
					[
				  		Keyframe({ time : 112000 , value : -650, interpolation : Interpolation.linear }),
				 		Keyframe({ time : 117000, value : -600, interpolation : Interpolation.hold })
				  	]
				}),
				y: -550,
				scaleX: 2.9,
				scaleY: 2.9,
				alpha : KeyframesBind(
			  	{
					keyframes :
					[
				  		Keyframe({ time : 112000 , value : 0, interpolation : Interpolation.linear }),
				 		Keyframe({ time : 112500, value : 1, interpolation : Interpolation.hold }),
				  		Keyframe({ time : 116500, value : 1, interpolation : Interpolation.linear }),
				  		Keyframe({ time : 117000, value : 0, interpolation : Interpolation.linear })
				  	]
				})
			}
		}),

		Layer(
		{
			source :  ED.Shapes_1.Part2["sector_3"] ,
			inPoint: 117000,
			outPoint: 122000,

			properties :
			{
				x: KeyframesBind(
			  	{
					keyframes :
					[
				  		Keyframe({ time : 117000 , value : -165, interpolation : Interpolation.linear }),
				 		Keyframe({ time : 122000, value : -115, interpolation : Interpolation.hold })
				  	]
				}),
				y: -350,
				scaleX: 2.25,
				scaleY: 2.25,
				alpha : KeyframesBind(
			  	{
					keyframes :
					[
				  		Keyframe({ time : 117000 , value : 0, interpolation : Interpolation.linear }),
				 		Keyframe({ time : 117500, value : 1, interpolation : Interpolation.hold }),
				  		Keyframe({ time : 121500, value : 1, interpolation : Interpolation.linear }),
				  		Keyframe({ time : 122000, value : 0, interpolation : Interpolation.linear })
				  	]
				})
			}
		}),

		Layer(
		{
			source :  ED.Shapes_1.Part2["sector_4"] ,
			inPoint: 122000,
			outPoint: 126700,

			properties :
			{
				x: KeyframesBind(
			  	{
					keyframes :
					[
				  		Keyframe({ time : 122000 , value : -300, interpolation : Interpolation.linear }),
				 		Keyframe({ time : 126700, value : -250, interpolation : Interpolation.hold })
				  	]
				}),
				y: -480-30,
				scaleX: 2.4,
				scaleY: 2.4,
				alpha : KeyframesBind(
			  	{
					keyframes :
					[
				  		Keyframe({ time : 122000 , value : 0, interpolation : Interpolation.linear }),
				 		Keyframe({ time : 122500, value : 1, interpolation : Interpolation.hold }),
				  		Keyframe({ time : 126200, value : 1, interpolation : Interpolation.linear }),
				  		Keyframe({ time : 126700, value : 0, interpolation : Interpolation.linear })
				  	]
				})
			}
		}),

		Layer(
		{
			source :  ED.Shapes_1.Part2["sector_5"] ,
			inPoint: 126700,
			outPoint: 137000,

			properties :
			{
				x: KeyframesBind(
			  	{
					keyframes :
					[
				  		Keyframe({ time : 126700, value : -395, interpolation : Interpolation.linear }),
				 		Keyframe({ time : 137000, value : -345, interpolation : Interpolation.hold })
				  	]
				}),
				y: -380,
				scaleX: 2.3,
				scaleY: 2.3,
				alpha : KeyframesBind(
			  	{
					keyframes :
					[
				  		Keyframe({ time : 126700 , value : 0, interpolation : Interpolation.linear }),
				 		Keyframe({ time : 127200, value : 1, interpolation : Interpolation.hold }),
				  		Keyframe({ time : 136500, value : 1, interpolation : Interpolation.linear }),
				  		Keyframe({ time : 137000, value : 0, interpolation : Interpolation.linear })
				  	]
				})
			}
		}),

		Layer(
		{
			source :  ED.Shapes_1.Part2["broadcaster"] ,
			inPoint: 106000,
			outPoint:  137000,

			properties :
			{
				x: 500,
				y: 50,
				scaleX: 2.3,
				scaleY: 2.3,
				alpha : KeyframesBind(
			  	{
					keyframes :
					[
				  		Keyframe({ time : 106000 , value : 0, interpolation : Interpolation.linear }),
				 		Keyframe({ time : 106500, value : 1, interpolation : Interpolation.hold }),
				  		Keyframe({ time : 136500, value : 1, interpolation : Interpolation.linear }),
				  		Keyframe({ time : 137000, value : 0, interpolation : Interpolation.linear })
				  	]
				})
			}
		})
	]
});

//小电视
ED.ShowComp.teleV=
Composition(
{
	width : 1280,
	height : 720,

	startTime: 42100,
	duration: 250000-42100,

	layers :
	[
		Layer(
		{
			source :  ED.Shapes_1.Part2["telev_1"] ,
			inPoint: 42100,
			outPoint: 45000,

			properties :
			{	
				x:560,
				y:280,
				scaleX: 3.0,
				scaleY: 3.0,
				alpha:KeyframesBind(
			  	{
					keyframes :
					[
					  Keyframe({ time : 42100, value : 1, interpolation : Interpolation.hold}),
					  Keyframe({ time : 42390, value : 0, interpolation : Interpolation.hold}),
					  Keyframe({ time : 42680, value : 1 ,interpolation : Interpolation.hold}),
					  Keyframe({ time : 42970, value : 0,interpolation : Interpolation.hold}),
					  Keyframe({ time : 43260, value : 1,interpolation : Interpolation.hold}),
					  Keyframe({ time : 43500, value : 0,interpolation : Interpolation.hold}),
					  Keyframe({ time : 43840, value : 1,interpolation : Interpolation.hold}),
					  Keyframe({ time : 44130, value : 0,interpolation : Interpolation.hold}),
					  Keyframe({ time : 44420, value : 1,interpolation : Interpolation.hold}),
					  Keyframe({ time : 44710, value : 0,interpolation : Interpolation.hold}),
					  Keyframe({ time : 45000, value : 1,interpolation : Interpolation.hold})
				  	]
				})

			}
		}),

		Layer(
		{
			source :  ED.Shapes_1.Part2["telev_2"] ,
			inPoint: 42100,
			outPoint: 45000,

			properties :
			{	
				x:560,
				y:280,
				scaleX: 3.0,
				scaleY: 3.0,
				alpha:KeyframesBind(
			  	{
					keyframes :
					[
					  Keyframe({ time : 42100, value : 0, interpolation : Interpolation.hold}),
					  Keyframe({ time : 42390, value : 1, interpolation : Interpolation.hold}),
					  Keyframe({ time : 42680, value : 0 ,interpolation : Interpolation.hold}),
					  Keyframe({ time : 42970, value : 1,interpolation : Interpolation.hold}),
					  Keyframe({ time : 43260, value : 0,interpolation : Interpolation.hold}),
					  Keyframe({ time : 43500, value : 1,interpolation : Interpolation.hold}),
					  Keyframe({ time : 43840, value : 0,interpolation : Interpolation.hold}),
					  Keyframe({ time : 44130, value : 1,interpolation : Interpolation.hold}),
					  Keyframe({ time : 44420, value : 0,interpolation : Interpolation.hold}),
					  Keyframe({ time : 44710, value : 1,interpolation : Interpolation.hold}),
					  Keyframe({ time : 45000, value : 0,interpolation : Interpolation.hold})
				  	]
				})
			}
		})
	]
});

//小菊花
ED.ShowComp.kikuri=
Composition(
{
	width : 1280,
	height : 720,

	startTime: 45000,
	duration: 250000-45000,

	layers :
	[
		Layer(
		{
			source :  Anchor(
			{
				source:function()
				{
					var unitBar = Shape();
					unitBar.graphics.beginFill(0x000000);
					unitBar.graphics.drawRect( 0, 0, 50, 10);
					unitBar.graphics.endFill();
					return unitBar ;					
				}(),
				x:-40


			}),

			inPoint: 45000,
			outPoint: 47200,

			properties:
			{
				x:640,
				y:360,
				rotationZ:1/12*360,

				alpha: KeyframesBind(
				{
					keyframes :
					[
					  Keyframe({ time : 45000, value : 0}),
					  Keyframe({ time : 45500, value : 1 }),
					  Keyframe({ time : 46000, value : 0 }),
					  Keyframe({ time : 46500, value : 1}),
					  Keyframe({ time : 47000, value : 0 }),
					  Keyframe({ time : 47200, value : 0.4})

					]
				})
			}
		}),

		Layer(
		{
			source :  Anchor(
			{
				source:function()
				{
					var unitBar = Shape();
					unitBar.graphics.beginFill(0x000000);
					unitBar.graphics.drawRect( 0, 0, 50, 10);
					unitBar.graphics.endFill();
					return unitBar ;					
				}(),
				x:-40

			}),

			inPoint: 45000,
			outPoint: 47200,

			properties:
			{
				x:640,
				y:360,
				rotationZ:2/12*360,
				alpha: KeyframesBind(
				{
					keyframes :
					[
					  Keyframe({ time : 45000, value : 0.2 }),
					  Keyframe({ time : 45400, value : 1 }),
					  Keyframe({ time : 45900, value : 0 }),
					  Keyframe({ time : 46400, value : 1}),
					  Keyframe({ time : 46900, value : 0 }),
					  Keyframe({ time : 47200, value : 0.6})

					]
				})				
			}
		}),	
	
		Layer(
		{
			source :  Anchor(
			{
				source:function()
				{
					var unitBar = Shape();
					unitBar.graphics.beginFill(0x000000);
					unitBar.graphics.drawRect( 0, 0, 50, 10);
					unitBar.graphics.endFill();
					return unitBar ;					
				}(),
				x:-40

			}),
			inPoint: 45000,
			outPoint: 47200,

			properties:
			{
				x:640,
				y:360,
				rotationZ:3/12*360,
				alpha: KeyframesBind(
				{
					keyframes :
					[
					  Keyframe({ time : 45000, value : 0.4 }),
					  Keyframe({ time : 45300, value : 1 }),
					  Keyframe({ time : 45800, value : 0 }),
					  Keyframe({ time : 46300, value : 1}),
					  Keyframe({ time : 46800, value : 0 }),
					  Keyframe({ time : 47200, value : 0.8})

					]
				})				
			}
		}),	
		Layer(
		{
			source :  Anchor(
			{
				source:function()
				{
					var unitBar = Shape();
					unitBar.graphics.beginFill(0x000000);
					unitBar.graphics.drawRect( 0, 0, 50, 10);
					unitBar.graphics.endFill();
					return unitBar ;					
				}(),
				x:-40


			}),

			inPoint: 45000,
			outPoint: 47200,

			properties:
			{
				x:640,
				y:360,
				rotationZ:4/12*360,
				alpha: KeyframesBind(
				{
					keyframes :
					[
					  Keyframe({ time : 45000, value : 0.6}),
					  Keyframe({ time : 45200, value : 1 }),
					  Keyframe({ time : 45700, value : 0 }),
					  Keyframe({ time : 46200, value : 1}),
					  Keyframe({ time : 46700, value : 0 }),
					  Keyframe({ time : 47200, value : 1})
					]
				})		
			}
		}),	

		Layer(
		{
			source :  Anchor(
			{
				source:function()
				{
					var unitBar = Shape();
					unitBar.graphics.beginFill(0x000000);
					unitBar.graphics.drawRect( 0, 0, 50, 10);
					unitBar.graphics.endFill();
					return unitBar ;					
				}(),
				x:-40
				

			}),

			inPoint: 45000,
			outPoint: 47200,

			properties:
			{
				x:640,
				y:360,
				rotationZ:5/12*360,
				alpha: KeyframesBind(
				{
					keyframes :
					[
					  Keyframe({ time : 45000, value : 0.8}),
					  Keyframe({ time : 45100, value : 1 }),
					  Keyframe({ time : 45600, value : 0 }),
					  Keyframe({ time : 46100, value : 1}),
					  Keyframe({ time : 46600, value : 0 }),
					  Keyframe({ time : 47100, value : 1}),
					  Keyframe({ time : 47200, value : 0.2})
					]
				})	
			}
		}),	

		Layer(
		{
			source :  Anchor(
			{
				source:function()
				{
					var unitBar = Shape();
					unitBar.graphics.beginFill(0x000000);
					unitBar.graphics.drawRect( 0, 0, 50, 10);
					unitBar.graphics.endFill();
					return unitBar ;					
				}(),
				x:-40
				

			}),

			inPoint: 45000,
			outPoint: 47200,

			properties:
			{
				x:640,
				y:360,
				rotationZ:6/12*360,
				alpha: KeyframesBind(
				{
					keyframes :
					[
					  Keyframe({ time : 45000, value : 0.2 }),
					  Keyframe({ time : 45500, value : 0.2 }),
					  Keyframe({ time : 45900, value : 1 }),
					  Keyframe({ time : 46400, value : 0}),
					  Keyframe({ time : 46900, value : 1 }),
					  Keyframe({ time : 47200, value : 0.4})

					]
				})
			}
		}),	

		Layer(
		{
			source :  Anchor(
			{
				source:function()
				{
					var unitBar = Shape();
					unitBar.graphics.beginFill(0x000000);
					unitBar.graphics.drawRect( 0, 0, 50, 10);
					unitBar.graphics.endFill();
					return unitBar ;					
				}(),
				x:-40
				

			}),

			inPoint: 45000,
			outPoint: 47200,

			properties:
			{
				x:640,
				y:360,
				rotationZ:7/12*360,
				alpha: KeyframesBind(
				{
					keyframes :
					[
					  Keyframe({ time : 45000, value : 0.2 }),
					  Keyframe({ time : 45700, value : 0.2 }),
					  Keyframe({ time : 46200, value : 1}),
					  Keyframe({ time : 46700, value : 0}),
					  Keyframe({ time : 47200, value : 1 })

					]
				})				
			
			}
		}),	

		Layer(
		{
			source :  Anchor(
			{
				source:function()
				{
					var unitBar = Shape();
					unitBar.graphics.beginFill(0x000000);
					unitBar.graphics.drawRect( 0, 0, 50, 10);
					unitBar.graphics.endFill();
					return unitBar ;					
				}(),
				x:-40
				

			}),

			inPoint: 45000,
			outPoint: 47200,

			properties:
			{
				x:640,
				y:360,
				rotationZ:8/12*360,
				alpha: KeyframesBind(
				{
					keyframes :
					[
					  Keyframe({ time : 45000, value : 0.2 }),
					  Keyframe({ time : 45900, value : 0.2 }),
					  Keyframe({ time : 46300, value : 1 }),
					  Keyframe({ time : 46800, value : 0}),
					  Keyframe({ time : 47200, value : 0.8 })
					]
				})
			}
		}),	

		Layer(
		{
			source :  Anchor(
			{
				source:function()
				{
					var unitBar = Shape();
					unitBar.graphics.beginFill(0x000000);
					unitBar.graphics.drawRect( 0, 0, 50, 10);
					unitBar.graphics.endFill();
					return unitBar ;					
				}(),
				x:-40
				

			}),

			inPoint: 45000,
			outPoint: 47200,

			properties:
			{
				x:640,
				y:360,
				rotationZ:8/12*360,
				alpha: KeyframesBind(
				{
					keyframes :
					[
					  Keyframe({ time : 45000, value : 0.2}),
					  Keyframe({ time : 46100, value : 0.2 }),
					  Keyframe({ time : 46500, value : 1 }),
					  Keyframe({ time : 47000, value : 0}),
					  Keyframe({ time : 47200, value : 0.4 })
					]
				})	
			}
		}),	

		Layer(
		{
			source :  Anchor(
			{
				source:function()
				{
					var unitBar = Shape();
					unitBar.graphics.beginFill(0x000000);
					unitBar.graphics.drawRect( 0, 0, 50, 10);
					unitBar.graphics.endFill();
					return unitBar ;					
				}(),
				x:-40
				

			}),

			inPoint: 45000,
			outPoint: 47200,

			properties:
			{
				x:640,
				y:360,
				rotationZ:9/12*360,
				alpha: KeyframesBind(
				{
					keyframes :
					[
					  Keyframe({ time : 45000, value : 0.2}),
					  Keyframe({ time : 46300, value : 0.2 }),
					  Keyframe({ time : 46700, value : 1}),
					  Keyframe({ time : 47200, value : 0})
					]
				})	
			}
		}),

		Layer(
		{
			source :  Anchor(
			{
				source:function()
				{
					var unitBar = Shape();
					unitBar.graphics.beginFill(0x000000);
					unitBar.graphics.drawRect( 0, 0, 50, 10);
					unitBar.graphics.endFill();
					return unitBar ;					
				}(),
				x:-40
				

			}),

			inPoint: 45000,
			outPoint: 47200,

			properties:
			{
				x:640,
				y:360,
				rotationZ:10/12*360,
				alpha: KeyframesBind(
				{
					keyframes :
					[
					  Keyframe({ time : 45000, value : 0.2 }),
					  Keyframe({ time : 46500, value : 0.2 }),
					  Keyframe({ time : 46900, value : 1 }),
					  Keyframe({ time : 47200, value : 0.6})
					]
				})
			}
		}),	

		Layer(
		{
			source :  Anchor(
			{
				source:function()
				{
					var unitBar = Shape();
					unitBar.graphics.beginFill(0x000000);
					unitBar.graphics.drawRect( 0, 0, 50, 10);
					unitBar.graphics.endFill();
					return unitBar ;					
				}(),
				x:-40
				

			}),

			inPoint: 45000,
			outPoint: 47200,

			properties:
			{
				x:640,
				y:360,
				rotationZ:11/12*360,
				alpha: KeyframesBind(
				{
					keyframes :
					[
					  Keyframe({ time : 45000, value : 0.2 }),
					  Keyframe({ time : 46700, value : 0.2 }),
					  Keyframe({ time : 47100, value : 1 }),
					  Keyframe({ time : 47200, value : 0.2})
					]
				})	
			}
		}),	

		Layer(
		{
			source :  Anchor(
			{
				source:function()
				{
					var unitBar = Shape();
					unitBar.graphics.beginFill(0x000000);
					unitBar.graphics.drawRect( 0, 0, 50, 10);
					unitBar.graphics.endFill();
					return unitBar ;					
				}(),
				x:-40
				

			}),

			inPoint: 45000,
			outPoint: 47200,

			properties:
			{
				x:640,
				y:360,
				rotationZ:12/12*360,
				alpha: KeyframesBind(
				{
					keyframes :
					[
					  Keyframe({ time : 45000, value : 0.2 }),
					  Keyframe({ time : 46900, value : 0.2 }),
					  Keyframe({ time : 47200, value : 0.8 })

					]
				})
			}
		}),	
	]
});


//原part2 播放器上的话
var broadcaster_word=
function(text,inpoint,outpoint,xposition,yposition,textColor,fz)
{
	return Composition(
	{
		width : 1280,
		height : 720,

		startTime : inpoint,
		duration : outpoint-inpoint,

		layers :
		[
			DynamicVectorTextLayer(
			{
				font : ED.FontLast.PartPlayer,
				inPoint : inpoint,
				outPoint : outpoint,

				properties :
				{
				  x:xposition,
				  y:yposition,

			  	//  filters :[$.createGlowFilter(0, 45, 0xffffff, 1, 18, 18, 10, 3)],				  

				  alpha: KeyframesBind(
			  	  {
					keyframes :
					[
					  Keyframe({ time : inpoint , value : 0, interpolation : Interpolation.linear }),
					  Keyframe({ time : inpoint+500, value : 1, interpolation : Interpolation.hold }),
					  Keyframe({ time : outpoint-500, value : 1, interpolation : Interpolation.linear }),
					  Keyframe({ time : outpoint,value:0,interpolation : Interpolation.linear })
					  ]
				  })
				},

				textProperties : 
				{
				  fontSize : fz,
				  text : text,
				  glyphFillColor:textColor
				}
			})
		]
	});
};

//以下是播放器上的蓝白logo
ED.ShowComp.broadcaster_logo =
Composition(
{
	width : 1280,
	height : 720,

	startTime : 126700,
	duration : 250000-126700,

	layers :
	[
		Layer(
		{
			source:  ED.Shapes_1.Part2["part3_logo"] ,

			inPoint: 126700,
			outPoint: 137000,

			properties :
			{
				x:800,
				y:200,
				scaleX:1.2,
				scaleY:1.2,

				alpha : KeyframesBind(
			  	{
					keyframes :
					[
				  		Keyframe({ time : 126700 , value : 0, interpolation : Interpolation.linear }),
				 		Keyframe({ time : 127200, value : 1, interpolation : Interpolation.hold }),
				  		Keyframe({ time : 136500, value : 1, interpolation : Interpolation.linear }),
				  		Keyframe({ time : 137000, value : 0, interpolation : Interpolation.linear })
				  	]
				})
			}		
		})
	]		
});

/*******************************************************************************************/

	//这个是staff上的图片层数组。Layer类
ED.PhotoLayerArray = 
	[
	  {//UHI 0
	  source :  
	 function(){
			 var shp = Shape();
			 if( $G._("OP.Pic")  )
			 {
			 	$G._("OP.Pic")(shp.graphics);
		 	}else
		 	{
			  shp.graphics.beginGradientFill( "linear", [ 0x66ccff, 0x00ffcc, 0x404040 ], [ 1, 1, 1 ], [ 0, 128, 255 ], $.createGradientBox( 500, 330, Math.PI/4, 0, 0 ) );
			  shp.graphics.drawRect( -100, -100, 600, 530 );
			};
			  shp.graphics.endFill();
			  return shp;
			  }(),
	  properties : 
			  {
				x : -60,
				y : 20,
				scaleY : 0.7,
				scaleX : 0.7
			  }
	  },
	  {//955 1
	  source :  ED.Shapes_1.StaffPic["m7_1"]
	  },
	  {//凉月奏2
	  source :  ED.Shapes_1.StaffPic["m7_3"]/*function()
	  {
	  	var canvas = Sprite();
	  canvas.addChild();
	  var txt = TextField({text : "遥 控 器" , fontsize : 48 , font : "KaiTi" , x : 320 , y : 300 ,color : 0xffffff});
	 // txt.blendMode = "invert";
	 // canvas.addChild(txt);
	  return canvas;
	  	}()*/
	  },
	  {//三倍速3
	  source :  ED.Shapes_1.StaffPic["m7_2"]
	  },
	  {//YS4
	  source :  ED.Shapes_1.StaffPic["m8_1"](),
	  properties : 
			  {
				x : 10,
				y : 40,
				scaleX : 0.55,
				scaleY :0.55
			  }
	  },
	  {//时空游客5
	  source :  function(){
				 var shp = Shape();
			  shp.graphics.beginGradientFill( "linear", [ 0x66ccff, 0x88ddff, 0xffffff ], [ 1, 1, 1 ], [ 0, 128, 255 ], $.createGradientBox( 500, 330, Math.PI/4, 0, 0 ) );
			  shp.graphics.drawRect( -100, -100, 600, 530 );
			  shp.graphics.endFill();
			  return shp;
			  }(),
	  properties : 
			  {
				x : 20,
				y : 20
			  }
	  },
	  {//EPM6
	  source : 
	  	 function(){
	  	 	var shp = Shape();
			  shp.graphics.beginGradientFill( "linear", [ 0xfefefe, 0xfafafa, 0x404040 ], [ 1, 1, 1 ], [ 0, 128, 255 ], $.createGradientBox( 1280, 720, Math.PI/4, 0, 0 ) );
			  shp.graphics.drawRect( -100, -100, 1280, 720 );
			 if( $G._("SNW.Pic")  )
			 {
			 	shp.graphics.copyFrom( ($G._("SNW.Pic")).graphics ) ;
		 	};
			  shp.graphics.endFill();
			  return shp;
			  }(),
	  properties : 
			  {
				x : 20,
				y : 20,
				scaleX : 0.6,
				scaleY : 0.6
			  }
	  },
	  {//ED7
	  source : ED.Shapes_1.StaffPic["ed"],
	  properties : 
			  {
				x : 40,
				y : 80,
				scaleX : 0.83,
				scaleY : 0.83
			  }
	  }
	];
	var PhotoComp = function(isDirection , PhotoLayer){
	  return  Composition(
		{
		  width : 540,
		  height : 390,

		  startTime : 0,
		  duration : 14000,
		  layers :
		  [
			Layer(
			{
			  source : function()
			  {
				var sp = Shape();
				var g = sp.graphics;
				g.beginFill(0xfefefe);
				g.drawRect(0,0,540,390);
/*				g.beginFill(0x666666);
				g.drawRect(0,10,540,10);
				g.drawRect(0,370,540,10);
				g.drawRect(0,0,10,390);
				g.drawRect(530,0,10,390);*/
				g.beginFill( getRandomHex() );
				g.drawRect(0,0,540,10);
				g.drawRect(0,380,540,10);

				return sp;
				}() ,
			  inPoint : 0,
			  outPoint : 14000,
			  properties : 
			  {
				filters : [$.createDropShadowFilter(8 , isDirection ? 135 : 45 , 0 , 0.7) ]
			  }
			}),
		   TrackMatte({
			  layer :  Layer(
			{
			  source :  PhotoLayer.source ,
			  inPoint : 0,
			  outPoint : 14000,
			  properties : PhotoLayer.properties
			}),
			  mask : Layer(
			{
			  source :  function(){
			  var shp2 = Shape();
			  shp2.graphics.beginFill(0xFFFFFF);
			  shp2.graphics.drawRoundRect( 20, 20, 500, 340 , 80 ,80);
			  shp2.graphics.endFill();
			  return shp2;
			  }(),
			  inPoint : 0,
			  outPoint : 14000
			})
			   })
		  ]
		});
	};   

var singleStaffComp = function(inPoint , ot,isDirection, providerComp, x,text){
	//var outPoint = outPoint ;
	 //var inPoint = 0;
	  return Composition({
		  width : 1280,
		  height : 720,
		  startTime : inPoint,
		  duration : ot - inPoint,
		  layers :
		  [
			DynamicSourceLayer(
			{
			  provider : providerComp,
			  inPoint : inPoint  ,
			  outPoint : ot,
			  properties : 
			  {
				x : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : inPoint, value : (isDirection ? 40 : 680), interpolation : Interpolation.linear }),
				  Keyframe({ time : (ot - 400), value : (isDirection ? 80 : 640), interpolation : Interpolation.cubic.easeIn }),
				  Keyframe({ time : ot, value : (isDirection ? 100 : 620), interpolation : Interpolation.cubic.easeOut })
				  ]
				}),
				 alpha : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : inPoint , value : 0, interpolation : Interpolation.linear }),
				  Keyframe({ time : inPoint+ 300, value : 1, interpolation : Interpolation.linear }),
				  Keyframe({ time : (ot - 400), value : 1, interpolation : Interpolation.linear }),
				  Keyframe({ time : ot, value : 0, interpolation : Interpolation.linear })
				  ]
				}),
				y : 100
			  }
			}),
		  DynamicVectorTextLayer({
			font : ED.FontLast.PartStaff,
			inPoint : inPoint,
			outPoint : ot,
			 properties :
			 {
			  x : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : inPoint, value : x, interpolation : Interpolation.linear }),
				  Keyframe({ time : (ot - 400), value : (isDirection ? x-40 : x+40), interpolation : Interpolation.cubic.easeIn }),
				  Keyframe({ time : ot, value : (isDirection ? x-60 : x+60), interpolation : Interpolation.cubic.easeOut })
				  ]
				}),
				 alpha : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : inPoint , value : 0, interpolation : Interpolation.linear }),
				  Keyframe({ time :  300, value : 1, interpolation : Interpolation.linear }),
				  Keyframe({ time : (ot - 400), value : 1, interpolation : Interpolation.linear }),
				  Keyframe({ time : ot, value : 0, interpolation : Interpolation.linear })
				  ]
				}),
			  y : 470,
			  "transform.colorTransform" : Color.rgbToTransformTint( [ 1, 0, 0, 0 ] ),
			  filters : [$.createDropShadowFilter(5 , (isDirection ? 45 : 135)  , getRandomHex() , 0.7) ]
			 },
			 textProperties : 
			{
			  horizontalAlign : "left",
			  verticalAlign : "center",
			  fontSize : 40,
			  text : text
			}
			})
		  ]
	  });
	};
ED.ShowComp.PartStaff = 
Composition({
			width : 1280,
		  height : 720,

		  startTime : 0,
		  duration : 250000,
		 	layers :
		 	[
			DynamicSourceLayer(
			{
			  //53830 58100 103300 108700 113900 119000 124400 129800 134300 141200
			  provider : singleStaffComp(53930 , 58900 , true,PhotoComp(true, ED.PhotoLayerArray[0] )  ,720,"蓝白OP：\n《tell Your World》\n弹幕：UHi\n素材画师：阿香\n特别感谢：Akaru") ,
			  inPoint : 53930,
			  outPoint : 58900 
			}),
			DynamicSourceLayer(
			{
			  //106679 - 136000 - 191250
			  provider : singleStaffComp(58900 , 63300 , false,PhotoComp(false, ED.PhotoLayerArray[1]),200,"特殊弹幕组：\n《track》\n弹幕：⑨55") ,
			  inPoint : 58900,
			  outPoint : 63300 
			}),
			DynamicSourceLayer(
			{
			  //106679 - 136000 - 191250
			  provider : singleStaffComp(63300 , 68700 , true,PhotoComp(true, ED.PhotoLayerArray[2]),800,"特殊弹幕组：\n《リモコン》\n弹幕：凉月奏") ,
			  inPoint : 63300,
			  outPoint : 68700 
			}),
			DynamicSourceLayer(
			{
			  //106679 - 136000 - 191250
			  provider : singleStaffComp(68700 , 73900 , false,PhotoComp(false, ED.PhotoLayerArray[3]),80,"特殊弹幕组：\n《ロストワンの号哭》\n弹幕：三倍速法兰西") ,
			  inPoint : 68700,
			  outPoint : 73900 
			}),
			DynamicSourceLayer(
			{
			  //106679 - 136000 - 191250
			  provider : singleStaffComp(73900 , 79000 , true,PhotoComp(true, ED.PhotoLayerArray[4]),700,"代码弹幕组：\n《Sister's Noise》\n弹幕：Yringsing") ,
			  inPoint : 73900,
			  outPoint : 79000 
			}),
			DynamicSourceLayer(
			{
			  //106679 - 136000 - 191250
			  provider : singleStaffComp(79000 , 84400 , false,PhotoComp(false, ED.PhotoLayerArray[5]),150,"代码弹幕组：\n《Brave Heart》\n弹幕：时空游客") ,
			  inPoint : 79000,
			  outPoint : 84400 
			}),
			DynamicSourceLayer(
			{
			  //106679 - 136000 - 191250
			  provider : singleStaffComp(84400 , 89800 ,true, PhotoComp(true, ED.PhotoLayerArray[6]),740,"代码弹幕组：\n《Shining World》\n弹幕：EPM\n素材画师：炙爱小爱") ,
			  inPoint : 84400,
			  outPoint : 89800
			}),
			DynamicSourceLayer(
			{
			  //106679 - 136000 - 191250
			  provider : singleStaffComp(89800 , 94300 , false,PhotoComp(false, ED.PhotoLayerArray[7]),100,"蓝白ED：《福笑い》\n弹幕：\n麦子、面汤拌菜菌\n素材画师：鱼火锅、Meltdown_\nED协力：奇迹の海") ,
			  inPoint : 89800,
			  outPoint : 94300 
			}),
			DynamicVectorTextLayer({
			font : ED.FontLast.PartStaff,
			inPoint : 94300,
			outPoint : 101500,
			 properties :
			 {
			  x : 300,
				 alpha : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 94300 , value : 0, interpolation : Interpolation.linear }),
				  Keyframe({ time :  94300+300, value : 1, interpolation : Interpolation.linear }),
				  Keyframe({ time : (101500 - 400), value : 1, interpolation : Interpolation.linear }),
				  Keyframe({ time : 101500, value : 0, interpolation : Interpolation.linear })
				  ]
				}),
			  y : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 94300, value : 380, interpolation : Interpolation.linear }),
				  Keyframe({ time : (101500 - 400), value : 360, interpolation : Interpolation.cubic.easeIn }),
				  Keyframe({ time : 101500, value : 350, interpolation : Interpolation.cubic.easeOut })
				  ]
				}),
			  "transform.colorTransform" : Color.rgbToTransformTint( [ 1, 0, 0, 0 ] ),
			  filters : [$.createDropShadowFilter(5 , 45, getRandomHex() , 0.7) ]
			 },
			 textProperties : 
			{
			  horizontalAlign : "left",
			  verticalAlign : "center",
			  lineHeight : 60,
			  fontSize : 40,
			  text : "策划、统筹：面汤拌菜菌\n音视频：面汤拌菜菌\nB站话题、封面：Encode.X\ncm制作：毛酱\n弹幕双子人设：Morchi毛毛"
			}
			}),
	DynamicVectorTextLayer({
			font : ED.FontLast.PartStaff,
			inPoint : 101500,
			outPoint : 106000,
			 properties :
			 {
			  x : 200,
				 alpha : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 101500 , value : 0, interpolation : Interpolation.linear }),
				  Keyframe({ time :  101500+300, value : 1, interpolation : Interpolation.linear }),
				  Keyframe({ time : (106000 - 400), value : 1, interpolation : Interpolation.linear }),
				  Keyframe({ time : 106000, value : 0, interpolation : Interpolation.linear })
				  ]
				}),
			  y : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 101500, value : 380, interpolation : Interpolation.linear }),
				  Keyframe({ time : (106000 - 400), value : 360, interpolation : Interpolation.cubic.easeIn }),
				  Keyframe({ time : 106000, value : 350, interpolation : Interpolation.cubic.easeOut })
				  ]
				}),
			  "transform.colorTransform" : Color.rgbToTransformTint( [ 1, 0, 0, 0 ] ),
			  filters : [$.createDropShadowFilter(5 , 45, getRandomHex() , 0.7) ]
			 },
			 textProperties : 
			{
			  horizontalAlign : "left",
			  verticalAlign : "center",
			  lineHeight : 55,
			  fontSize : 40,
			  text :"赞助：白龙舞兮云飞扬\n技术支持：nekofs、KPX、UHi\n萌力支持：黑岩镜\n协力：ABZ  初音の消失  Dreamon  Devl \n大吃货焦糖桑  河童子  静之籁  沁沁 \nStar寒雨  XiaoLLK  小包子  妖刀罪歌  云雀"
			}
			})
		 	]

	});

//-----------------------------------------------------------------------------

ED.ShowComp.Part3 = 
Composition(
{
	width : 1280,
	height : 720,

	startTime : 0,
	duration : 250000,
	layers :
	[
		DynamicSourceLayer(
		{
		  provider : broadcaster_word("神弹幕 好厉害",106000,112000,800,260,0x333333,25) ,
		  inPoint : 106000,
		  outPoint : 112000
		}),
		DynamicSourceLayer(
		{
		  provider : broadcaster_word("字幕GJ",106000,112000,780,220,0x444444,20) ,
		  inPoint : 106000,
		  outPoint : 112000
		}),
		DynamicSourceLayer(
		{
		  provider : broadcaster_word("感谢字幕君",106000,112000,800,350,0x444444,35) ,
		  inPoint : 106000,
		  outPoint : 112000
		}),
		DynamicSourceLayer(
		{
		   provider : broadcaster_word("我\n是\n竖\n排\n弹\n幕",112000,117000,800,150,0x444444,25) ,
		  inPoint : 112000,
		  outPoint : 117000
		}),
		DynamicSourceLayer(
		{
		   provider : broadcaster_word("我来挡字幕",112000,117000,860,400,0x444444,25) ,
		  inPoint : 112000,
		  outPoint : 117000
		}),
		DynamicSourceLayer(
		{
		  provider : broadcaster_word("ERROR",117000,122000,800,350,0x666666,35) ,
		  inPoint : 117000,
		  outPoint : 122000
		}),
		DynamicSourceLayer(
		{
		  provider : broadcaster_word("弹幕无法发送",117000,122000,700,210,0x444444,20) ,
		  inPoint : 117000,
		  outPoint : 122000
		}),
		DynamicSourceLayer(
		{
		  provider : broadcaster_word("无法连接弹幕服务器",117000,122000,720,270,0xff0000,35) ,
		  inPoint : 117000,
		  outPoint : 122000
		}),
		DynamicSourceLayer(
		{
		  provider : broadcaster_word("意义不明 \n\n\n什么玩意",122000,126700,880,220,0x444444,25) ,
		  inPoint : 122000,
		  outPoint : 126700
		}),		 
		DynamicSourceLayer(
		{
		  provider : broadcaster_word("高级弹幕根本不是弹幕",122000,126700,680,270,0x333333,30) ,
		  inPoint : 122000,
		  outPoint : 126700
		}),		
		DynamicSourceLayer(
		{
		  provider : ED.ShowComp.part2_word ,
		  inPoint : 106000,
		  outPoint : 250000
		}),
		DynamicSourceLayer(
		{
		  provider : ED.ShowComp.broadcaster_logo,
		  inPoint : 126700,
		  outPoint : 250000
		}),
		DynamicSourceLayer(
		{
		  provider : ED.ShowComp.Part2 ,
		  inPoint : 106000,
		  outPoint : 250000
		}),	
		DynamicSourceLayer(
		{
		  provider : ED.ShowComp.teleV ,
		  inPoint : 42100,
		  outPoint : 250000
		}),
		DynamicSourceLayer(
		{
		  provider : ED.ShowComp.kikuri ,
		  inPoint : 45000,
		  outPoint : 250000
		})
	]
});

ED.ShowComp.BGComp3 = Composition(
	{
		  width : 1280,
		  height : 720,

		  startTime : 0,
		  duration : 250000,

		  layers :
		  [ 
		  Layer(
		  {
			inPoint : 18000,
			outPoint : 21000,
			source : Solid({width : 1280 ,height : 720 ,color : 0}),
				properties :
				{
				alpha : KeyframesBind(
			  	{
					keyframes :
					[
						Keyframe({ time : 18000, value : 0, interpolation : Interpolation.linear }),
				 		Keyframe({ time : 19000, value : 1, interpolation : Interpolation.linear }),
				  		Keyframe({ time : 21000, value : 0, interpolation : Interpolation.linear })
				  	]
				})
			}
		  }),
		  Layer(
		  {
			inPoint : 52100,
			outPoint : 53900,
			source : Solid({width : 1280 ,height : 720 ,color : 0}),
				properties :
				{
				alpha : KeyframesBind(
			  	{
					keyframes :
					[
				  		Keyframe({ time : 52100 , value : 0, interpolation : Interpolation.linear }),
				 		Keyframe({ time : 53100, value : 1, interpolation : Interpolation.linear }),
				  		Keyframe({ time : 53900, value : 0, interpolation : Interpolation.linear })
				  	]
				})
			}
		  }),
		  Layer(
		  {
			inPoint : 105400,
			outPoint : 107100,
			source : Solid({width : 1280 ,height : 720 ,color : 0xFFFFFF}),
				properties :
				{
				alpha : KeyframesBind(
			  	{
					keyframes :
					[
				  		Keyframe({ time : 104700 , value : 0, interpolation : Interpolation.linear }),
				 		Keyframe({ time : 106100, value : 0.7, interpolation : Interpolation.linear }),
				  		Keyframe({ time : 107100, value : 0, interpolation : Interpolation.linear })
				  	]
				}),
				blendMode : "add"
			}
		  }),
		  Layer(
		  {
			inPoint : 136500,
			outPoint : 138100,
			source : Solid({width : 1280 ,height : 720 ,color : 0}),
				properties :
				{
				alpha : KeyframesBind(
			  	{
					keyframes :
					[
				  		Keyframe({ time : 136500 , value : 0, interpolation : Interpolation.linear }),
				 		Keyframe({ time : 137500, value : 1, interpolation : Interpolation.linear }),
				  		Keyframe({ time : 137800, value : 1, interpolation : Interpolation.linear })
				  	]
				})
			}
		  }),
		  		  Layer(
		  {
			inPoint : 137800,
			outPoint : 138800,
			source : Solid({width : 1280 ,height : 720 ,color : 0xFFFFFF}),
				properties :
				{
				alpha : KeyframesBind(
			  	{
					keyframes :
					[
				  		Keyframe({ time : 138100 , value : 0.7, interpolation : Interpolation.linear }),
				 		Keyframe({ time : 138800, value : 0, interpolation : Interpolation.linear })
				  	]
				}),
				blendMode : "add"
			}
		  })
		  ]
		});
/*****************************************************************************
partMel
******************************************************************************/
//白闪
ED.ShowComp.blink=
Composition(
{
	width : 1280,
    height : 720,

    startTime : 165000,
    duration : 250000-165000,
    layers:
    [
    	Layer(
    	{
    		source: Solid({ width : 1280, height : 720, color : 0xFFFFFF }),
    		inPoint: 165000,
			outPoint: 165500,

			properties:
			{
				blendMode:"overlay",
				alpha:0.8
			}
    	})
    ]

});

//开盒子
ED.ShowComp.boxItem=function()
{
	var rand = Akari.Utilities.Randomizer.createTwister( 3141592 );
  	return Composition(
	{
		width:1280,
		height:720,

		startTime : 164000,
		duration : 250000-164000,

		layers :
		[ 	//多边形（其实就是三角和正方形）Algorithm based on EPM
			Factory.replicate( Layer, 30, function(id)
			{
				var startTime=rand.integer(164000,190000);
				var duration=rand.integer(500,3000);
				var endTime=startTime+duration;
				var xpo=rand.integer( 0, 1280 );
				var yOffset=rand.uniform()*200;
				var rotaSpeed=rand.uniform();
				var size = id * 4 ;

				var edges=rand.integer(3,5);
				var polygon= Shape();
				polygon.graphics.beginFill(0xff0000*rand.uniform());
       			polygon.graphics.moveTo( size, 0 );
        		polygon.graphics.lineStyle( 1, 0xffffff );

        		for ( var i = edges; i --; )
		        {
		          var ang = i * 2 * Math.PI / edges;
		          polygon.graphics.lineTo( Math.cos( ang ) * size, Math.sin( ang ) * size );
		        }
		        polygon.graphics.endFill();

				return
				[{
					source : polygon,
				  	inPoint : startTime,
				  	outPoint : endTime,
				  	properties :
				 	{
						filters : [ $.createBlurFilter(8, 8, 2) ],


						x:KeyframesBind(
				  		{
							keyframes :
							[
							  Keyframe({ time : startTime, value : 580, interpolation : Interpolation.cubic.easeInOut }),
							  Keyframe({ time : endTime, value : xpo , interpolation : Interpolation.cubic.easeInOut })
							]
						}),
						y:KeyframesBind(
				  		{
							keyframes :
							[
							  Keyframe({ time : startTime, value : 550, interpolation : Interpolation.cubic.easeInOut }),
							  Keyframe({ time : endTime, value : -yOffset , interpolation : Interpolation.cubic.easeInOut })
							]
						}),

						rotationZ:function(time)
						{
							return time*rotaSpeed;
						},

						rotationX:function(time)
						{
							return time*rotaSpeed;
						}					
					}
				}];
			}),
			//圆
			Factory.replicate( Layer, 50, function()
			{
				var startTime=rand.integer(164000,190000);
				var duration=rand.integer(500,3000);
				var endTime=startTime+duration;
				var xpo=rand.integer( 0, 1280 );
				var yOffset=rand.uniform()*200;
				var rotaSpeed=rand.uniform();

				var circles= Shape();
				circles.graphics.beginFill(0xffffff*rand.uniform());
       			circles.graphics.drawCircle( 0,0, rand.integer(5,30) );
        		circles.graphics.lineStyle( rand.integer( 4, 8 ), 0xffffff );
		        circles.graphics.endFill();

				return
				[{
					source : circles,
				  	inPoint : startTime,
				  	outPoint : endTime,
				  	properties :
				 	{
						filters : [ $.createBlurFilter(16,16,1) ],


						x:KeyframesBind(
				  		{
							keyframes :
							[
							  Keyframe({ time : startTime, value : 580, interpolation : Interpolation.cubic.easeInOut }),
							  Keyframe({ time : endTime, value : xpo , interpolation : Interpolation.cubic.easeInOut })
							]
						}),
						y:KeyframesBind(
				  		{
							keyframes :
							[
							  Keyframe({ time : startTime, value : 550, interpolation : Interpolation.cubic.easeInOut }),
							  Keyframe({ time : endTime, value : -yOffset , interpolation : Interpolation.cubic.easeInOut })
							]
						}),

						rotationX:function(time)
						{
							return time*rotaSpeed;
						},

						rotationY:function(time)
						{
							return time*rotaSpeed;
						}					
					}
				}];
			}),
		]
	});
};
//盒子的话
var boxWord=function(text,inpoint,outpoint,xpo,ypoS,ypoM,rotaZ,fz)
{
	return Composition(
	{
		width : 1280,
		height : 720,

		startTime : inpoint,
		duration : outpoint-inpoint,

		layers :
		[

			DynamicVectorTextLayer(
		 	{
				font : ED.FontLast.PartPlayer ,
				inPoint : inpoint,
				outPoint : outpoint,

				properties :
				{
			  		x : xpo,
			  		y : KeyframesBind(
			  		{
						keyframes :
						[
						  Keyframe({ time : inpoint+300, value : ypoM , interpolation : Interpolation.linear }),
						  Keyframe({ time : outpoint-150, value : ypoM-50, interpolation : Interpolation.linear })
						]
					}),
			  		filters :[$.createGlowFilter(0, 45, 0xffffff, 1, 18, 18, 10, 3)],
			  		alpha :	 KeyframesBind(
		  			{
						keyframes :
						[
						  Keyframe({ time : inpoint+200, value : 0, interpolation : Interpolation.linear }),
						  Keyframe({ time : inpoint+350, value : 1 , interpolation : Interpolation.linear }),
						  Keyframe({ time : outpoint-250, value : 1 , interpolation : Interpolation.linear }),
						  Keyframe({ time : outpoint-150, value : 0 , interpolation : Interpolation.linear })
						]
					}),
			  		rotationZ:rotaZ	  	
				},
				textProperties : 
				{
			  	  verticalAlign : "center",
				  fontSize : fz,
				  text : text
				}
			}),
		]
	});		
};


//纸片
var boxLetter= function(inpoint,outpoint,w,l,lx,lys,lym,rotaZ)
{
	var rand = Akari.Utilities.Randomizer.createTwister( 3141595 );
	return Composition(
	{
		width : 1280,
		height : 720,

		startTime : inpoint,
		duration : outpoint-inpoint,
		layers :
		[	
	    	Layer(
	    	{
	    		source: Anchor(
				{	
					source: function()
		    		{
		    			var letter=Shape();
		    			letter.graphics.beginGradientFill("linear",[0xffff66,0xffffcc],[1,1],[0x00,0xff],$.createGradientBox(w,l,Math.PI*0.5,0,0));
		    			letter.graphics.drawRect(0,0,w,l);
		    			letter.graphics.endFill();
		    			return letter;
		    		}(),
		    		x:w/2,
		    		y:l/2
		    	}),
	    		inPoint: inpoint,
				outPoint: outpoint,

				properties:
				{
					x:lx,
					y:KeyframesBind(
			  		{
						keyframes :
						[
						  Keyframe({ time : inpoint, value : lys, interpolation : Interpolation.linear }),
						  Keyframe({ time : inpoint+300, value : lym , interpolation : Interpolation.linear }),
						  Keyframe({ time : outpoint-300, value : lym-50, interpolation : Interpolation.linear }),
						  Keyframe({ time : outpoint, value : -300 , interpolation : Interpolation.linear })
						]
					}),
					alpha:KeyframesBind(
		  			{
						keyframes :
						[
						  Keyframe({ time : inpoint, value : 0, interpolation : Interpolation.linear}),
						  Keyframe({ time : inpoint+150, value : 1 , interpolation : Interpolation.hold }),
						  Keyframe({ time : outpoint-150, value : 1 , interpolation :Interpolation.linear}),
						  Keyframe({ time : outpoint, value : 0 , interpolation : Interpolation.linear })
						]
					}),
					rotationZ:KeyframesBind(
		  			{
						keyframes :
						[
						  Keyframe({ time : inpoint, value : rand.integer(30,360), interpolation : Interpolation.linear }),
						  Keyframe({ time : inpoint+300, value : rotaZ , interpolation : Interpolation.linear }),
						  Keyframe({ time : outpoint-150, value : rotaZ , interpolation : Interpolation.linear}),
						  Keyframe({ time : outpoint, value : rand.integer(30,360) , interpolation : Interpolation.linear })
						]
					}),
					rotationX: KeyframesBind(
		  			{
						keyframes :
						[
						  Keyframe({ time : inpoint, value : rand.integer(30,360), interpolation : Interpolation.linear }),
						  Keyframe({ time : inpoint+300, value : 0 , interpolation : Interpolation.linear }),
						  Keyframe({ time : outpoint-150, value : 0 , interpolation : Interpolation.linear }),
						  Keyframe({ time : outpoint, value : rand.integer(30,360) , interpolation : Interpolation.linear })
						]
					}),

					scaleX:KeyframesBind(
		  			{
						keyframes :
						[
						  Keyframe({ time : inpoint, value : rand.uniform(), interpolation : Interpolation.linear }),
						  Keyframe({ time : inpoint+300, value : 1 , interpolation : Interpolation.hold }),
						  Keyframe({ time : outpoint-150, value : 1 , interpolation : Interpolation.linear }),
						  Keyframe({ time : outpoint, value : 0.4 , interpolation : Interpolation.linear })
						]
					}),
					scaleY : Binder.Link({name : "scaleX"})
				}
			})
		]
	});
};



//盒子效果放入合成
ED.ShowComp.Box = 
Composition(
{
	width : 1280,
	height : 720,

	startTime : 0,
	duration : 250000,
	layers :
	[
		DynamicSourceLayer(
		{
		  //(inpoint,outpoint,w,l,lx,lys,lym,rotaZ)
		  provider : boxLetter(164000,168000,450,200,880,350,250,-15),
		  inPoint : 164000,//p5中间 2:44开始
		  outPoint : 168000
		}),		
		DynamicSourceLayer(
		{
		  //(text,inpoint,outpoint,xpo,ypoS,ypoM,rotaZ,fz)
		  provider : boxWord("黑音：用弹幕去贯彻\n   对作品满满的爱",164000,168000,680,400,300,-15,35) ,
		  inPoint : 164000,
		  outPoint : 168000
		}),

		DynamicSourceLayer(
		{
		  //(inpoint,outpoint,w,l,lx,lys,lym,rotaZ)
		  provider : boxLetter(165000,169000,450,200,300,370,270,-5),
		  inPoint : 165000,
		  outPoint : 169000
		}),	
		DynamicSourceLayer(
		{
		  //(text,inpoint,outpoint,xpo,ypoS,ypoM,rotaZ)
		  provider : boxWord("毛酱：再炫的弹幕\n也需要一颗真诚的心",165000,169000,115,360,260,-5,30) ,
		  inPoint : 165000,
		  outPoint : 169000
		}),	

		DynamicSourceLayer(
		{
		  //(inpoint,outpoint,w,l,lx,lys,lym,rotaZ)
		  provider : boxLetter(167500,172500,540,150,880,600,500,-20),
		  inPoint : 167500,
		  outPoint : 172500
		}),
		DynamicSourceLayer(
		{
		  //(text,inpoint,outpoint,xpo,ypoS,ypoM,rotaZ,fz)
		  provider : boxWord("光驱：trace('有志者事竞成');",167500,172500,630,700,600,-20,30) ,
		  inPoint : 167500,
		  outPoint : 172500
		}),	

		DynamicSourceLayer(
		{
		  //(inpoint,outpoint,w,l,lx,lys,lym,rotaZ)
		  provider : boxLetter(167500,172500,650,200,840,380,280,-20),
		  inPoint : 167500,
		  outPoint : 172500
		}),

		DynamicSourceLayer(
		{
		  //(text,inpoint,outpoint,xpo,ypoS,ypoM,rotaZ,fz)
		  provider : boxWord("凉月奏：\n /"+"n/"+"n/"+"n/"+"n/"+"n/"+"n/"+"n/"+"n/"+"n勿忘初心/"+"n/"+"n/"+"n/"+"n/"+"n",167500,172500,530,460,360,-20,25) ,
		  inPoint : 167500,
		  outPoint : 172500
		}),


		DynamicSourceLayer(
		{
		  //(inpoint,outpoint,w,l,lx,lys,lym,rotaZ)
		  provider : boxLetter(168000,172000,400,400,240,500,400,-20),
		  inPoint : 168000,
		  outPoint : 172500
		}),	

		DynamicSourceLayer(
		{
		  //(text,inpoint,outpoint,xpo,ypoS,ypoM,rotaZ,fz)
		  provider : boxWord("静之籁：\n弹幕是热情\n弹幕是灵感\n弹幕是创造与收获\n弹幕是美",168000,172500,100,530,430,-20,25) ,
		  inPoint : 168000,
		  outPoint : 172500
		}),

		DynamicSourceLayer(
		{
		  //(inpoint,outpoint,w,l,lx,lys,lym,rotaZ)
		  provider : boxLetter(172000,175000,500,200,290,460,360,-20),
		  inPoint : 172000,
		  outPoint : 175000
		}),	

		DynamicSourceLayer(
		{
		  //(text,inpoint,outpoint,xpo,ypoS,ypoM,rotaZ)
		  provider : boxWord("Encode.X：未来的神弹幕\n 等待着由你来创造",172000,175000,100,540,440,-20,30) ,
		  inPoint : 172000,
		  outPoint : 175000
		}),



		DynamicSourceLayer(
		{
		  //(inpoint,outpoint,w,l,lx,lys,lym,rotaZ)
		  provider : boxLetter(172000,176000,400,400,900,600,500,15),
		  inPoint : 172000,
		  outPoint : 176000
		}),		
		DynamicSourceLayer(
		{
		  //(text,inpoint,outpoint,xpo,ypoS,ypoM,rotaZ,fz)
		  provider : boxWord("ABZ : 弹幕艺术也贵在\n 有限素材的无限可能\n  希望能洗去浮华\n   回想起小时候\n拼七巧板的奇妙心情",172000,176000,760,540,440,15,25) ,
		  inPoint : 172000,
		  outPoint : 176000
		}),

		DynamicSourceLayer(
		{
		  //(inpoint,outpoint,w,l,lx,lys,lym,rotaZ)
		  provider : boxLetter(175000,180000,500,300,350,450,350,0),
		  inPoint : 175000,
		  outPoint : 180000
		}),		
		DynamicSourceLayer(
		{
		  //(text,inpoint,outpoint,xpo,ypoS,ypoM,rotaZ,fz)
		  provider : boxWord("妖刀罪歌：\n每一条弹幕都可能\n包含着真挚的感情\n请不要复制别人的情感\n自己的爱要由自己来表达",175000,180000,130,430,330,0,25) ,
		  inPoint : 175000,
		  outPoint : 180000
		}),

		DynamicSourceLayer(
		{
		  //(inpoint,outpoint,w,l,lx,lys,lym,rotaZ)
		  provider : boxLetter(175500,180500,500,300,900,500,400,0),
		  inPoint : 175500,
		  outPoint : 180500
		}),		
		DynamicSourceLayer(
		{
		  //(text,inpoint,outpoint,xpo,ypoS,ypoM,rotaZ,fz)
		  provider : boxWord("Yringsing：\n通过弹幕可以表达\n自己的想法和心情\n无论是哪种形式的弹幕\n互相理解才是\n弹幕艺术的最高形式",175500,180500,710,600,400,0,25) ,
		  inPoint : 175500,
		  outPoint : 180500
		}),

		DynamicSourceLayer(
		{
		  //(inpoint,outpoint,w,l,lx,lys,lym,rotaZ)
		  provider : boxLetter(179000,184000,600,350,340,500,350,-5),
		  inPoint : 179000,
		  outPoint : 184000
		}),		
		DynamicSourceLayer(
		{
		  //(text,inpoint,outpoint,xpo,ypoS,ypoM,rotaZ,fz)
		  provider : boxWord("黑岩镜：\n感谢带来这场视觉盛宴的参赛人员\n以及平日里燃烧着爱与青春的字幕君们\n希望有更多的人能加入到\n这个有爱的组织中=ｗ=",179000,184000,60,470,370,-5,25) ,
		  inPoint : 179000,
		  outPoint : 184000
		}),

		DynamicSourceLayer(
		{
		  //(inpoint,outpoint,w,l,lx,lys,lym,rotaZ)
		  provider : boxLetter(18000,184500,500,250,940,600,500,5),
		  inPoint : 180000,
		  outPoint : 184500
		}),		
		DynamicSourceLayer(
		{
		  //(text,inpoint,outpoint,xpo,ypoS,ypoM,rotaZ,fz)
		  provider : boxWord("麦子SAMA：\n普权M7M8一路走来\n不变的是那份热爱\n和对弹幕之美的追求",180000,184500,750,570,470,5,25) ,
		  inPoint : 180000,
		  outPoint : 184500
		}),
		DynamicSourceLayer(
		{
		  //(inpoint,outpoint,w,l,lx,lys,lym,rotaZ)
		  provider : boxLetter(183000,187000,500,180,50+300,600+100,500,-5),
		  inPoint : 183000,
		  outPoint : 187000
		}),		
		DynamicSourceLayer(
		{
		  //(text,inpoint,outpoint,xpo,ypoS,ypoM,rotaZ,fz)
		  provider : boxWord("奇迹の海：\nremember the happniess!\nlove it and enjoy it",183000,187000,140,620,520,-5,25) ,
		  inPoint : 183000,
		  outPoint : 187000
		}),		

		DynamicSourceLayer(
		{
		  //(inpoint,outpoint,w,l,lx,lys,lym,rotaZ)
		  provider : boxLetter(184500,188000,410,320,650+250,300+250,200+250,10),
		  inPoint : 184500,
		  outPoint : 188000
		}),		
		DynamicSourceLayer(
		{
		  //(text,inpoint,outpoint,xpo,ypoS,ypoM,rotaZ,fz)
		  provider : boxWord("G线上的魔调：\n希望弹幕能越传越广\n被所有人认知认可\n未来能在电视电影\n荧幕看到无处不在~",184500,188000,750,480,380,10,25) ,
		  inPoint : 184500,
		  outPoint : 188000
		}),

		DynamicSourceLayer(
		{
		  //(inpoint,outpoint,w,l,lx,lys,lym,rotaZ)
		  provider : boxLetter(184000,188000,500,150,50+250,160+250,60+250,-5),
		  inPoint : 184000,
		  outPoint : 188000
		}),		
		DynamicSourceLayer(
		{
		  //(text,inpoint,outpoint,xpo,ypoS,ypoM,rotaZ,fz)
		  provider : boxWord("Black★Rock.Shooter：\n为有爱的作品做字幕\n其实是件幸福的事情",184000,188000,120,410,310,-5,23) ,
		  inPoint : 184000,
		  outPoint : 188000
		}),

		DynamicSourceLayer(
		{
		  //(inpoint,outpoint,w,l,lx,lys,lym,rotaZ)
		  provider : boxLetter(187000,193000,500,500,50+250,250+250,150+250,0),
		  inPoint : 187000,
		  outPoint : 193000
		}),		
		DynamicSourceLayer(
		{
		  //(text,inpoint,outpoint,xpo,ypoS,ypoM,rotaZ,fz)
		  provider : boxWord("初音の消失：\n弹幕技术在进化\n无论是底端字幕还是高级代码\n都包含着制作者的热情与爱\n任岁月荏苒初心依旧 \n用我们的力量\n给你带去惊喜和感动\n就足够了",187000,193000,100,480,380,0,25) ,
		  inPoint : 187000,
		  outPoint : 193000
		}),

		DynamicSourceLayer(
		{
		  //(inpoint,outpoint,w,l,lx,lys,lym,rotaZ)
		  provider : boxLetter(188000,193000,500,330,650+250,300+250,200+250,0),
		  inPoint : 188000,
		  outPoint : 193000
		}),		
		DynamicSourceLayer(
		{
		  //(text,inpoint,outpoint,xpo,ypoS,ypoM,rotaZ,fz)
		  provider : boxWord("白龙舞兮云飞扬：\n希望大家能给予\n新人弹幕君更多的鼓励\n往往是您的一个鼓励\n成为他努力的基点。",188000,193000,720,520,420,0,25) ,
		  inPoint : 188000,
		  outPoint : 193000
		}),

		DynamicSourceLayer(
		{
		  //(inpoint,outpoint,w,l,lx,lys,lym,rotaZ)
		  provider : boxLetter(192500,197500,500,250,50+250,300+250,200+250,0),
		  inPoint : 192500,
		  outPoint : 197500
		}),		
		DynamicSourceLayer(
		{
		  //(text,inpoint,outpoint,xpo,ypoS,ypoM,rotaZ,fz)
		  provider : boxWord("⑨55：两年过去了\nB站的弹幕系统发生了很大的变化\n但字幕君对弹幕的热情\n和弹幕艺术的本质却没有变化",192500,197500,70,530,430,0,23) ,
		  inPoint : 192500,
		  outPoint : 197500
		}),
		DynamicSourceLayer(
		{
		  //(inpoint,outpoint,w,l,lx,lys,lym,rotaZ)
		  provider : boxLetter(193000,197200,500,300,650+250,210+250,110+250,-5),
		  inPoint : 193000,
		  outPoint : 198000
		}),		
		DynamicSourceLayer(
		{
		  //(text,inpoint,outpoint,xpo,ypoS,ypoM,rotaZ,fz)
		  provider : boxWord("残星：之前我们发弹幕\n现在我们做弹幕\n以后会有更多的人参与到其中\n一/"+"n 一遮罩 一屏幕\n字幕君抖M 一辈子",193000,198000,700,450,350,-5,25) ,
		  inPoint : 193000,
		  outPoint : 198000
		}),


//面汤的位置
		DynamicSourceLayer(
		{
		  //(inpoint,outpoint,w,l,lx,lys,lym,rotaZ)
		  provider : boxLetter(197500,201500,500,350,450+250,270+250,170+250,0),
		  inPoint : 197500,
		  outPoint : 201500
		}),		
DynamicSourceLayer(
		{
		  //(text,inpoint,outpoint,xpo,ypoS,ypoM,rotaZ,fz)
		  provider : boxWord("面汤拌菜菌：\n愿诸君对弹幕的热情\n与爱得以传承与延续\n正因有你们的支持\n弹幕君才能走到今天",197500,201500,480,500,400,0,30) ,
		  inPoint : 197500,
		  outPoint : 201500
		}),
		DynamicSourceLayer(
		{
		  provider : ED.ShowComp.boxItem() ,
		  inPoint : 164000,
		  outPoint : 250000
		}),
		DynamicSourceLayer(
		{
		  provider : ED.ShowComp.blink ,
		  inPoint : 165000,
		  outPoint : 250000
		})
	]
});

/*******************************************************************************************/

ED.ShowComp.PartMel = 
Composition({
			width : 1280,
		  height : 720,

		  startTime : 0,
		  duration : 250000,
		   layers :
		  [
	Layer(
			{
			  source :  ED.Shapes3["P1"] ,
			  inPoint : 138169,
			  outPoint : 142600,
			  properties : 
			  {
			  	y : 0,
			  	x :  KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 138169, value : 0, interpolation : Interpolation.linear }),
				  Keyframe({ time : 142600, value : -45, interpolation : Interpolation.linear })
				  ]
				}),
			  	alpha : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 138169, value : 0, interpolation : Interpolation.linear }),
				  Keyframe({ time : 138569, value : 0.8, interpolation : Interpolation.linear }),
				  Keyframe({ time : 142200, value : 0.8, interpolation : Interpolation.linear }),
				  Keyframe({ time : 142600, value : 0, interpolation : Interpolation.linear })

				  ]
				}),
			  	scaleX : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 138169, value : 1, interpolation : Interpolation.linear }),
				  Keyframe({ time : 142600, value : 1.05, interpolation : Interpolation.linear })
				  ]
				}),
				scaleY : Binder.Link({name : "scaleX"})
			  }
			}),
	Layer(
			{
			  source :  ED.Shapes3["P2"],
			  inPoint : 142600,
			  outPoint : 147800,
			  properties : 
			  {
			  	y : 0,
			  	x :  KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 142600, value : 0, interpolation : Interpolation.linear }),
				  Keyframe({ time : 147800, value : -45, interpolation : Interpolation.linear })
				  ]
				}),
			  	alpha : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 142600, value : 0, interpolation : Interpolation.linear }),
				  Keyframe({ time : 143000, value : 0.8, interpolation : Interpolation.linear }),
				  Keyframe({ time : 147400, value : 0.8, interpolation : Interpolation.linear }),
				  Keyframe({ time : 147800, value : 0, interpolation : Interpolation.linear })

				  ]
				}),
			  	scaleX : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 142600, value : 1, interpolation : Interpolation.linear }),
				  Keyframe({ time : 147800, value : 1.05, interpolation : Interpolation.linear })
				  ]
				}),
				scaleY : Binder.Link({name : "scaleX"})
			  }
			}),
	Layer(
			{
			  source :  ED.Shapes3["P3"] ,
			  inPoint : 147800,
			  outPoint : 153100,
			  properties : 
			  {
			  	y : 0,
			  	x :  KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 147800, value : 0, interpolation : Interpolation.linear }),
				  Keyframe({ time : 153100, value : -45, interpolation : Interpolation.linear })
				  ]
				}),
			  	alpha : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 147800, value : 0, interpolation : Interpolation.linear }),
				  Keyframe({ time : 148200, value : 0.8, interpolation : Interpolation.linear }),
				  Keyframe({ time : 152700, value : 0.8, interpolation : Interpolation.linear }),
				  Keyframe({ time : 153100, value : 0, interpolation : Interpolation.linear })

				  ]
				}),
			  	scaleX : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 147800, value : 1, interpolation : Interpolation.linear }),
				  Keyframe({ time : 153100, value : 1.05, interpolation : Interpolation.linear })
				  ]
				}),
				scaleY : Binder.Link({name : "scaleX"})
			  }
			}),
	Layer(
			{
			  source :  ED.Shapes3["P4"] ,
			  inPoint : 153100,
			  outPoint : 158300,
			  properties : 
			  {
			  	y : 0,
			  	x :  KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 153100, value : 0, interpolation : Interpolation.linear }),
				  Keyframe({ time : 158300, value : -45, interpolation : Interpolation.linear })
				  ]
				}),
			  	alpha : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 153100, value : 0, interpolation : Interpolation.linear }),
				  Keyframe({ time : 153500, value : 0.8, interpolation : Interpolation.linear }),
				  Keyframe({ time : 157900, value : 0.8, interpolation : Interpolation.linear }),
				  Keyframe({ time : 158300, value : 0, interpolation : Interpolation.linear })

				  ]
				}),
			  	scaleX : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 153100, value : 1, interpolation : Interpolation.linear }),
				  Keyframe({ time : 158300, value : 1.05, interpolation : Interpolation.linear })
				  ]
				}),
				scaleY : Binder.Link({name : "scaleX"})
			  }
			}),
	Layer(
			{
			  source :  ED.Shapes3["P5"] ,
			  inPoint : 158300,
			  outPoint : 161000,
			  properties : 
			  {
			  	y : 0,
			  	x :  KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 158300, value : 0, interpolation : Interpolation.linear }),
				  Keyframe({ time : 161000, value : -25, interpolation : Interpolation.linear })
				  ]
				}),
			  	alpha : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 158300, value : 0, interpolation : Interpolation.linear }),
				  Keyframe({ time : 158700, value : 0.8, interpolation : Interpolation.linear }),
				  Keyframe({ time : 160700, value : 0.8, interpolation : Interpolation.linear }),
				  Keyframe({ time : 161000, value : 0, interpolation : Interpolation.linear })

				  ]
				}),
				scaleX : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 158300, value : 1, interpolation : Interpolation.linear }),
				  Keyframe({ time : 161000, value : 1.05, interpolation : Interpolation.linear })
				  ]
				}),
				scaleY : Binder.Link({name : "scaleX"})
			  }
			}),
	Layer(
			{
			  source :  ED.Shapes3["P6"] ,
			  inPoint : 161000,
			  outPoint : 163000,
			  properties : 
			  {
			  	x :  KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 161000, value : -25, interpolation : Interpolation.linear }),
				  Keyframe({ time : 163000, value : -45, interpolation : Interpolation.linear })
				  ]
				}),
			  	alpha : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 161000, value : 0, interpolation : Interpolation.linear }),
				  Keyframe({ time : 160500, value : 0.85, interpolation : Interpolation.linear }),
				  Keyframe({ time : 162500 , value : 0.85, interpolation : Interpolation.linear }),
				  Keyframe({ time : 163000, value : 0, interpolation : Interpolation.linear })

				  ]
				}),
			  	scaleX : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 161000, value : 1.05, interpolation : Interpolation.linear }),
				  Keyframe({ time : 163000, value : 1.08, interpolation : Interpolation.linear })
				  ]
				}),
				scaleY : Binder.Link({name : "scaleX"})
			  }
			}),
		Layer(
			{
			  source :  ED.Shapes3["P7"] ,
			  inPoint : 163000,
			  outPoint : 163000 + 2500,
			  properties : 
			  {
			  	y : KeyframesBind(
			    {
				  keyframes :
				  [
				    Keyframe({ time : 163000, value : 0, interpolation : Interpolation.linear }),
				    Keyframe({ time : 163000+2500, value : 40, interpolation : Interpolation.linear })
				  ]
				}),
			  	x : KeyframesBind(
			    {
				  keyframes :
				  [
				    Keyframe({ time : 163000, value : 0, interpolation : Interpolation.linear }),
				    Keyframe({ time : 163000+2500, value : 90, interpolation : Interpolation.linear })
				  ]
				}),
			  	alpha : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 163000, value : 0, interpolation : Interpolation.linear }),
				  Keyframe({ time : 163500, value : 0.8, interpolation : Interpolation.linear }),
				  Keyframe({ time : 162500 + 2500, value : 0.8, interpolation : Interpolation.linear }),
				  Keyframe({ time : 163000 + 2500, value : 0, interpolation : Interpolation.linear })

				  ]
				}),
			  	scaleX : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 163000, value : 1, interpolation : Interpolation.linear }),
				  Keyframe({ time : 163000+2500, value : 0.9, interpolation : Interpolation.linear })
				  ]
				}),
				scaleY : Binder.Link({name : "scaleX"})
			  }
			}),
			
			Layer(
			{
			  source :  ED.Shapes3["P8"] ,
			  inPoint : 165500,
			  outPoint : 169500,
			  properties : 
			  {
			  	y :  KeyframesBind(
			    {
				  keyframes :
				  [
				    Keyframe({ time : 165500, value : 30, interpolation : Interpolation.linear }),
				    Keyframe({ time : 169500, value : 250, interpolation : Interpolation.linear })
				  ]
				}),
			  	x : KeyframesBind(
			    {
				  keyframes :
				  [
				    Keyframe({ time : 165500, value : 20, interpolation : Interpolation.linear }),
				    Keyframe({ time : 169500, value : 210, interpolation : Interpolation.linear })
				  ]
				}),
			  	alpha : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 165500, value : 0, interpolation : Interpolation.linear }),
				  Keyframe({ time : 166000, value : 0.8, interpolation : Interpolation.linear }),
				  Keyframe({ time : 169000, value : 0.8, interpolation : Interpolation.linear }),
				  Keyframe({ time : 169500, value : 0, interpolation : Interpolation.linear })
				  ]
				}),
			  	scaleX : KeyframesBind(
			  {
				keyframes :
				[
				  Keyframe({ time : 165500, value : 1, interpolation : Interpolation.linear }),
				  Keyframe({ time : 169500, value : 0.6, interpolation : Interpolation.linear })
				  ]
				}),
				scaleY : Binder.Link({name : "scaleX"})
			  }			  
			}),
	DynamicSourceLayer(
	{
	  provider : ED.ShowComp.Box ,
	  inPoint : 0,
	  outPoint : 250000
	})
  ]
	});

/***********************************************************************************************/

ED.ShowComp.prelude=function()
{
	var rand = Akari.Utilities.Randomizer.createTwister( 3141592 );
  	return Composition(
	{
		width:1280,
		height:720,

		startTime : 0,
		duration : 250000,

		layers :
		[ 	//开场白背景 蓝方块 扩大到全屏
			Layer(
			{
				inPoint : 0,
        		outPoint : 5000,
       			source : Solid({ width : 1280, height : 720, color : 0xffffff }),
       			properties:
       			{
       				alpha:KeyframesBind(
			  		{
						keyframes :
						[
						  Keyframe({ time : 0, value : 0.3 , interpolation : Interpolation.linear }),
						  Keyframe({ time : 2000, value : 0.9, interpolation : Interpolation.linear})						  
						]
					})
       			}
			}),

			Layer(
			{
				inPoint : 0,
        		outPoint : 21000,
        		source: Anchor(
				{	
	        		source: function()
	        		{
	        			var blueRect=Shape();
	        			blueRect.graphics.beginFill(0x333366);
	        			blueRect.graphics.drawRect(0,0,120,20);
	        			blueRect.graphics.endFill();
	        			return blueRect;
	        		}(),
	        		x:60,
	        		y:10
	        	}),
				properties:
				{
					x:580,
					y:350,
					filters : [ $.createBlurFilter(16,16,2) ]  ,
					scaleX:KeyframesBind(
			  		{
						keyframes :
						[
						  Keyframe({ time : 500, value : 1 , interpolation : Interpolation.linear}),
						  Keyframe({ time : 2000, value : 15 , interpolation : Interpolation.cubic.easeOut })
						]
					}),
					scaleY:KeyframesBind(
			  		{
						keyframes :
						[
						  Keyframe({ time : 500, value : 1, interpolation : Interpolation.linear }),
						  Keyframe({ time : 2000, value : 40 , interpolation : Interpolation.cubic.easeOut })
						]
					}),
					alpha:KeyframesBind(
			  		{
						keyframes :
						[
						  Keyframe({ time : 19500, value : 1 , interpolation : Interpolation.linear }),
						  Keyframe({ time : 20500, value : 0, interpolation : Interpolation.linear})						  
						]
					})
				}
			}),
			// 白光点从右向左
			Factory.replicate( Layer, 60, function()
			{
				var startTime=rand.integer(2000,20000);
				var duration=rand.integer(10000,12000);
				var endTime=startTime+duration;
				
				var ypos=rand.integer( 5, 715 );
				var xpos=rand.integer( 0, 1280 );

				var circles= Shape();
				circles.graphics.beginFill(0xffffff);
       			circles.graphics.drawCircle( 0,0, rand.integer(1,5) );
        		circles.graphics.lineStyle(  0xffffff );
		        circles.graphics.endFill();

		        return
				[{
					source : circles,
				  	inPoint : startTime,
				  	outPoint : endTime,
				  	properties :
				 	{
						filters : [ $.createGlowFilter(0xffffff,1,4,4,1) ],
						x:KeyframesBind(
				  		{
							keyframes :
							[
							  Keyframe({ time : startTime, value : xpos, interpolation : Interpolation.linear  }),
							  Keyframe({ time : endTime, value : -10 , interpolation : Interpolation.linear  })
							]
						}),
						y:ypos
					}
				}];
			}),


			//从左向右短线
			Factory.replicate( Layer, 20, function()
			{
				var startTime=rand.integer(10000,20000);
				var duration=rand.integer(1000,2000);
				var endTime=startTime+duration;
				
				var ypos=rand.integer( 20, 700 );

				var line=Shape();
				line.graphics.lineStyle(rand.integer(1,5),0xffffff,1 );
				line.graphics.moveTo(0,0);
				line.graphics.lineTo(rand.integer(200,250),0);

		        return
				[{
					source : line,
				  	inPoint : startTime,
				  	outPoint : endTime,
				  	properties :
				 	{
						x:KeyframesBind(
				  		{
							keyframes :
							[
							  Keyframe({ time : startTime, value : -60, interpolation : Interpolation.linear  }),
							  Keyframe({ time : endTime, value : 1350 , interpolation : Interpolation.linear  })
							]
						}),
						y:ypos
					}
				}];
			}),
			//0.1黑屏模糊。。
			Layer(
			{
				inPoint : 0,
        		outPoint : 21000,
       			source : Solid({ width : 1280, height : 720, color : 0x000000 }),
       			properties:
       			{
       				alpha:KeyframesBind(
			  		{
						keyframes :
						[
						  Keyframe({ time : 0, value : 0, interpolation : Interpolation.linear }),
						  Keyframe({ time : 21000, value : 1 , interpolation : Interpolation.linear })
						]
					}),
					filters : [ $.createBlurFilter(16,16,2) ]    				
       			}

			}),
			//纸飞机
			Layer(
			{
				inPoint : 11500,
        		outPoint : 20000,
       			source : function()
       			{
					var plane=Shape();
					plane.graphics.moveTo(195,188);
					plane.graphics.lineStyle(3,0xffffff,1);
					plane.graphics.lineTo(256,385);
					plane.graphics.moveTo(247,400);
					plane.graphics.lineTo(314,313);
					plane.graphics.lineTo(194,187);
					plane.graphics.lineTo(355,256);
					plane.graphics.lineTo(431,137);
					plane.graphics.lineTo(195,187);
					plane.graphics.moveTo(351,254);
					plane.graphics.moveTo(371,297);
					plane.graphics.moveTo(311,312);
					plane.graphics.lineTo(370,302);
					plane.graphics.lineTo(355,256);
					plane.graphics.lineTo(355,256);
					plane.graphics.lineTo(194,189);
					plane.graphics.lineTo(197,189);
					plane.graphics.lineTo(197,189);
					plane.graphics.lineTo(193,188);
					plane.graphics.curveTo(251,380,257,384);
					plane.graphics.curveTo(207,222,196,189);
					plane.graphics.moveTo(196,193);
					plane.graphics.curveTo(305,308,314,310);
					plane.graphics.curveTo(219,213,199,193);
					plane.graphics.moveTo(200,189);
					plane.graphics.curveTo(346,249,354,255);
					plane.graphics.moveTo(195,189);
					plane.graphics.curveTo(317,155,430,138);
					plane.graphics.curveTo(264,176,196,189);
					plane.graphics.moveTo(354,256);
					plane.graphics.curveTo(426,153,429,138);
					plane.graphics.moveTo(355,256);
					plane.graphics.curveTo(363,293,369,300);
					plane.graphics.curveTo(359,262,356,256);
					plane.graphics.moveTo(368,299);
					plane.graphics.curveTo(352,306,313,312);
					plane.graphics.moveTo(314,311);
					plane.graphics.curveTo(344,302,369,301);
					plane.graphics.moveTo(312,311);
					plane.graphics.curveTo(254,392,246,399);
					plane.graphics.curveTo(299,334,314,311);
					plane.graphics.endFill();

					return plane;
       			}(),
       			properties:
				{
					filters : [ $.createBlurFilter(8,8,2) ] , 			
					alpha:KeyframesBind(
			  		{
						keyframes :
						[
						  Keyframe({ time : 10000, value : 0, interpolation : Interpolation.linear }),
						  Keyframe({ time : 11000, value : 1 , interpolation : Interpolation.linear })
						]
					}),
					x:KeyframesBind(
			  		{
						keyframes :
						[
						  Keyframe({ time : 10000, value : 800, interpolation : Interpolation.linear}),
						  Keyframe({ time : 11500, value : 600, interpolation : Interpolation.linear}),
						  Keyframe({ time : 19000, value : 550, interpolation : Interpolation.linear }),
						  Keyframe({ time : 20000, value : -300 , interpolation : Interpolation.hold })
						]
					}),
					y:KeyframesBind(
			  		{
						keyframes :
						[
						  Keyframe({ time : 10000, value : 200, interpolation : Interpolation.linear}),
						  Keyframe({ time : 15000, value : 250, interpolation : Interpolation.linear}),
						  Keyframe({ time : 20000, value : 220, interpolation : Interpolation.linear})
	
						]
					}),
					rotationZ:-15,
					scaleX:KeyframesBind(
			  		{
						keyframes :
						[
						  Keyframe({ time : 11500, value : 1 , interpolation : Interpolation.linear}),
						  Keyframe({ time : 20000, value : 0.9 , interpolation : Interpolation.linear })
						]
					}),
					scaleY : Binder.Link({name : "scaleX"})
				}
			}),	
		]
	});
};
	// 主合成执行
var mainComp = Composition(
{
  width : 1280,
  height : 720,

  startTime : 0,
  duration : 250000,

  layers :
  [
  	DynamicSourceLayer(
	{
	  provider : ED.ShowComp.prelude() ,
	  inPoint : 0,
	  outPoint : 250000
	}),
	DynamicSourceLayer(
	{
	  provider : ED.ShowComp.BGComp ,
	  inPoint : 19000,
	  outPoint : 250000
	}),
	DynamicSourceLayer(
	{
	  provider : ED.ShowComp.Part1 ,
	  inPoint : 21000,
	  outPoint : 250000
	}),
	DynamicSourceLayer(
	{
	  provider : ED.ShowComp.PartStaff,
	  inPoint : 0,
	  outPoint : 250000
	}),
	DynamicSourceLayer(
	{
	  provider : ED.ShowComp.Part3 ,//这一层就是原PArt2现Part3，全部都在这了。
	  inPoint : 0,
	  outPoint : 250000
	}),
DynamicSourceLayer(
	{
	  provider : ED.ShowComp.PartMel ,
	  inPoint : 0,
	  outPoint : 250000
	}),
	DynamicSourceLayer(
	{
	  provider : ED.ShowComp.LastWordComp ,
	  inPoint : 201500,
	  outPoint : 227130
	}),
	DynamicSourceLayer(
	{
	  provider : ED.ShowComp.logoCompEx ,
	  inPoint : 227630,
	  outPoint : 250000
	}),
	DynamicSourceLayer(
	{
	  provider : ED.ShowComp.BGComp2 ,//这一层必须放在最后面，因为是镶边
	  inPoint : 19000,
	  outPoint : 250000
	}),
	  	DynamicSourceLayer(
	{
	  provider : ED.ShowComp.BGComp3 ,//这一层必须放在最后面，是Part转移的白黑场
	  inPoint : 0,
	  outPoint : 250000
	})
  ]
});
//Global._set( "ED.LogoComp", Akari.Utilities.Factory.clone(ED.ShowComp.logoCompEx) );
Global._set( "ED.MainComp", mainComp );
//Akari.execute(mainComp);
if (playerState == 'playing')
{
	Player.play();
	($G._("loading")).change(50);
	if($G._("ED.FontLast") && $G._("ED.Shapes") && $G._("ED.Shapes_1") && $G._("ED.Shapes3") )
	 ($G._("loading")).changeT("观看弹幕作品需要屏蔽普通弹幕...\n");
	//$$.appendLog('20%...');
};