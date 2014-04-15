/*10BRH主合成               */
/*---20130818 0358 BETA---*/
if($G._("BRH"))
stopExecution();//只为Error1009
//ScriptManager.clearEl();
ScriptManager.clearTimer();  

/*---System Setting---*/

var vh=Player.videoHeight; 
var vw=Player.videoWidth;
var vhf=Player.height;
var vwf=Player.width;
//trace(vw+" "+vwf);
var blends;
var locationset; 
var filterset;
var txtset;
var otherset;
var settinglist=[blends,locationset,txtset,filterset,otherset];
var format01 ; 
var sizeset=[0.06,5];
var timer_interval=50;
var tweeneasing=[null,TweenEasing.Back,Bounce,Circ,Cubic,Elastic,Expo,Linear,Quad,Quart,Quint,SIne];

var proportion=vh/720;
//var startdelay=0;
var startdelay=550000;

/*---System Setting fin---*/

/*---Video Setting---*/

var mask_base=$.createCanvas({x:0,y:0,lifeTime:0});
var mask_bg=$.createCanvas({x:(Player.width-vw)/2 ,y:(Player.height-vh)/2 ,lifeTime:0});  
var mask_black=$.createCanvas({x:0,y:0,lifeTime:0});
var mask_hidden=$.createCanvas({x:(Player.width-vw)/2 ,y:(Player.height-vh)/2 ,lifeTime:0}); 
//var mask_hidden=$.createCanvas({x:0,y:0,alpha:0,lifeTime:0});
var blackmask=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:mask_black});
blackmask.graphics.beginFill(0x000000,1);
blackmask.graphics.drawRect(-vw*0.5,-vh*0.5,vw*2,vhf*0.5);
blackmask.graphics.drawRect(-vw*0.5,(vhf-vh)*0.5,vwf*0.5,vh);
blackmask.graphics.drawRect((vwf+vw)*0.5,(vhf-vh)*0.5,vw*0.5,vh);
blackmask.graphics.drawRect(-vw*0.5,(vhf+vh)*0.5,vw*2,vh*2);
blackmask.graphics.endFill();
var i_mask;


var masks=[];
var txtlist=[];
var itwnslist=[];
var funlist=[];  
var tempobjlist=[];
var piclist=[];

/*---Video Setting fin---*/

/*---components---*/

var lastview=0;
var lasttime=0;
var timenow=0;
var timerlist;
var maintimer;

function Get_X(px){
	return Player.videoWidth*(px/1280);
}

function Get_Y(py){
	return Player.videoHeight*(py/720);
}

function Settempobj(tempobj){
	tempobjlist.push(tempobj);
}

function Gettempobj(objname){
	while(i<tempobjlist.length){
		if(tempobjlist[i].name==objname){
			//trace("find!");
			return tempobjlist[i];
		}else{
			i++;
		}
	}
}

function Deltempobj(objname){
	while(i<tempobjlist.length){
		if(tempobjlist[i].name==objname){
			tempobjlist[i].splice(i,1);
			break;
		}
	}
}

function Cleartempobj(){
	tempobjlist=[];
}

function Delayfun(fun,starttime){
	timer(fun,starttime-Player.time);
}

function Creatmove(mode,mask,obj_original,obj_target,obj_controls,itweenfun,spents,endtime,easingmode){
	var tw;
	var iw;
	switch(mode) {
		case 1:
			//trace("tween!");
			tw = Tween.tween(mask,obj_target,obj_original,(endtime-Player.time)/1000.0,Returneasing(easingmode));
			tw.play();
			iw=["tween",mask,tw,obj_target,obj_original,null,endtime,easingmode];
			itwnslist.push(iw);
			//hastimer=true;
			break;
		case 2:
			
			var hidden_txt=$.createComment("迷",{x:0,y:0,lifeTime:0,alpha:0,color:0xffffff,parent:mask_hidden});
			//trace("has size? "+hidden_txt.hasOwnProperty("fontsize"));
			tw=Tween.bezier(
				hidden_txt, 
				obj_target, 
				obj_original,
				obj_controls,
				(endtime-Player.time)/1000.0
			);
			tw.play();//var tw;
			
			var i_itween=interval(function(){
				itweenfun(mask,hidden_txt);
			},50,0);
			interlist.push(i_itween);
			hastimer=true;
			break;
		case 3:
			//var tw;
			break;
		default:
			//trace("Error! itweens mode");
			break;
	}
	//trace("stween set!");
}

function Returneasing(num){
	return Linear;
}

function Getrandomtwoway(num,offsets){
	return num-offsets+offsets*2*Math.random();
}

function Getrandom(num,offsets){
	return num+offsets*Math.random();
}

function Clearmaskbg(num){
	if(num>=0)
	{
		for(i=0;i<=num;i++){
			mask_bg.removeChildAt(0);
		}
	}else{
		for(i=mask_bg.numChildren;i>0;i--){
			mask_bg.removeChildAt(0);
		}
	}
}

//---Checkfont
var txtfont;
function Testfont(fonts_)
{
	var fonts=fonts_;
	var font_test=$.createComment("字体测试",{x:-3000,y:-3000,lifeTime:1});
	var font_errer=$.createComment("字体测试",{x:-3000,y:-3000,lifeTime:1});
	font_errer.font="errer"; 
	for(i=0;i<fonts.length;i++)
	{
		font_test.font=fonts[i];  
		if(font_test.width!=font_errer.width||font_test.height!=font_errer.height)
		{
			return fonts[i];
		}
	}
}
txtfont=[Testfont(["华文新魏","微软雅黑","黑体"]),Testfont(["华文新魏","微软雅黑","宋体"])];
//---Checkfont fin 

//----Disppear
//var concount=0;
var bg=$.createCanvas({x:(Player.width-vw)/2 ,y:(Player.height-vh)/2 ,lifeTime:0,parent:mask_base});  
var bg2=$.createCanvas({x:(Player.width-vw)/2 ,y:(Player.height-vh)/2 ,lifeTime:0});  

var bg_txt;

function Disppear()
{
	
	var maskslen=masks.length;
	for(i=0;i<maskslen;i++){
		for(m=masks[i].numChildren-1;m>=0;m--){
			masks[i].removeChildAt(0);
		}
	}
	for(i=bg.numChildren-1;i>=0;i--){
		bg.removeChildAt(0);
	}
	for(i=bg2.numChildren-1;i>=0;i--){
		bg2.removeChildAt(0);
	}
	
	var conlistlen=conlist.length;
	for(i=0;i<conlistlen;i++)
	{
		if(conlist[i].hasOwnProperty("graphics"))
		{
			conlist[i].graphics.clear();
		}
	}
	
	conlist=[];
	txtlist=[];
	itwnslist=[];
	masks=[];
	//trace("Disppear!");
}

function Txtclear(){
	if(bg_txt!=null){
		for(i=bg_txt.numChildren-1;i>=0;i--){
			bg_txt.removeChildAt(0);;
		}
	}
	txtlist=[];
}

//----Disppear fin

//--Timerstop
var interlist=[];
var hastimer=false;

function Timerstop()
{
	//trace("debug");
	if(i_mask!=null)
	{
		//i_mask.stop();
		
	}
	
	//trace("hastimer "+hastimer+" length "+interlist.length);
	if(hastimer)
	{
		for(i=0;i<interlist.length;i++)
		{
			(interlist[i]).stop();
			//trace("timerstop!");
		}
		interlist=[];
		hastimer=false;
	}
	//trace("Timerstop!");
}
//--Timerstop fin

//---Fixpositon
var conlist=[];  
var txtsize=Math.round(sizeset[0])+sizeset[1]; 

function Fixpo()
{
	proportion=Player.videoHeight/vh;
	proportionX=Player.videoWidth/vw;
	//trace("proportion "+proportion+" proportionX "+proportionX);
	vh=Player.videoHeight ; 
	vw=Player.videoWidth; 
	vhf=Player.height;
	vwf=Player.width;
	txtsize=Math.round(vh*sizeset[0])+sizeset[1];  
	blackmask.graphics.clear();
	//blackmask=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:mask_black});
	blackmask.graphics.beginFill(0x000000,1);
	blackmask.graphics.drawRect(-vw*0.5,-vh*0.5,vw*2,vhf*0.5);
	blackmask.graphics.drawRect(-vw*0.5,(vhf-vh)*0.5,vwf*0.5,vh);
	blackmask.graphics.drawRect((vwf+vw)*0.5,(vhf-vh)*0.5,vw*0.5,vh);
	blackmask.graphics.drawRect(-vw*0.5,(vhf+vh)*0.5,vw*2,vh*2);
	blackmask.graphics.endFill();
	
	initialization=vh/720;
	
	bg.x=(vwf-vw)*0.5;
	bg.y=(vhf-vh)*0.5;
	bg2.x=(vwf-vw)*0.5;
	bg2.y=(vhf-vh)*0.5;
	
	for(i=0;i<masks.length;i++){
		masks[i].x=masks[i].x*proportion;
		masks[i].y=masks[i].y*proportion;
	}
	
	for(i=0;i<txtlist.length;i++){
		format01=$.createTextFormat(txtset[0],txtsize ,txtset[2] ,txtset[3] ,txtset[4] ,txtset[5] ,txtset[6] ,txtset[7] ,txtset[8] ,txtset[9] ,txtset[10] ,txtset[11] ,txtset[12] ); 
		(txtlist[i]).setTextFormat(format01);
		(txtlist[i]).x=otherset[1]+i*txtsize;
		(txtlist[i]).y=otherset[2];
		
	}
	
	for(i=0;i<conlist.length;i++){
		conlist[i].x=conlist[i].x*proportion;
		conlist[i].y=conlist[i].y*proportion;
		if(conlist[i].hasOwnProperty("graphics"))
		{
			conlist[i].width=conlist[i].width*proportion;
			conlist[i].height=conlist[i].height*proportion;
			
		}
		
		conlist[i].visible=true;
	}
	Fixiwteen(Player.time,proportion,proportionX);
	
	
	
}

function Fixiwteen(timenow,rate,rateX)
{
	
	for(i=itwnslist.length-1;i>=0;i--)
	{
		var tempobj=itwnslist[i];
		itwnslist[i][2].stop();
		
		
		if(tempobj[0]==("tween"))
		{
			if(tempobj[3].hasOwnProperty("x"))
			{
				
				tempobj[3].x=tempobj[3].x*rateX;
				tempobj[4].x=tempobj[1].x;
				
			}
			if(tempobj[3].hasOwnProperty("y"))
			{
				
				tempobj[3].y=tempobj[3].y*rate;
				tempobj[4].y=tempobj[1].y;
			}
			if(tempobj[3].hasOwnProperty("rotationY"))
			{
				tempobj[4].rotationY=tempobj[1].rotationY;
			}
			if(tempobj[3].hasOwnProperty("rotationZ"))
			{
				tempobj[4].rotationZ=tempobj[1].rotationZ;
			}
			if(tempobj[3].hasOwnProperty("rotationX"))
			{
				tempobj[4].rotationX=tempobj[1].rotationX;
			}
			if(tempobj[3].hasOwnProperty("alpha"))
			{
				tempobj[4].alpha=tempobj[1].alpha;
			}
			var temptime=(tempobj[6]-timenow)/1000.0;
			tempobj[2]=Tween.tween(tempobj[1],tempobj[3],tempobj[4],temptime,Returneasing(tempobj[7]));
			
			
		}
		if(tempobj[0]==("to")){
			
		}
		if(tempobj[0]==("bezier")){
			
		}
		itwnslist[i]=tempobj;
		itwnslist[i][2].play();
		//trace("Play");
	}
	
	
	
}

//---Fixpositon fin 

//---Playback controls
function Mainfun(state,timenow,timenext)
{
	
	
	lastview=state;
	//trace("lastview= "+state);
	lasttime=Gettime(state);
	
	funlist[state](timenow,timenext,state);
	
}

function  Gettime(count)
{
	
	return  parseInt(((data[count][1]).substring(0,2)))*60000+parseInt(((data[count][1]).substring(2,(data[count][1]).length))*1000)+startdelay ;
}

function Turnback(count)
{
	//trace("Turnback "+count);
	for( i=0;i<=count;i++)
	{
		var temptime=Gettime(i);
		var tempnexttime=Gettime(i+1);
		
		if(timenow>=tempnexttime)
		{continue;}
		else
		{
			//trace("temptime "+temptime+" tempnexttime "+tempnexttime);
			if(timenow>=temptime&&timenow<tempnexttime)
			{
				lastview=i;
				lasttime=Gettime(i);
				//lasttime=Gettime(i);
				if(timenow<(temptime+data[i][2]) )
				{
					
					Mainfun(i);
					
				}
			}
			else
			{
				Disppear();
				Timerstop();
			}
			break;
		}
	}
}

function Turnnext(count)
{
	for( i=count+1;i<=data.length;i++)
	{
		var temptime=Gettime(i);
		if(timenow>=temptime&&timenow<(temptime+data[i][2]))
		{
			//trace("timenow "+timenow+" gettime "+temptime);
			//trace("next "+i);
			Mainfun(i,timenow,temptime+data[i][2]);
			
			break;
		}
		if(timenow<temptime)
		{break;}
	} 
}
//---Playback controls fin

//---Timerstart 
function Start()
{
	maintimer= interval(function(){
		timenow=Player.time;
		//trace(lastview);
		if(timenow<startdelay){
			LBfun_NULL();
		}
		if(vh!=Player.videoHeight ||vw!=Player.videoWidth)
		{
			Fixpo();
		} 
		//trace(data[lastview][2]);
		if(timenow<lasttime)
		{
			//trace("backview "+lastview);
			Turnback(lastview);
			
		}
			
		else if(timenow>lasttime+(data[lastview][2]))
		{
			//trace(data[lastview][2]);
			Turnnext(lastview);
		}
	},50,0);
}
//---Timerstart fin

//---Timerstop
function Stopviewing()
{
	maintimer.stop();
}

$G._set("StopT",Stopviewing);
//---Timerstop fin

/*---components fin---*/

/*---Updata function---*/

function UpdataLyrics(lyrics)
{
	data=lyrics;
}
$G._set("UPLyrics",UpdataLyrics);

function UpdataFunlist(newfunlist)
{
	funlist=newfunlist;
}
$G._set("UPFunctions",UpdataFunlist);

function AddFunction(newfunction)
{
	funlist.push(newfunction);
}
$G._set("ADDFunctions",AddFunction);

/*---Updata function fin---*/

/*---Functions---*/

function ViewMask(){
	
	mask_black.alpha=1;
}

function HideMask(){
	mask_black.alpha=0;
}

function LBfun_NULL(){
	//trace("LB_NULL");
	Timerstop();
	Disppear();
	HideMask();
}
funlist.push(LBfun_NULL);

function LBfun_001(timenow,timenext,state){
	//trace("startfun01");
	Clearmaskbg(-1);
	Timerstop();
	ViewMask();
	Disppear();
	
	var tempvw=vw;
	var tempvh=vh;
	
	var delay_shape_lines=0;
	var temptime_shape_lines=Gettime(state)+delay_shape_lines;
	var shape_lines=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:bg});
	conlist.push(shape_lines);
	shape_lines.transform.matrix3D = null;
	
	
	var shape_lines_original={x:0};
	var shape_lines_target={x:0};
	var shape_lines_controls={x:[0,0]};
	var tempvw=vw;
	var tempvh=vh;
	var line_01=[vh,vh,vh,vh,vh,vh,vh,vh,vh,vh];
	var line_02=[vh,vh,vh,vh,vh,vh,vh,vh,vh,vh];
	var line_03=[vh,vh,vh,vh,vh,vh,vh,vh,vh,vh];
	var line_04=[vh,vh,vh,vh,vh,vh,vh,vh,vh,vh];
	var line_05=[vh,vh,vh,vh,vh,vh,vh,vh,vh,vh];
	var line_06=[vh,vh,vh,vh,vh,vh,vh,vh,vh,vh];
	var linelist=[line_01,line_02,line_03,line_04,line_05,line_06];
	var ranlist=[1,0.9,0.8,0.7,0.6,0.5];
	var tempcount=0;
	var shape_lines_fun=function(obj,obj_hidden){
		
		if(tempcount>-1){
			tempcount=0;
			obj.graphics.clear();
			obj.graphics.lineStyle(1,0x00a2e8,0.3);
			for(i=0;i<linelist.length;i++){
				for(m=0;m<line_01.length-1;m++){
					linelist[i][m]=linelist[i][m+1];
				}
				linelist[i][line_01.length-1]=Getrandomtwoway(tempvh*ranlist[i],tempvh*0.1);
				
				obj.graphics.drawPath( $.toIntVector([1,2,3,3,3,3,3,2,2]),$.toNumberVector([Getrandom(0,-tempvw*0.05),linelist[i][0],Getrandomtwoway(tempvw*0.1,tempvw*0.05),linelist[i][1],Getrandomtwoway(tempvw*0.2,tempvw*0.05),linelist[i][2],Getrandomtwoway(tempvw*0.3,tempvw*0.05),linelist[i][3],Getrandomtwoway(tempvw*0.4,tempvw*0.05),linelist[i][4],Getrandomtwoway(tempvw*0.6,tempvw*0.05),linelist[i][5],Getrandomtwoway(tempvw*0.7,tempvw*0.05),linelist[i][6],Getrandomtwoway(tempvw*0.8,tempvw*0.05),linelist[i][7],Getrandomtwoway(tempvw*0.9,tempvw*0.05),linelist[i][8],Getrandom(tempvw,tempvw*0.05),linelist[i][9]]));
			}
		}else
		{
			tempcount++;
		}
		obj.filters=[$.createBlurFilter(vw*0.01,vh*0.01,1)];
		
	};
	Creatmove(2,shape_lines,shape_lines_original,shape_lines_target,shape_lines_controls,shape_lines_fun,1,temptime_shape_lines+10000,1);
	
	
	
	
	var i_01=interval(function(){},1000,1);
	var remainingtime=timenext-timenow;
	if(remainingtime<0.5){
		remainingtime=0.5;
	}
	var mask_01=$.createCanvas({x:vw*0.3,y:vh*1,lifeTime:0,parent:bg});
	masks.push(mask_01);
	var middle=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:mask_01});
	middle.graphics.beginGradientFill("linear",[0x67bbf5,0x8dd0ff,0xcee4ff],[1,1,1],[0x00,0x7f,0xff] , $.createGradientBox(vh*0.2,vw*0.5,Math.PI / 2, 0, 0),"reflect");
	for(i=0;i<35;i++)
	{	middle.graphics.drawRect(0,i*vh*0.3,vw*0.5,vh*0.2);}
	middle.graphics.endFill();
	var shapecount=1;
	var tempvh=vh;
	i_01=interval(function(){
		//trace("now pic "+-shapecount*tempvh*0.5);
		middle.graphics.beginGradientFill("linear", [0x67bbf5,0x8dd0ff,0xcee4ff],[1,1,1],[0x00,0x7f,0xff] , $.createGradientBox(tempvh*0.2,tempvw*0.5,Math.PI / 2, 0,0),"reflect");
		middle.graphics.drawRect(0,-shapecount*tempvh*0.3,tempvw*0.5,tempvh*0.2);
		middle.graphics.endFill();
		shapecount++;
	},remainingtime/50.0,20);
	hastimer=true; 
	interlist.push(i_01);
	
	
	conlist.push(middle);
	var time_delay_001=0;
	var temptime_001=Gettime(state)+time_delay_001;
	var obj_target={x:vw*0.3,y:vh*-1,rotationX:-10,rotationY:10};
	var obj_original={x:vw*0.4,y:vh*1,rotationX:5,rotationY:20};
	//trace("temptime_001 "+temptime_001);
	Creatmove(1,mask_01,obj_original,obj_target,null,null,9.5,temptime_001+10000,0);
	
	var time_delay_002=10000;
	var temptime_002=Gettime(state)+time_delay_002;
	var fun_00=function next(){
		var obj02_target={x:vw*0.25,y:vh*-12,rotationX:15,rotationY:0};
		var obj02_original={x:vw*0.3,y:vh*-1,rotationX:-10,rotationY:10};
		Creatmove(1,mask_01,obj02_original,obj02_target,null,null,10,temptime_002+10000,0);
		
	};
	Delayfun(fun_00,temptime_002);
	
	var time_delay_01=16000;
	var temptime_01=Gettime(state)+time_delay_01;
	//trace("temptime_01 "+temptime_01);
	var fun_01=function Viewtop(){
		
		var mask_03=$.createCanvas({x:vw*0.5,y:-vh,lifeTime:0,parent:bg});
		masks.push(mask_03);
		var beam_01=$.createShape({lifeTime:0,x:vw*0.1,y:0,alpha:1,parent:mask_03});
		beam_01.graphics.beginGradientFill("radial", [0xffffff,0xdadada, 0x000000],[1,0.5,0],[0x00,0x7f,0xff] , $.createGradientBox(vw*2.5,vh*2.5,0,-vw*1.25, -vh*1.25));
		beam_01.graphics.moveTo(vw*0.4,vh*1.6);
		beam_01.graphics.lineTo(vw*0.2,vh*2); 
		beam_01.graphics.lineTo(0,0);
		beam_01.graphics.endFill();
		beam_01.filters=[$.createBlurFilter(vw*0.01,vh*0.01,1)];
		conlist.push(beam_01);
		var obj4_original={rotationZ:-30};
		var obj4_target={rotationZ:0};
		Creatmove(1,beam_01,obj4_original,obj4_target,null,null,4,temptime_01+6000,0);
		var time_delay_011=3000;
		var temptime_011=temptime_01+time_delay_011;
		
		var fun_02=function(){
			var obj_original_5={rotationZ:0};
			var obj_target_5={rotationZ:50};
			Creatmove(1,beam_01,obj_original_5,obj_target_5,null,null,4,temptime_011+6000,0);
		};
		Delayfun(fun_02,temptime_011);
		
		var beam_02=$.createShape({lifeTime:0,x:-vw*0.1,y:0,alpha:1,parent:mask_03});
		beam_02.graphics.beginGradientFill("radial", [0xffffff,0xdadada, 0x000000],[1,0.5,0],[0x00,0x7f,0xff] , $.createGradientBox(vw*2.2,vh*2.2,0,-vw*1.1, -vh*1.1));
		beam_02.graphics.moveTo(vw*0.3,vh*2);
		beam_02.graphics.lineTo(vw*0.2,vh*3); 
		beam_02.graphics.lineTo(0,0);
		beam_02.graphics.endFill();
		beam_02.filters=[$.createBlurFilter(vw*0.01,vh*0.01,1)];
		conlist.push(beam_02);
		var obj_original_6={rotationZ:60};
		var obj_target_6={rotationZ:10};
		Creatmove(1,beam_02,obj_original_6,obj_target_6,null,null,4,temptime_01+6000,0);
		var fun_03=function(){
			var obj_original_7={rotationZ:10};
			var obj_target_7={rotationZ:-40};
			Creatmove(1,beam_02,obj_original_7,obj_target_7,null,null,4,temptime_011+6000,0);
		};
		Delayfun(fun_03,temptime_011);
		
		var beam_03=$.createShape({lifeTime:0,x:vw*0.1,y:0,alpha:1,parent:mask_03});
		beam_03.graphics.beginGradientFill("radial", [0xffffff,0xdadada, 0x000000],[1,0.5,0],[0x00,0x7f,0xff] , $.createGradientBox(vw*2.1,vh*2.1,0,-vw*1.05, -vh*1.05));
		beam_03.graphics.moveTo(vw*0.4,vh*2);
		beam_03.graphics.lineTo(vw*0.2,vh*3); 
		beam_03.graphics.lineTo(0,0);
		beam_03.graphics.endFill();
		beam_03.filters=[$.createBlurFilter(vw*0.01,vh*0.01,1)];
		conlist.push(beam_03);
		var obj_original_8={rotationZ:-70};
		var obj_target_8={rotationZ:-40};
		Creatmove(1,beam_03,obj_original_8,obj_target_8,null,null,4,temptime_01+6000,0);
		var fun_04=function(){
			var obj_original_9={rotationZ:-30};
			var obj_target_9={rotationZ:10};
			Creatmove(1,beam_03,obj_original_9,obj_target_9,null,null,4,temptime_011+6000,0);
		};
		Delayfun(fun_04,temptime_011);
		
		var beam_04=$.createShape({lifeTime:0,x:-vw*0.1,y:0,alpha:1,parent:mask_03});
		beam_04.graphics.beginGradientFill("radial", [0xffffff,0xdadada, 0x000000],[1,0.5,0],[0x00,0x7f,0xff] , $.createGradientBox(vw*2.8,vh*2.8,0,-vw*1.4, -vh*1.4));
		beam_04.graphics.moveTo(vw*0.3,vh*2.5);
		beam_04.graphics.lineTo(vw*0.2,vh*3); 
		beam_04.graphics.lineTo(0,0);
		beam_04.graphics.endFill();
		beam_04.filters=[$.createBlurFilter(vw*0.01,vh*0.01,1)];
		conlist.push(beam_04);
		var obj_original_9={rotationZ:90};
		var obj_target_9={rotationZ:60};
		Creatmove(1,beam_04,obj_original_9,obj_target_9,null,null,4,temptime_01+6000,0);
		var fun_05=function(){
			var obj_original_10={rotationZ:60};
			var obj_target_10={rotationZ:-60};
			Creatmove(1,beam_04,obj_original_10,obj_target_10,null,null,4,temptime_011+6000,0);
		};
		Delayfun(fun_05,temptime_011);
		
		
		var top=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:mask_03});
		top.graphics.beginGradientFill("radial", [0xffffff,0xdadada, 0x000000],[1,0.5,0],[0x00,0x7f,0xff] , $.createGradientBox(vw*2,vh*2,0,-vw, -vh));
		top.graphics.lineStyle(0,0,0);
		top.graphics.drawEllipse(-vw,-vh, vw*2, vh*2);
		top.graphics.endFill();
		conlist.push(top);
		
		var obj3_target={y:-vh*0.3};
		var obj3_original={y:-vh};
		Creatmove(1,mask_03,obj3_original,obj3_target,null,null,4,temptime_011+4000,0);
	};
	Delayfun(fun_01,time_delay_01);
	var time_delay_02=24000;
	//var time_delay_02=2000;
	var temptime_02=Gettime(state)+time_delay_02;
	var nextscenesfun=function(){
		var mask_04=$.createCanvas({x:-vwf*0.5,y:-vhf*2,lifeTime:0,parent:mask_bg});
		masks.push(mask_04);
		var nextscenes=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:mask_04});
		nextscenes.graphics.beginGradientFill("linear", [0xffffff,0x000000],[1,0],[0x00,0xff] , $.createGradientBox(vw*2,vhf*2,Math.PI / 2,0, 0));
		nextscenes.graphics.lineStyle(0,0,0);
		nextscenes.graphics.drawRect(0, 0,vw*2, vhf*2);
		nextscenes.graphics.endFill();
		conlist.push(nextscenes);
		
		var obj_target_11={y:0};
		var obj_original_11={y:-vh*2};
		Creatmove(1,mask_04,obj_original_11,obj_target_11,null,null,4,temptime_02+500,0);
	};
	Delayfun(nextscenesfun,temptime_02);
	
	var mask_02=$.createCanvas({x:0,y:0,lifeTime:0,parent:bg});
	masks.push(mask_02);
	var delay_ViewLB=18000;
	var temptime_03=Gettime(state)+delay_ViewLB;
	var ViewLB=function(){
		//trace("ViewLB");
		var shape_LB01=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:mask_02});
		conlist.push(shape_LB01);
		var shape_LB01_original={x:vw*0.5,y:-vh*0.3,fontsize:vh*0.02};
		var shape_LB01_target={x: vw*0.5, y: -vh*0.3,fontsize:vh*0.02};
		var shape_LB01_controls={x: [vw*0.6, vw*0.7, vw*0.8, vw*0.7,vw*0.4,vw*0.3],y: [vh*0.2, vh*0.7, vh*0.6, vh*0.5,vh*0.8,vh*0.6],fontsize:[vh*0.02,vh*0.03,vh*0.04,vh*0.05,vh*0.035,vh*0.025]};
		var tempvw02=vw;
		var tempvh02=vh;
		var shape_LB01_fun= function(obj,obj_hidden){
			obj.rotationY=obj_hidden.rotationY;
			obj.rotationX=obj_hidden.rotationX;
			obj.rotationZ=obj_hidden.rotationZ;
			obj.alpha=1;
			obj.graphics.clear();
			obj.graphics.beginFill(0x00a2e8,1);
			//trace("obj.width "+obj_hidden.fontsize);
			obj.graphics.drawCircle(obj_hidden.x,obj_hidden.y,Getrandomtwoway(obj_hidden.fontsize,obj_hidden.fontsize*0.1));
			obj.graphics.endFill();
			obj.filters=[$.createGlowFilter(0x00a2e8,1,obj_hidden.fontsize*0.4,obj_hidden.fontsize*0.4,4,3,false,ture)]; 
		};
		Creatmove(2,shape_LB01,shape_LB01_original,shape_LB01_target,shape_LB01_controls,shape_LB01_fun,1,temptime_03+5500,1);
		
		var shape_LB02=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:mask_02});
		conlist.push(shape_LB02);
		var shape_LB02_original={x:vw*0.6,y:-vh*0.5,fontsize:vh*0.02};
		var shape_LB02_target={x: vw*0.3, y: -vh*0.2,fontsize:vh*0.02};
		var shape_LB02_controls={x: [vw*0.2, vw*0.4, vw*0.7, vw*0.9,vw*0.6,vw*0.4],y: [vh*0.7, vh*0.5, vh*0.3, vh*0.4,vh*0.6,vh*0.2],fontsize:[vh*0.02,vh*0.03,vh*0.04,vh*0.05,vh*0.035,vh*0.025]};
		var tempvw03=vw;
		var tempvh03=vh;
		var shape_LB02_fun= function(obj,obj_hidden){
			obj.rotationY=obj_hidden.rotationY;
			obj.rotationX=obj_hidden.rotationX;
			obj.rotationZ=obj_hidden.rotationZ;
			obj.alpha=1;
			obj.graphics.clear();
			obj.graphics.beginFill(0x00a2e8,1);
			//trace("obj.width "+obj_hidden.fontsize);
			obj.graphics.drawCircle(obj_hidden.x,obj_hidden.y,Getrandomtwoway(obj_hidden.fontsize,obj_hidden.fontsize*0.1));
			obj.graphics.endFill();
			obj.filters=[$.createGlowFilter(0x00a2e8,1,obj_hidden.fontsize*0.4,obj_hidden.fontsize*0.4,4,3,false,ture)]; 
		};
		Creatmove(2,shape_LB02,shape_LB02_original,shape_LB02_target,shape_LB02_controls,shape_LB02_fun,1,temptime_03+5500,1);
		
		var shape_LB03=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:mask_02});
		conlist.push(shape_LB03);
		var shape_LB03_original={x:vw*0.3,y:-vh*0.2,fontsize:vh*0.03};
		var shape_LB03_target={x: vw*0.7, y: -vh*0.2,fontsize:vh*0.03};
		var shape_LB03_controls={x: [vw*0.4, vw*0.2, vw*0.3, vw*0.4,vw*0.6,vw*0.8],y: [vh*0.3, vh*0.5, vh*0.7, vh*0.8,vh*0.8,vh*0.2],fontsize:[vh*0.03,vh*0.06,vh*0.07,vh*0.04,vh*0.06,vh*0.035]};
		var tempvw04=vw;
		var tempvh04=vh;
		var shape_LB03_fun= function(obj,obj_hidden){
			obj.rotationY=obj_hidden.rotationY;
			obj.rotationX=obj_hidden.rotationX;
			obj.rotationZ=obj_hidden.rotationZ;
			obj.alpha=1;
			obj.graphics.clear();
			obj.graphics.beginFill(0x00a2e8,1);
			//trace("obj.width "+obj_hidden.fontsize);
			obj.graphics.drawCircle(obj_hidden.x,obj_hidden.y,Getrandomtwoway(obj_hidden.fontsize,obj_hidden.fontsize*0.1));
			obj.graphics.endFill();
			obj.filters=[$.createGlowFilter(0x00a2e8,1,obj_hidden.fontsize*0.4,obj_hidden.fontsize*0.4,4,3,false,ture)]; 
		};
		Creatmove(2,shape_LB03,shape_LB03_original,shape_LB03_target,shape_LB03_controls,shape_LB03_fun,1,temptime_03+5500,1);
	};
	//trace("time_delay_01 "+temptime_03);
	Delayfun(ViewLB,temptime_03);
	
}
funlist.push(LBfun_001);

