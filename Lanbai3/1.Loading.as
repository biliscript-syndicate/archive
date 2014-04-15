/*1预载等待分镜                */
if($G._("loading"))
stopExecution();
	var loading = {};
		loading.canvas = $.createCanvas({x:0, y:0, lifeTime:0});
		loading.canvas.transform.matrix3D = null;

		loading.logText = $.createComment('', {x:0, y:0, lifeTime:0, parent:loading.canvas});
		loading.logText.transform.matrix3D = null;
		loading.logText.x = 120;
		loading.logText.y = 45;
		loading.logFormat = $.createTextFormat('黑体', 16, 0xFFFFFF, false);
		loading.logText.text = "弹幕娘正在用力加载...\n浏览器未响应纯属正常\n请耐心等待片刻\n播放器可能会自动暂停\n若配置高,高级弹幕全屏推荐\n第2分P为录屏加相关福利下载\n为不影响观看，会禁止弹幕。P2、评论区可以发表评论";
		loading.logText.setTextFormat(loading.logFormat);

		loading.logText2 = $.createComment('', {x:0, y:0, lifeTime:0, parent:loading.canvas});
		loading.logText2.transform.matrix3D = null;
		loading.logText2.x = 320;
		loading.logText2.y = 190;
		loading.logFormat2 = $.createTextFormat('黑体', 12, 0xFFFFFF, false);
		loading.logText2.text = "";
		loading.logText2.setTextFormat(loading.logFormat2);


		loading.bar = $.createShape({x:0, y:0, lifeTime:0, parent:loading.canvas});
		loading.bar.transform.matrix3D = null;
		loading.bar.x = 8;
		loading.bar.y = 180;
		loading.bar.filters = [$.createGlowFilter(0xFFFFFF, 1, 5, 5, 0.8, 3)];

		loading.changeT = function(text)
		{
			loading.logText2.text += text;
			loading.logText2.setTextFormat(loading.logFormat2);
		};

		loading.prepare = function()
		{
			if ($.root.contains(loading.canvas))
				$.root.removeChild(loading.canvas);
			$.root.addChild(loading.canvas);
		};
		loading.redraw = function()
		{
			this.bar.graphics.clear();
			this.bar.graphics.beginFill(0xFFFFFF);
			this.bar.graphics.drawRect(0, 0, this.value, 10);
			this.bar.graphics.endFill();
		};
		loading.remove = function()
		{
			if ($.root.contains(loading.logText2))
			loading.logText2.remove();
			if ($.root.contains(loading.logText))
			loading.logText.remove();
			if ($.root.contains(loading.bar))
			loading.bar.remove();
			if ($.root.contains(this.canvas))
			$.root.removeChild(this.canvas);
		};
		loading.change = function(v)
		{
			this.value = v;
			this.redraw();
		};
/*		loading.finish = function()
		{
			this.base = this.value;
		};*/
		loading.change(20);

$G._set("loading",loading);
/*
if($G._("isLoaded_1"))
stopExecution();//只为Error1009
var playerState = Player.state;
if (playerState == 'playing')
{
	lastPlayerState = Player.state;
	Player.pause();
}


if (playerState == 'playing')
{
	Player.play();
	($G._("loading")).change(50);
	//$$.appendLog('20%...');
};
$G._set("isLoaded_1" , true);