function LBfun_002(timenow,timenext,state){
	//trace("LB002");
	//trace(bg.numChildren);
	Timerstop();
	ViewMask();
	Disppear();
	
	var shape_00=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:bg});
	shape_00.graphics.beginFill(0xffffff,1);
	shape_00.graphics.drawRect(0,0,vw,vh);
	shape_00.graphics.endFill();
	conlist.push(shape_00);
	Clearmaskbg(0);
	
	//trace("gettitle");
	var time_delay_02=4500;
	
	var mask_01=$.createCanvas({x:0,y:0,lifeTime:0,parent:bg,motionGroup:
		[
			{
				y:{fromValue:-vh*2,toValue:0,lifeTime:1,easing:"Back" }
			}
		]});
	masks.push(mask_01);
	
	var mask_02=$.createCanvas({x:0,y:0,lifeTime:0,parent:bg,motionGroup:
		[
			{
				x:{fromValue:0,toValue:0,lifeTime:1,easing:"Back"},
				y:{fromValue:-vh*2,toValue:0,lifeTime:1,easing:"Back" }
			},
			{
				x:{fromValue:0,toValue:-vw,lifeTime:1.5,startDelay:time_delay_02,easing:"Expo"},
				y:{fromValue:0,toValue:0,lifeTime:1.5,startDelay:time_delay_02,easing:"Expo" }
			}
		]});
	masks.push(mask_02);
	//trace(bg.x+" "+mask_02.x);
	var mask_03=$.createCanvas({x:0,y:0,lifeTime:0,parent:bg,motionGroup:
		[
			{
				y:{fromValue:-vh*2,toValue:0,lifeTime:1,easing:"Back" }
			}
		]});
	masks.push(mask_03);
	
	Showtitle(mask_02);
	var time_delay_01=0;
	var ViewLB=function(){
		//trace("ViewLB");
		
		//trace(state);
		var temptime_01=Gettime(state)+time_delay_01;
		var shape_LB01=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:mask_01});
		conlist.push(shape_LB01);
		var shape_LB01_original={x:vw*0.3,y:vh*2,fontsize:vh*0.02};
		var shape_LB01_target={x: vw*1.5, y: vh*0.1,fontsize:vh*0.02};
		var shape_LB01_controls={x: [vw*0.2, vw*0.4, vw*0.5, vw*0.6,vw*0.7,vw*0.9],y: [vh*0.1, vh*0.3, vh*0.45, vh*0.3,vh*0.25,vh*0.2],fontsize:[vh*0.02,vh*0.03,vh*0.04,vh*0.05,vh*0.035,vh*0.025]};
		
		var shape_LB01_fun= function(obj,obj_hidden){
			obj.rotationY=obj_hidden.rotationY;
			obj.rotationX=obj_hidden.rotationX;
			obj.rotationZ=obj_hidden.rotationZ;
			obj.alpha=1;
			obj.graphics.clear();
			obj.graphics.beginFill(0x00a2e8,1);
			//trace("obj.width "+obj_hidden.fontsize);
			obj.graphics.drawCircle(obj_hidden.x,obj_hidden.y,Getrandomtwoway(obj_hidden.fontsize,obj_hidden.fontsize*0.1));
			obj.graphics.endFill();
			obj.filters=[$.createGlowFilter(0x00a2e8,1,obj_hidden.fontsize*0.4,obj_hidden.fontsize*0.4,4,3,false,ture)]; 
		};
		Creatmove(2,shape_LB01,shape_LB01_original,shape_LB01_target,shape_LB01_controls,shape_LB01_fun,1,temptime_01+7000,1);
		
		var shape_LB02=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:mask_01});
		conlist.push(shape_LB02);
		var shape_LB02_original={x:vw*0.7,y:vh*2,fontsize:vh*0.02};
		var shape_LB02_target={x: vw*1.6, y: vh*0.9,fontsize:vh*0.02};
		var shape_LB02_controls={x: [vw*0.6, vw*0.3, vw*0.4, vw*0.6,vw*0.65,vw*0.7,vw*0.9],y: [vh*0.2, vh*0.8, vh*0.5, vh*0.7,vh*0.3,vh*0.45,vh*0.6],fontsize:[vh*0.02,vh*0.03,vh*0.04,vh*0.05,vh*0.035,vh*0.025,vh*0.025]};
		
		var shape_LB02_fun= function(obj,obj_hidden){
			obj.rotationY=obj_hidden.rotationY;
			obj.rotationX=obj_hidden.rotationX;
			obj.rotationZ=obj_hidden.rotationZ;
			obj.alpha=1;
			obj.graphics.clear();
			obj.graphics.beginFill(0x00a2e8,1);
			//trace("obj.width "+obj_hidden.fontsize);
			obj.graphics.drawCircle(obj_hidden.x,obj_hidden.y,Getrandomtwoway(obj_hidden.fontsize,obj_hidden.fontsize*0.1));
			obj.graphics.endFill();
			obj.filters=[$.createGlowFilter(0x00a2e8,1,obj_hidden.fontsize*0.4,obj_hidden.fontsize*0.4,4,3,false,ture)]; 
		};
		Creatmove(2,shape_LB02,shape_LB02_original,shape_LB02_target,shape_LB02_controls,shape_LB02_fun,1,temptime_01+7000,1);
		
		var shape_LB03=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:mask_01});
		conlist.push(shape_LB03);
		var shape_LB03_original={x:vw*0.3,y:vh*2,fontsize:vh*0.03};
		var shape_LB03_target={x: vw*1.2, y: -vh*0.5,fontsize:vh*0.03};
		var shape_LB03_controls={x: [vw*0.4, vw*0.2, vw*0.3, vw*0.4,vw*0.6,vw*0.8],y: [vh*0.3, vh*0.5, vh*0.7, vh*0.8,vh*0.8,vh*0.2],fontsize:[vh*0.03,vh*0.06,vh*0.07,vh*0.04,vh*0.06,vh*0.035]};
		var shape_LB03_fun= function(obj,obj_hidden){
			obj.rotationY=obj_hidden.rotationY;
			obj.rotationX=obj_hidden.rotationX;
			obj.rotationZ=obj_hidden.rotationZ;
			//obj.alpha=1;
			obj.graphics.clear();
			obj.graphics.beginFill(0x00a2e8,1);
			//trace("obj.width "+obj_hidden.fontsize);
			obj.graphics.drawCircle(obj_hidden.x,obj_hidden.y,Getrandomtwoway(obj_hidden.fontsize,obj_hidden.fontsize*0.1));
			obj.graphics.endFill();
			obj.filters=[$.createGlowFilter(0x00a2e8,1,obj_hidden.fontsize*0.4,obj_hidden.fontsize*0.4,4,3,false,ture)]; 
		};
		Creatmove(2,shape_LB03,shape_LB03_original,shape_LB03_target,shape_LB03_controls,shape_LB03_fun,1,temptime_01+7000,1);
	};
	Delayfun(ViewLB,time_delay_01);
	var time_delay_02=5500;
	var temptime_02=Gettime(state)+time_delay_02;
	var Gotonext=function(){
		
		var count=1;
		interval(function(){
			var shape_pika=$.createShape({lifeTime:0,x:0,y:0,alpha:0.7,parent:mask_03});
			conlist.push(shape_pika);
			var shape_pika_original={x:vw,alpha:1};
			var shape_pika_target={ x: 0,alpha:0};
			var shape_pika_controls={x: [vw*0.7, vw*0.2],alpha:[0.8,0.4]};
			var shape_pika_fun=function(obj,obj_hidden){
				obj.rotationY=obj_hidden.rotationY;
				obj.rotationX=obj_hidden.rotationX;
				obj.rotationZ=obj_hidden.rotationZ;
				obj.alpha=obj_hidden.alpha;
				obj.graphics.clear();
				obj.graphics.beginFill(0xffffff,1);
				obj.graphics.drawRect(obj_hidden.x,obj_hidden.y,vw*0.15,vh);
				obj.graphics.endFill();
				obj.filters=[$.createBlurFilter(vw*0.08,vh*0.25,1)];  
				obj.blendMode="invert";
			};
			Creatmove(2,shape_pika,shape_pika_original,shape_pika_target,shape_pika_controls,shape_pika_fun,1,temptime_02+400*count,1);
			count++;
			
		},150,3);
	};
	Delayfun(Gotonext,temptime_02);
	
	var time_delay_n=6500;
	var temptime_n=Gettime(state)+time_delay_n;
	var Viewnext=function(){
		var shape_next=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:mask_03});
		shape_next.graphics.beginFill(0x000000,1);
		shape_next.graphics.drawRect(0,-vh*0.5,vw*2,vh*2);
		shape_next.graphics.endFill();
		shape_next.filters=[$.createBlurFilter(vw*0.4,vh*0.1,1)];  
		conlist.push(shape_next);
		
		var obj_target_n={x:-vw*0.5};
		var obj_original_n={x:vw*1.5};
		
		Creatmove(1,shape_next,obj_original_n,obj_target_n,null,null,4,temptime_n+500,0);
	};
	Delayfun(Viewnext,temptime_n);
	
}
funlist.push(LBfun_002);

function LBfun_003(timenow,timenext,state){
	//trace("LB003");
	Timerstop();
	Disppear();
	
	ViewMask();
	var shape_00=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:mask_bg});
	shape_00.graphics.beginFill(0x000000,1);
	shape_00.graphics.drawRect(0,0,vw,vh);
	shape_00.graphics.endFill();
	shape_00.filters=[$.createBlurFilter(vw*0.3,vh*0.1,1)];  
	conlist.push(shape_00);
	Clearmaskbg(0);
	
	var time_delay_01=0;
	var temptime_01=Gettime(state)+time_delay_01;
	var shape_lins=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:bg});
	conlist.push(shape_lins);
	shape_lins.transform.matrix3D = null;
	
	
	var shape_lins_original={x:0};
	var shape_lins_target={x:0};
	var shape_lins_controls={x:[0,0]};
	var tempvw=vw;
	var tempvh=vh;
	var shape_lins_fun=function(obj,obj_hidden){
		
		
		obj.alpha=1;
		obj.graphics.clear();
		obj.graphics.beginFill(0xffffff,0);
		obj.graphics.lineStyle(1,0xffffff,0.3,false, "normal","round", "round", 1); 
		obj.graphics.moveTo(Getrandom(0,tempvw),Getrandom(0,tempvh));
		var totalnum=Getrandom(10,40);
		for(var i=0;i<totalnum;i++){
			//trace(vw*(obj_hidden.fontsize*(16/9.0)));
			obj.graphics.curveTo(Getrandom(0,tempvw), Getrandom(0,tempvh), Getrandom(0,tempvw),  Getrandom(0,tempvh)); 
		}
		obj.graphics.endFill();
		
	};
	Creatmove(2,shape_lins,shape_lins_original,shape_lins_target,shape_lins_controls,shape_lins_fun,1,temptime_01+10000,1);
	Showcard01(bg,state);
	Showcard02(bg,state);
	Showcard03(bg,state);
	Showcard04(bg,state);
	Showcard05(bg,state);
	
	var time_delay_ViewLB=4000;
	var temptime_ViewLB=Gettime(state)+time_delay_ViewLB;
	var ViewLB=function(){
		
		var shape_LB01=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:bg});
		conlist.push(shape_LB01);
		var shape_LB01_original={x:vw*0.8,y:vh*1.5,fontsize:vh*0.02};
		var shape_LB01_target={x: vw*1.5, y: vh*0.1,fontsize:vh*0.02};
		var shape_LB01_controls={x: [vw*0.6, vw*0.7],y: [vh*0.6, vh*0.4],fontsize:[vh*0.02,vh*0.03,vh*0.04,vh*0.05,vh*0.035,vh*0.025]};
		
		var shape_LB01_fun= function(obj,obj_hidden){
			obj.rotationY=obj_hidden.rotationY;
			obj.rotationX=obj_hidden.rotationX;
			obj.rotationZ=obj_hidden.rotationZ;
			obj.alpha=1;
			obj.graphics.clear();
			obj.graphics.beginFill(0x00a2e8,1);
			//trace("obj.width "+obj_hidden.fontsize);
			obj.graphics.drawCircle(obj_hidden.x,obj_hidden.y,Getrandomtwoway(obj_hidden.fontsize,obj_hidden.fontsize*0.1));
			obj.graphics.endFill();
			obj.filters=[$.createGlowFilter(0x00a2e8,1,obj_hidden.fontsize*0.4,obj_hidden.fontsize*0.4,4,3,false,ture)]; 
		};
		Creatmove(2,shape_LB01,shape_LB01_original,shape_LB01_target,shape_LB01_controls,shape_LB01_fun,1,temptime_ViewLB+3000,1);
		
		var shape_LB02=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:bg});
		conlist.push(shape_LB02);
		var shape_LB02_original={x:vw*0.4,y:vh*1.3,fontsize:vh*0.022};
		var shape_LB02_target={x: -vw*0.6, y: vh*0.2,fontsize:vh*0.022};
		var shape_LB02_controls={x: [vw*0.5, vw*0.3],y: [vh*0.6, vh*0.3],fontsize:[vh*0.022,vh*0.032,vh*0.042,vh*0.052,vh*0.037,vh*0.027,vh*0.027]};
		
		var shape_LB02_fun= function(obj,obj_hidden){
			obj.rotationY=obj_hidden.rotationY;
			obj.rotationX=obj_hidden.rotationX;
			obj.rotationZ=obj_hidden.rotationZ;
			obj.alpha=1;
			obj.graphics.clear();
			obj.graphics.beginFill(0x00a2e8,1);
			//trace("obj.width "+obj_hidden.fontsize);
			obj.graphics.drawCircle(obj_hidden.x,obj_hidden.y,Getrandomtwoway(obj_hidden.fontsize,obj_hidden.fontsize*0.1));
			obj.graphics.endFill();
			obj.filters=[$.createGlowFilter(0x00a2e8,1,obj_hidden.fontsize*0.4,obj_hidden.fontsize*0.4,4,3,false,ture)]; 
		};
		Creatmove(2,shape_LB02,shape_LB02_original,shape_LB02_target,shape_LB02_controls,shape_LB02_fun,1,temptime_ViewLB+3000,1);
		
		var shape_LB03=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:bg});
		conlist.push(shape_LB03);
		var shape_LB03_original={x:vw*0.3,y:vh*1.5,fontsize:vh*0.03};
		var shape_LB03_target={x: vw*0.5, y: -vh*0.5,fontsize:vh*0.03};
		var shape_LB03_controls={x: [vw*0.7, vw*0.4, vw*0.5],y: [vh*0.8, vh*0.7, vh*0.6],fontsize:[vh*0.03,vh*0.06,vh*0.07,vh*0.04,vh*0.06,vh*0.035]};
		var shape_LB03_fun= function(obj,obj_hidden){
			obj.rotationY=obj_hidden.rotationY;
			obj.rotationX=obj_hidden.rotationX;
			obj.rotationZ=obj_hidden.rotationZ;
			//obj.alpha=1;
			obj.graphics.clear();
			obj.graphics.beginFill(0x00a2e8,1);
			//trace("obj.width "+obj_hidden.fontsize);
			obj.graphics.drawCircle(obj_hidden.x,obj_hidden.y,Getrandomtwoway(obj_hidden.fontsize,obj_hidden.fontsize*0.1));
			obj.graphics.endFill();
			obj.filters=[$.createGlowFilter(0x00a2e8,1,obj_hidden.fontsize*0.4,obj_hidden.fontsize*0.4,4,3,false,ture)]; 
		};
		Creatmove(2,shape_LB03,shape_LB03_original,shape_LB03_target,shape_LB03_controls,shape_LB03_fun,1,temptime_ViewLB+3000,1);
	};
	Delayfun(ViewLB,temptime_ViewLB);
	
	var time_delay_ViewLB2=7500;
	var temptime_ViewLB2=Gettime(state)+time_delay_ViewLB2;
	var ViewLB2=function(){
		
		
		var shape_LB03=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:bg});
		conlist.push(shape_LB03);
		var shape_LB03_original={x:vw*0.5,y:-vh,fontsize:vh*0.03};
		var shape_LB03_target={x: vw*0.5, y: vh*0.5,fontsize:vh*0.03};
		var shape_LB03_controls={x: [vw*0.5, vw*0.5],y: [vh*0.2, vh*0.3],fontsize:[vh*0.03,vh*0.02]};
		var templength03=1;
		var tempvw=vw;
		var tempvh=vh;
		var tempsize=vh*0.01;
		var tempcount03=2;
		var tempalpha03=0.9;
		var shape_LB03_fun= function(obj,obj_hidden){
			
			if(Player.time<=temptime_ViewLB2+1000)
			{
				obj.rotationY=obj_hidden.rotationY;
				obj.rotationX=obj_hidden.rotationX;
				obj.rotationZ=obj_hidden.rotationZ;
				//obj.alpha=1;
				obj.graphics.clear();
				obj.graphics.beginFill(0xffffff,1);
				//trace("obj.width "+obj_hidden.fontsize);
				obj.graphics.drawCircle(obj_hidden.x,obj_hidden.y,Getrandomtwoway(obj_hidden.fontsize,obj_hidden.fontsize*0.1));
				obj.graphics.endFill();
				obj.filters=[$.createGlowFilter(0xffffff,1,obj_hidden.fontsize*0.4,obj_hidden.fontsize*0.4,4,3,false,ture)]; 
			}
			else if(Player.time<=temptime_ViewLB2+2000){
				obj.graphics.clear();
				obj.graphics.beginFill(0xffffff,tempalpha03);
				obj.graphics.drawCircle(obj_hidden.x,obj_hidden.y,tempcount03*1.5);
				obj.graphics.endFill();
				obj.graphics.beginFill(0xffffff,1);
				obj.graphics.drawEllipse(obj_hidden.x,obj_hidden.y-tempcount03*0.5,tempsize,tempsize+tempcount03);
				obj.graphics.endFill();
				obj.filters=[$.createGlowFilter(0xffffff,1,obj_hidden.fontsize*0.4,obj_hidden.fontsize*0.4,4,3,false,ture)]; 
				//obj.rotationZ+=count;
				tempcount03*=1.6;
				tempalpha03-=0.2;
			}
			else if(templength03<=tempvw*0.5){
				templength03*=2;
				obj.graphics.clear();
				obj.graphics.endFill();
				obj.graphics.beginFill(0xffffff,1);
				//obj.graphics.lineStyle(1,0xffffff,0.3,false, "normal","round", "round", 1); 
				obj.graphics.drawRect(obj_hidden.x-templength03,0,templength03*2,tempvh);
				obj.graphics.endFill();
				
			}
		};
		Creatmove(2,shape_LB03,shape_LB03_original,shape_LB03_target,shape_LB03_controls,shape_LB03_fun,1,temptime_ViewLB2+900,1);
		
		
		var shape_LB01=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:bg});
		conlist.push(shape_LB01);
		var shape_LB01_original={x:vw*1.2,y:vh*0.4,fontsize:vh*0.02};
		var shape_LB01_target={x: vw*0.75, y: vh*0.5,fontsize:vh*0.01};
		var shape_LB01_controls={x: [vw*0.9, vw*0.8],y: [vh*0.2, vh*0.35],fontsize:[vh*0.02,vh*0.015]};
		var templength01=1;
		var tempcount01=2;
		var tempalpha01=0.9;
		var shape_LB01_fun= function(obj,obj_hidden){
			if(Player.time<=temptime_ViewLB2+1000)
			{
				obj.rotationY=obj_hidden.rotationY;
				obj.rotationX=obj_hidden.rotationX;
				obj.rotationZ=obj_hidden.rotationZ;
				//obj.alpha=1;
				obj.graphics.clear();
				obj.graphics.beginFill(0x00a2e8,1);
				//trace("obj.width "+obj_hidden.fontsize);
				obj.graphics.drawCircle(obj_hidden.x,obj_hidden.y,Getrandomtwoway(obj_hidden.fontsize,obj_hidden.fontsize*0.1));
				obj.graphics.endFill();
				obj.filters=[$.createGlowFilter(0x00a2e8,1,obj_hidden.fontsize*0.4,obj_hidden.fontsize*0.4,4,3,false,ture)]; 
			}
			else if(Player.time<=temptime_ViewLB2+2000){
				obj.graphics.clear();
				obj.graphics.beginFill(0x00a2e8,tempalpha01);
				obj.graphics.drawCircle(obj_hidden.x,obj_hidden.y,tempcount01*1.5);
				obj.graphics.endFill();
				obj.graphics.beginFill(0x00a2e8,1);
				obj.graphics.drawEllipse(obj_hidden.x,obj_hidden.y-tempcount01*0.5,tempsize,tempsize+tempcount01);
				obj.graphics.endFill();
				obj.filters=[$.createGlowFilter(0x00a2e8,1,obj_hidden.fontsize*0.2,obj_hidden.fontsize*0.2,3,3,false,ture)];
				//obj.rotationZ+=count;
				tempcount01*=1.6;
				tempalpha01-=0.2;
			}
			else if(templength01<=tempvw*0.25){
				templength01*=2;
				obj.graphics.clear();
				obj.graphics.endFill();
				obj.graphics.beginFill(0x00a2e8,1);
				//obj.graphics.lineStyle(1,0xffffff,0.3,false, "normal","round", "round", 1); 
				obj.graphics.drawRect(obj_hidden.x,0,templength01,tempvh);
				obj.graphics.endFill();
				obj.filters=[$.createGlowFilter(0x00a2e8,1,obj_hidden.fontsize*0.2,obj_hidden.fontsize*0.2,3,3,false,ture)];
			}
			
		};
		Creatmove(2,shape_LB01,shape_LB01_original,shape_LB01_target,shape_LB01_controls,shape_LB01_fun,1,temptime_ViewLB2+900,1);
		
		var shape_LB02=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:bg});
		conlist.push(shape_LB02);
		var shape_LB02_original={x:-vw*0.2,y:vh*0.4,fontsize:vh*0.022};
		var shape_LB02_target={x: vw*0.25, y: vh*0.5,fontsize:vh*0.022};
		var shape_LB02_controls={x: [vw*0.1, vw*0.2],y: [vh*0.2, vh*0.35],fontsize:[vh*0.022,vh*0.017]};
		var templength02=1;
		var tempcount02=2;
		var tempalpha02=0.9;
		var shape_LB02_fun= function(obj,obj_hidden){
			var templength=1;
			if(Player.time<=temptime_ViewLB2+1000)
			{
				obj.rotationY=obj_hidden.rotationY;
				obj.rotationX=obj_hidden.rotationX;
				obj.rotationZ=obj_hidden.rotationZ;
				//obj.alpha=1;
				obj.graphics.clear();
				obj.graphics.beginFill(0x00a2e8,1);
				//trace("obj.width "+obj_hidden.fontsize);
				obj.graphics.drawCircle(obj_hidden.x,obj_hidden.y,Getrandomtwoway(obj_hidden.fontsize,obj_hidden.fontsize*0.1));
				obj.graphics.endFill();
				obj.filters=[$.createGlowFilter(0x00a2e8,1,obj_hidden.fontsize*0.4,obj_hidden.fontsize*0.4,4,3,false,ture)]; 
			}
			else if(Player.time<=temptime_ViewLB2+2000){
				obj.graphics.clear();
				obj.graphics.beginFill(0x00a2e8,tempalpha02);
				obj.graphics.drawCircle(obj_hidden.x,obj_hidden.y,tempcount02*1.5);
				obj.graphics.endFill();
				obj.graphics.beginFill(0x00a2e8,1);
				obj.graphics.drawEllipse(obj_hidden.x,obj_hidden.y-tempcount02*0.5,tempsize,tempsize+tempcount02);
				obj.graphics.endFill();
				obj.filters=[$.createGlowFilter(0x00a2e8,1,obj_hidden.fontsize*0.4,obj_hidden.fontsize*0.4,4,3,false,ture)]; 
				//obj.rotationZ+=count;
				tempcount02*=1.6;
				tempalpha02-=0.2;
			}
			else if(templength02<=tempvw*0.25){
				templength02*=2;
				obj.graphics.clear();
				obj.graphics.endFill();
				obj.graphics.beginFill(0x00a2e8,1);
				//obj.graphics.lineStyle(1,0xffffff,0.3,false, "normal","round", "round", 1); 
				obj.graphics.drawRect(obj_hidden.x,0,-templength02,tempvh);
				obj.graphics.endFill();
				
			}
		};
		Creatmove(2,shape_LB02,shape_LB02_original,shape_LB02_target,shape_LB02_controls,shape_LB02_fun,1,temptime_ViewLB2+900,1);
		
	};
	Delayfun(ViewLB2,temptime_ViewLB2);
	
	//trace("fun03 over");
	var delay_Viewtxt=00;
	var temptime_Viewtxt=Gettime(state)+delay_Viewtxt;
	var Viewtxt=function(){
		Txtfun("不论是谁　都有想去逃避的时候",Gettime(state+1)-Player.time-6000);
	};
	Delayfun(Viewtxt,temptime_Viewtxt);
	
	var delay_Viewtxt2=6000;
	var temptime_Viewtxt2=Gettime(state)+delay_Viewtxt2;
	var Viewtxt2=function(){
		Txtfun("只要在那一刻发挥出潜藏的那种力量",Gettime(state+1)-Player.time-2000);
	};
	Delayfun(Viewtxt2,temptime_Viewtxt2);
	
	var delay_Viewtxt3=10000;
	var temptime_Viewtxt3=Gettime(state)+delay_Viewtxt3;
	var Viewtxt3=function(){
		Txtfun("便可以清楚前路上的障碍",Gettime(state+1)-Player.time);
	};
	Delayfun(Viewtxt3,temptime_Viewtxt3);
	
}
funlist.push(LBfun_003);

function LBfun_004(timenow,timenext,state){
	//trace("LB004");
	ViewMask();
	var shape_00=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:mask_bg});
	conlist.push(shape_00);
	shape_00.graphics.beginFill(0xffffff,1);
	shape_00.graphics.drawRect(0,0,vw,vh);
	shape_00.graphics.endFill();  
	Timerstop();
	Disppear();
	
	
	
	
	
	
	var delay_BG01=0;
	var temptime_BG01=Gettime(state)+delay_BG01;
	
	var shape_BG03=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:mask_bg});
	conlist.push(shape_BG03);
	var shape_BG03_original={y:0};
	var shape_BG03_target={ y: -vh*1.5};
	var shape_BG03_controls={y: [-vh*0.1, -vh*0.15,-vh*0.25,-vh*0.4,-vh*0.8]};
	var tempvw=vw;
	var tempvh=vh;
	var shape_BG03_fun= function(obj,obj_hidden){
		obj.graphics.clear();
		obj.graphics.beginFill(0xffffff,1);
		//trace("obj.width "+obj_hidden.fontsize);
		obj.graphics.drawRect(vw*0.25,obj_hidden.y,tempvw*0.5,tempvh);
		obj.graphics.endFill();
		obj.filters=[$.createGlowFilter(0xffffff,1,obj_hidden.fontsize*0.2,obj_hidden.fontsize*0.2,3,3,false,ture)];
		//obj.filters=[$.createGlowFilter(0xffffff,1,tempvw*0.01,tempvh*0.04,4,3,false,ture)]; 
	};
	Creatmove(2,shape_BG03,shape_BG03_original,shape_BG03_target,shape_BG03_controls,shape_BG03_fun,1,temptime_BG01+1500,1);
	//conlist.push(shape_BG03);
	
	var shape_BG01=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:mask_bg});
	conlist.push(shape_BG01);
	var shape_BG01_original={y:0};
	var shape_BG01_target={y: vh*1.5};
	var shape_BG01_controls={y: [vh*0.1, vh*0.15,vh*0.25,vh*0.4,vh*0.8]};
	var tempvw=vw;
	var tempvh=vh;
	var shape_BG01_fun= function(obj,obj_hidden){
		obj.graphics.clear();
		obj.graphics.beginFill(0x00a2e8,1);
		//trace("obj.width "+obj_hidden.fontsize);
		obj.graphics.drawRect(0,obj_hidden.y,tempvw*0.25,tempvh);
		obj.graphics.endFill();
		obj.filters=[$.createGlowFilter(0x00a2e8,1,obj_hidden.fontsize*0.2,obj_hidden.fontsize*0.2,3,3,false,ture)];
		//obj.filters=[$.createGlowFilter(0x00a2e8,1,tempvw*0.01,tempvh*0.04,4,3,false,ture)]; 
	};
	Creatmove(2,shape_BG01,shape_BG01_original,shape_BG01_target,shape_BG01_controls,shape_BG01_fun,1,temptime_BG01+1500,1);
	//conlist.push(shape_BG01);
	
	var shape_BG02=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:mask_bg});
	conlist.push(shape_BG02);
	var shape_BG02_original={y:0};
	var shape_BG02_target={ y: vh*1.5};
	var shape_BG02_controls={y: [vh*0.1, vh*0.15,vh*0.25,vh*0.4,vh*0.8]};
	var tempvw=vw;
	var tempvh=vh;
	var shape_BG02_fun= function(obj,obj_hidden){
		obj.graphics.clear();
		obj.graphics.beginFill(0x00a2e8,1);
		//trace("obj.width "+obj_hidden.fontsize);
		obj.graphics.drawRect(vw*0.75,obj_hidden.y,tempvw*0.25,tempvh);
		obj.graphics.endFill();
		obj.filters=[$.createGlowFilter(0x00a2e8,1,obj_hidden.fontsize*0.2,obj_hidden.fontsize*0.2,3,3,false,ture)];
		//obj.filters=[$.createGlowFilter(0x00a2e8,1,tempvw*0.01,tempvh*0.04,4,3,false,ture)]; 
	};
	Creatmove(2,shape_BG02,shape_BG02_original,shape_BG02_target,shape_BG02_controls,shape_BG02_fun,1,temptime_BG01+1500,1);
	//conlist.push(shape_BG02);
	
	
	shape_00.alpha=0;
	
	var time_delay_ViewLB2=1500;
	var temptime_ViewLB2=Gettime(state)+time_delay_ViewLB2;
	var ViewLB2=function(){
		
		Clearmaskbg(-1);
		
		var shape_LB03=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:bg});
		var shape_LB03_pika=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:bg});
		conlist.push(shape_LB03);
		conlist.push(shape_LB03_pika);
		var shape_LB03_original={x:-vw*0.5,y:0,fontsize:vh*0.03,rotationZ:0};
		var shape_LB03_target={x: vw*1.5, y: 0,fontsize:vh*0.03,rotationZ:50};
		var shape_LB03_controls={x:[vw*0,vw*0.1,vw*0.2,vw*0.3,vw*0.4,vw*0.5,vw*0.6,vw*0.7,vw*0.8,vw*0.9,vw*1],y: [vh*0.1, vh*0.2,vh*0.3,vh*0.4,vh*0.5,vh*0.6,vh*0.5,vh*0.4,vh*0.3,vh*0.2,vh*0.1],fontsize:[vh*0.05,vh*0.06,vh*0.07,vh*0.08,vh*0.08,vh*0.09,vh*0.09,vh*0.09,vh*0.08,vh*0.07,vh*0.06],rotationZ:[0,0,0,10,20,30]};
		var templength03=1;
		var tempvw=vw;
		var tempvh=vh;
		var tempsize=vh*0.01;
		var tempcount03=2;
		var tempalpha03=0.9;
		
		var shape_LB03_fun= function(obj,obj_hidden){
			
			if(Player.time<=temptime_ViewLB2+8000)
			{
				
				//obj.alpha=1;
				obj.graphics.clear();
				obj.graphics.beginFill(0x00a2e8,1);
				//trace("obj.width "+obj_hidden.fontsize);
				obj.graphics.drawCircle(obj_hidden.x,obj_hidden.y,Getrandomtwoway(obj_hidden.fontsize,obj_hidden.fontsize*0.1));
				obj.graphics.endFill();
				obj.filters=[$.createGlowFilter(0x00a2e8,1,obj_hidden.fontsize*0.4,obj_hidden.fontsize*0.4,4,3,false,ture)]; 
				obj.rotationY=obj_hidden.rotationY;
				obj.rotationX=obj_hidden.rotationX;
				obj.rotationZ=obj_hidden.rotationZ;
				shape_LB03_pika.graphics.clear();
				//shape_LB03_pika.beginGradientFill("radial", [0xffffff,0xffffff, 0xffffff],[1,1,1],[0x00,0x7f,0xff] , $.createGradientBox(obj_hidden.x,obj_hidden.y,-obj_hidden.fontsize*0.5,-obj_hidden.fontsize*0.5));
				shape_LB03_pika.graphics.beginFill(0xffffff,Getrandom(0.1,0.3));
				shape_LB03_pika.graphics.drawCircle(obj_hidden.x,obj_hidden.y,Getrandom(obj_hidden.fontsize*1.5,obj_hidden.fontsize*3));
				shape_LB03_pika.graphics.endFill();
				shape_LB03_pika.filters=[$.createBlurFilter(obj_hidden.fontsize*2,obj_hidden.fontsize*2,3)]; 
				shape_LB03_pika.rotationZ=obj_hidden.rotationZ;
			}else{
				
				obj.graphics.clear();
				obj.graphics.beginFill(0x00a2e8,1);
				obj.graphics.lineStyle(12, 0x00a2e8, 1, false, "vertical","miter", "miter", 10);
				var tempLBsize=Getrandomtwoway(obj_hidden.fontsize,obj_hidden.fontsize*0.1);
				obj.graphics.moveTo(0,-tempLBsize*2);
				obj.graphics.lineTo(tempLBsize*2*Math.sqrt(3),tempLBsize*2*0.5);
				obj.graphics.lineTo(-tempLBsize*2*Math.sqrt(3),tempLBsize*2*0.5);
				//trace("obj.width "+obj_hidden.fontsize);
				//obj.graphics.drawCircle(obj_hidden.x,obj_hidden.y,Getrandomtwoway(obj_hidden.fontsize,obj_hidden.fontsize*0.1));
				obj.graphics.endFill();
				obj.filters=null;
				obj.x=obj_hidden.x*(vw/tempvw);
				obj.y=obj_hidden.y*(vw/tempvw);
				obj.filters=[$.createGlowFilter(0x00a2e8,1,obj_hidden.fontsize*0.4,obj_hidden.fontsize*0.4,4,3,false,ture)]; 
				obj.rotationZ=obj_hidden.rotationZ;
			}
			if(Player.time>=temptime_ViewLB2+7000&&tempcount03<=tempvh){
				tempcount03*=1.6;
				shape_LB03_pika.graphics.clear();
				//shape_LB03_pika.beginGradientFill("radial", [0xffffff,0xffffff, 0xffffff],[1,1,1],[0x00,0x7f,0xff] , $.createGradientBox(obj_hidden.x,obj_hidden.y,-obj_hidden.fontsize*0.5,-obj_hidden.fontsize*0.5));
				shape_LB03_pika.graphics.beginFill(0x00a2e8,Getrandom(0.4,0.8));
				shape_LB03_pika.graphics.drawCircle(obj_hidden.x,obj_hidden.y,Getrandomtwoway(tempcount03,tempcount03*0.2));
				shape_LB03_pika.graphics.endFill();
				shape_LB03_pika.filters=[$.createBlurFilter(tempcount03*0.3,tempcount03*0.3,3)]; 
				
			}
			if(Player.time>=temptime_ViewLB2+8000){
				shape_LB03_pika.alpha=0;
			}
		};
		Creatmove(2,shape_LB03,shape_LB03_original,shape_LB03_target,shape_LB03_controls,shape_LB03_fun,1,temptime_ViewLB2+13000,1);
		
		
		var shape_LB01=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:bg});
		var shape_LB01_pika=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:bg});
		conlist.push(shape_LB01);
		conlist.push(shape_LB01_pika);
		var shape_LB01_original={x:vw*0.5,y:-vh*0.3,fontsize:vh*0.02,rotationZ:-50};
		var shape_LB01_target={x: vw*0.3, y: -vh*0.5,fontsize:vh*0.02,rotationZ:80};
		var shape_LB01_controls={x:[vw*0.3,vw*0.2,vw*0.3,vw*0.4,vw*0.3,vw*0.5,vw*0.6,vw*0.3,vw*0.5,vw*0.6,vw*0.4],y: [vh*0.4, vh*0.6,vh*0.1,vh*0.3,vh*0.5,vh*0.7,vh*0.8,vh*0.4,vh*0.6,vh*0.8,vh*0.7],fontsize:[vh*0.03,vh*0.04,vh*0.05,vh*0.06,vh*0.06,vh*0.07,vh*0.07,vh*0.07,vh*0.06,vh*0.05,vh*0.04],rotationZ:[-30,-20,30,-10,20,30]};
		var templength01=1;
		var tempcount01=2;
		var tempalpha01=0.9;
		var shape_LB01_fun= function(obj,obj_hidden){
			if(Player.time<=temptime_ViewLB2+8500)
			{
				
				//obj.alpha=1;
				obj.graphics.clear();
				obj.graphics.beginFill(0x00a2e8,1);
				//trace("obj.width "+obj_hidden.fontsize);
				obj.graphics.drawCircle(obj_hidden.x,obj_hidden.y,Getrandomtwoway(obj_hidden.fontsize,obj_hidden.fontsize*0.1));
				obj.graphics.endFill();
				obj.filters=[$.createGlowFilter(0x00a2e8,1,obj_hidden.fontsize*0.4,obj_hidden.fontsize*0.4,4,3,false,ture)]; 
				obj.rotationY=obj_hidden.rotationY;
				obj.rotationX=obj_hidden.rotationX;
				obj.rotationZ=obj_hidden.rotationZ;
				shape_LB01_pika.graphics.clear();
				//shape_LB03_pika.beginGradientFill("radial", [0xffffff,0xffffff, 0xffffff],[1,1,1],[0x00,0x7f,0xff] , $.createGradientBox(obj_hidden.x,obj_hidden.y,-obj_hidden.fontsize*0.5,-obj_hidden.fontsize*0.5));
				shape_LB01_pika.graphics.beginFill(0x00a2e8,Getrandom(0.1,0.3));
				shape_LB01_pika.graphics.drawCircle(obj_hidden.x,obj_hidden.y,Getrandom(obj_hidden.fontsize*1.5,obj_hidden.fontsize*3));
				shape_LB01_pika.graphics.endFill();
				shape_LB01_pika.filters=[$.createBlurFilter(obj_hidden.fontsize*2,obj_hidden.fontsize*2,3)]; 
				shape_LB01_pika.rotationZ=obj_hidden.rotationZ;
			}
			else{
				obj.graphics.clear();
				obj.graphics.beginFill(0x00a2e8,1);
				obj.graphics.lineStyle(12, 0x00a2e8, 1, false, "vertical","miter", "miter", 10);
				var tempLBsize=Getrandomtwoway(obj_hidden.fontsize,obj_hidden.fontsize*0.1);
				obj.graphics.moveTo(0,-tempLBsize);
				obj.graphics.lineTo(tempLBsize*Math.sqrt(3),tempLBsize*0.5);
				obj.graphics.lineTo(-tempLBsize*Math.sqrt(3),tempLBsize*0.5);
				//trace("obj.width "+obj_hidden.fontsize);
				//obj.graphics.drawCircle(obj_hidden.x,obj_hidden.y,Getrandomtwoway(obj_hidden.fontsize,obj_hidden.fontsize*0.1));
				obj.graphics.endFill();
				obj.filters=null;
				obj.x=obj_hidden.x*(vw/tempvw);
				obj.y=obj_hidden.y*(vw/tempvw);
				obj.filters=[$.createGlowFilter(0x00a2e8,1,obj_hidden.fontsize*0.4,obj_hidden.fontsize*0.4,4,3,false,ture)]; 
				obj.rotationZ=obj_hidden.rotationZ;
			}
			if(Player.time>=temptime_ViewLB2+7500&&tempcount01<=tempvh){
				tempcount01*=1.6;
				shape_LB01_pika.graphics.clear();
				//shape_LB03_pika.beginGradientFill("radial", [0xffffff,0xffffff, 0xffffff],[1,1,1],[0x00,0x7f,0xff] , $.createGradientBox(obj_hidden.x,obj_hidden.y,-obj_hidden.fontsize*0.5,-obj_hidden.fontsize*0.5));
				shape_LB01_pika.graphics.beginFill(0x00a2e8,Getrandom(0.4,0.8));
				shape_LB01_pika.graphics.drawCircle(obj_hidden.x,obj_hidden.y,Getrandomtwoway(tempcount01,tempcount01*0.2));
				shape_LB01_pika.graphics.endFill();
				shape_LB01_pika.filters=[$.createBlurFilter(tempcount01*0.3,tempcount01*0.3,3)]; 
			}
			
			if(Player.time>=temptime_ViewLB2+8500){
				shape_LB01_pika.alpha=0;
			}
		};
		Creatmove(2,shape_LB01,shape_LB01_original,shape_LB01_target,shape_LB01_controls,shape_LB01_fun,1,temptime_ViewLB2+13000,1);
		
		var shape_LB02=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:bg});
		var shape_LB02_pika=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:bg});
		conlist.push(shape_LB02);
		conlist.push(shape_LB02_pika);
		var shape_LB02_original={x:vw*0.1,y:vh*0.6,fontsize:vh*0.03,rotationZ:80};
		var shape_LB02_target={x: vw*0.9, y: -vh*0.5,fontsize:vh*0.03,rotationZ:50};
		var shape_LB02_controls={x:[vw*0.2,vw*0.4,vw*0.5,vw*0.6,vw*0.7,vw*0.5,vw*0.3,vw*0.2,vw*0.25,vw*0.3,vw*0.4],y: [vh*0.4, vh*0.3,vh*0.2,vh*0.3,vh*0.4,vh*0.6,vh*0.8,vh*0.3,vh*0.4,vh*0.3,vh*0.2],fontsize:[vh*0.04,vh*0.05,vh*0.06,vh*0.07,vh*0.07,vh*0.08,vh*0.08,vh*0.08,vh*0.07,vh*0.06,vh*0.05],rotationZ:[30,20,-30,10,-20,30]};
		var templength02=1;
		var tempcount02=2;
		var tempalpha02=0.9;
		var shape_LB02_fun= function(obj,obj_hidden){
			if(Player.time<temptime_ViewLB2+9000)
			{
				
				//obj.alpha=1;
				obj.graphics.clear();
				obj.graphics.beginFill(0x00a2e8,1);
				//trace("obj.width "+obj_hidden.fontsize);
				obj.graphics.drawCircle(obj_hidden.x,obj_hidden.y,Getrandomtwoway(obj_hidden.fontsize,obj_hidden.fontsize*0.1));
				obj.graphics.endFill();
				obj.filters=[$.createGlowFilter(0x00a2e8,1,obj_hidden.fontsize*0.4,obj_hidden.fontsize*0.4,4,3,false,ture)]; 
				obj.rotationY=obj_hidden.rotationY;
				obj.rotationX=obj_hidden.rotationX;
				obj.rotationZ=obj_hidden.rotationZ;
				shape_LB02_pika.graphics.clear();
				//shape_LB03_pika.beginGradientFill("radial", [0xffffff,0xffffff, 0xffffff],[1,1,1],[0x00,0x7f,0xff] , $.createGradientBox(obj_hidden.x,obj_hidden.y,-obj_hidden.fontsize*0.5,-obj_hidden.fontsize*0.5));
				shape_LB02_pika.graphics.beginFill(0x00a2e8,Getrandom(0.1,0.3));
				shape_LB02_pika.graphics.drawCircle(obj_hidden.x,obj_hidden.y,Getrandom(obj_hidden.fontsize*1.5,obj_hidden.fontsize*3));
				shape_LB02_pika.graphics.endFill();
				shape_LB02_pika.filters=[$.createBlurFilter(obj_hidden.fontsize*2,obj_hidden.fontsize*2,3)]; 
				shape_LB02_pika.rotationZ=obj_hidden.rotationZ;
			}
			else{
				obj.graphics.clear();
				obj.graphics.beginFill(0x00a2e8,1);
				obj.graphics.lineStyle(12, 0x00a2e8, 1, false, "vertical","miter", "miter", 10);
				var tempLBsize=Getrandomtwoway(obj_hidden.fontsize,obj_hidden.fontsize*0.1);
				Drawrhombus(obj.graphics,tempLBsize);
				obj.graphics.endFill();
				obj.filters=null;
				obj.x=obj_hidden.x*(vw/tempvw);
				obj.y=obj_hidden.y*(vw/tempvw);
				obj.filters=[$.createGlowFilter(0x00a2e8,1,obj_hidden.fontsize*0.4,obj_hidden.fontsize*0.4,4,3,false,ture)]; 
				obj.rotationY=obj_hidden.rotationY;
				obj.rotationX=obj_hidden.rotationX;
				obj.rotationZ=obj_hidden.rotationZ;
			}
			if(Player.time>=temptime_ViewLB2+8000&&tempcount02<=tempvh){
				tempcount02*=1.5;
				shape_LB02_pika.graphics.clear();
				//shape_LB03_pika.beginGradientFill("radial", [0xffffff,0xffffff, 0xffffff],[1,1,1],[0x00,0x7f,0xff] , $.createGradientBox(obj_hidden.x,obj_hidden.y,-obj_hidden.fontsize*0.5,-obj_hidden.fontsize*0.5));
				shape_LB02_pika.graphics.beginFill(0x00a2e8,Getrandom(0.4,0.8));
				shape_LB02_pika.graphics.drawCircle(obj_hidden.x,obj_hidden.y,Getrandomtwoway(tempcount02,tempcount02*0.2));
				shape_LB02_pika.graphics.endFill();
				shape_LB02_pika.filters=[$.createBlurFilter(tempcount02*0.3,tempcount02*0.3,3)]; 
			}
			
			if(Player.time>=temptime_ViewLB2+9000){
				shape_LB02_pika.alpha=0;
			}
			
		};
		Creatmove(2,shape_LB02,shape_LB02_original,shape_LB02_target,shape_LB02_controls,shape_LB02_fun,1,temptime_ViewLB2+13000,1);
		
	};
	Delayfun(ViewLB2,temptime_ViewLB2);
	
	var delay_Scrollcolor=0;
	var temptime_Scrollcolor=Gettime(state)+delay_Scrollcolor;
	
	var Scrollcolor= function(){
		//trace("scroll");
		var shape_00=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:bg});
		conlist.push(shape_00);
		shape_00.graphics.beginFill(0xffffff,1);
		shape_00.graphics.drawRect(0,0,vw,vh);
		shape_00.graphics.endFill();  
		var shape_light=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:bg});
		conlist.push(shape_light);
		var colorlist=[0xffffff,0xffffff];
		var tempcount01=1;
		
		var i_01=interval(function(){
			tempcount01=Getrandom(0,1000);
			tempcount02=Getrandom(150150150,100100100);
			tempcount03=Getrandom(150150150,100100100);
			var tempcolor=Rancolor(tempcount02,tempcount03,1000,tempcount01);
			//tempcount01++;
			colorlist[0]=colorlist[1];
			colorlist[1]=tempcolor;
			
			shape_light.graphics.clear();
			//shape_light.graphics.beginGradientFill("linear",[colorlist[0],colorlist[1],colorlist[2]],[0.5,0.5,0.5],[0x00,0x7f,0xff] , $.createGradientBox(vh,vw, 0,0, 0),"pad");
			shape_light.graphics.beginGradientFill("linear",[colorlist[0],colorlist[1]],[0.5,0.5],[0x00,0xff] , $.createGradientBox(vh,vw, 0,0, 0),"pad");
			shape_light.graphics.drawRect(0,0,vw,vh);
			shape_light.endFill();
			//shape_light.graphics.lineStyle(12, 0x00a2e8, 1, false, "vertical","miter", "miter", 10);
		},200,0);
		interlist.push(i_01);
		hastimer=true;
	};
	Delayfun(Scrollcolor,temptime_Scrollcolor);
	
	var delay_Nextscenes=14000;
	var temptime_Nextscenes=Gettime(state)+delay_Nextscenes;
	var Nextscenes=function(){
		var shape_next=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:bg});
		
		conlist.push(shape_next);
		//var colorlist=[0x000000,0x000000];
		var shape_next_original={x:vw*2};
		var shape_next_target={x:-vw*0.5};
		var shape_next_controls={x: [vw, vw*0.8,vw*0.5,0]};
		var tempvw=vw;
		var tempvh=vh;
		var shape_next_fun= function(obj,obj_hidden){
			shape_next.graphics.clear();
			shape_next.graphics.beginFill(0x000000,1);
			shape_next.graphics.drawRect(0,-tempvh*0.5,tempvw*2,tempvh*2);
			shape_next.graphics.endFill();
			shape_next.filters=[$.createBlurFilter(tempvw*0.5,0,2)]; 
			obj.x=obj_hidden.x*(vw/tempvw);
			
		};
		Creatmove(2,shape_next,shape_next_original,shape_next_target,shape_next_controls,shape_next_fun,1,temptime_Nextscenes+1000,1);
	};
	Delayfun(Nextscenes,temptime_Nextscenes);
	
	var delay_Viewtxt=0;
	var temptime_Viewtxt=Gettime(state)+delay_Viewtxt;
	var Viewtxt=function(){
		Txtfun("一定有些什么事情是你才能做到的",Gettime(state+1)-Player.time-10000);
	};
	Delayfun(Viewtxt,temptime_Viewtxt);
	
	var delay_Viewtxt2=6000;
	var temptime_Viewtxt2=Gettime(state)+delay_Viewtxt2;
	var Viewtxt2=function(){
		Txtfun("使这个蓝色星球　可以继续闪耀着光芒",Gettime(state+1)-Player.time);
	};
	Delayfun(Viewtxt2,temptime_Viewtxt2);
	
}
funlist.push(LBfun_004);

function LBfun_005(timenow,timenext,state){
	//trace("LB005");
	Clearmaskbg(-1);
	ViewMask();
	Timerstop();
	Disppear();
	var shape_00=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:bg});
	conlist.push(shape_00);
	shape_00.graphics.beginFill(0xffffff,1);
	shape_00.graphics.drawRect(0,0,vw,vh);
	shape_00.graphics.endFill();  
	var delay_Shake=1000;
	var temptime_Shake=Gettime(state)+delay_Shake;
	
	var Shake= function(){
		
		var templength=1;
		i_mask=interval(function(){
			blackmask.graphics.clear();
			//blackmask=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:mask_black});
			var ranX=Getrandomtwoway(0,vw*0.1);
			var ranY=Getrandomtwoway(0,vh*0.1);
			blackmask.graphics.beginFill(0x000000,1);
			blackmask.graphics.drawRect(-vw*0.5+ranX,-vh*0.5+ranY,vw*2,vhf*0.5);
			blackmask.graphics.drawRect(-vw*0.5+ranX,(vhf-vh)*0.5+ranY,vwf*0.5,vh);
			blackmask.graphics.drawRect((vwf+vw)*0.5+ranX,(vhf-vh)*0.5+ranY,vw*0.5,vh);
			blackmask.graphics.drawRect(-vw*0.5+ranX,(vhf+vh)*0.5+ranY,vw*2,vh*2);
			blackmask.graphics.endFill();
			//trace("ahah");
			shape_00.alpha=Getrandom(0.2,0.8);
			
		},100,0);
		//interlist.push(i_mask);
		hastimer=true;
	};
	//Delayfun(Shake,temptime_Shake);
	
	
	var delay_ViewLB2=500;
	var temptime_ViewLB2=Gettime(state)+delay_ViewLB2;
	var ViewLB2=function(){
		
		var shape_LB03=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:bg});
		conlist.push(shape_LB03);
		var shape_LB03_original={x:-vw*0.5,y:-vh*0.3,fontsize:vh*0.03,rotationZ:50};
		var shape_LB03_target={x: vw*0.5, y: vh*0.5,fontsize:0,rotationZ:0};
		var shape_LB03_controls={x:[vw*0,vw*0.4,vw*0.2,vw*0.7,vw*0.35,vw*0.6,vw*0.5,vw*0.5],y: [vh*0.4, vh*0.8,vh*0.6,vh*0.2,vh*0.5,vh*0.8,vh*0.5,vh*0.5],fontsize:[vh*0.05,vh*0.06,vh*0.05,vh*0.06,vh*0.1,vh*0.05,2,0],rotationZ:[Getrandomtwoway(0,180),Getrandomtwoway(0,180),Getrandomtwoway(0,180),Getrandomtwoway(0,180),Getrandomtwoway(0,180),Getrandomtwoway(0,180),Getrandomtwoway(0,180),Getrandomtwoway(0,180)]};
		var templength03=1;
		var tempvw=vw;
		var tempvh=vh;
		var tempsize=vh*0.01;
		var tempcount03=2;
		var tempalpha03=0.9;
		
		var shape_LB03_fun= function(obj,obj_hidden){
			
			obj.graphics.clear();
			obj.graphics.beginFill(0x00a2e8,1);
			obj.graphics.lineStyle(12, 0x00a2e8, 1, false, "vertical","miter", "miter", 10);
			var tempLBsize=Getrandomtwoway(obj_hidden.fontsize,obj_hidden.fontsize*0.1);
			obj.graphics.moveTo(0,-tempLBsize*2);
			obj.graphics.lineTo(tempLBsize*2*Math.sqrt(3),tempLBsize*2*0.5);
			obj.graphics.lineTo(-tempLBsize*2*Math.sqrt(3),tempLBsize*2*0.5);
			//trace("obj.width "+obj_hidden.fontsize);
			//obj.graphics.drawCircle(obj_hidden.x,obj_hidden.y,Getrandomtwoway(obj_hidden.fontsize,obj_hidden.fontsize*0.1));
			obj.graphics.endFill();
			obj.filters=null;
			obj.x=obj_hidden.x*(vw/tempvw);
			obj.y=obj_hidden.y*(vw/tempvw);
			obj.filters=[$.createGlowFilter(0x00a2e8,1,obj_hidden.fontsize*0.4,obj_hidden.fontsize*0.4,4,3,false,ture)]; 
			obj.rotationZ=obj_hidden.rotationZ;
		};
		Creatmove(2,shape_LB03,shape_LB03_original,shape_LB03_target,shape_LB03_controls,shape_LB03_fun,1,temptime_ViewLB2+9000,1);
		
		
		var shape_LB01=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:bg});
		
		conlist.push(shape_LB01);
		
		var shape_LB01_original={x:vw*1,y:vh*1.3,fontsize:vh*0.03,rotationZ:Getrandomtwoway(0,180)};
		var shape_LB01_target={x: vw*0.5, y: vh*0.5,fontsize:0,rotationZ:Getrandomtwoway(0,180)};
		var shape_LB01_controls={x:[vw*0.5,vw*0.8,vw*0.4,vw*0.7,vw*0.35,vw*0.5,vw*0.5],y: [vh*0.4, vh*0.8,vh*0.6,vh*0.8,vh*0.9,vh*0.5,vh*0.5],fontsize:[vh*0.05,vh*0.06,vh*0.05,vh*0.06,vh*0.1,2,0],rotationZ:[Getrandomtwoway(0,180),Getrandomtwoway(0,180),Getrandomtwoway(0,180),Getrandomtwoway(0,180),Getrandomtwoway(0,180),Getrandomtwoway(0,180),Getrandomtwoway(0,180)]};
		var templength01=1;
		var tempcount01=2;
		var tempalpha01=0.9;
		var shape_LB01_fun= function(obj,obj_hidden){
			
			obj.graphics.clear();
			obj.graphics.beginFill(0x00a2e8,1);
			obj.graphics.lineStyle(12, 0x00a2e8, 1, false, "vertical","miter", "miter", 10);
			var tempLBsize=Getrandomtwoway(obj_hidden.fontsize,obj_hidden.fontsize*0.1);
			obj.graphics.moveTo(0,-tempLBsize);
			obj.graphics.lineTo(tempLBsize*Math.sqrt(3),tempLBsize*0.5);
			obj.graphics.lineTo(-tempLBsize*Math.sqrt(3),tempLBsize*0.5);
			//trace("obj.width "+obj_hidden.fontsize);
			//obj.graphics.drawCircle(obj_hidden.x,obj_hidden.y,Getrandomtwoway(obj_hidden.fontsize,obj_hidden.fontsize*0.1));
			obj.graphics.endFill();
			obj.filters=null;
			obj.x=obj_hidden.x*(vw/tempvw);
			obj.y=obj_hidden.y*(vw/tempvw);
			obj.filters=[$.createGlowFilter(0x00a2e8,1,obj_hidden.fontsize*0.4,obj_hidden.fontsize*0.4,4,3,false,ture)]; 
			obj.rotationZ=obj_hidden.rotationZ;
			
		};
		Creatmove(2,shape_LB01,shape_LB01_original,shape_LB01_target,shape_LB01_controls,shape_LB01_fun,1,temptime_ViewLB2+9000,1);
		
		var shape_LB02=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:bg});
		
		conlist.push(shape_LB02);
		
		var shape_LB02_original={x:-vw*0.5,y:-vh*0.3,fontsize:vh*0.03,rotationZ:50};
		var shape_LB02_target={x: vw*0.5, y: vh*0.5,fontsize:0,rotationZ:0};
		var shape_LB02_controls={x:[vw*0.3,vw*0.8,vw*0.4,vw*0.6,vw*0.7,vw*0.3,vw*0.5,vw*0.5],y: [vh*0.6, vh*0.2,vh*0.4,vh*0.2,vh*0.1,vh*0.4,vh*0.5,vh*0.5],fontsize:[vh*0.05,vh*0.06,vh*0.05,vh*0.06,vh*0.1,vh*0.05,1,0],rotationZ:[Getrandomtwoway(0,180),Getrandomtwoway(0,180),Getrandomtwoway(0,180),Getrandomtwoway(0,180),Getrandomtwoway(0,180),Getrandomtwoway(0,180),Getrandomtwoway(0,180),Getrandomtwoway(0,180)]};
		var templength02=1;
		var tempcount02=2;
		var tempalpha02=0.9;
		var shape_LB02_fun= function(obj,obj_hidden){
			
			obj.graphics.clear();
			obj.graphics.beginFill(0x00a2e8,1);
			obj.graphics.lineStyle(12, 0x00a2e8, 1, false, "vertical","miter", "miter", 10);
			var tempLBsize=Getrandomtwoway(obj_hidden.fontsize,obj_hidden.fontsize*0.1);
			Drawrhombus(obj.graphics,tempLBsize);
			obj.graphics.endFill();
			obj.filters=null;
			obj.x=obj_hidden.x*(vw/tempvw);
			obj.y=obj_hidden.y*(vw/tempvw);
			obj.filters=[$.createGlowFilter(0x00a2e8,1,obj_hidden.fontsize*0.4,obj_hidden.fontsize*0.4,4,3,false,ture)]; 
			obj.rotationY=obj_hidden.rotationY;
			obj.rotationX=obj_hidden.rotationX;
			obj.rotationZ=obj_hidden.rotationZ;
			
		};
		Creatmove(2,shape_LB02,shape_LB02_original,shape_LB02_target,shape_LB02_controls,shape_LB02_fun,1,temptime_ViewLB2+9000,1);
		
	};
	Delayfun(ViewLB2,temptime_ViewLB2);
	
	var delay_Drawract=8500;
	var temptime_Drawract=Gettime(state)+delay_Drawract;
	var Drawsquare_tempvw=vw;
	var Drawsquare_tempvh=vh;
	
	
	var Drawsquare =function(){
		//trace("Drawract");
		var shape_square=$.createShape({lifeTime:0,x:vw*0.5,y:vh*0.5,alpha:1,parent:bg});
		conlist.push(shape_square);
		var colorlist=[0xff395e,0x3955ff,0x39f3ff,0xe5ff39,0x000000];
		var colorstate=0;
		var length=0;
		var tempvw=vw;
		var tempvh=vh;
		var shape_Square_original={x:vh*0.5,y:vh*0.5};
		var shape_Square_target={x: vw*0.5, y: vh*0.5};
		var shape_Square_controls={x:[vw*0.5],y: [vh*0.5]};
		
		var Square= function(obj,obj_hidden){
			
			obj.graphics.clear();
			obj.graphics.beginFill(colorlist[colorstate],1);
			
			obj.graphics.drawRect(-tempvw*length*0.5,-tempvh*length*0.5,tempvw*length,tempvh*length);
			obj.graphics.endFill();
			obj.filters=[$.createBlurFilter(tempvw*length*0.1,tempvh*length*0.1,2)];
			length+=0.1;
			if(length>1.05&&colorstate<5){
				if(colorstate>3){
					colorstate=4;
				}else{
					length=0;
					colorstate++;
				}
			}
		};
		Creatmove(2,shape_square,shape_Square_original,shape_Square_target,shape_Square_controls,Square,1,temptime_ViewLB2+7000,1);
		
	};
	Delayfun(Drawsquare,temptime_Drawract);
	
	var delay_Viewtxt=0;
	var temptime_Viewtxt=Gettime(state)+delay_Viewtxt;
	var Viewtxt=function(){
		Txtfun("紧握着！　你所拥有的梦想",Gettime(state+1)-Player.time-11000);
	};
	Delayfun(Viewtxt,temptime_Viewtxt);
	
	var delay_Viewtxt2=3000;
	var temptime_Viewtxt2=Gettime(state)+delay_Viewtxt2;
	var Viewtxt2=function(){
		Txtfun("守护着！　你重要的朋友",Gettime(state+1)-Player.time-7000);
	};
	Delayfun(Viewtxt2,temptime_Viewtxt2);
	
	var delay_Viewtxt3=7000;
	var temptime_Viewtxt3=Gettime(state)+delay_Viewtxt3;
	var Viewtxt3=function(){
		Txtfun("使自己变得更坚强",Gettime(state+1)-Player.time);
	};
	Delayfun(Viewtxt3,temptime_Viewtxt3);
}
funlist.push(LBfun_005);

function LBfun_006(timenow,timenext,state){
	//trace("LB006");
	Clearmaskbg(-1);
	ViewMask();
	Timerstop();
	Disppear();
	
	
	var shape_LB99=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:bg});
	conlist.push(shape_LB99);
	
	
	var delay_ViewLB2=0;
	var temptime_ViewLB2=Gettime(state)+delay_ViewLB2;
	var ViewLB2=function(){
		//trace("F006 ViewLB2");
		
		//var temptime_01=Gettime(state)+time_delay_ViewLB;
		var shape_LB03=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:bg});
		conlist.push(shape_LB03);
		var shape_LB03_original={x:-vw*0.5,y:vh*0.3,fontsize:vh*0.03,rotationZ:0};
		var shape_LB03_target={x: vw*1.5, y: vh*0.7,fontsize:0,rotationZ:20};
		var shape_LB03_controls={x:[vw*0,vw*0.1,vw*0.2,vw*0.25,vw*0.7,vw*1.5],y: [vh*0.1, vh*0.2,vh*0.25,vh*0.3,vh*0.4,vh*0.86],fontsize:[vh*0.05,vh*0.06,vh*0.05,vh*0.06],rotationZ:[0,0,10,10,20,20]};
		var templength03=1;
		var tempvw=vw;
		var tempvh=vh;
		var tempsize=vh*0.01;
		var tempcount03=2;
		var tempalpha03=0.9;
		var signal=0;
		var shape_LB03_fun= function(obj,obj_hidden){
			
			obj.graphics.clear();
			obj.graphics.beginFill(0x00a2e8,1);
			obj.graphics.lineStyle(12, 0x00a2e8, 1, false, "vertical","miter", "miter", 10);
			var tempLBsize=Getrandomtwoway(obj_hidden.fontsize,obj_hidden.fontsize*0.1);
			obj.graphics.moveTo(0,-tempLBsize*2);
			obj.graphics.lineTo(tempLBsize*2*Math.sqrt(3),tempLBsize*2*0.5);
			obj.graphics.lineTo(-tempLBsize*2*Math.sqrt(3),tempLBsize*2*0.5);
			//if(signal>1){
			shape_LB99.graphics.beginFill(0x00a2e8,0);
			shape_LB99.graphics.lineStyle(1, 0xffffff, 1, false, "vertical","miter", "miter", 1);
			//var tempLBsize=Getrandomtwoway(obj_hidden.fontsize,obj_hidden.fontsize*0.1);
			shape_LB99.graphics.moveTo(obj_hidden.x*(vw/tempvw)+0,obj_hidden.y*(vw/tempvw)-tempLBsize*2);
			shape_LB99.graphics.lineTo(obj_hidden.x*(vw/tempvw)+tempLBsize*2*Math.sqrt(3),obj_hidden.y*(vw/tempvw)+tempLBsize*2*0.5);
			shape_LB99.graphics.lineTo(obj_hidden.x*(vw/tempvw)-tempLBsize*2*Math.sqrt(3),obj_hidden.y*(vw/tempvw)+tempLBsize*2*0.5);
			shape_LB99.graphics.endFill();
			obj.graphics.endFill();
			obj.filters=null;
			obj.x=obj_hidden.x*(vw/tempvw);
			obj.y=obj_hidden.y*(vw/tempvw);
			obj.filters=[$.createGlowFilter(0x00a2e8,1,obj_hidden.fontsize*0.4,obj_hidden.fontsize*0.4,4,3,false,ture)]; 
			obj.rotationZ=obj_hidden.rotationZ;
		};
		Creatmove(2,shape_LB03,shape_LB03_original,shape_LB03_target,shape_LB03_controls,shape_LB03_fun,1,temptime_ViewLB2+1000,1);
		
		
		var shape_LB01=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:bg});
		conlist.push(shape_LB01);
		
		var shape_LB01_original={x:-vw*0.5,y:vh*0.9,fontsize:vh*0.03,rotationZ:0};
		var shape_LB01_target={x: vw*1.5, y: vh*0.3,fontsize:0,rotationZ:20};
		var shape_LB01_controls={x:[vw*0,vw*0.2,vw*0.3,vw*0.35,vw*0.8,vw*1.5],y: [vh*0.8, vh*0.75,vh*0.7,vh*0.65,vh*0.5,vh*0.4],fontsize:[vh*0.05,vh*0.06,vh*0.05,vh*0.06],rotationZ:[0,0,10,10,20,20]};
		var templength01=1;
		var tempcount01=2;
		var tempalpha01=0.9;
		var shape_LB01_fun= function(obj,obj_hidden){
			
			obj.graphics.clear();
			obj.graphics.beginFill(0x00a2e8,1);
			obj.graphics.lineStyle(12, 0x00a2e8, 1, false, "vertical","miter", "miter", 10);
			var tempLBsize=Getrandomtwoway(obj_hidden.fontsize,obj_hidden.fontsize*0.1);
			obj.graphics.moveTo(0,-tempLBsize);
			obj.graphics.lineTo(tempLBsize*Math.sqrt(3),tempLBsize*0.5);
			obj.graphics.lineTo(-tempLBsize*Math.sqrt(3),tempLBsize*0.5);
			//trace("obj.width "+obj_hidden.fontsize);
			//obj.graphics.drawCircle(obj_hidden.x,obj_hidden.y,Getrandomtwoway(obj_hidden.fontsize,obj_hidden.fontsize*0.1));
			obj.graphics.endFill();
			shape_LB99.graphics.beginFill(0x00a2e8,0);
			shape_LB99.graphics.lineStyle(1, 0xffffff, 1, false, "vertical","miter", "miter", 1);
			//var tempLBsize=Getrandomtwoway(obj_hidden.fontsize,obj_hidden.fontsize*0.1);
			shape_LB99.graphics.moveTo(obj_hidden.x*(vw/tempvw)+0,obj_hidden.y*(vw/tempvw)-tempLBsize*2);
			shape_LB99.graphics.lineTo(obj_hidden.x*(vw/tempvw)+tempLBsize*2*Math.sqrt(3),obj_hidden.y*(vw/tempvw)+tempLBsize*2*0.5);
			shape_LB99.graphics.lineTo(obj_hidden.x*(vw/tempvw)-tempLBsize*2*Math.sqrt(3),obj_hidden.y*(vw/tempvw)+tempLBsize*2*0.5);
			shape_LB99.graphics.endFill();
			obj.filters=null;
			obj.x=obj_hidden.x*(vw/tempvw);
			obj.y=obj_hidden.y*(vw/tempvw);
			obj.filters=[$.createGlowFilter(0x00a2e8,1,obj_hidden.fontsize*0.4,obj_hidden.fontsize*0.4,4,3,false,ture)]; 
			obj.rotationZ=obj_hidden.rotationZ;
			
		};
		Creatmove(2,shape_LB01,shape_LB01_original,shape_LB01_target,shape_LB01_controls,shape_LB01_fun,1,temptime_ViewLB2+1000,1);
		
		var shape_LB02=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:bg});
		var shape_LB02_pika=$.createShape({lifeTime:0,x:0,y:0,alpha:1,parent:bg});
		conlist.push(shape_LB02);
		conlist.push(shape_LB02_pika);
		var shape_LB02_original={x:-vw*0.5,y:vh*0.3,fontsize:vh*0.03,rotationZ:0};
		var shape_LB02_target={x: vw*1.5, y: vh,fontsize:0,rotationZ:20};
		var shape_LB02_controls={x:[vw*0,vw*0.1,vw*0.2,vw*0.25,vw*0.7,vw*1.5],y: [vh*0.5, vh*0.55,vh*0.5,vh*0.7,vh*0.8,vh*0.9],fontsize:[vh*0.05,vh*0.06,vh*0.05,vh*0.06],rotationZ:[0,0,10,10,20,20]};
		var templength02=1;
		var tempcount02=2;
		var tempalpha02=0.9;
		var shape_LB02_fun= function(obj,obj_hidden){
			
			obj.graphics.clear();
			obj.graphics.beginFill(0x00a2e8,1);
			obj.graphics.lineStyle(12, 0x00a2e8, 1, false, "vertical","miter", "miter", 10);
			var tempLBsize=Getrandomtwoway(obj_hidden.fontsize,obj_hidden.fontsize*0.1);
			Drawrhombus(obj.graphics,tempLBsize);
			obj.graphics.endFill();
			shape_LB99.graphics.beginFill(0x00a2e8,0);
			shape_LB99.graphics.lineStyle(1, 0xffffff, 1, false, "vertical","miter", "miter", 1);
			Drawrhombus2(shape_LB99.graphics,tempLBsize,obj_hidden.x*(vw/tempvw),obj_hidden.y*(vw/tempvw));
			shape_LB99.graphics.endFill();
			obj.filters=null;
			obj.x=obj_hidden.x*(vw/tempvw);
			obj.y=obj_hidden.y*(vw/tempvw);
			obj.filters=[$.createGlowFilter(0x00a2e8,1,obj_hidden.fontsize*0.4,obj_hidden.fontsize*0.4,4,3,false,ture)]; 
			obj.rotationY=obj_hidden.rotationY;
			obj.rotationX=obj_hidden.rotationX;
			obj.rotationZ=obj_hidden.rotationZ;
			
		};
		Creatmove(2,shape_LB02,shape_LB02_original,shape_LB02_target,shape_LB02_controls,shape_LB02_fun,1,temptime_ViewLB2+1000,1);
		
	};
	Delayfun(ViewLB2,temptime_ViewLB2);
	
	
	var delay_FFFire=2000;
	var temptime_FFFire=Gettime(state)+delay_FFFire;
	var FFFire=function(){
		//trace("FFF");
		var shape_LB03=$.createShape({lifeTime:0,x:0,y:0,alpha:0.3,parent:bg});
		conlist.push(shape_LB03);
		var shape_LB03_original={x:-vw*0.5,y:vh*0.3,fontsize:vh*0.03,rotationZ:0};
		var shape_LB03_target={x: vw*1.5, y: vh*0.7,fontsize:0,rotationZ:20};
		var shape_LB03_controls={x:[vw*0,vw*0.1,vw*0.2,vw*0.25,vw*0.7,vw*1.5],y: [vh*0.4, vh*0.45,vh*0.4,vh*0.6,vh*0.7,vh*0.8],fontsize:[vh*0.05,vh*0.06,vh*0.05,vh*0.06],rotationZ:[0,0,10,10,20,20]};
		var templength03=1;
		var tempvw=vw;
		var tempvh=vh;
		var tempsize=vh*0.01;
		var tempcount03=2;
		var tempalpha03=0.9;
		var tempheight=1;
		var tempcolor=0xff2b2b;
		var tempY01=[vh,vh,vh,vh,vh,vh,vh,vh,vh,vh];
		var tempY02=[vh,vh,vh,vh,vh,vh,vh,vh,vh,vh];
		var tempY03=[vh,vh,vh,vh,vh,vh,vh,vh,vh,vh];
		//trace("Debug01");
		var shape_LB03_fun= function(obj,obj_hidden){
			
			for(i=0;i<9;i++)
			{
				tempY01[i]=tempY01[i+1];
				tempY02[i]=tempY02[i+1];
				tempY03[i]=tempY03[i+1];
			}
			
			tempY01[9]=Getrandom(tempvh*tempheight,-tempvh*0.6);
			tempY02[9]=Getrandom(tempvh*tempheight,-tempvh*0.4);
			tempY03[9]=Getrandom(tempvh*tempheight*1.2,-tempvh*0.1);
			
			obj.graphics.clear();
			obj.graphics.beginFill(0xffe972,1);
			obj.graphics.moveTo(0,vh*1.5);
			obj.graphics.curveTo(0,tempY01[0],0,tempY01[0]);
			for(i=1;i<tempY01.length-1;i+=2){
				obj.graphics.curveTo(Getrandomtwoway(vw*0.1*(i),vw*0.02),tempY01[i],Getrandomtwoway(vw*0.1*(i+1),vw*0.02),tempY01[i+1]);
			}
			obj.graphics.curveTo(vw,tempY01[9],vw,tempY01[9]);
			obj.graphics.curveTo(vw,vh*1.5,vw,vh*1.5);
			obj.graphics.endFill();
			
			obj.graphics.beginFill(tempcolor,1);
			obj.graphics.moveTo(0,vh*1.5);
			obj.graphics.curveTo(0,tempY02[0],0,tempY02[0]);
			for(i=1;i<tempY02.length-1;i+=2){
				obj.graphics.curveTo(Getrandomtwoway(vw*0.1*(i),vw*0.02),tempY02[i],Getrandomtwoway(vw*0.1*(i+1),vw*0.02),tempY02[i+1]);
			}
			obj.graphics.curveTo(vw,tempY02[9],vw,tempY02[9]);
			obj.graphics.curveTo(vw,vh*1.5,vw,vh*1.5);
			obj.graphics.endFill();
			
			obj.graphics.beginFill(0x000000,1);
			obj.graphics.moveTo(0,vh*1.5);
			obj.graphics.curveTo(0,tempY03[0],0,tempY03[0]);
			for(i=1;i<tempY03.length-1;i+=2){
				obj.graphics.curveTo(Getrandomtwoway(vw*0.1*(i),vw*0.02),tempY03[i],Getrandomtwoway(vw*0.1*(i+1),vw*0.02),tempY03[i+1]);
			}
			obj.graphics.curveTo(vw,tempY03[9],vw,tempY03[9]);
			obj.graphics.curveTo(vw,vh*1.5,vw,vh*1.5);
			obj.graphics.endFill();
			
			obj.filters=[$.createBlurFilter(0,tempvh*0.2,3)];
			obj.alpha+=0.016;
			tempheight-=0.025;
			
		};
		Creatmove(2,shape_LB03,shape_LB03_original,shape_LB03_target,shape_LB03_controls,shape_LB03_fun,1,temptime_ViewLB2+2000,1);
		
		
		
		
		
	};
	Delayfun(FFFire,temptime_FFFire);
	
	var delay_Viewtxt=0;
	var temptime_Viewtxt=Gettime(state)+delay_Viewtxt;
	var Viewtxt=function(){
		Txtfun("潜在的未知力量　像火焰那般被点燃",Gettime(state+1)-Player.time);
	};
	Delayfun(Viewtxt,temptime_Viewtxt);
	
	
}
funlist.push(LBfun_006);


function LBfun_007(timenow,timenext,state){
	//trace("LB007");
	Clearmaskbg(-1);
	ViewMask();
	Timerstop();
	Disppear();
	
	var delay_ViewLB2=0;
	var temptime_ViewLB2=Gettime(state)+delay_ViewLB2;
	
	var mask_01=$.createCanvas({x:0,y:0,lifeTime:0,parent:bg});
	masks.push(mask_01);
	var mask_02=$.createCanvas({x:0,y:0,lifeTime:0,parent:bg});
	masks.push(mask_02);
	var mask_03=$.createCanvas({x:0,y:0,lifeTime:0,parent:bg});
	masks.push(mask_03);
	
	var tempran=0.2;
	var i_04=interval(function(){
		
		
		var mask_temp=$.createCanvas({x:Getrandomtwoway(vw*0.1,vw*tempran),y:Getrandomtwoway(vh*0.1,vh*tempran),lifeTime:500,parent:bg});
		masks.push(mask_temp);
		Showend(mask_temp);
		mask_temp.alpha=0.5;
		var i_06=interval(function(){
			mask_temp.alpha-=0.1;
		},100,5);
		interlist.push(i_06);
		//		mask_temp.x+=;
		//		mask_temp.y=;
		tempran-=0.04;
	},1000,5);
	interlist.push(i_04);
	
	var delay_FinalLB=6000;
	var temptime_FinalLB=Gettime(state)+delay_FinalLB;
	
	var FinalLB=function(){
		//trace("Final");
		mask_02.alpha=0;
		mask_02.x=vw*0.1;
		Showend(mask_02);
		var i_05=interval(function(){
			mask_02.alpha+=0.1;
		},200,10);
		interlist.push(i_05);
	};
	Delayfun(FinalLB,temptime_FinalLB);
	
	var delay_Finished=10000;
	var temptime_Finished=Gettime(state)+delay_Finished;
	var Finished=function(){
		//trace("end!");
		var i_end=interval(function(){
			mask_02.alpha-=0.1;
		},100,10);
		
	};
	Delayfun(Finished,temptime_Finished);
	
	var delay_Viewtxt=0;
	var temptime_Viewtxt=Gettime(state)+delay_Viewtxt;
	var Viewtxt=function(){
		Txtfun("是真的　你的所有愿望",Gettime(state+1)-Player.time-8000);
	};
	Delayfun(Viewtxt,temptime_Viewtxt);
	
	var delay_Viewtxt2=4000;
	var temptime_Viewtxt2=Gettime(state)+delay_Viewtxt2;
	var Viewtxt2=function(){
		Txtfun("都一定可以实现",Gettime(state+1)-Player.time-4000);
	};
	Delayfun(Viewtxt2,temptime_Viewtxt2);
	
	var delay_Viewtxt3=8000;
	var temptime_Viewtxt3=Gettime(state)+delay_Viewtxt3;
	var Viewtxt3=function(){
		Txtfun("show me your brave heart",Gettime(state+1)-Player.time);
	};
	Delayfun(Viewtxt3,temptime_Viewtxt3);
	
}
funlist.push(LBfun_007);

function LBfun_end(timenow,timenext,state){
	//trace("LB006");
	Clearmaskbg(-1);
	HideMask();
	Disppear();
	Timerstop();
	
}
funlist.push(LBfun_end);

function LRCfun(){
	
}

function Rancolor(c1,c2,length,i)
{
	i = i - 1;
	var r1 = (c1 & 0xff0000) >> 16; var r2 = (c2 & 0xff0000) >> 16;
	var g1 = (c1 & 0x00ff00) >> 8;  var g2 = (c2 & 0x00ff00) >> 8;
	var b1 = c1 & 0x0000ff; var b2 = c2 & 0x0000ff;
	
	var now = (r1 + (r2 - r1)/(length - 1) *i) << 16 |(g1 + (g2 - g1)/(length - 1) *i) << 8 |(b1 + (b2 - b1)/(length - 1) *i) ;
	return now;
};

function Drawrhombus(graphics,length){
	
	graphics.moveTo((length*Math.sqrt(3))/2.0,-(length*Math.sqrt(3))/2.0);
	graphics.lineTo(-3*(length*Math.sqrt(3))/2.0,-(length*Math.sqrt(3))/2.0);
	graphics.lineTo(-(length*Math.sqrt(3))/2.0,(length*Math.sqrt(3))/2.0);
	graphics.lineTo(3*(length*Math.sqrt(3))/2.0,(length*Math.sqrt(3))/2.0);
}

function Drawrhombus2(graphics,length,px,py){
	
	graphics.moveTo(px+(length*Math.sqrt(3))/2.0,py-(length*Math.sqrt(3))/2.0);
	graphics.lineTo(px-3*(length*Math.sqrt(3))/2.0,py-(length*Math.sqrt(3))/2.0);
	graphics.lineTo(px-(length*Math.sqrt(3))/2.0,py+(length*Math.sqrt(3))/2.0);
	graphics.lineTo(px+3*(length*Math.sqrt(3))/2.0,py+(length*Math.sqrt(3))/2.0);
}

function Showtitle(mask){
	
	var title = $.createShape({x:0,y:0,lifeTime:0,parent:mask});
	title.transform.matrix3D = null;
	var g = title.graphics;
	
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,3,3,3,3,1]),$.toNumberVector([906,126.164,905.492,127.906,904.306,128.97,903.12,130.034,901.498,130.663,899.877,131.291,897.941,131.606,896.006,131.92,894,132.164,892.789,130.868,891.323,129.055,889.856,127.243,888.782,125.133,887.708,123.023,887.35,120.726,886.993,118.429,888,116.164,890.173,116.056,892.83,116.797,895.486,117.537,898.032,118.899,900.578,120.262,902.718,122.135,904.859,124.007,906,126.164,906,126.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,3,3,3,3,1]),$.toNumberVector([811,153.164,809.197,152.342,808.174,150.74,807.151,149.138,806.32,147.344,805.489,145.55,804.556,143.858,803.623,142.166,802,141.164,799.885,141.049,798.719,141.883,797.553,142.718,796.897,144.062,796.242,145.406,795.877,147.042,795.512,148.677,795,150.164,791.308,140.039,794.568,135.557,797.828,131.075,802.565,131.712,807.303,132.349,810.78,137.843,814.257,143.337,811,153.164,811,153.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1]),$.toNumberVector([750,171.164,747.042,168.862,745.366,165.479,743.689,162.096,742.057,158.859,740.425,155.621,738.22,153.141,736.014,150.661,732,150.164,722.864,149.033,721.07,153.405,719.276,157.776,720.292,164.233,721.307,170.691,722.867,177.528,724.427,184.364,722,188.164,719.276,185.761,717.586,181.292,715.896,176.822,715.26,171.56,714.625,166.298,715.055,160.88,715.484,155.463,717,151.164,723.122,146.544,728.773,146.754,734.423,146.963,738.899,150.31,743.375,153.656,746.326,159.293,749.277,164.929,750,171.164,750,171.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1]),$.toNumberVector([686,165.164,688.558,167.109,690.644,170.303,692.73,173.497,694.352,177.061,695.974,180.625,697.134,184.121,698.295,187.616,699,190.164,696.07,187.62,694.474,184.065,692.878,180.51,691.291,177.154,689.704,173.799,687.462,171.249,685.221,168.699,681,168.164,671.656,166.98,669.534,172.203,667.411,177.425,668.527,185.551,669.644,193.677,672.007,202.956,674.371,212.234,674,219.164,677.124,220.665,679.55,222.864,681.976,225.063,683.886,227.778,685.795,230.494,687.278,233.635,688.762,236.777,690,240.164,693.442,241.104,696.518,240.842,699.594,240.581,702.247,239.51,704.901,238.439,707.103,236.755,709.306,235.07,711,233.164,711.346,229.443,710.871,226.543,710.395,223.644,709.629,221.035,708.863,218.426,708.073,215.841,707.283,213.256,707,210.164,708.966,207.88,711.735,206.4,714.504,204.919,717.695,203.86,720.886,202.801,724.308,201.972,727.73,201.144,731,200.164,733.655,202.595,735.1,206.102,736.545,209.609,738.04,212.887,739.535,216.165,741.71,218.561,743.885,220.956,748,221.164,753.669,221.45,756.013,218.821,758.357,216.191,758.947,211.926,759.536,207.66,759.157,202.4,758.777,197.139,759,192.164,759.04,191.256,759.416,190.051,759.792,188.847,760.196,187.596,760.6,186.346,760.878,185.176,761.156,184.005,761,183.164,760.608,181.056,759.577,179.854,758.545,178.651,757.489,177.802,756.432,176.953,755.656,176.181,754.88,175.409,755,174.164,756.173,174.241,757.493,174.171,758.813,174.101,760.051,174.113,761.29,174.124,762.334,174.33,763.378,174.536,764,175.164,763.648,182.964,764.202,193.773,764.756,204.581,763.659,214.103,762.562,223.625,758.536,229.714,754.511,235.802,745,234.164,741.718,233.599,739.764,231.34,737.81,229.081,736.434,226.014,735.059,222.946,733.887,219.513,732.716,216.079,731,213.164,728.402,213.566,726.086,214.25,723.77,214.934,721.592,215.756,719.414,216.578,717.302,217.466,715.19,218.354,713,219.164,713.557,221.857,713.771,224.893,713.985,227.929,714.025,231.138,714.066,234.348,714.017,237.646,713.969,240.945,714,244.164,712.386,246.55,710.121,248.286,707.857,250.022,704.969,251.133,702.081,252.245,698.582,252.746,695.083,253.247,691,253.164,687.715,251.199,685.948,247.716,684.181,244.233,682.431,240.733,680.681,237.232,678.199,234.465,675.716,231.698,671,231.164,670.756,223.679,669.591,216.809,668.427,209.938,667.148,202.936,665.869,195.933,664.88,188.427,663.892,180.92,664,172.164,665.371,169.91,667.516,168.43,669.66,166.949,672.465,166.13,675.271,165.311,678.683,165.097,682.094,164.884,686,165.164,686,165.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1]),$.toNumberVector([578,213.164,578.744,215.406,580.019,219.2,581.293,222.994,581.895,226.943,582.496,230.891,581.824,234.296,581.151,237.7,578,239.164,578.066,236.249,578.263,233.928,578.46,231.607,578.319,229.698,578.179,227.789,577.466,226.201,576.754,224.613,575,223.164,572.486,224.4,570.725,226.389,568.964,228.378,567.628,230.792,566.292,233.206,565.217,235.881,564.142,238.556,563,241.164,560.276,237.414,560.495,231.628,560.713,225.842,563.016,220.902,565.32,215.961,569.28,213.306,573.24,210.651,578,213.164,578,213.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1]),$.toNumberVector([473,334.164,468.654,340.184,462.187,343.785,455.719,347.387,448.606,348.115,441.493,348.843,434.473,346.469,427.452,344.095,422,338.164,417.326,340.24,412.691,342.355,408.057,344.47,403.358,346.522,398.659,348.573,393.845,350.509,389.031,352.445,384,354.164,383.168,361.457,380.742,367.156,378.317,372.855,374.227,376.89,370.137,380.926,364.348,383.262,358.559,385.598,351,386.164,349.175,380.025,346.078,371.517,342.982,363.01,341.943,354.885,340.904,346.76,343.586,340.392,346.268,334.024,356,332.164,354.066,334.333,352.107,335.904,350.149,337.474,348.571,339.048,346.993,340.621,345.999,342.5,345.005,344.378,345,347.164,344.996,349.229,345.577,350.237,346.159,351.245,346.964,351.979,347.77,352.712,348.619,353.563,349.469,354.414,350,356.164,350.636,358.26,350.467,360.25,350.299,362.24,350.057,364.201,349.816,366.162,349.868,368.133,349.921,370.104,351,372.164,357.563,371.726,362.403,369.567,367.244,367.407,370.616,363.78,373.989,360.153,376.022,355.186,378.054,350.218,379,344.164,381.005,341.836,383.329,340.494,385.652,339.152,388.115,338.284,390.579,337.416,393.094,336.764,395.61,336.112,398,335.164,400.319,334.243,402.65,332.748,404.98,331.252,407.344,329.812,409.708,328.371,412.117,327.302,414.525,326.232,417,326.164,419.185,326.104,422.014,327.514,424.842,328.925,427.916,330.719,430.99,332.513,434.11,334.146,437.231,335.78,440,336.164,445.896,336.983,449.759,335.469,453.623,333.954,456.649,331.589,459.676,329.223,462.465,326.747,465.253,324.27,469,323.164,472.243,322.206,475.469,322.097,478.695,321.989,481.848,321.819,485,321.649,488.052,320.963,491.104,320.276,494,318.164,497.855,315.351,500.593,310.144,503.33,304.937,504.954,298.236,506.577,291.536,507.087,283.792,507.598,276.049,507,268.164,506.742,264.765,506.128,259.819,505.513,254.873,504.356,250.209,503.199,245.544,501.407,242.076,499.614,238.608,497,238.164,489.565,236.903,488.286,243.756,487.006,250.61,488.215,260.266,489.424,269.922,491.287,279.724,493.15,289.527,492,294.164,490.247,286.988,487.655,277.207,485.064,267.427,484.337,258.214,483.61,249.002,486.1,241.946,488.59,234.89,497,233.164,502.471,236.606,506.053,247.966,509.636,259.325,510.95,273.083,512.264,286.842,511.122,300.241,509.979,313.641,506,321.164,503.828,325.271,500.232,328.464,496.636,331.657,492.212,333.5,487.789,335.343,482.837,335.618,477.884,335.893,473,334.164,473,334.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1]),$.toNumberVector([468,280.164,464.083,277.989,461.66,273.775,459.237,269.56,457.01,265.225,454.784,260.89,452.106,257.395,449.428,253.9,445,253.164,441.589,252.597,438.441,253.873,435.293,255.148,432.831,257.354,430.37,259.561,428.806,262.241,427.242,264.921,427,267.164,426.041,276.034,430.741,282.381,435.44,288.729,441.809,294.087,448.178,299.445,454.223,304.581,460.267,309.717,462,316.164,457.803,315.327,454.179,313.972,450.555,312.618,447.371,310.661,444.187,308.704,441.378,306.101,438.568,303.498,436,300.164,433.935,297.483,431.334,293.086,428.734,288.69,426.606,283.735,424.478,278.781,423.325,273.849,422.172,268.916,423,265.164,423.402,263.344,426.032,260.564,428.661,257.784,432.114,255.204,435.567,252.624,439.14,250.824,442.712,249.024,445,249.164,449.645,249.448,452.91,253.389,456.175,257.33,458.72,262.446,461.264,267.562,463.419,272.612,465.574,277.662,468,280.164,468,280.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1]),$.toNumberVector([419,288.164,415.702,286.955,411.947,284.241,408.193,281.527,403.79,278.871,399.386,276.214,394.237,274.397,389.088,272.58,383,273.164,380.087,273.444,377.321,274.207,374.556,274.971,372.099,276.303,369.643,277.635,367.578,279.579,365.512,281.523,364,284.164,364.255,285.659,364.674,286.99,365.093,288.321,365.454,289.71,365.815,291.099,366.006,292.657,366.198,294.215,366,296.164,357.052,289.639,359.413,283.619,361.774,277.598,369.748,274.093,377.721,270.587,388.458,270.602,399.195,270.617,407,276.164,409.318,277.811,410.741,279.553,412.164,281.295,413.34,282.907,414.516,284.519,415.769,285.889,417.022,287.26,419,288.164,419,288.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,3,3,3,3,1]),$.toNumberVector([964,330.164,956.941,325.647,950.143,318.665,943.345,311.683,935.665,306.283,927.986,300.884,918.855,299.092,909.724,297.3,898,303.164,904.202,297.534,910.268,296.216,916.334,294.898,922.228,296.479,928.121,298.06,933.824,301.835,939.526,305.609,945,310.164,948.04,312.695,951.075,315.362,954.11,318.029,956.703,320.63,959.297,323.231,961.23,325.665,963.163,328.099,964,330.164,964,330.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,3,3,3,3,1]),$.toNumberVector([364,298.164,364.375,298.164,364.75,298.164,365.125,298.164,365.5,298.164,365.875,298.164,366.25,298.164,366.625,298.164,367,298.164,366.069,301.608,365.285,305.199,364.502,308.79,363.789,312.453,363.077,316.116,362.398,319.812,361.72,323.509,361,327.164,359.457,324.492,359.748,320.989,360.039,317.487,360.997,313.626,361.955,309.765,362.998,305.782,364.04,301.798,364,298.164,364,298.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1]),$.toNumberVector([382,300.164,385.303,300.861,388.217,301.947,391.13,303.034,393.638,304.526,396.146,306.018,398.241,307.923,400.335,309.829,402,312.164,401.579,313.118,401.118,314.032,400.658,314.947,400.158,315.822,399.658,316.697,399.118,317.532,398.579,318.368,398,319.164,396.592,318.072,395.277,316.887,393.961,315.703,392.637,314.527,391.312,313.351,389.929,312.235,388.545,311.119,387,310.164,385.856,310.981,386.217,313.092,386.578,315.203,386.95,317.421,387.322,319.639,386.959,321.371,386.595,323.103,384,323.164,381.459,321.813,381.118,319.221,380.776,316.629,381.229,313.435,381.681,310.241,382.225,306.764,382.769,303.287,382,300.164,382,300.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1]),$.toNumberVector([291,361.164,292.878,357.663,296.668,352.663,300.459,347.662,303.026,342.246,305.593,336.829,305.37,331.538,305.147,326.246,299,322.164,293.369,318.425,286.267,317.675,279.164,316.925,271.556,318.005,263.947,319.085,256.317,321.415,248.686,323.745,242,326.164,237.257,327.88,232.411,329.646,227.564,331.411,223.581,333.432,219.598,335.453,216.961,337.835,214.324,340.216,214,343.164,214.374,344.54,215.667,344.998,216.959,345.455,218.613,345.551,220.267,345.647,222.003,345.661,223.739,345.675,225,346.164,226.056,354.849,223.043,357.658,220.03,360.467,216.253,359.111,212.476,357.756,209.587,353.091,206.697,348.426,208,342.164,209.229,336.258,226.537,328.044,243.845,319.829,263.557,316.905,283.27,313.981,298.549,320.146,313.829,326.311,311,349.164,310.773,351.001,310.328,352.369,309.882,353.737,309.161,355.12,308.44,356.503,307.414,358.143,306.389,359.783,305,362.164,303.656,362.649,301.605,362.986,299.553,363.324,297.466,363.303,295.379,363.283,293.594,362.801,291.81,362.318,291,361.164,291,361.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1]),$.toNumberVector([260,373.164,259.391,376.483,259.556,380.059,259.721,383.634,260.118,387.328,260.515,391.022,260.871,394.765,261.227,398.509,261,402.164,260.64,407.961,257.973,413.504,255.306,419.048,251.399,423.228,247.491,427.407,242.875,429.669,238.259,431.93,234,431.164,227.893,430.064,225.14,421.713,222.386,413.361,221.587,402.41,220.787,391.458,221.241,380.234,221.694,369.009,222,362.164,224.802,367.396,224.549,375.792,224.296,384.189,223.86,392.626,223.423,401.063,224.24,407.978,225.057,414.894,230,417.164,234.257,419.119,238.527,416.409,242.797,413.699,246.308,408.908,249.819,404.116,252.185,398.534,254.551,392.953,255,389.164,255.973,380.955,255.2,372.951,254.427,364.948,253.505,357.431,252.582,349.915,252.307,343.027,252.032,336.14,254,330.164,258.773,327.865,262.887,328.355,267.001,328.845,270.07,331.272,273.138,333.698,274.967,337.635,276.797,341.571,277,346.164,275.466,344.948,273.601,344.063,271.736,343.178,269.504,342.66,267.272,342.142,264.655,342.009,262.038,341.876,259,342.164,258.818,347.014,258.446,352.265,258.075,357.516,258.555,362.484,259.035,367.452,260.886,371.793,262.737,376.135,267,379.164,271.86,382.618,282.597,385.825,293.335,389.032,303.79,389.102,314.245,389.172,321.337,384.66,328.43,380.148,326,368.164,324.777,366.137,322.101,365.563,319.426,364.988,316.217,364.947,313.008,364.906,309.724,364.94,306.44,364.974,304,364.164,306.422,363.336,309.513,363.177,312.604,363.018,315.857,363.021,319.111,363.024,322.273,362.937,325.435,362.849,328,362.164,329.371,364.937,330.708,368.302,332.045,371.667,332.896,375.236,333.746,378.806,333.885,382.384,334.024,385.963,333,389.164,329.749,399.321,318.116,401.525,306.484,403.728,293.729,400.562,280.975,397.395,270.727,390.15,260.48,382.904,260,374.164,260,374.039,260,373.914,260,373.789,260,373.664,260,373.539,260,373.414,260,373.289,260,373.164,260,373.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1]),$.toNumberVector([191,389.164,197.225,391.301,202.282,395.192,207.34,399.083,210.303,404.298,213.266,409.513,213.672,415.837,214.078,422.161,211,429.164,207.945,436.113,201.084,444.333,194.224,452.552,185.418,460.381,176.612,468.211,166.792,474.821,156.973,481.432,148,485.164,142.353,487.513,135.853,489.589,129.353,491.664,123.568,492.015,117.784,492.366,113.499,490.266,109.215,488.166,108,482.164,106.634,482.28,105.407,482.256,104.181,482.233,103.068,482.095,101.956,481.958,100.945,481.719,99.9345,481.479,99,481.164,93.8257,477.407,91.4049,469.278,88.9841,461.15,88.6782,451.65,88.3724,442.15,89.8625,432.778,91.3525,423.407,94,417.164,94.0859,423.383,93.1461,430.449,92.2064,437.514,91.6346,444.402,91.0628,451.29,91.5558,457.487,92.0487,463.683,95,468.164,96.5139,469.213,98.0986,469.173,99.6833,469.133,101.319,468.673,102.954,468.213,104.629,467.669,106.305,467.124,108,467.164,107.799,469.29,107.622,470.834,107.445,472.377,107.478,473.698,107.51,475.018,107.844,476.295,108.179,477.571,109,479.164,117.188,479.464,125.077,477.842,132.966,476.219,140.579,473.038,148.193,469.856,155.542,465.297,162.892,460.738,170,455.164,174.713,451.468,181.416,445.766,188.119,440.063,194.017,433.243,199.915,426.423,203.61,418.93,207.304,411.438,206,404.164,205.055,398.89,201.565,396.484,198.075,394.077,193.147,393.231,188.219,392.384,182.406,392.444,176.593,392.504,171,392.164,175.264,388.704,180.037,381.814,184.81,374.924,186.154,368.234,187.497,361.544,183.443,356.869,179.389,352.194,166,353.164,160.533,353.56,154.59,354.949,148.647,356.338,142.508,358.381,136.369,360.425,130.172,362.955,123.976,365.485,118,368.164,111.728,370.975,105.692,374.27,99.6571,377.565,95.0576,381.408,90.4582,385.251,87.894,389.674,85.3299,394.097,86,399.164,86.7091,399.726,87.816,399.305,88.923,398.884,90.2579,398.166,91.5928,397.448,93.0708,396.776,94.5487,396.104,96,396.164,95.8245,398.738,95.6058,401.27,95.3871,403.801,95.0498,406.214,94.7124,408.626,94.2188,410.883,93.7253,413.139,93,415.164,87.8812,413.863,84.926,410.577,81.9708,407.291,81.0403,403.117,80.1097,398.943,81.1343,394.431,82.159,389.918,85,386.164,89.0875,380.764,99.0191,374.514,108.951,368.264,121.209,362.897,133.468,357.53,146.295,353.913,159.122,350.297,169,350.164,177.392,350.051,183.004,353.411,188.615,356.772,191.391,362.3,194.168,367.828,194.083,374.87,193.999,381.913,191,389.164,191,389.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,3,3,3,3,1]),$.toNumberVector([860,372.164,858.748,371.666,857.992,370.671,857.237,369.677,856.567,368.597,855.897,367.517,855.108,366.556,854.318,365.595,853,365.164,850.961,366.114,848.808,366.462,846.655,366.81,844.816,366.476,842.977,366.141,841.666,365.084,840.355,364.026,840,362.164,838.571,354.682,845.169,353.729,851.767,352.776,858.309,355.468,864.85,358.16,867.294,363.055,869.738,367.95,860,372.164,860,372.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,1]),$.toNumberVector([792,389.164,793.515,377.893,789.497,371.411,785.479,364.929,778.629,362.531,771.778,360.134,763.446,361.468,755.114,362.803,748,367.164,754.612,359.506,763.968,358.164,773.323,356.821,781.022,360.312,788.721,363.803,792.565,371.387,796.41,378.97,792,389.164,792,389.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1]),$.toNumberVector([153,372.164,154.013,373.365,154.031,374.619,154.05,375.874,153.724,377.227,153.399,378.58,153.055,380.053,152.711,381.526,153,383.164,148.13,382.927,144.344,384.439,140.559,385.951,138.408,388.788,136.258,391.625,136.018,395.575,135.779,399.524,138,404.164,137.092,404.779,136.17,405.229,135.249,405.68,134.27,405.859,133.292,406.038,132.235,405.891,131.178,405.744,130,405.164,129.678,402.435,129.716,398.841,129.755,395.247,129.972,391.344,130.189,387.44,130.492,383.506,130.795,379.572,131,376.164,132.601,374.71,135.157,373.506,137.713,372.302,140.716,371.65,143.72,370.999,146.917,371.052,150.115,371.105,153,372.164,153,372.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1]),$.toNumberVector([902,400.164,901.951,401.99,900.979,402.894,900.008,403.798,898.711,404.375,897.413,404.952,896.087,405.501,894.76,406.049,894,407.164,892.421,406.45,891.798,405.557,891.176,404.664,890.703,403.723,890.231,402.783,889.506,401.86,888.782,400.937,887,400.164,884.822,399.219,882.341,399.387,879.86,399.556,877.765,399.484,875.67,399.411,874.307,398.42,872.943,397.429,873,394.164,873.027,392.616,874.681,391.115,876.335,389.615,878.595,388.464,880.856,387.314,883.212,386.663,885.569,386.013,887,386.164,889.81,386.461,892.047,388.212,894.284,389.964,896.089,392.199,897.894,394.434,899.336,396.668,900.779,398.902,902,400.164,902,400.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,1]),$.toNumberVector([798,395.164,800.33,397.459,802.091,400.323,803.852,403.187,805.333,406.331,806.814,409.475,808.158,412.755,809.503,416.036,811,419.164,808.476,417.063,806.609,414.305,804.743,411.547,803.256,408.408,801.77,405.269,800.525,401.889,799.281,398.509,798,395.164,798,395.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,1]),$.toNumberVector([769,412.164,766.066,411.223,763.027,410.387,759.988,409.551,757.606,408.057,755.225,406.564,753.883,404.031,752.54,401.499,753,397.164,756.703,396.11,759.534,397.021,762.364,397.933,764.35,400.142,766.336,402.351,767.492,405.523,768.647,408.696,769,412.164,769,412.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1]),$.toNumberVector([167,411.164,168.17,411.87,168.527,413.387,168.885,414.904,169.067,416.597,169.249,418.29,169.573,419.841,169.897,421.392,171,422.164,167.274,421.434,163.087,421.651,158.901,421.867,154.436,422.505,149.97,423.142,145.316,423.939,140.662,424.735,136,425.164,135.999,429.134,135.416,433.17,134.833,437.206,134.362,441.24,133.89,445.274,133.877,449.272,133.863,453.27,135,457.164,133.031,456.945,131.517,457.181,130.003,457.417,128.567,457.731,127.131,458.045,125.583,458.248,124.036,458.45,122,458.164,122.897,452.436,123.986,446.9,125.075,441.364,126.253,435.917,127.43,430.469,128.643,425.057,129.856,419.645,131,414.164,134.652,413.146,139.159,411.834,143.666,410.523,148.453,409.738,153.241,408.953,158.021,409.104,162.802,409.256,167,411.164,167,411.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,1]),$.toNumberVector([695,432.164,694.717,433.756,693.761,434.675,692.806,435.595,691.513,436.177,690.22,436.76,688.758,437.173,687.296,437.585,686,438.164,684.989,435.485,685.885,433.563,686.781,431.64,688.466,430.751,690.151,429.862,692.064,430.145,693.977,430.429,695,432.164,695,432.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,3,3,3,3,1]),$.toNumberVector([712,450.164,711.708,451.872,710.802,452.967,709.897,454.061,708.808,454.972,707.718,455.882,706.659,456.823,705.6,457.764,705,459.164,704.149,458.764,703.47,458.194,702.79,457.624,702.287,456.877,701.784,456.13,701.46,455.203,701.137,454.277,701,453.164,702.16,452.451,703.392,451.556,704.625,450.662,705.976,450.053,707.328,449.444,708.822,449.355,710.316,449.266,712,450.164,712,450.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,1]),$.toNumberVector([764,459.164,765.608,461.045,766.002,464.07,766.395,467.095,765.954,470.235,765.514,473.375,764.43,476.115,763.346,478.854,762,480.164,759.928,477.82,760.193,475.453,760.458,473.086,761.492,470.54,762.526,467.993,763.545,465.189,764.564,462.384,764,459.164,764,459.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,1]),$.toNumberVector([728,469.164,728.226,471.524,727.1,473.376,725.974,475.228,724.231,476.176,722.488,477.124,720.496,476.97,718.505,476.816,717,475.164,717.429,473.604,718.546,472.11,719.663,470.615,721.181,469.638,722.699,468.662,724.476,468.43,726.252,468.198,728,469.164,728,469.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,1]),$.toNumberVector([586,472.164,585.24,475.65,582.484,478.358,579.728,481.067,576.144,482.71,572.56,484.354,568.732,484.789,564.904,485.224,562,484.164,562.117,480.035,564.681,477.135,567.245,474.234,570.916,472.677,574.587,471.12,578.693,470.963,582.799,470.806,586,472.164,586,472.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,3,3,3,3,1]),$.toNumberVector([600,488.164,598.226,491.265,595.69,493.605,593.155,495.945,589.89,497.554,586.624,499.164,582.644,500.058,578.664,500.953,574,501.164,573.42,500.619,573.208,499.706,572.997,498.793,572.965,497.699,572.934,496.606,572.989,495.425,573.045,494.244,573,493.164,575.905,492.173,579.098,490.466,582.291,488.759,585.701,487.534,589.112,486.31,592.704,486.167,596.297,486.025,600,488.164,600,488.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,1]),$.toNumberVector([527,499.164,525.959,502.623,523.54,504.704,521.121,506.785,518.022,508.186,514.923,509.587,511.493,510.657,508.063,511.727,505,513.164,501.244,509.464,503.267,505.828,505.29,502.191,509.724,499.834,514.158,497.476,519.319,497.005,524.48,496.534,527,499.164,527,499.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,3,3,3,3,1]),$.toNumberVector([516,529.164,515.661,528.503,515.038,528.126,514.415,527.748,513.78,527.384,513.145,527.019,512.632,526.532,512.12,526.044,512,525.164,512.529,522.086,516.897,518.753,521.266,515.42,526.002,513.89,530.738,512.361,534.105,513.665,537.473,514.968,536,521.164,533.149,521.813,530.889,523.053,528.629,524.293,526.406,525.57,524.183,526.847,521.72,527.884,519.256,528.921,516,529.164,516,529.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1]),$.toNumberVector([1037,45.164,1037,46.5391,1037,47.9141,1037,49.2891,1037,50.664,1037,52.0389,1037,53.4139,1037,54.7889,1037,56.164,1040.01,61.9907,1046.98,68.6824,1053.95,75.374,1059.17,82.8095,1064.4,90.245,1065.03,98.3639,1065.66,106.483,1056,115.164,1052.73,115.555,1050.18,115.236,1047.62,114.917,1045.51,114.157,1043.39,113.397,1041.58,112.331,1039.77,111.266,1038,110.164,1037.02,111.439,1036.5,113.163,1035.97,114.887,1035.53,116.694,1035.09,118.502,1034.55,120.211,1034.01,121.92,1033,123.164,1028.19,125.817,1022.55,126.114,1016.9,126.41,1011.16,125.474,1005.42,124.538,999.946,122.929,994.472,121.321,990,120.164,988.986,124.674,987.312,129.949,985.639,135.224,982.861,138.987,980.084,142.751,975.98,143.864,971.875,144.977,966,141.164,964.456,143.158,963.284,145.164,962.113,147.171,960.929,148.927,959.746,150.683,958.36,152.058,956.973,153.433,955,154.164,950.792,155.723,946.611,154.748,942.429,153.773,938.128,152.104,933.827,150.434,929.332,148.99,924.836,147.545,920,148.164,918.716,148.328,915.966,149.347,913.216,150.365,910.227,151.822,907.238,153.28,904.625,154.969,902.011,156.658,901,158.164,898.404,162.031,897.645,166.446,896.886,170.862,895.412,174.434,893.938,178.005,890.473,180.036,887.009,182.067,879,181.164,877.543,180.371,876.998,178.665,876.454,176.959,876.243,174.92,876.033,172.881,875.867,170.797,875.701,168.713,875,167.164,874.223,166.316,872.749,166.165,871.276,166.013,869.72,165.944,868.164,165.875,866.83,165.584,865.497,165.292,865,164.164,864.309,161.165,864.29,157.498,864.271,153.832,864.905,150.304,865.539,146.776,866.817,143.79,868.096,140.803,870,139.164,869.257,136.657,868.667,133.997,868.077,131.336,867.515,128.648,866.953,125.96,866.356,123.308,865.759,120.655,865,118.164,864.817,116.722,863.666,116.247,862.516,115.773,861.143,115.52,859.771,115.268,858.549,114.865,857.327,114.462,857,113.164,858.984,100.491,865.498,96.6744,872.012,92.8579,880.611,94.1212,889.209,95.3846,898.668,99.8395,908.127,104.294,916,108.164,921.066,110.654,926.077,112.909,931.088,115.164,935.824,117.254,940.559,119.344,944.908,121.304,949.257,123.263,953,125.164,952.264,122.023,950.338,118.668,948.413,115.312,946.124,111.789,943.836,108.265,941.599,104.598,939.361,100.93,938,97.164,936.254,97.2915,934.655,97.8189,933.055,98.3463,931.487,98.7387,929.919,99.1312,928.326,99.1212,926.732,99.1112,925,98.164,923.282,86.7119,928.565,80.2198,933.847,73.7277,942.941,70.6336,952.035,67.5396,963.347,67.0627,974.659,66.5857,985,67.164,986.378,59.8372,992.102,54.7985,997.827,49.7597,1005.52,47.0095,1013.21,44.2592,1021.67,43.7977,1030.14,43.3363,1037,45.164,1037,45.164,1026,96.164,1023.12,96.164,1020.25,96.164,1017.37,96.164,1014.5,96.164,1011.63,96.164,1008.75,96.164,1005.88,96.164,1003,96.164,1003.09,93.7145,1003.39,91.2858,1003.7,88.8572,1003.87,86.4712,1004.05,84.0853,1003.92,81.753,1003.78,79.4207,1003,77.164,1004.32,76.7297,1005.4,76.0595,1006.47,75.3892,1007.59,74.7537,1008.7,74.1183,1009.99,73.6532,1011.27,73.188,1013,73.164,1014.2,76.4685,1015.94,79.2263,1017.68,81.9841,1019.53,84.6377,1021.37,87.2914,1023.1,90.0623,1024.83,92.8332,1026,96.164,1026,96.164,999,95.164,1002.57,97.9458,1006.98,98.5869,1011.39,99.228,1016.06,99.1449,1020.73,99.0617,1025.36,98.9624,1029.99,98.8631,1034,100.164,1034.34,101.689,1034.7,102.699,1035.07,103.71,1035.28,104.625,1035.49,105.54,1035.46,106.57,1035.43,107.6,1035,109.164,1028.41,112.418,1021.15,112.507,1013.9,112.596,1006.75,111.07,999.606,109.545,992.971,107.181,986.336,104.817,981,103.164,984.933,96.7931,983.861,90.836,982.789,84.8788,978.93,80.8644,975.071,76.8499,969.535,75.5426,963.998,74.2352,959,77.164,959.576,81.2125,961.753,83.6603,963.931,86.1081,966.773,87.8905,969.616,89.6729,972.656,91.2574,975.697,92.842,978,95.164,976.064,99.124,977.029,101.96,977.994,104.795,979.949,107.282,981.904,109.769,983.895,112.296,985.885,114.822,986,118.164,986.072,120.275,985.39,122.537,984.707,124.8,983.395,126.687,982.083,128.575,980.203,129.826,978.323,131.077,976,131.164,973.335,131.264,970.714,128.871,968.093,126.477,965.651,123.015,963.209,119.552,961.013,115.733,958.817,111.915,957,109.164,954.758,105.77,952.602,102.541,950.446,99.3113,948.423,96.2895,946.399,93.2678,944.532,90.4755,942.664,87.6833,941,85.164,939.986,84.2775,938.93,84.4019,937.874,84.5264,936.842,84.8215,935.809,85.1166,934.833,85.1623,933.856,85.208,933,84.164,935.792,77.9562,942.009,75.1728,948.225,72.3893,956.189,71.3529,964.152,70.3165,973.025,70.1885,981.897,70.0606,990,69.164,991.198,68.6128,991.567,67.2312,991.935,65.8497,992.031,64.1958,992.127,62.5418,992.23,60.8944,992.333,59.247,993,58.164,995.811,57.0353,999.71,54.6767,1003.61,52.3182,1008.02,50.1221,1012.43,47.926,1017.07,46.5885,1021.71,45.2509,1026,46.164,1028.09,46.6084,1030.47,49.5712,1032.85,52.5339,1035.24,56.361,1037.63,60.1881,1039.89,64.0523,1042.15,67.9166,1044,70.164,1046.12,72.7493,1050.79,77.9682,1055.47,83.1872,1058.62,88.5547,1061.78,93.9223,1061.39,98.1959,1061,102.47,1053,103.164,1049.6,103.459,1046.55,101.368,1043.49,99.277,1040.84,96.2013,1038.19,93.1255,1035.97,89.7658,1033.74,86.4061,1032,84.164,1029.45,80.879,1027.32,77.9718,1025.19,75.0646,1023.21,72.3881,1021.22,69.7117,1019.24,67.1924,1017.26,64.6731,1015,62.164,1011.79,62.2045,1009.16,62.8277,1006.54,63.4509,1004.19,64.3529,1001.84,65.2548,999.62,66.2836,997.399,67.3124,995,68.164,996.228,71.3759,997.586,74.4602,998.944,77.5445,999.774,80.7801,1000.6,84.0157,1000.57,87.542,1000.55,91.0683,999,95.164,999,95.164,923,115.164,928.282,117.776,933.52,120.038,938.757,122.3,943.988,124.271,949.219,126.241,954.462,127.95,959.706,129.658,965,131.164,964.351,133.364,963.119,135.244,961.887,137.123,960.282,138.56,958.677,139.996,956.804,140.928,954.931,141.859,953,142.164,949.445,142.724,946.184,141.606,942.923,140.488,939.601,138.973,936.279,137.457,932.718,136.185,929.156,134.912,925,135.164,920.819,135.417,917.756,136.785,914.692,138.153,911.877,139.813,909.062,141.474,906.06,143.017,903.059,144.56,899,145.164,899.164,150.079,898.472,154.137,897.781,158.195,896.015,161.179,894.249,164.163,891.3,165.964,888.35,167.765,884,168.164,881.688,166.726,880.603,164.06,879.519,161.395,878.483,158.681,877.447,155.967,875.871,153.793,874.295,151.619,871,151.164,870.578,148.618,870.891,146.805,871.203,144.993,871.885,143.549,872.567,142.106,873.437,140.851,874.307,139.596,875,138.164,875.221,132.443,874.48,127.683,873.74,122.923,872.423,118.74,871.106,114.557,869.405,110.759,867.703,106.961,866,103.164,872.792,97.6643,879.927,97.5562,887.062,97.4482,894.305,100.209,901.548,102.971,908.781,107.34,916.013,111.709,923,115.164,923,115.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1]),$.toNumberVector([855,153.164,864.069,165.818,858.666,177.749,853.263,189.68,840.638,197.165,828.013,204.651,811.791,205.831,795.569,207.011,783,198.164,772.394,190.699,769.959,178.103,767.524,165.507,771.02,153.099,774.515,140.69,782.82,131.127,791.126,121.564,802,120.164,807.976,119.394,813.892,120.194,819.807,120.994,824.009,123.866,828.211,126.739,829.872,131.938,831.533,137.136,829,145.164,829.904,145.837,831.458,145.471,833.013,145.104,834.831,144.636,836.649,144.167,838.538,144.065,840.427,143.962,842,145.164,842.272,148.311,842.079,150.993,841.886,153.675,841.5,156.165,841.115,158.654,840.672,161.086,840.229,163.518,840,166.164,841.891,166.049,843.394,164.147,844.897,162.245,846.519,159.932,848.141,157.619,850.135,155.583,852.128,153.546,855,153.164,855,153.164,824,177.164,828.835,177.123,832.714,174.126,836.593,171.129,840.234,167.727,843.875,164.326,847.637,161.797,851.399,159.268,856,160.164,856.827,170.102,849.343,177.868,841.859,185.634,830.678,189.666,819.496,193.697,806.924,193.212,794.351,192.728,785,186.164,777.756,181.08,775.406,172.885,773.055,164.691,774.152,156.173,775.25,147.654,779.073,140.206,782.896,132.757,788,129.164,791.646,126.598,798.213,124.861,804.78,123.124,811.11,123.488,817.439,123.852,821.952,126.953,826.464,130.054,826,137.164,825.811,140.05,824.735,141.716,823.658,143.383,822.17,144.698,820.682,146.014,819.02,147.413,817.359,148.812,816,151.164,818.288,152.001,821.189,151.038,824.091,150.075,827.095,149.154,830.1,148.234,832.953,148.276,835.807,148.318,838,151.164,837.868,156.657,834.819,159.233,831.77,161.809,827.532,163.196,823.293,164.582,818.728,165.643,814.164,166.703,811,169.164,811.73,171.449,813.152,172.99,814.575,174.531,816.363,175.464,818.151,176.397,820.142,176.788,822.132,177.18,824,177.164,824,177.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1]),$.toNumberVector([625,239.164,633.537,253.214,627.353,266.049,621.168,278.884,607.783,287.258,594.398,295.632,577.572,297.92,560.746,300.208,548,293.164,543.874,290.884,540.939,286.8,538.003,282.717,536.171,277.421,534.34,272.126,533.568,265.914,532.797,259.702,533,253.164,533.308,243.254,537.781,233.064,542.254,222.874,549.884,215.051,557.513,207.227,567.795,203.094,578.076,198.961,590,201.164,593.651,201.839,596.496,203.886,599.341,205.933,601.188,209.322,603.034,212.712,603.785,217.43,604.537,222.148,604,228.164,604.418,229.121,605.699,229.215,606.979,229.31,608.444,229.221,609.908,229.131,611.217,229.197,612.526,229.264,613,230.164,613.643,232.467,613.724,234.452,613.804,236.438,613.643,238.41,613.482,240.383,613.241,242.495,613,244.608,613,247.164,614.355,247.509,615.688,246.438,617.021,245.366,618.459,243.871,619.896,242.375,621.5,240.951,623.104,239.526,625,239.164,625,239.164,616,248.164,617.13,247.657,618.464,246.958,619.799,246.259,621.145,246.045,622.492,245.832,623.754,246.442,625.016,247.053,626,249.164,624.407,257.795,616.228,265.993,608.049,274.19,596.628,279.446,585.206,284.701,572.214,285.758,559.221,286.815,548,281.164,544.889,279.597,542.507,276.388,540.125,273.179,538.575,268.978,537.024,264.778,536.355,259.911,535.686,255.045,536,250.164,536.611,240.669,541.234,231.663,545.857,222.656,553.069,215.983,560.281,209.31,569.37,205.893,578.459,202.477,588,204.164,595.514,205.492,597.653,209.969,599.793,214.446,598.298,219.655,596.803,224.863,592.543,229.595,588.284,234.326,583,236.164,586.183,237.596,589.241,236.89,592.3,236.184,595.277,234.986,598.255,233.787,601.175,232.92,604.094,232.053,607,233.164,609.002,241.21,605.158,244.766,601.315,248.322,595.335,250.261,589.356,252.2,583.095,253.957,576.833,255.715,574,260.164,575.798,261.487,577.153,262.722,578.508,263.958,579.895,264.924,581.282,265.89,582.939,266.495,584.597,267.101,587,267.164,591.787,267.289,595.585,264.934,599.383,262.58,602.736,259.385,606.089,256.189,609.269,252.974,612.449,249.759,616,248.164,616,248.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1]),$.toNumberVector([1081,292.164,1080.48,295.495,1082.14,298.008,1083.79,300.52,1085.9,302.752,1088.01,304.984,1089.71,307.202,1091.42,309.421,1091,312.164,1090.49,315.495,1088.22,316.844,1085.95,318.193,1083.02,317.982,1080.1,317.772,1077.06,316.211,1074.03,314.651,1072,312.164,1072.51,311.559,1073.32,312.028,1074.12,312.497,1075.08,313.345,1076.03,314.193,1077.05,315.071,1078.07,315.95,1079,316.164,1077.18,314.057,1076.31,311.332,1075.43,308.608,1075.37,305.661,1075.31,302.714,1076,299.741,1076.69,296.768,1078,294.164,1074.61,290.761,1070.87,289.026,1067.13,287.292,1063.43,286.02,1059.73,284.748,1056.28,283.335,1052.82,281.923,1050,279.164,1046.1,275.349,1045.06,270.014,1044.02,264.678,1045.46,259.726,1046.9,254.774,1050.63,251.157,1054.36,247.54,1060,247.164,1064.22,246.882,1068.83,248.115,1073.44,249.348,1078.1,251.347,1082.77,253.346,1087.33,255.737,1091.88,258.128,1096,260.164,1102.03,263.146,1108.7,266.214,1115.36,269.281,1119.96,273.498,1124.56,277.715,1125.75,283.616,1126.93,289.516,1122,298.164,1125.76,302.145,1129.46,306.205,1133.16,310.265,1135.38,314.644,1137.59,319.024,1137.6,323.843,1137.62,328.663,1134,334.164,1131.45,338.041,1124.06,342.853,1116.68,347.664,1107.94,351.912,1099.2,356.16,1090.84,359.097,1082.49,362.034,1078,362.164,1071.35,362.356,1066.53,360.012,1061.71,357.667,1057.72,354.457,1053.72,351.246,1050.04,348.005,1046.37,344.765,1042,343.164,1038.44,338.87,1034.24,332.7,1030.04,326.529,1025.42,320.097,1020.81,313.665,1015.89,307.778,1010.98,301.891,1006,298.164,1003.32,296.16,998.817,295.332,994.311,294.504,989.867,295.12,985.423,295.737,981.984,297.931,978.546,300.125,978,304.164,977.694,306.429,979.516,309.913,981.339,313.396,984.073,317.214,986.806,321.031,989.843,324.74,992.879,328.448,995,331.164,997.086,333.835,999.717,337.552,1002.35,341.268,1005.07,344.855,1007.8,348.443,1010.39,351.313,1012.99,354.184,1015,355.164,1019.48,357.346,1024.4,357.542,1029.33,357.738,1033.37,356.142,1037.41,354.545,1039.9,351.252,1042.39,347.959,1042,343.164,1045.34,351.32,1042.56,357.491,1039.78,363.661,1033.9,366.89,1028.02,370.119,1020.54,369.926,1013.06,369.734,1007,365.164,1005.13,363.757,1002.93,360.968,1000.72,358.18,998.373,354.79,996.024,351.4,993.632,347.798,991.24,344.197,989,341.164,984.195,334.657,980.123,329.445,976.051,324.233,974.022,319.178,971.992,314.122,972.66,308.653,973.327,303.185,978,296.164,980.132,295.046,982.9,294.564,985.668,294.082,988.303,293.467,990.937,292.851,993.054,291.718,995.17,290.585,996,288.164,990.138,289.743,983.8,290.247,977.462,290.751,972.024,289.561,966.587,288.371,962.737,285.176,958.887,281.982,958,276.164,957.755,274.56,957.895,272.039,958.036,269.519,958.628,266.79,959.219,264.062,960.296,261.478,961.372,258.895,963,257.164,965.597,254.402,976.191,251.294,986.786,248.187,999.317,246.369,1011.85,244.551,1023.28,244.841,1034.72,245.131,1039,249.164,1042.12,252.107,1043.22,255.963,1044.31,259.818,1043.75,263.991,1043.19,268.163,1041.16,272.355,1039.12,276.547,1036,280.164,1040.25,284.043,1044.61,287.805,1048.97,291.567,1053.38,295.282,1057.79,298.997,1062.21,302.7,1066.64,306.403,1071,310.164,1064.96,309.241,1059.22,303.597,1053.47,297.953,1047.48,291.498,1041.5,285.044,1035.01,279.733,1028.52,274.422,1021,274.164,1018.1,274.065,1014.28,275.091,1010.47,276.117,1007.13,277.918,1003.8,279.719,1001.67,282.118,999.53,284.517,1000,287.164,1000.26,288.637,1000.98,289.202,1001.69,289.767,1002.92,290.153,1004.14,290.538,1005.9,291.109,1007.66,291.68,1010,293.164,1016.13,297.048,1023.38,304.569,1030.63,312.09,1038.25,320.227,1045.88,328.363,1053.5,335.603,1061.12,342.843,1068,346.164,1074.23,349.173,1080.27,348.878,1086.3,348.584,1092,346.551,1097.7,344.519,1102.98,341.53,1108.27,338.542,1113,336.164,1115.28,335.017,1118.73,333.824,1122.19,332.631,1125.48,330.969,1128.77,329.306,1131.23,326.961,1133.7,324.616,1134,321.164,1134.32,317.476,1132.81,314.886,1131.3,312.297,1129.1,309.967,1126.9,307.638,1124.59,305.147,1122.28,302.656,1121,299.164,1114.13,300.55,1108.8,298.986,1103.47,297.421,1098.87,295.333,1094.27,293.245,1090.01,291.846,1085.74,290.447,1081,292.164,1081,292.164,1085,281.164,1079.57,278.433,1074.17,276.385,1068.78,274.338,1064.16,271.884,1059.54,269.43,1056.07,266.023,1052.59,262.616,1051,257.164,1051.65,255.428,1053.5,254.131,1055.36,252.833,1057.63,252.047,1059.9,251.261,1062.19,251.022,1064.48,250.783,1066,251.164,1070.47,251.855,1074.35,253.19,1078.23,254.525,1081.91,256.268,1085.59,258.011,1089.26,260.044,1092.93,262.077,1097,264.164,1099.9,265.655,1104.09,267.389,1108.28,269.123,1112.19,271.281,1116.09,273.44,1118.94,276.115,1121.78,278.79,1122,282.164,1122.54,290.559,1117.44,291.757,1112.33,292.955,1105.66,290.872,1098.99,288.789,1092.8,285.383,1086.62,281.977,1085,281.164,1085,281.164,986,253.164,987.914,252.727,990.704,252.065,993.495,251.404,996.883,250.691,1000.27,249.979,1004.12,249.304,1007.97,248.628,1012,248.164,1015.91,247.714,1021.32,247.842,1026.72,247.971,1031.53,249.291,1036.33,250.61,1039.47,253.425,1042.62,256.241,1042,261.164,1041.64,264.047,1039.64,265.348,1037.65,266.649,1034.68,267.138,1031.72,267.628,1028.13,267.692,1024.55,267.756,1021,268.164,1015.57,268.789,1005.64,271.893,995.705,274.996,986.223,276.524,976.742,278.052,970.196,275.976,963.649,273.899,965,264.164,965.435,261.023,967.811,259.131,970.187,257.238,973.376,256.107,976.565,254.976,980.003,254.362,983.441,253.748,986,253.164,986,253.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,3,3,3,3,3,3,3,3,1,1,3,3,3,3,3,3,3,3,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1]),$.toNumberVector([943,385.164,944.51,388.557,946.64,392.197,948.77,395.837,951.771,398.882,954.771,401.928,958.766,403.959,962.761,405.99,968,406.164,972.944,406.329,979.169,404.271,985.393,402.213,990.978,399.036,996.563,395.859,1000.55,392.115,1004.53,388.371,1005,385.164,1005.4,382.39,1004.79,380.05,1004.18,377.709,1003.06,375.49,1001.93,373.271,1000.54,371.017,999.155,368.764,998,366.164,1010.58,377.294,1006.97,389.371,1003.35,401.447,992.246,409.289,981.14,417.13,966.901,418.144,952.661,419.159,944,408.164,943.88,415.931,941.615,420.953,939.35,425.976,935.464,429.485,931.577,432.995,926.33,435.607,921.084,438.219,915,441.164,909.939,443.614,905.177,446.37,900.415,449.125,895.594,450.895,890.773,452.665,885.714,452.805,880.655,452.945,875,450.164,869.769,447.592,864.964,443.081,860.159,438.57,855.45,433.087,850.74,427.604,845.96,421.631,841.181,415.659,836,410.164,830.497,404.328,824.641,398.823,818.784,393.318,813.548,388.177,808.311,383.036,804.181,378.275,800.051,373.513,798,369.164,795.836,364.574,796.288,359.82,796.74,355.066,797.929,350.01,799.119,344.954,800.106,339.527,801.094,334.1,800,328.164,801.75,324.655,806.586,322.038,811.422,319.421,816.979,318.596,822.536,317.771,827.632,319.188,832.729,320.605,835,325.164,831.679,322.887,826.925,321.946,822.172,321.006,817.526,321.554,812.881,322.103,809.114,324.218,805.348,326.332,804,330.164,806.049,333.168,805.815,335.995,805.58,338.822,804.491,341.622,803.401,344.422,802.171,347.27,800.941,350.118,801,353.164,801.055,355.994,802.809,358.825,804.563,361.656,807.131,364.434,809.7,367.212,812.638,369.908,815.577,372.604,818,375.164,820.553,377.86,822.758,380.315,824.964,382.77,827.084,385.174,829.203,387.579,831.367,390.028,833.531,392.478,836,395.164,841.408,401.047,846.25,406.703,851.093,412.359,855.602,417.419,860.111,422.479,864.403,426.758,868.695,431.036,873,434.164,874.911,435.553,877.423,436.745,879.935,437.937,882.806,438.602,885.677,439.267,888.786,439.241,891.895,439.214,895,438.164,900.102,436.439,907.7,433.526,915.297,430.613,922.494,426.913,929.692,423.213,935.042,418.925,940.392,414.638,941,410.164,941.33,407.734,940.692,405.417,940.055,403.099,939.436,400.697,938.818,398.295,938.712,395.711,938.606,393.126,940,390.164,934.478,389.822,930.338,387.776,926.198,385.73,922.612,382.896,919.027,380.063,915.581,376.9,912.135,373.738,908,371.164,899.37,365.792,890.98,362.182,882.59,358.573,875.54,354.29,868.49,350.008,863.329,343.835,858.169,337.662,856,327.164,853.964,326.878,852.416,327.081,850.869,327.284,849.433,327.597,847.996,327.911,846.483,328.147,844.969,328.383,843,328.164,843.892,327.181,845.231,326.645,846.57,326.109,848.082,325.746,849.594,325.383,851.142,325.056,852.69,324.729,854,324.164,849.385,315.324,852.608,307.883,855.83,300.443,862.35,296.596,868.87,292.75,876.417,293.593,883.965,294.437,888,302.164,884.775,298.886,879.998,297.48,875.221,296.074,870.612,296.479,866.003,296.885,862.42,299.071,858.837,301.258,858,305.164,857.053,309.581,859.56,316.319,862.068,323.058,865.722,329.911,869.376,336.765,873.023,342.63,876.669,348.495,878,351.164,879.956,349.399,881.054,347.28,882.152,345.161,883.148,343.003,884.145,340.845,885.419,338.807,886.693,336.768,889,335.164,891.075,333.721,894.888,331.896,898.701,330.071,902.967,328.502,907.234,326.933,911.314,325.939,915.393,324.945,918,325.164,920.738,325.394,923.114,327.081,925.489,328.767,927.494,330.898,929.498,333.029,931.127,335.099,932.755,337.168,934,338.164,937.922,341.303,943.335,343.599,948.748,345.896,953.799,348.214,958.85,350.532,962.613,353.303,966.377,356.075,967,360.164,967.768,365.204,965.869,369.156,963.971,373.107,960.449,376.145,956.927,379.182,952.304,381.394,947.681,383.605,943,385.164,943,385.164,959,367.164,960.141,367.699,960.632,369.115,961.122,370.53,961.069,372.129,961.016,373.727,960.472,375.16,959.928,376.594,959,377.164,958.264,376.644,958,375.229,957.736,373.815,957.806,372.212,957.875,370.609,958.209,369.17,958.542,367.732,959,367.164,959,367.164,885,358.164,883.173,357.395,883.067,356.319,882.961,355.243,883.582,354.032,884.204,352.821,885.056,351.561,885.909,350.301,886,349.164,887.572,349.679,887.551,350.628,887.53,351.577,886.909,352.788,886.287,354,885.562,355.387,884.837,356.773,885,358.164,885,358.164,889,351.164,888.534,347.572,889.579,345.37,890.625,343.168,892.311,341.897,893.997,340.627,895.887,340.058,897.777,339.489,899,339.164,902.941,338.117,907.148,338.591,911.354,339.065,915.678,340.397,920.002,341.729,924.369,343.587,928.737,345.444,933,347.164,936.379,348.527,940.583,349.768,944.788,351.009,948.548,352.632,952.308,354.255,954.989,356.512,957.669,358.769,958,362.164,958.258,364.809,957.146,367.369,956.035,369.929,953.958,371.921,951.881,373.912,949.041,375.094,946.2,376.275,943,376.164,939.919,376.057,936.419,375.043,932.918,374.03,929.111,372.556,925.305,371.082,921.249,369.373,917.193,367.663,913,366.164,909.684,364.979,905.654,363.523,901.624,362.067,898.042,360.242,894.461,358.417,891.91,356.172,889.359,353.927,889,351.164,889,351.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1]),$.toNumberVector([777,450.164,777.3,452.09,777.156,453.57,777.011,455.051,776.648,456.313,776.285,457.575,775.817,458.731,775.348,459.887,775,461.164,769.688,459.351,765.336,456.578,760.984,453.804,757.187,450.476,753.39,447.149,749.944,443.469,746.499,439.789,743,436.164,739.174,435.623,735.386,435.568,731.597,435.514,728.096,435.241,724.596,434.969,721.509,434.126,718.422,433.283,716,431.164,714.451,429.81,713.334,427.221,712.217,424.632,711.322,421.44,710.426,418.249,709.648,414.772,708.87,411.294,708,408.164,706.51,402.808,704.794,397.657,703.078,392.505,702.014,387.273,700.95,382.041,700.977,376.585,701.004,371.129,703,365.164,706.207,363.775,711.108,361.66,716.009,359.545,721.04,358.431,726.072,357.317,730.452,358.068,734.833,358.82,737,363.164,733.612,361.347,728.38,360.766,723.147,360.185,718.039,361.07,712.93,361.955,708.928,364.421,704.927,366.887,704,371.164,703.256,374.597,704.044,378.211,704.832,381.826,706.272,385.508,707.712,389.191,709.364,392.883,711.016,396.576,712,400.164,712.563,402.219,713.281,406.166,713.999,410.113,715.04,414.31,716.081,418.507,717.529,422.131,718.976,425.755,721,427.164,722.66,428.32,724.686,428.653,726.711,428.986,728.924,428.989,731.138,428.993,733.451,428.913,735.764,428.834,738,429.164,744.08,430.062,749.695,432.586,755.309,435.11,760.275,438.244,765.241,441.377,769.468,444.612,773.695,447.846,777,450.164,777,450.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1]),$.toNumberVector([817,474.164,813.807,478.971,811.51,485.282,809.213,491.592,805.829,496.696,802.445,501.8,796.983,504.344,791.522,506.888,782,504.164,781.641,510.477,777.037,514.044,772.432,517.612,766.482,518.469,760.532,519.327,754.687,517.492,748.841,515.657,746,511.164,740.705,514.609,731.899,520.328,723.092,526.047,713.819,529.378,704.546,532.708,696.33,531.32,688.113,529.933,684,519.164,683.152,516.945,683.064,514.49,682.977,512.035,683.034,509.388,683.092,506.741,682.987,503.924,682.882,501.107,682,498.164,680.423,492.905,676.687,488.113,672.951,483.321,668.736,478.963,664.521,474.604,660.667,470.663,656.813,466.722,655,463.164,650.451,463.651,646.396,462.702,642.341,461.752,639.155,459.707,635.968,457.662,633.836,454.691,631.704,451.72,631,448.164,630.78,447.052,630.928,445.833,631.077,444.614,631.249,443.338,631.422,442.063,631.446,440.757,631.469,439.451,631,438.164,629.732,434.69,626.474,431.548,623.217,428.406,620.301,424.803,617.385,421.2,615.977,416.739,614.568,412.277,617,406.164,618.784,403.891,621.84,401.819,624.896,399.747,628.755,397.79,632.614,395.833,637.043,393.948,641.471,392.063,646,390.164,653.067,387.201,660.594,384.226,668.121,381.252,674.617,380.84,681.113,380.428,685.832,383.866,690.551,387.303,692,397.164,690.116,394.455,688.312,391.604,686.507,388.754,683.933,386.673,681.358,384.591,677.587,383.736,673.817,382.881,668,384.164,662.641,385.346,654.858,388.175,647.076,391.004,639.757,394.413,632.439,397.822,627.028,401.277,621.616,404.732,621,407.164,620.309,409.889,620.688,411.941,621.066,413.994,622.049,415.621,623.031,417.248,624.385,418.572,625.739,419.896,627,421.164,632.679,421.82,636.917,420.285,641.154,418.75,645.003,416.925,648.852,415.1,652.838,413.935,656.824,412.769,662,414.164,660.898,419.139,656.688,421.228,652.477,423.317,647.62,424.635,642.764,425.953,638.493,427.557,634.222,429.161,633,433.164,632.351,435.291,632.966,437.961,633.581,440.631,635.04,443.119,636.5,445.607,638.594,447.55,640.689,449.493,643,450.164,644.489,450.597,645.935,450.499,647.382,450.401,648.766,450.191,650.151,449.982,651.464,449.87,652.777,449.759,654,450.164,658.306,451.592,662.861,456.946,667.415,462.3,671.766,468.727,676.117,475.154,680.039,481.226,683.96,487.299,687,490.164,684.588,495.293,685.062,500.267,685.535,505.241,687.905,509.264,690.274,513.287,694.045,515.961,697.817,518.635,702,519.164,708.65,520.005,714.916,517.259,721.181,514.513,726.808,510.735,732.436,506.956,737.297,503.425,742.159,499.893,746,499.164,749.062,501.997,753.68,503.726,758.299,505.455,763.19,505.663,768.082,505.871,772.605,504.35,777.129,502.83,780,499.164,778.954,497.334,777.414,495.999,775.875,494.664,774.03,493.633,772.186,492.603,770.131,491.783,768.076,490.963,766,490.164,765.723,488.387,765.862,487.026,766.001,485.666,766.27,484.434,766.538,483.203,766.792,481.957,767.047,480.711,767,479.164,768.486,478.558,769.775,479.62,771.063,480.682,772.427,482.425,773.791,484.168,775.366,486.1,776.942,488.031,779,489.164,787.743,493.975,793.648,492.496,799.552,491.016,803.741,486.26,807.929,481.503,810.963,474.976,813.997,468.448,817,463.164,824.706,463.633,833.728,463.943,842.75,464.252,849.362,462.385,855.975,460.518,858.316,455.467,860.657,450.415,855,440.164,851.81,438.103,847.869,436.795,843.928,435.486,839.53,434.634,835.132,433.781,830.426,433.238,825.72,432.694,821,432.164,826.796,431.253,833.338,431.707,839.88,432.16,845.643,434.098,851.406,436.037,855.627,439.523,859.848,443.009,861,448.164,863.406,458.929,860.303,465.373,857.2,471.816,850.662,474.69,844.124,477.564,835.19,477.244,826.256,476.925,817,474.164,817,474.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1]),$.toNumberVector([582,454.164,582.646,450.549,584.013,446.268,585.381,441.988,585.91,438.006,586.44,434.024,585.352,430.823,584.265,427.622,580,426.164,576.648,425.018,573.445,425.58,570.242,426.141,567.057,427.397,563.872,428.654,560.64,430.098,557.408,431.543,554,432.164,558.703,426.926,565.954,424.875,573.206,422.825,579.556,424.62,585.906,426.416,589.63,432.387,593.353,438.358,591,449.164,594.631,447.32,599.457,446.932,604.284,446.543,608.875,447.732,613.466,448.921,617.105,451.749,620.744,454.576,622,459.164,623.3,460.845,623.304,461.198,623.308,461.55,622.71,461.225,622.113,460.9,621.262,460.222,620.411,459.545,620,459.164,618.918,458.162,617.574,456.601,616.23,455.04,614.527,453.5,612.825,451.96,610.717,450.731,608.609,449.502,606,449.164,602.501,448.711,599.432,449.253,596.363,449.794,593.483,450.723,590.603,451.652,587.793,452.664,584.982,453.676,582,454.164,582,454.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,1]),$.toNumberVector([553,432.164,552.725,432.514,552.388,432.802,552.051,433.09,551.668,433.332,551.285,433.574,550.864,433.778,550.443,433.982,550,434.164,549.058,434.003,549.221,433.649,549.383,433.295,550.056,432.945,550.729,432.596,551.614,432.351,552.499,432.106,553,432.164,553,432.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,1]),$.toNumberVector([546,435.164,545.725,435.514,545.388,435.802,545.051,436.09,544.668,436.332,544.285,436.574,543.864,436.778,543.443,436.982,543,437.164,542.058,437.003,542.221,436.649,542.383,436.295,543.056,435.945,543.729,435.596,544.614,435.351,545.499,435.106,546,435.164,546,435.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,1]),$.toNumberVector([539,438.164,538.725,438.514,538.388,438.802,538.051,439.09,537.668,439.332,537.285,439.574,536.864,439.778,536.443,439.982,536,440.164,535.058,440.003,535.221,439.649,535.383,439.295,536.056,438.945,536.729,438.596,537.614,438.351,538.499,438.106,539,438.164,539,438.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,1]),$.toNumberVector([532,441.164,531.725,441.514,531.388,441.802,531.051,442.09,530.668,442.332,530.285,442.574,529.864,442.778,529.443,442.982,529,443.164,528.058,443.003,528.221,442.649,528.383,442.295,529.056,441.945,529.729,441.596,530.614,441.351,531.499,441.106,532,441.164,532,441.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,1]),$.toNumberVector([525,444.164,524.725,444.514,524.388,444.802,524.051,445.09,523.668,445.332,523.285,445.574,522.864,445.778,522.443,445.982,522,446.164,521.058,446.003,521.221,445.649,521.383,445.295,522.056,444.945,522.729,444.596,523.614,444.351,524.499,444.106,525,444.164,525,444.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,1]),$.toNumberVector([520,446.164,519.725,446.514,519.388,446.802,519.051,447.09,518.668,447.332,518.285,447.574,517.864,447.778,517.443,447.982,517,448.164,516.058,448.003,516.221,447.649,516.383,447.295,517.056,446.945,517.729,446.596,518.614,446.351,519.499,446.106,520,446.164,520,446.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,1]),$.toNumberVector([513,449.164,512.725,449.514,512.388,449.802,512.051,450.09,511.668,450.332,511.285,450.574,510.864,450.778,510.443,450.982,510,451.164,509.058,451.003,509.221,450.649,509.384,450.295,510.056,449.945,510.729,449.596,511.614,449.351,512.499,449.106,513,449.164,513,449.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,1]),$.toNumberVector([506,452.164,505.725,452.514,505.388,452.802,505.051,453.09,504.668,453.332,504.285,453.574,503.864,453.778,503.443,453.982,503,454.164,502.058,454.003,502.221,453.649,502.384,453.295,503.056,452.945,503.729,452.596,504.614,452.351,505.499,452.106,506,452.164,506,452.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,1]),$.toNumberVector([499,455.164,498.725,455.514,498.388,455.802,498.051,456.09,497.668,456.332,497.285,456.574,496.864,456.778,496.443,456.982,496,457.164,495.058,457.003,495.221,456.649,495.384,456.295,496.056,455.945,496.729,455.596,497.614,455.351,498.499,455.106,499,455.164,499,455.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,1]),$.toNumberVector([494,457.164,493.725,457.514,493.388,457.802,493.051,458.09,492.668,458.332,492.285,458.574,491.864,458.778,491.443,458.982,491,459.164,490.058,459.003,490.221,458.649,490.384,458.295,491.056,457.945,491.729,457.596,492.614,457.351,493.499,457.106,494,457.164,494,457.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1]),$.toNumberVector([446,481.164,445.734,484.43,445.885,487.279,446.036,490.128,446.725,492.439,447.415,494.749,448.703,496.461,449.991,498.173,452,499.164,456.564,496.893,461.214,495.824,465.865,494.755,470.361,493.716,474.856,492.677,479.077,491.082,483.297,489.487,487,486.164,489.633,483.801,491.11,480.971,492.588,478.14,493.862,475.29,495.136,472.44,496.682,469.797,498.229,467.153,501,465.164,504.199,462.868,508.36,461.347,512.521,459.825,516.978,459.409,521.436,458.993,525.858,459.849,530.279,460.705,534,463.164,533.481,465.764,531.856,466.478,530.231,467.192,528.154,467.051,526.076,466.91,523.874,466.431,521.673,465.951,520,466.164,515.708,466.711,511.696,468.234,507.685,469.757,504.774,472.59,501.864,475.423,500.465,479.733,499.066,484.043,500,490.164,499.292,490.122,499.059,489.605,498.826,489.088,498.656,488.508,498.487,487.927,498.176,487.488,497.865,487.049,497,487.164,495.595,493.098,490.717,495.669,485.839,498.241,480.305,500.06,474.771,501.879,469.99,504.253,465.21,506.626,464,512.164,463.009,516.701,465.854,524.503,468.699,532.305,473.259,540.078,477.819,547.85,483.035,553.945,488.25,560.04,492,561.164,496.203,562.423,499.685,561.689,503.166,560.955,506.42,559.379,509.673,557.803,512.945,555.962,516.217,554.12,520,553.164,520.542,551.831,521.075,550.489,521.608,549.147,522.033,547.697,522.458,546.247,522.725,544.639,522.992,543.031,523,541.164,529.31,537.223,534.645,532.309,539.981,527.395,546.185,523.348,552.389,519.302,560.382,517.046,568.375,514.789,580,516.164,582.766,514.625,585.334,512.545,587.901,510.465,590.69,508.507,593.479,506.55,596.702,505.048,599.924,503.546,604,503.164,605.732,503.001,607.473,503.331,609.214,503.661,610.964,504.102,612.714,504.543,614.473,504.904,616.232,505.265,618,505.164,621.529,504.964,624.699,504.001,627.869,503.039,630.64,501.464,633.41,499.889,635.76,497.776,638.11,495.664,640,493.164,640.319,491.258,639.92,488.764,639.521,486.27,638.565,483.827,637.609,481.383,636.177,479.308,634.745,477.233,633,476.164,635.426,476.866,637.614,479.209,639.802,481.551,641.286,485.129,642.769,488.706,643.314,493.317,643.86,497.927,643,503.164,639.415,505.276,636.481,506.761,633.548,508.247,630.454,509.284,627.36,510.321,623.699,510.997,620.039,511.672,615,512.164,610.289,512.624,606.238,514.274,602.186,515.925,598.389,517.872,594.592,519.819,590.846,521.616,587.1,523.412,583,524.164,579.028,524.892,575.156,524.595,571.283,524.297,567.526,524.106,563.768,523.915,560.133,524.396,556.498,524.878,553,527.164,548.981,529.791,545.252,534.271,541.523,538.751,537.794,543.696,534.064,548.641,530.188,553.355,526.313,558.069,522,561.164,517.518,564.38,513.171,565.636,508.823,566.892,504.335,567.574,499.848,568.256,495.082,569.057,490.317,569.858,485,572.164,485.233,575.182,485.655,578.009,486.077,580.837,486.865,583.299,487.653,585.761,488.893,587.771,490.132,589.781,492,591.164,499.453,590.118,505.498,587.662,511.542,585.207,517.171,582.335,522.799,579.463,528.508,576.672,534.217,573.881,541,572.164,539.426,577.465,535.977,580.891,532.528,584.317,528.42,587.084,524.312,589.851,520.153,592.567,515.994,595.283,513,599.164,514.189,614.313,521.536,616.854,528.884,619.396,538.136,615.457,547.388,611.519,556.418,604.164,565.447,596.809,570,592.164,572.234,589.884,574.58,586.922,576.926,583.96,579.078,580.662,581.231,577.364,583.037,573.903,584.844,570.442,586,567.164,586.929,564.531,587.408,561.696,587.887,558.861,588.397,556.182,588.907,553.503,589.687,551.159,590.468,548.815,592,547.164,593.141,545.935,595.426,544.625,597.712,543.314,600.438,542.017,603.165,540.72,605.981,539.483,608.798,538.247,611,537.164,613.648,535.862,616.455,534.525,619.262,533.188,621.917,532.481,624.572,531.774,626.92,532.028,629.269,532.283,631,534.164,629.794,538.083,626.817,540.231,623.84,542.379,620.341,544.005,616.841,545.63,613.444,547.358,610.047,549.086,608,552.164,608.83,555.053,609.736,558.165,610.642,561.278,612.053,563.973,613.464,566.667,615.594,568.625,617.723,570.583,621,571.164,624.426,571.771,632.593,569.007,640.76,566.243,649.479,561.864,658.198,557.485,665.376,552.371,672.553,547.256,674,543.164,674.933,540.525,674.934,538.035,674.936,535.545,674.46,533.265,673.984,530.984,673.255,528.944,672.527,526.903,672,525.164,674.8,528.124,676.289,532.405,677.779,536.687,677.922,541.388,678.065,546.089,676.843,550.759,675.622,555.428,673,559.164,671.134,561.822,664.866,566.102,658.598,570.381,651.041,574.431,643.485,578.481,636.196,581.377,628.908,584.272,625,584.164,620.416,584.036,616.832,581.64,613.248,579.243,610.886,575.188,608.525,571.133,607.498,565.724,606.471,560.315,607,554.164,600.648,554.052,597.32,557.013,593.992,559.975,592.057,564.569,590.122,569.164,588.765,574.672,587.409,580.181,585,585.164,582.256,590.841,576.42,598.211,570.584,605.582,563.441,612.354,556.298,619.125,548.742,624.151,541.185,629.177,535,630.164,528.164,631.255,523.682,629.374,519.2,627.493,516.408,623.375,513.616,619.258,512.18,613.271,510.744,607.285,510,600.164,502.391,604.595,496.298,602.35,490.206,600.106,486.597,594.382,482.988,588.659,482.347,581.055,481.706,573.451,485,567.164,482.299,560.24,478.395,554.519,474.491,548.798,470.872,542.792,467.253,536.786,464.663,529.751,462.073,522.716,462,513.164,454.394,513.113,449.196,506.642,443.998,500.172,442.818,492.458,441.638,484.744,445.281,478.376,448.924,472.008,459,472.164,459.212,471.496,459.645,471.393,460.078,471.289,460.38,471.442,460.681,471.595,460.674,471.853,460.668,472.11,460,472.164,457.94,472.979,456.012,473.926,454.083,474.872,452.317,475.981,450.551,477.09,448.964,478.378,447.377,479.666,446,481.164,446,481.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,1]),$.toNumberVector([487,460.164,486.725,460.514,486.388,460.802,486.051,461.09,485.668,461.332,485.285,461.574,484.864,461.778,484.443,461.982,484,462.164,483.058,462.003,483.221,461.649,483.384,461.295,484.056,460.945,484.729,460.596,485.614,460.351,486.499,460.106,487,460.164,487,460.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,1]),$.toNumberVector([480,463.164,479.725,463.514,479.388,463.802,479.051,464.09,478.668,464.332,478.285,464.574,477.864,464.778,477.443,464.982,477,465.164,476.058,465.003,476.221,464.649,476.384,464.295,477.056,463.945,477.729,463.596,478.614,463.351,479.499,463.106,480,463.164,480,463.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,2,1]),$.toNumberVector([625,464.164,624.316,462.966,624.847,463.547,625.378,464.128,625.959,464.915,626.541,465.702,626.592,465.908,626.643,466.113,625,464.164,625,464.164,625,464.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,1]),$.toNumberVector([475,465.164,474.725,465.514,474.388,465.802,474.051,466.09,473.668,466.332,473.285,466.574,472.864,466.778,472.443,466.982,472,467.164,471.058,467.003,471.221,466.649,471.384,466.295,472.056,465.945,472.729,465.596,473.614,465.351,474.499,465.106,475,465.164,475,465.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,2,1]),$.toNumberVector([628,468.164,627.316,466.966,627.847,467.547,628.378,468.128,628.959,468.915,629.541,469.702,629.592,469.908,629.643,470.113,628,468.164,628,468.164,628,468.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,1]),$.toNumberVector([468,468.164,467.725,468.514,467.388,468.802,467.051,469.09,466.668,469.332,466.285,469.574,465.864,469.778,465.443,469.982,465,470.164,464.058,470.003,464.221,469.649,464.384,469.295,465.056,468.945,465.729,468.596,466.614,468.351,467.499,468.106,468,468.164,468,468.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,2,1]),$.toNumberVector([631,472.164,630.316,470.966,630.847,471.547,631.378,472.128,631.959,472.915,632.541,473.702,632.592,473.908,632.643,474.113,631,472.164,631,472.164,631,472.164]),"evenOdd");
	g.endFill();
	g.beginFill(0x000000);
	g.drawPath($.toIntVector([1,3,3,3,3,3,3,3,3,3,3,3,3,1]),$.toNumberVector([646,500.164,646.743,496.925,649.386,496.556,652.03,496.188,655.045,497.522,658.059,498.856,660.681,501.309,663.302,503.761,664,506.164,663.163,506.362,661.93,505.566,660.696,504.771,659.319,503.591,657.942,502.411,656.549,501.152,655.156,499.893,654,499.164,653.103,499.392,651.846,499.26,650.589,499.128,649.383,499.047,648.177,498.966,647.228,499.142,646.279,499.318,646,500.164,646,500.164]),"evenOdd");
	g.endFill();
	
	if(vw!=null){
		title.width=vw*0.8;
		title.height=316*(vw*0.8/560.0);
		conlist.push(title);
	}
	
	//trace("titlepic show!");
	
}

function Showend(mask){
	
	var title = $.createShape({x:0,y:0,lifeTime:0,parent:mask});
	title.transform.matrix3D = null;
	var g = title.graphics;
	
	g.moveTo(1,321);
	g.beginFill(0xffffff);
	g.lineStyle(1,16711680,1);
	g.curveTo(13,317,14,304);
	g.curveTo(13,287,27,265);
	g.curveTo(6,261,16,233);
	g.curveTo(10,237,6,244);
	g.curveTo(3,235,9,230);
	g.curveTo(8,221,17,218);
	g.curveTo(25,209,31,214);
	g.curveTo(35,215,31,208);
	g.curveTo(36,207,38,211);
	g.curveTo(40,207,35,196);
	g.curveTo(44,188,50,194);
	g.curveTo(53,201,48,202);
	g.curveTo(46,200,45,195);
	g.curveTo(40,199,42,203);
	g.curveTo(45,208,43,212);
	g.curveTo(45,215,48,208);
	g.curveTo(49,214,52,212);
	g.curveTo(52,217,59,220);
	g.curveTo(67,217,72,220);
	g.curveTo(76,216,79,202);
	g.curveTo(70,207,68,196);
	g.curveTo(65,186,75,183);
	g.curveTo(79,180,78,173);
	g.curveTo(82,166,76,164);
	g.curveTo(74,160,74,155);
	g.curveTo(53,121,76,86);
	g.curveTo(83,116,90,82);
	g.curveTo(144,128,111,164);
	g.curveTo(111,172,117,180);
	g.curveTo(115,188,119,191);
	g.curveTo(116,195,112,194);
	g.curveTo(111,200,128,192);
	g.curveTo(123,187,130,172);
	g.curveTo(133,162,135,142);
	g.curveTo(138,134,142,131);
	g.curveTo(141,126,136,126);
	g.curveTo(136,122,134,119);
	g.curveTo(134,129,135,130);
	g.curveTo(132,138,132,140);
	g.curveTo(133,148,128,143);
	g.curveTo(131,135,129,124);
	g.curveTo(128,109,127,103);
	g.curveTo(122,103,125,87);
	g.curveTo(140,59,164,74);
	g.curveTo(178,88,170,108);
	g.curveTo(172,112,174,109);
	g.curveTo(168,116,167,120);
	g.curveTo(161,122,161,126);
	g.curveTo(173,164,174,174);
	g.curveTo(183,176,179,184);
	g.curveTo(182,198,180,203);
	g.curveTo(174,207,163,204);
	g.curveTo(163,216,161,225);
	g.curveTo(165,223,167,217);
	g.curveTo(174,212,180,215);
	g.curveTo(184,216,187,196);
	g.curveTo(189,186,194,183);
	g.curveTo(197,180,197,177);
	g.curveTo(192,181,181,171);
	g.curveTo(183,163,183,158);
	g.lineTo(178,157);
	g.lineTo(177,162);
	g.lineTo(176,158);
	g.lineTo(172,158);
	g.lineTo(173,153);
	g.lineTo(170,152);
	g.lineTo(173,148);
	g.lineTo(168,146);
	g.lineTo(173,144);
	g.lineTo(168,143);
	g.lineTo(174,135);
	g.lineTo(170,132);
	g.lineTo(179,129);
	g.lineTo(174,123);
	g.lineTo(190,120);
	g.lineTo(185,116);
	g.lineTo(194,117);
	g.lineTo(191,110);
	g.lineTo(203,116);
	g.lineTo(204,108);
	g.lineTo(208,116);
	g.lineTo(212,113);
	g.lineTo(214,116);
	g.lineTo(218,114);
	g.lineTo(218,118);
	g.lineTo(227,119);
	g.lineTo(220,123);
	g.lineTo(228,125);
	g.lineTo(225,131);
	g.lineTo(233,128);
	g.lineTo(230,134);
	g.lineTo(236,139);
	g.lineTo(231,141);
	g.lineTo(235,147);
	g.curveTo(254,138,272,149);
	g.curveTo(282,139,285,161);
	g.curveTo(287,195,281,196);
	g.curveTo(277,207,271,205);
	g.curveTo(271,214,265,213);
	g.curveTo(275,221,275,226);
	g.curveTo(281,229,283,232);
	g.curveTo(284,230,285,223);
	g.curveTo(291,236,290,236);
	g.curveTo(283,244,279,243);
	g.curveTo(282,255,288,259);
	g.curveTo(292,235,300,208);
	g.curveTo(300,198,307,193);
	g.curveTo(306,191,307,188);
	g.curveTo(306,187,311,188);
	g.curveTo(306,184,300,180);
	g.curveTo(301,186,301,187);
	g.curveTo(274,152,300,123);
	g.curveTo(314,116,321,119);
	g.curveTo(323,116,319,111);
	g.curveTo(318,106,308,104);
	g.curveTo(306,104,302,108);
	g.curveTo(303,106,302,102);
	g.curveTo(295,104,296,107);
	g.curveTo(295,100,299,96);
	g.curveTo(283,94,274,86);
	g.curveTo(284,74,294,71);
	g.curveTo(292,70,285,68);
	g.curveTo(296,63,302,63);
	g.curveTo(305,63,303,57);
	g.curveTo(306,57,309,59);
	g.curveTo(307,54,307,51);
	g.curveTo(313,61,314,42);
	g.curveTo(317,53,318,50);
	g.curveTo(324,35,345,32);
	g.curveTo(338,37,338,42);
	g.curveTo(354,33,371,33);
	g.curveTo(371,37,369,40);
	g.curveTo(377,40,381,33);
	g.curveTo(378,64,370,68);
	g.curveTo(370,72,376,69);
	g.curveTo(372,76,364,83);
	g.curveTo(369,86,374,84);
	g.curveTo(368,90,361,90);
	g.curveTo(365,93,363,96);
	g.curveTo(361,97,358,96);
	g.curveTo(358,100,358,101);
	g.curveTo(354,102,353,99);
	g.curveTo(351,117,335,114);
	g.curveTo(334,118,338,118);
	g.curveTo(337,121,337,123);
	g.curveTo(347,124,345,135);
	g.curveTo(347,144,351,151);
	g.curveTo(350,154,348,154);
	g.curveTo(348,159,352,159);
	g.curveTo(356,145,377,153);
	g.curveTo(377,136,383,126);
	g.curveTo(389,127,393,125);
	g.curveTo(391,121,393,120);
	g.curveTo(377,120,380,108);
	g.curveTo(376,108,374,106);
	g.curveTo(373,102,378,99);
	g.curveTo(379,97,373,99);
	g.curveTo(374,95,377,94);
	g.curveTo(375,95,376,89);
	g.curveTo(376,90,379,92);
	g.curveTo(380,85,380,73);
	g.curveTo(385,73,384,80);
	g.curveTo(384,74,396,61);
	g.curveTo(394,67,396,69);
	g.curveTo(399,70,401,64);
	g.curveTo(400,70,401,71);
	g.curveTo(410,65,419,65);
	g.curveTo(413,69,413,70);
	g.curveTo(424,71,427,73);
	g.curveTo(421,75,420,76);
	g.curveTo(428,79,429,79);
	g.curveTo(424,81,424,82);
	g.curveTo(432,84,431,87);
	g.curveTo(426,87,425,88);
	g.curveTo(428,92,434,92);
	g.curveTo(432,96,429,96);
	g.curveTo(429,100,433,100);
	g.curveTo(430,100,426,102);
	g.curveTo(427,104,429,108);
	g.lineTo(424,104);
	g.lineTo(424,109);
	g.lineTo(418,107);
	g.lineTo(422,112);
	g.lineTo(417,111);
	g.curveTo(413,114,415,119);
	g.curveTo(408,129,401,124);
	g.curveTo(402,126,401,129);
	g.curveTo(409,131,409,134);
	g.curveTo(412,145,412,162);
	g.curveTo(416,184,430,189);
	g.curveTo(439,168,431,170);
	g.curveTo(437,157,438,146);
	g.curveTo(444,146,443,141);
	g.curveTo(450,142,449,138);
	g.curveTo(447,134,442,133);
	g.curveTo(437,130,438,122);
	g.lineTo(435,124);
	g.lineTo(435,119);
	g.lineTo(432,118);
	g.lineTo(434,115);
	g.lineTo(428,113);
	g.curveTo(437,106,441,106);
	g.curveTo(437,105,435,103);
	g.curveTo(448,100,455,99);
	g.curveTo(454,98,452,94);
	g.curveTo(469,101,472,106);
	g.curveTo(474,107,475,105);
	g.curveTo(472,115,477,118);
	g.curveTo(475,121,472,123);
	g.curveTo(471,135,457,143);
	g.curveTo(463,148,461,155);
	g.curveTo(470,177,463,177);
	g.curveTo(466,186,465,192);
	g.curveTo(472,183,483,165);
	g.curveTo(473,201,475,204);
	g.curveTo(478,210,484,212);
	g.curveTo(481,220,483,223);
	g.curveTo(494,225,485,239);
	g.curveTo(481,244,475,245);
	g.curveTo(470,247,468,250);
	g.curveTo(472,258,474,275);
	g.curveTo(476,284,482,286);
	g.curveTo(481,279,476,272);
	g.curveTo(487,276,487,284);
	g.curveTo(488,292,494,295);
	g.curveTo(504,297,507,289);
	g.curveTo(496,283,494,273);
	g.lineTo(496,270);
	g.curveTo(487,268,495,265);
	g.curveTo(493,259,498,259);
	g.curveTo(502,252,492,258);
	g.curveTo(480,256,480,249);
	g.curveTo(494,252,502,249);
	g.curveTo(505,246,503,244);
	g.lineTo(507,248);
	g.lineTo(507,241);
	g.lineTo(510,245);
	g.lineTo(515,244);
	g.lineTo(515,240);
	g.lineTo(518,245);
	g.lineTo(524,243);
	g.lineTo(524,246);
	g.lineTo(526,247);
	g.lineTo(527,245);
	g.lineTo(528,251);
	g.lineTo(536,253);
	g.curveTo(533,261,536,264);
	g.curveTo(543,285,535,287);
	g.curveTo(532,292,528,292);
	g.curveTo(532,305,535,306);
	g.curveTo(555,311,555,318);
	g.curveTo(540,323,531,316);
	g.curveTo(528,312,522,313);
	g.curveTo(518,319,513,316);
	g.curveTo(512,329,502,324);
	g.curveTo(495,329,490,327);
	g.curveTo(490,333,488,333);
	g.curveTo(482,335,482,335);
	g.curveTo(476,333,468,334);
	g.curveTo(449,334,442,326);
	g.curveTo(437,320,437,327);
	g.curveTo(445,334,442,337);
	g.curveTo(435,340,430,343);
	g.curveTo(423,343,421,343);
	g.curveTo(407,349,384,340);
	g.curveTo(385,352,386,358);
	g.curveTo(381,360,370,356);
	g.curveTo(369,360,367,360);
	g.curveTo(359,359,354,355);
	g.curveTo(356,369,347,367);
	g.curveTo(332,371,323,361);
	g.curveTo(327,352,327,349);
	g.curveTo(327,346,325,343);
	g.curveTo(321,342,318,342);
	g.curveTo(317,350,318,355);
	g.curveTo(323,371,310,371);
	g.curveTo(293,372,291,367);
	g.curveTo(285,363,290,357);
	g.curveTo(288,355,289,349);
	g.curveTo(284,345,274,348);
	g.curveTo(274,364,280,370);
	g.curveTo(279,373,274,372);
	g.curveTo(271,378,266,374);
	g.curveTo(264,371,260,366);
	g.curveTo(244,372,238,367);
	g.curveTo(235,377,228,377);
	g.curveTo(221,377,225,372);
	g.curveTo(221,372,217,372);
	g.curveTo(217,371,219,368);
	g.curveTo(223,360,222,348);
	g.curveTo(214,351,211,347);
	g.curveTo(211,345,210,342);
	g.curveTo(208,354,204,351);
	g.curveTo(173,350,171,356);
	g.curveTo(159,357,164,345);
	g.curveTo(155,346,144,346);
	g.curveTo(129,343,121,346);
	g.curveTo(125,337,121,334);
	g.curveTo(115,331,116,340);
	g.curveTo(115,346,94,343);
	g.curveTo(89,339,86,341);
	g.curveTo(83,343,85,337);
	g.curveTo(63,342,57,334);
	g.curveTo(61,326,58,326);
	g.curveTo(59,326,53,321);
	g.curveTo(53,326,56,330);
	g.curveTo(50,331,47,331);
	g.curveTo(42,332,39,335);
	g.curveTo(37,330,32,330);
	g.curveTo(28,329,29,332);
	g.curveTo(28,327,24,329);
	g.curveTo(22,331,20,331);
	g.curveTo(20,327,14,328);
	g.curveTo(18,327,19,323);
	g.curveTo(0,328,0,322);
	
	if(vw!=null){
		title.width=vw*0.8;
		title.height=316*(vw*0.8/560.0);
		conlist.push(title);
	}
	
	//trace("titlepic show!");
	
}

$G._set("shape_BH",Showtitle);

function Showcard01(mask,state){
	
	var time_delay_01=0;
	var temptime_01=Gettime(state)+time_delay_01;
	
	var shape_card_01 = $.createShape({lifeTime:0,x:0,y:0,parent:bg});
	conlist.push(shape_card_01);
	shape_card_01.transform.matrix3D = null;
	
	
	var shape_card_original={x:-vw*0.3,y:-vh*0.3,rotationY:160,rotationX:-20,fontsize:300};
	var shape_card_target={x:vw*0.8,y:vh*0.6,rotationY:-100,rotationX:80,fontsize:0};
	var shape_card_controls={x:[vw*0.5,vw*0.7],y:[vh*0.4,vh*0.6],rotationY:[60],rotationX:[20],fontsize:[100]};
	var tempvw=vw;
	var tempvh=vh;
	
	var shape_card_fun=function(obj,obj_hidden){
		
		obj.rotationY=obj_hidden.rotationY;
		obj.rotationX=obj_hidden.rotationX;
		obj.rotationZ=obj_hidden.rotationZ;
		//		obj.alpha=1;
		obj.graphics.clear();
		obj.graphics.beginFill(0xffffff,0);
		obj.graphics.lineStyle(4,0x00a2e8,0.8);
		obj.graphics.drawPath( $.toIntVector([1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,3,3,3,3,1,3,3,3,3]),$.toNumberVector([78,57,92,97,124,85,148,72,130,35,114,6,59,21,7,42,12,97,18,150,67,175,142,199,186,264,216,189,274,170,328,137,319,88,314,36,259,19,209,12,196,44,171,65,166,173,152,154,85,135,44,113,61,72,62,67,76,57,210,78,205,125,253,129,296,126,293,89,288,49,246,48,218,50,210,76,235,83,238,112,263,102,278,92,270,77,254,60,243,70,236,73,236,82]));
		//obj.graphics.filters=[$.createGlowFilter(0xffffff,1,5,5,4,3,false,ture)]; 
		obj.graphics.endFill();
		var temp=obj.height/obj.width;
		
		obj.x=obj_hidden.x*(vw/tempvw);
		obj.y=obj_hidden.y*(vw/tempvw);
		obj.width=obj_hidden.fontsize;
		obj.height=obj.width*temp;
	};
	Creatmove(2,shape_card_01,shape_card_original,shape_card_target,shape_card_controls,shape_card_fun,1,temptime_01+2000,1);
	
	//trace("cardok");
}

function Showcard02(mask,state){
	
	var time_delay_01=600;
	var temptime_01=Gettime(state)+time_delay_01;
	
	var shape_card_01 = $.createShape({lifeTime:0,x:0,y:0,parent:bg});
	conlist.push(shape_card_01);
	shape_card_01.transform.matrix3D = null;
	
	
	var shape_card_original={x:vw*0.1,y:vh*1.3,rotationY:160,rotationX:-20,fontsize:300};
	var shape_card_target={x:vw*0.8,y:vh*0.2,rotationY:-100,rotationX:80,fontsize:0};
	var shape_card_controls={x:[vw*0.2,vw*0.6],y:[vh*0.5,vh*0.6],rotationY:[60],rotationX:[20],fontsize:[100]};
	var tempvw=vw;
	var tempvh=vh;
	
	var shape_card_fun=function(obj,obj_hidden){
		
		obj.rotationY=obj_hidden.rotationY;
		obj.rotationX=obj_hidden.rotationX;
		obj.rotationZ=obj_hidden.rotationZ;
		//		obj.alpha=1;
		obj.graphics.clear();
		obj.graphics.beginFill(0xffffff,0);
		
		obj.graphics.lineStyle(4,0x00a2e8,0.8);
		obj.graphics.drawPath( $.toIntVector([1,3,3,3,3,3,3,3,1,3,3,3,3,1,3,3,3,3]),$.toNumberVector([124,13,74,115,46,174,23,230,64,278,93,307,126,303,172,302,193,283,228,251,222,192,216,171,180,110,155,60,125,12,149,153,210,181,178,245,153,285,109,268,61,251,71,196,88,136,148,153,128,183,154,184,156,211,157,238,122,241,92,233,96,211,97,183,127,181]));
		//obj.graphics.filters=[$.createGlowFilter(0xffffff,1,5,5,4,3,false,ture)]; 
		obj.graphics.endFill();
		var temp=obj.height/obj.width;
		obj.x=obj_hidden.x*(vw/tempvw);
		obj.y=obj_hidden.y*(vw/tempvw);
		obj.width=obj_hidden.fontsize;
		obj.height=obj.width*temp;
	};
	Creatmove(2,shape_card_01,shape_card_original,shape_card_target,shape_card_controls,shape_card_fun,1,temptime_01+2000,1);
	
	//trace("cardok");
}

function Showcard03(mask,state){
	
	var time_delay_01=1200;
	var temptime_01=Gettime(state)+time_delay_01;
	
	var shape_card_01 = $.createShape({lifeTime:0,x:0,y:0,parent:bg});
	conlist.push(shape_card_01);
	shape_card_01.transform.matrix3D = null;
	
	
	var shape_card_original={x:vw*0.4,y:-vh*0.3,rotationY:160,rotationX:-20,fontsize:300};
	var shape_card_target={x:vw*0.9,y:vh*0.9,rotationY:-100,rotationX:80,fontsize:0};
	var shape_card_controls={x:[vw*0.2,vw*0.6],y:[vh*0.3,vh*0.6],rotationY:[100,40],rotationX:[10,40],fontsize:[100,50]};
	var tempvw=vw;
	var tempvh=vh;
	
	var shape_card_fun=function(obj,obj_hidden){
		
		obj.rotationY=obj_hidden.rotationY;
		obj.rotationX=obj_hidden.rotationX;
		obj.rotationZ=obj_hidden.rotationZ;
		//		obj.alpha=1;
		obj.graphics.clear();
		obj.graphics.beginFill(0xffffff,0);
		
		obj.graphics.lineStyle(4,0x00a2e8,0.8);
		obj.graphics.drawPath( $.toIntVector([1,3,3,3,3,3,3,3,3,3,1,3,3,3,3,3]),$.toNumberVector([78,136,61,245,45,316,59,311,75,296,92,312,105,325,125,286,141,297,161,316,164,326,172,286,214,303,195,219,170,134,145,167,118,163,89,160,79,135,141,140,179,109,153,71,131,46,101,59,70,76,77,110,84,132,105,143,113,143,138,142]));
		obj.graphics.lineStyle(6,0x00a2e8,0.8);
		obj.graphics.drawPath( $.toIntVector([1,3,3,3,1,3,3,3,1,3,3,3,1,3,3,3,1,3,3,3]),$.toNumberVector([66,108,50,109,34,101,51,93,62,88,63,99,66,108,75,63,73,61,64,40,79,45,88,53,82,58,75,63,108,44,120,45,123,42,122,31,118,13,113,32,106,40,151,51,157,46,169,34,166,51,164,60,156,56,150,52,176,84,196,91,205,93,184,100,177,102,177,93,175,83]));
		//obj.graphics.filters=[$.createGlowFilter(0xffffff,1,5,5,4,3,false,ture)]; 
		obj.graphics.endFill();
		var temp=obj.height/obj.width;
		obj.x=obj_hidden.x*(vw/tempvw);
		obj.y=obj_hidden.y*(vy/tempvy);
		obj.width=obj_hidden.fontsize;
		obj.height=obj.width*temp;
	};
	Creatmove(2,shape_card_01,shape_card_original,shape_card_target,shape_card_controls,shape_card_fun,1,temptime_01+2000,1);
	
	//trace("cardok");
}

function Showcard04(mask,state){
	
	var time_delay_01=1800;
	var temptime_01=Gettime(state)+time_delay_01;
	
	var shape_card_01 = $.createShape({lifeTime:0,x:0,y:0,parent:bg});
	conlist.push(shape_card_01);
	shape_card_01.transform.matrix3D = null;
	
	
	var shape_card_original={x:vw*0.1,y:vh*1.3,rotationY:160,rotationX:-20,fontsize:300};
	var shape_card_target={x:vw*0.8,y:vh*0.2,rotationY:-100,rotationX:80,fontsize:0};
	var shape_card_controls={x:[vw*0.2,vw*0.6],y:[vh*0.5,vh*0.6],rotationY:[100,40],rotationX:[10,40],fontsize:[100,50]};
	var tempvw=vw;
	var tempvh=vh;
	
	var shape_card_fun=function(obj,obj_hidden){
		
		obj.rotationY=obj_hidden.rotationY;
		obj.rotationX=obj_hidden.rotationX;
		obj.rotationZ=obj_hidden.rotationZ;
		//		obj.alpha=1;
		obj.graphics.clear();
		obj.graphics.beginFill(0xffffff,0);
		
		obj.graphics.lineStyle(4,0x00a2e8,0.8);
		obj.graphics.drawPath( $.toIntVector([1,3,3,3,3,3,3,3,3,3,3,1,3,3,3,3,3,1,3,3,3,3]),$.toNumberVector([12,161,56,126,110,155,128,205,184,219,255,230,300,163,363,174,395,111,401,92,392,70,348,102,304,83,291,33,235,14,190,6,150,27,122,40,112,77,12,74,11,157,180,177,135,149,145,101,153,74,182,58,221,49,225,80,230,113,188,135,173,145,181,176,233,55,255,103,227,130,187,156,219,179,240,190,269,138,290,77,232,52]));
		//obj.graphics.filters=[$.createGlowFilter(0xffffff,1,5,5,4,3,false,ture)]; 
		obj.graphics.endFill();
		var temp=obj.height/obj.width;
		
		obj.x=obj_hidden.x*(vw/tempvw);
		obj.y=obj_hidden.y*(vw/tempvw);
		obj.width=obj_hidden.fontsize;
		obj.height=obj.width*temp;
		
	};
	Creatmove(2,shape_card_01,shape_card_original,shape_card_target,shape_card_controls,shape_card_fun,1,temptime_01+2000,1);
	
	//trace("cardok");
}

function Showcard05(mask,state){
	
	var time_delay_01=2400;
	var temptime_01=Gettime(state)+time_delay_01;
	
	var shape_card_01 = $.createShape({lifeTime:0,x:0,y:0,parent:bg});
	conlist.push(shape_card_01);
	shape_card_01.transform.matrix3D = null;
	
	
	var shape_card_original={x:vw*1.2,y:vh*0.1,rotationY:160,rotationX:-20,fontsize:300};
	var shape_card_target={x:vw*0.3,y:vh*0.8,rotationY:-100,rotationX:80,fontsize:0};
	var shape_card_controls={x:[vw*0.8,vw*0.4],y:[vh*0.5,vh*0.6],rotationY:[60],rotationX:[20],fontsize:[100]};
	var tempvw=vw;
	var tempvh=vh;
	
	var shape_card_fun=function(obj,obj_hidden){
		
		obj.rotationY=obj_hidden.rotationY;
		obj.rotationX=obj_hidden.rotationX;
		obj.rotationZ=obj_hidden.rotationZ;
		//		obj.alpha=1;
		obj.graphics.clear();
		obj.graphics.beginFill(0xffffff,0);
		
		obj.graphics.lineStyle(4,0x00a2e8,0.8);
		obj.graphics.drawPath( $.toIntVector([1,2,2,2,2,2,2,2,2,2,2,2,2,1,2,2,2,1,2,2,2,1,2,2,2,1,2,2,2]),$.toNumberVector([80,10,83,139,22,140,22,206,85,205,88,328,137,328,136,205,197,203,196,137,137,139,133,11,80,12,153,41,154,105,193,40,153,42,160,229,158,295,201,294,162,228,21,40,63,40,64,111,21,40,65,231,67,301,23,300,64,228]));
		//obj.graphics.filters=[$.createGlowFilter(0xffffff,1,5,5,4,3,false,ture)]; 
		obj.graphics.endFill();
		var temp=obj.height/obj.width;
		obj.x=obj_hidden.x*(vw/tempvw);
		obj.y=obj_hidden.y*(vw/tempvw);
		obj.width=obj_hidden.fontsize;
		obj.height=obj.width*temp;
		
	};
	Creatmove(2,shape_card_01,shape_card_original,shape_card_target,shape_card_controls,shape_card_fun,1,temptime_01+2000,1);
	
	//trace("cardok");
}

function Txtfun(txt,time)
{
	//trace("txt "+txt+"time "+time);
	Txtclear();
	var timerset=[true,true];
	
	blends=["invert","add"]; 
	//trace("debug00");
	filterset=["0xffffff",0.5,2,2,3,false,true];
	locationset=[0,vh*0.9];
	sizeset=[0.05,3];
	txtset=[txtfont[0],sizeset,"0x000000",true,false,false,null,null,"center",null,null,null,10]; 
	//trace("debug00");
	otherset=[1000,0,0,0.9,0.4,4,[0.007,0.006,0.15,0.2,0.001,0.001,0,0,100]];
	
	if(arguments.length>2)
	{
		(arguments[2]!=null)?(timerset=arguments[2]):null;
		(arguments[3]!=null)?(blends=arguments[3]):null;
		(arguments[4]!=null)?(locationset=arguments[4]):null;
		(arguments[5]!=null)?(txtset=arguments[5]):null;
		(arguments[6]!=null)?(filterset=arguments[6]):null;
		(arguments[7]!=null)?(otherset=arguments[7]):null;
	}
	
	sizeset=txtset[1];
	txtsize=Math.round(vh*sizeset[0])+sizeset[1]; 
	bg_txt=$.createCanvas({x:locationset[0],y:locationset[1],alpha:1,lifeTime:0,parent:bg2});    
	masks.push(bg_txt);
	
	var txt00=$.createComment("",{x:otherset[1],y:otherset[2],lifeTime:time/otherset[0],parent:bg_txt});
	
	format01=$.createTextFormat(txtset[0],txtsize,txtset[2] ,txtset[3] ,txtset[4] ,txtset[5] ,txtset[6] ,txtset[7] ,txtset[8] ,txtset[9] ,txtset[10] ,txtset[11] ,txtset[12] ); 
	
	var txt01=$.createComment(txt,{x:otherset[1],y:otherset[2],lifeTime:time/otherset[0],parent:bg_txt}); 
	
	txt00.setTextFormat(format01);
	txt01.setTextFormat(format01); 
	txt00.filters=null;
	txt00.blendMode=blends[0];   
	txt00.alpha=otherset[3];
	txt01.alpha=otherset[4]; 
	txt01.filters=[$.createGlowFilter(filterset[0],filterset[1],filterset[2],filterset[3],filterset[4],3,filterset[5] ,filterset[6])] ;
	txt01.blendMode=blends[1];    
	
	var txtcount=0;
	var intertime=Math.round((time/otherset[5])/txt.length);
	var num=txt.length;
	var i01=interval(function(){},1000,1);
	var i02=interval(function(){},1000,1);
	
	txtlist.push(txt00);
	if(timerset[0])
	{
		i01=interval(function(){
			
			txt00.appendText(txt.substring(txtcount,txtcount+1));
			txt00.setTextFormat(format01);
			txtcount++;
		},intertime,num);
		hastimer=true; 
		interlist.push(i01);
	}
	else
	{
		txt00.appendText(txt);
		txt00.setTextFormat(format01);
		txt01.text="";
	}
	//trace("debug04");
	if(timerset[1])
	{
		interval(function(){
			var filx=Math.round(otherset[6][0]*vw*Math.random())+1;
			var fily=Math.round(otherset[6][1]*vh*Math.random())+1;
			txt00.alpha=otherset[3]+otherset[6][2]-otherset[6][2]*2*Math.random();
			txt01.alpha=otherset[4]+otherset[6][3]-otherset[6][3]*2*Math.random();
			txt00.filters=[$.createBlurFilter(filx,fily,1)]; 
			//txtlist[0][2]=tempfilter;
			var tempx1=otherset[6][4]*vw;
			var tempy1=otherset[6][5]*vh;
			var tempx0=otherset[6][6]*vw;
			var tempy0=otherset[6][7]*vh;
			txt01.x=Math.round(otherset[1]+tempx1*2*Math.random()-tempx1);
			txt01.y=Math.round(otherset[2]+tempy1*2*Math.random()-tempy1); 
			txt00.x=Math.round(otherset[1]+tempx0*2*Math.random()-tempx0);
			txt00.y=Math.round(otherset[2]+tempy0*2*Math.random()-tempy0); 
		},otherset[6][8],Math.round(time/otherset[6][8]));
		txtlist.push(txt01);
		interlist.push(i02);
	}
	
}


var data=[
	["","0000",500,0],
	["","0000.5",24500,1],
	["","0025",7000,2],
	["","0032",12000,3],
	["","0044",16000,4],
	["","0100",14000,5],
	["","0114",6000,6],
	["","0120",12000,7],
	["","0132",999999,8]
];


/*---Functions fin---*/

/*---Start Viewing---*/

Start();

$G._set("BRH" , true);
/*---Start Viewing fin---*/

/*---CODE BY 时空游客---*/
/*---20130818 0358 BETA---*/