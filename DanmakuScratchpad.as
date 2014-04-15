/*
弹幕涂鸦系统 - 1.0 (2013/02/26)
  - http://www.bilibili.tv/video/av488629/

== 更新历史:
 * 1.0
  - 首次发布

== Github:
   https://github.com/biliscript-syndicate/archive/DanmakuScratchpad.as

== 《弹幕艺术联合文档》
   http://biliscript-syndicate.github.com/

== 作者
 * Xarple: 界面开发、图形算法、性能调优、视频渲染/压制
    - http://space.bilibili.tv/140964
 * Nekofs: 编解码组件、QA、技术咨询
    - http://space.bilibili.tv/5621
*/

var aboutStr = '【弹幕涂鸦系统 1.0】\n使用方法：画好后点击复制，再点击弹幕输入框(进度\n条下面)，自动填充涂鸦数据，这时点击发送即可。';
var colors = [0x000000, 0x880015, 0xed1c24, 0xff7f27, 0xfff227, 0x22b149, 0x00a2e8, 0xa349a4,
			0xffffff, 0xb97a57, 0xffaec9, 0xffc90e, 0xefe4b0, 0xb5e61d, 0x99d9ea, 0xc8bfe7];
var thicknesses = [1, 2, 4, 6];
var maxDataLength = 404;
var cfgHidePattern = false;
var cfgHideComment = false;
var cfgShowCommentDate = false;
var defaultErrorTolerance = 0.2;
var patternSymbol = 'ㄖ';

var currentTime = 0;
var lastTime = 0;
var deltaTime = 0;

var ptTool = null;
var dispatcher = null;
var transport = null;
	
/***********************************************************************/
function resetObject(object, param)
{
	ScriptManager.popEl(object);
	if (param && param.parent)
		param.parent.addChild(object);
	else
		$.root.addChild(object);
	object.transform.matrix3D = null;
	return object;
}

/***********************************************************************/
function setParameters(object, param)
{
	foreach(param, function(key, val)
	{
		if (object.hasOwnProperty(key))
			object['' + key] = val;
	});
}

/***********************************************************************/
function eraseParameters(param, filter)
{
	var newParam = {};
	foreach(param, function(key, val)
	{
		if (!filter.hasOwnProperty(key))
			newParam['' + key] = val;
	});
	return newParam;
}

/***********************************************************************/
function createCanvas(param)
{
	var object = resetObject($.createCanvas({lifeTime:0}), param);
	setParameters(object, eraseParameters(param, {parent:0}));
	return object;
}

/***********************************************************************/
function createShape(param)
{
	var object = resetObject($.createShape({lifeTime:0}), param);
	setParameters(object, eraseParameters(param, {parent:0}));
	return object;
}

/***********************************************************************/
function createBitmap(param)
{
	var object = resetObject(Bitmap.createBitmap({lifeTime:0}), param);
	setParameters(object, eraseParameters(param, {parent:0}));
	return object;
}

/***********************************************************************/
function createText(str, param)
{
	var object = resetObject($.createComment(str, {lifeTime:0}), param);
	object.defaultTextFormat = $.createTextFormat('微软雅黑', (param && param.size) || 14, (param && param.color != null) ? param.color : 0xFFFFFF, false, false, false);
	object.filters = [];
	object.text = str;
	setParameters(object, eraseParameters(param, {parent:0, size:0, color:0}));
	return object;
}

/***********************************************************************/
function createByteArray()
{
	var byteArray = $G._get('byteArray');
	if (!byteArray)
	{
		var bitmapData = Bitmap.createBitmapData(1, 1);
		byteArray = bitmapData.getPixels(bitmapData.rect);
		byteArray.position = 0;
		byteArray.length = 0;
		byteArray.endian = 'littleEndian';
		$G._set('byteArray', byteArray);
	}
	return clone(byteArray);
}

/***********************************************************************/
function setToButton(object, onClickFunction)
{
	object.mouseEnabled = true;
	object.addEventListener('mouseOver', function(e) {
		(Tween.to(e.target, {alpha:0.7}, 0.2)).play();
	});
	object.addEventListener('mouseOut', function(e) {
		(Tween.to(e.target, {alpha:1.0}, 0.2)).play();
	});
	if (onClickFunction)
		object.addEventListener('click', onClickFunction);
}

/***********************************************************************/
function startTweenAndHookEvent(tween, onFinishedFunction)
{
	tween.addEventListener('complete', onFinishedFunction);
	tween.play();
	return tween;
}

/***********************************************************************/
function startTweenAndAutoRemoveObject(tween)
{
	tween.addEventListener('complete', function(e)
	{
		e.target.remove();
	});
	tween.play();
	return tween;
}

/***********************************************************************/
function createPenPath(canvas, color, thickness)
{
	var penPath = {};
	penPath.shape = createBitmap({parent:canvas, bitmapData:Bitmap.createBitmapData(256, 256, true, 0)});
	penPath.vectorizer = createVectorizer(ptTool.errorTolerance, 1.0/3.0, color, thickness);
	penPath.penColorIndex = color;
	penPath.penThicknessType = thickness;
	penPath.pointPaths = [];
	penPath.vectorizer.reset();

	penPath.add = function(x, y)
	{
		this.vectorizer.add(x, y);
	};

	penPath.update = function()
	{
		this.pointPaths = this.vectorizer.drawToBitmapDataAndReturnPath(penPath.shape.bitmapData);
	};
	
	return penPath;
}

/***********************************************************************/
function initializePaintingTool()
{
	ptTool = {};
	ptTool.painting = false;
	ptTool.lastPenX = 0xFFFF;
	ptTool.lastPenY = 0xFFFF;
	ptTool.rootCanvas = createCanvas({visible:false});
	ptTool.bottomButtonsCanvas = createCanvas({parent:ptTool.rootCanvas});
	ptTool.startPaintBtn = createCanvas({parent:ptTool.bottomButtonsCanvas});
	{
		ptTool.startPaintBtn.graphics.beginFill(0, 0.7);
		ptTool.startPaintBtn.graphics.drawRoundRect(0, 0, 73, 30, 5);
		ptTool.startPaintBtn.graphics.endFill();
		ptTool.startPaintText = createText('开始涂鸦', {parent:ptTool.startPaintBtn, color:0xFFFFFF, x:6, y:2, alpha:0.7});
	}
	ptTool.aboutBtn = createCanvas({parent:ptTool.bottomButtonsCanvas, x:ptTool.bottomButtonsCanvas.width+1});
	{
		ptTool.aboutBtn.graphics.beginFill(0, 0.7);
		ptTool.aboutBtn.graphics.drawRoundRect(0, 0, 18, 30, 5);
		ptTool.aboutBtn.graphics.endFill();
		createText('?', {parent:ptTool.aboutBtn, color:0xFFFFFF, x:3, y:2, alpha:0.7});
	}
	ptTool.settingBtn = createCanvas({parent:ptTool.bottomButtonsCanvas, x:ptTool.bottomButtonsCanvas.width+1});
	{
		ptTool.settingBtn.graphics.beginFill(0, 0.7);
		ptTool.settingBtn.graphics.drawRoundRect(0, 0, 20, 30, 5);
		ptTool.settingBtn.graphics.endFill();
		ptTool.settingBtn.graphics.beginFill(0xffffff, 0.6);
		ptTool.settingBtn.graphics.drawPath($.toIntVector([1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2]),$.toNumberVector([15.9,11,14.55,12.4,14.7,12.7,14.85,13,14.95,13.3,15.05,13.6,17,13.6,17,16.35,15.05,16.35,14.55,17.6,15.9,18.95,15.9,19,14,20.9,13.95,20.9,12.65,19.6,12.35,19.8,12.05,19.95,11.7,20.1,11.35,20.2,11.35,22,8.6,22,8.6,20.35,7.15,19.8,6,20.9,4.1,19,4.1,18.95,5.1,17.95,4.9,17.55,4.75,17.15,4.55,16.8,4.45,16.35,3,16.35,3,13.6,4.45,13.6,5.1,12.05,4.1,11,6,9.1,7.15,10.2,7.5,10,7.85,9.85,8.25,9.75,8.6,9.65,8.6,8,11.35,8,11.35,9.8,12.65,10.4,13.95,9.1,14,9.1,15.9,11,9.65,12.65,10,12.6,10.3,12.65,10.65,12.7,10.9,12.8,11.2,12.95,11.45,13.1,11.7,13.3,11.9,13.55,12.05,13.8,12.2,14.05,12.3,14.35,12.35,14.65,12.4,15,12.35,15.3,12.3,15.65,12.2,15.9,12.05,16.2,11.9,16.45,11.7,16.7,11.45,16.9,11.2,17.05,10.9,17.2,10.65,17.3,10.3,17.35,10,17.4,9.05,17.2,8.3,16.7,7.8,15.9,7.6,15,7.65,14.65,7.7,14.35,7.8,14.05,7.95,13.8,8.1,13.55,8.3,13.3,8.55,13.1,8.8,12.95,9.05,12.8,9.35,12.7,9.65,12.65]),"evenOdd");
		ptTool.settingBtn.graphics.endFill();
	}
	ptTool.copyBtn = createCanvas({parent:ptTool.bottomButtonsCanvas, x:ptTool.bottomButtonsCanvas.width+1});
	{
		ptTool.copyBtn.graphics.beginFill(0, 0.7);
		ptTool.copyBtn.graphics.drawRoundRect(0, 0, 45, 30, 5);
		ptTool.copyBtn.graphics.endFill();
		ptTool.copyProm = createCanvas({parent:ptTool.copyBtn, x:0, y:0, visible:false});
		{
			ptTool.copyProm.graphics.beginFill(0xb5e61d, 0.8);
			ptTool.copyProm.graphics.drawRoundRect(2, 2, 41, 26, 5);
			ptTool.copyProm.graphics.endFill();
		}
		ptTool.copyTextField = createText('', {parent:ptTool.copyBtn, color:0xFFFFFF, x:0, y:2, alpha:0.1, filters:[$.createGlowFilter(0, 0.7, 3, 3, 2, 3)]});
		{
			ptTool.copyTextField.autoSize = 'none';
			var format = ptTool.copyTextField.defaultTextFormat;
			format.align = 'center';
			ptTool.copyTextField.defaultTextFormat = format;

			ptTool.copyTextField.width = 45;
			ptTool.copyTextField.height = 28;
			ptTool.copyTextField.text = '复制';
			ptTool.copyTextField.mouseEnabled = ptTool.copyTextField.selectable = true;

			ptTool.copyTextFieldTweener = null;
			ptTool.copyButtonEnable = false;
			ptTool.setCopyButtonEnable = function(enable)
			{
				if (ptTool.copyButtonEnable == enable)
					return;
					
				ptTool.copyButtonEnable = enable;
				if (!enable)
					ptTool.copyProm.visible = false;
				
				if (ptTool.copyTextFieldTweener)
					ptTool.copyTextFieldTweener.stop();

				ptTool.copyTextFieldTweener = startTweenAndHookEvent(
					Tween.to(ptTool.copyTextField, {alpha:enable ? 0.7 : 0.1}, 0.2), function()
				{
					ptTool.copyTextFieldTweener = null;
				});
			};
		}
	}
	ptTool.toolRootCanvas = createCanvas({parent:ptTool.rootCanvas, alpha:0, filters:[$.createDropShadowFilter(1, 90, 0x231F20, 0.8, 9, 9, 1)]});
	ptTool.ptCanvas = createCanvas({parent:ptTool.toolRootCanvas});
	{
		ptTool.ptCanvas.graphics.beginFill(0xffffff);
		ptTool.ptCanvas.graphics.drawPath($.toIntVector([1,2,3,2,3,2,3,2,3]),$.toNumberVector([256,10.5,256,245.45,256,256,245.5,256,10.55,256,0,256,0,245.45,0,10.5,0,0,10.55,0,245.5,0,256,0,256,10.5]),"evenOdd");
		ptTool.ptCanvas.graphics.endFill();
	}
	ptTool.ptCanvasDebugInfo = createCanvas({parent:ptTool.toolRootCanvas, visible:false});
	ptTool.settingListPanel = createCanvas({parent:ptTool.rootCanvas, filters:[$.createDropShadowFilter(1, 90, 0x231F20, 0.8, 9, 9, 1)], visible:false, alpha:0});
	{
		ptTool.settingListPanel.graphics.beginFill(0x1f1f1f, 0.9);
		ptTool.settingListPanel.graphics.drawRoundRect(0, 0, 110, 161, 8);
		ptTool.settingListPanel.graphics.endFill();

		var hidePatternBtn = createCanvas({parent:ptTool.settingListPanel, x:5, y:5});
		{
			hidePatternBtn.graphics.beginFill(0);
			hidePatternBtn.graphics.drawRoundRect(0, 0, 100, 25, 5);
			hidePatternBtn.graphics.endFill();
			ptTool.hidePatternProm = createCanvas({parent:hidePatternBtn, x:0, y:0, visible:false});
			{
				ptTool.hidePatternProm.graphics.beginFill(0xb5e61d, 0.8);
				ptTool.hidePatternProm.graphics.drawRoundRect(0, 0, 100, 25, 5);
				ptTool.hidePatternProm.graphics.endFill();
			}
			createText('隐藏涂鸦', {parent:hidePatternBtn, color:0xFFFFFF, x:20, alpha:0.8, filters:[$.createGlowFilter(0, 0.7, 3, 3, 2, 3)]});

			setToButton(hidePatternBtn, function()
			{
				cfgHidePattern = !cfgHidePattern;
				ptTool.hidePatternProm.visible = cfgHidePattern;
				dispatcher.patternRoot.visible = !cfgHidePattern;
			});
		}
	
		var hideCommentBtn = createCanvas({parent:ptTool.settingListPanel, x:5, y:32});
		{
			hideCommentBtn.graphics.beginFill(0);
			hideCommentBtn.graphics.drawRoundRect(0, 0, 100, 25, 5);
			hideCommentBtn.graphics.endFill();
			ptTool.hideCommentProm = createCanvas({parent:hideCommentBtn, x:0, y:0, visible:false});
			{
				ptTool.hideCommentProm.graphics.beginFill(0xb5e61d, 0.8);
				ptTool.hideCommentProm.graphics.drawRoundRect(0, 0, 100, 25, 5);
				ptTool.hideCommentProm.graphics.endFill();
			}
			createText('隐藏文字弹幕', {parent:hideCommentBtn, color:0xFFFFFF, x:6, alpha:0.8, filters:[$.createGlowFilter(0, 0.7, 3, 3, 2, 3)]});

			setToButton(hideCommentBtn, function()
			{
				cfgHideComment = !cfgHideComment;
				ptTool.hideCommentProm.visible = cfgHideComment;
			});
		}
		
		// error tolerance slider
		{
			ptTool.settingListPanel.graphics.beginFill(0);
			ptTool.settingListPanel.graphics.drawRoundRect(5, 59, 100, 43, 5);
			ptTool.settingListPanel.graphics.endFill();
			createText('曲线近似容差：', {parent:ptTool.settingListPanel, size:12, color:0xFFFFFF, x:13, y:60, alpha:0.6});
			ptTool.settingListPanel.graphics.lineStyle(2, 0x7f7f7f, 0.8);
			ptTool.settingListPanel.graphics.moveTo(15, 90);
			ptTool.settingListPanel.graphics.lineTo(90, 90);
			ptTool.errTolSlider = createCanvas({parent:ptTool.settingListPanel, x:15 + defaultErrorTolerance*75, y:90});
			{
				ptTool.errTolSlider.graphics.beginFill(0xffffff);
				ptTool.errTolSlider.graphics.drawRoundRect(-4, -6, 8, 12, 4);
				ptTool.errTolSlider.graphics.endFill();
				setToButton(ptTool.errTolSlider);
				
				ptTool.errTolSliderBounds = Bitmap.createRectangle(15, 90, 75, 0);
				ptTool.errTolSliderMouseUp = function()
				{
					ptTool.errTolSlider.stopDrag();
					$.root.removeEventListener('mouseUp', ptTool.errTolSliderMouseUp);
					ptTool.errorTolerance = (ptTool.errTolSlider.x - 15)/75;
					if (ptTool.errorTolerance == 0)
						ptTool.errorTolerance = 0.014;
				};
				
				ptTool.errTolSlider.addEventListener('mouseDown', function()
				{
					ptTool.errTolSlider.startDrag(false, ptTool.errTolSliderBounds);
					$.root.addEventListener('mouseUp', ptTool.errTolSliderMouseUp);
				});
			}
		}

		var showDebugInfoBtn = createCanvas({parent:ptTool.settingListPanel, x:5, y:104});
		{
			showDebugInfoBtn.graphics.beginFill(0);
			showDebugInfoBtn.graphics.drawRoundRect(0, 0, 100, 25, 5);
			showDebugInfoBtn.graphics.endFill();
			ptTool.showDebugInfoProm = createCanvas({parent:showDebugInfoBtn, x:0, y:0, visible:false});
			{
				ptTool.showDebugInfoProm.graphics.beginFill(0xb5e61d, 0.8);
				ptTool.showDebugInfoProm.graphics.drawRoundRect(0, 0, 100, 25, 5);
				ptTool.showDebugInfoProm.graphics.endFill();
			}
			createText('显示辅助信息', {parent:showDebugInfoBtn, color:0xFFFFFF, x:6, alpha:0.8, filters:[$.createGlowFilter(0, 0.7, 3, 3, 2, 3)]});

			setToButton(showDebugInfoBtn, function()
			{
				ptTool.showDebugInfo = !ptTool.showDebugInfo;
				ptTool.showDebugInfoProm.visible = ptTool.showDebugInfo;
			});
		}

		var showCommentDateBtn = createCanvas({parent:ptTool.settingListPanel, x:5, y:131});
		{
			showCommentDateBtn.graphics.beginFill(0);
			showCommentDateBtn.graphics.drawRoundRect(0, 0, 100, 25, 5);
			showCommentDateBtn.graphics.endFill();
			ptTool.showCommentDateProm = createCanvas({parent:showCommentDateBtn, x:0, y:0, visible:false});
			{
				ptTool.showCommentDateProm.graphics.beginFill(0xb5e61d, 0.8);
				ptTool.showCommentDateProm.graphics.drawRoundRect(0, 0, 100, 25, 5);
				ptTool.showCommentDateProm.graphics.endFill();
			}
			createText('显示涂鸦日期', {parent:showCommentDateBtn, color:0xFFFFFF, x:6, alpha:0.8, filters:[$.createGlowFilter(0, 0.7, 3, 3, 2, 3)]});

			setToButton(showCommentDateBtn, function()
			{
				cfgShowCommentDate = !cfgShowCommentDate;
				ptTool.showCommentDateProm.visible = cfgShowCommentDate;
				dispatcher.updateCommentDateVisible();
			});
		}
	}
	ptTool.aboutPanel = createCanvas({parent:ptTool.rootCanvas, filters:[$.createDropShadowFilter(1, 90, 0x231F20, 0.8, 9, 9, 1)], visible:false, alpha:0});
	{
		ptTool.aboutPanel.graphics.beginFill(0, 0.75);
		ptTool.aboutPanel.graphics.drawRoundRect(0, 0, 340, 77, 8);
		ptTool.aboutPanel.graphics.endFill();
		createText(aboutStr, {parent:ptTool.aboutPanel, color:0xFFFFFF, x:5, y:5, alpha:0.9});
	}
	ptTool.msgPanel = createCanvas({parent:ptTool.rootCanvas, filters:[$.createDropShadowFilter(1, 90, 0x231F20, 0.8, 9, 9, 1)], visible:false});
	{
		ptTool.msgPanelTweener = null;
		ptTool.msgPanel.graphics.beginFill(0, 0.75);
		ptTool.msgPanel.graphics.drawRoundRect(0, 0, 80, 35, 8);
		ptTool.msgPanel.graphics.endFill();
		ptTool.msgText = createText('', {parent:ptTool.msgPanel, color:0xFFFFFF, x:8, y:4, alpha:0.9});
		
		ptTool.popupMes = function(str)
		{
			if (ptTool.msgPanelTweener)
				ptTool.msgPanelTweener.stop();

			ptTool.msgPanel.alpha = 0;
			ptTool.msgPanel.visible = true;
			ptTool.msgText.text = str;

			ptTool.msgPanel.graphics.clear();
			ptTool.msgPanel.graphics.beginFill(0, 0.75);
			ptTool.msgPanel.graphics.drawRoundRect(0, 0, 18+ptTool.msgText.width, 35, 8);
			ptTool.msgPanel.graphics.endFill();
			ptTool.onScreenResized(true);
		
			ptTool.msgPanelTweener = startTweenAndHookEvent(Tween.serial(
				Tween.to(ptTool.msgPanel, {alpha:1.0}, 0.4),
				Tween.delay(Tween.to(ptTool.msgPanel, {alpha:0.0}, 0.4), 2)), function()
			{
				ptTool.msgPanelTweener = null;
				ptTool.msgPanel.alpha = 0;
				ptTool.msgPanel.visible = false;
			});
		};
	}
	ptTool.penColorIndex = 0;
	ptTool.penThicknessType = 0;
	ptTool.penPaths = [];
	ptTool.curPenPath = null;
	ptTool.curPenPathIdx = -1;
	ptTool.dataLength = 1;
	ptTool.isSpaceWarning = false;
	ptTool.debugResult = createCanvas({parent:ptTool.toolRootCanvas});
	ptTool.showDebugInfo = false;
	ptTool.errorTolerance = defaultErrorTolerance;
	ptTool.copiedData = null;
	ptTool.copyTextFieldFocused = false;

	ptTool.startPaintBtnClicked = function()
	{
		if (ptTool.toolRootCanvas.alpha == 0)
		{
			ptTool.toolRootCanvas.alpha = 0;
			ptTool.toolRootCanvas.visible = true;
			ptTool.startPaintText.text = '关闭涂鸦';
			ptTool.ptCanvas.mouseEnabled = true;
			startTweenAndHookEvent(Tween.to(ptTool.toolRootCanvas, {alpha:1.0}, 0.4), function()
			{
				ptTool.toolRootCanvas.alpha = 1;
			});
		}
		else if (ptTool.toolRootCanvas.alpha == 1)
		{
			ptTool.setCopyButtonEnable(false);
			ptTool.startPaintText.text = '开始涂鸦';
			ptTool.ptCanvas.mouseEnabled = false;
			startTweenAndHookEvent(Tween.to(ptTool.toolRootCanvas, {alpha:0.0}, 0.4), function()
			{
				ptTool.toolRootCanvas.alpha = 0;
				ptTool.toolRootCanvas.visible = false;
				ptTool.clear();
			});
		}
	};
	setToButton(ptTool.startPaintBtn, ptTool.startPaintBtnClicked);

	setToButton(ptTool.aboutBtn, function()
	{
		if (ptTool.aboutPanel.alpha == 0)
		{
			ptTool.aboutPanel.alpha = 0;
			ptTool.aboutPanel.visible = true;
			startTweenAndHookEvent(Tween.to(ptTool.aboutPanel, {alpha:1.0}, 0.3), function()
			{
				ptTool.aboutPanel.alpha = 1;
			});
		}
	});
	ptTool.aboutBtn.addEventListener('mouseOut', function()
	{
		startTweenAndHookEvent(Tween.to(ptTool.aboutPanel, {alpha:0.0}, 0.3), function()
		{
			ptTool.aboutPanel.alpha = 0;
			ptTool.aboutPanel.visible = false;
		});
	});

	setToButton(ptTool.settingBtn, function()
	{
		if (ptTool.settingListPanel.alpha == 0)
		{
			ptTool.settingListPanel.alpha = 0;
			ptTool.settingListPanel.visible = true;
			startTweenAndHookEvent(Tween.to(ptTool.settingListPanel, {alpha:1.0}, 0.3), function()
			{
				ptTool.settingListPanel.alpha = 1;
			});
		}
		else if (ptTool.settingListPanel.alpha == 1)
		{
			startTweenAndHookEvent(Tween.to(ptTool.settingListPanel, {alpha:0.0}, 0.3), function()
			{
				ptTool.settingListPanel.alpha = 0;
				ptTool.settingListPanel.visible = false;
			});
		}
	});

	ptTool.copyTextField.addEventListener('mouseOver', function(e)
	{
		if (ptTool.copyButtonEnable)
			(Tween.to(ptTool.copyBtn, {alpha:0.7}, 0.2)).play();
	});
	ptTool.copyTextField.addEventListener('mouseOut', function(e)
	{
		if (ptTool.copyButtonEnable)
			(Tween.to(ptTool.copyBtn, {alpha:1.0}, 0.2)).play();
	});
	ptTool.copyTextField.addEventListener('focusIn', function(e)
	{
		ptTool.copyTextFieldFocused = true;
	});
	ptTool.copyTextField.addEventListener('focusOut', function(e)
	{
		ptTool.copyTextFieldFocused = false;
		if (ptTool.copyProm.visible && ptTool.copiedData)
		{
			ptTool.copyProm.visible = false;

			if (e.relatedObject
				&& e.relatedObject.hasOwnProperty('owner')
				&& e.relatedObject.owner.hasOwnProperty('owner')
				&& e.relatedObject.owner.owner.hasOwnProperty('owner')
				&& e.relatedObject.owner.owner.owner.hasOwnProperty('owner')
				&& e.relatedObject.owner.owner.owner.owner.hasOwnProperty('textInput'))
			{
				var code = transport.encapsulate(ptTool.copiedData);
				if (!code)
					ptTool.popupMes('复制失败!');

				var textInput = e.relatedObject.owner.owner.owner.owner.textInput;
				textInput.text = code;
				textInput.selectAll();
				ptTool.popupMes('复制成功! 请点击发送按钮!');
			}
			else
				ptTool.popupMes('复制失败!');
		}
	});
	ptTool.copyTextField.addEventListener('click', function(e)
	{
		if (!ptTool.copyButtonEnable)
			return;
		if (ptTool.copyTextFieldFocused)
		{
			if (ptTool.copyProm.visible)
				ptTool.copyProm.visible = false;
			else
			{
				ptTool.copiedData = ptTool.getData();
				if (ptTool.copiedData)
				{
					ptTool.popupMes('请点击输入框');
					ptTool.copyProm.visible = true;
				}
			}
		}
		else
			ptTool.popupMes('请再点击一次!');
	});


	// settings for painting
	{
		ptTool.settingPanel = createCanvas({parent:ptTool.toolRootCanvas, x:266, mouseEnabled:true});
		ptTool.settingPanel.graphics.beginFill(0xffffff);
		ptTool.settingPanel.graphics.drawPath($.toIntVector([1,2,3,2,2,2,3,2,3,2,2,2,2,2,3,2,3,3,2,3,3]),$.toNumberVector([61.8,10.15,62,292,62,302,48.45,302,-254.45,302,-254.8,302,-255.4,302,-264.7,301.5,-265,292.1,-265,275.9,-264.7,266.45,-255.3,266.05,-254.7,266,-254.45,266,-254.3,266,-10,266,-10,265.85,-0.15,264.6,0,255.75,0,10,0,6.8,1.2,4.65,3.55,0,10.55,0,51.3,0,56.15,0,58.8,2.25,61.7,4.8,61.8,10.15]),"evenOdd");
		ptTool.settingPanel.graphics.endFill();
	
		for (var i = 0; i < colors.length; ++i)
		{
			var colBtn = createCanvas({parent:ptTool.settingPanel, x:i>7?35:10, y:10+(i%8)*25, filters:[$.createGlowFilter(0, 0.8, 3, 3, 2)], mouseEnabled:true});
			colBtn.graphics.beginFill(colors[i]);
			colBtn.graphics.drawRect(0, 0, 17, 17);
			colBtn.graphics.endFill();

			setToButton(colBtn, function(e)
			{
				ptTool.changePenColor(ptTool.settingPanel.getChildIndex(e.target));
			});
		}
		
		for (var i = 0; i < 4; ++i)
		{
			var thicknessBtn = createCanvas({parent:ptTool.settingPanel, x:10, y:212+i*12});
			thicknessBtn.graphics.beginFill(0xFFFFFF);
			thicknessBtn.graphics.drawRect(0, 0, 42, 10);
			thicknessBtn.graphics.lineStyle(thicknesses[i], 0, 1, true);
			thicknessBtn.graphics.moveTo(0, thicknesses[i]/2);
			thicknessBtn.graphics.lineTo(42, thicknesses[i]/2);
			
			setToButton(thicknessBtn, function(e)
			{
				ptTool.changePenThickness(ptTool.settingPanel.getChildIndex(e.target) - 16);
			});
		}
		
		ptTool.colorSelection = createCanvas({parent:ptTool.settingPanel});
		ptTool.colorSelection.graphics.lineStyle(3, 0xff00ff, 0.7);
		ptTool.colorSelection.graphics.drawRect(-2, -2, 19, 19);
		
		ptTool.thicknessSelection = createCanvas({parent:ptTool.settingPanel});
		ptTool.thicknessSelection.graphics.lineStyle(2, 0xff00ff, 0.7);
		ptTool.thicknessSelection.graphics.drawRect(-6, -2, 54, 8);
		
		var undoBtn = createCanvas({parent:ptTool.settingPanel, x:-259, y:271.5});
		undoBtn.graphics.beginFill(0, 0.7);
		undoBtn.graphics.drawRoundRect(0, 0, 47, 25, 10);
		undoBtn.graphics.endFill();
		createText('撤销', {parent:undoBtn, color:0xFFFFFF, x:7});
		setToButton(undoBtn, function(e)
		{
			ptTool.undo();
		});
		
		var redoBtn = createCanvas({parent:ptTool.settingPanel, x:8, y:271.5});
		redoBtn.graphics.beginFill(0, 0.7);
		redoBtn.graphics.drawRoundRect(0, 0, 47, 25, 10);
		redoBtn.graphics.endFill();
		createText('重做', {parent:redoBtn, color:0xFFFFFF, x:7});
		setToButton(redoBtn, function(e)
		{
			ptTool.redo();
		});
		
		var spacePanel = createCanvas({parent:ptTool.settingPanel, x:-206, y:271.5});
		spacePanel.graphics.beginFill(0, 0.9);
		spacePanel.graphics.drawRoundRect(0, 0, 208, 25, 10);
		spacePanel.graphics.endFill();
		
		ptTool.spaceWarnPanel = createCanvas({parent:spacePanel, alpha:0});
		ptTool.spaceWarnPanel.graphics.beginFill(0xFF0000);
		ptTool.spaceWarnPanel.graphics.drawRoundRect(0, 0, 208, 25, 10);
		ptTool.spaceWarnPanel.graphics.endFill();
		
		ptTool.spaceBar = createCanvas({parent:spacePanel, x:4, y:4});
		ptTool.spaceBar.graphics.beginFill(0x00CBD2);
		ptTool.spaceBar.graphics.drawRoundRect(0, 0, 200, 17, 5);
		ptTool.spaceBar.graphics.endFill();
		ptTool.spaceBar.graphics.beginGradientFill("linear",[0xffffff,0xffffff],[0.4,0],[0x5b,0xb5],$.createMatrix(0.000000,0.010376,-0.010376,0.000000,102.500000,8.500000),"pad","rgb",0.000000);
		ptTool.spaceBar.graphics.drawRoundRect(0, 0, 200, 17, 5);
		ptTool.spaceBar.graphics.endFill();
		ptTool.spaceText = createText('', {parent:spacePanel, size:12, color:0, x:59, y:2, filters:[$.createGlowFilter(0xFFFFFF, 0.7, 4, 4, 5, 3)]});
	}


	ptTool.ptCanvas.addEventListener('mouseDown', function(e)
	{
		if (ptTool.toolRootCanvas.alpha == 1)
			ptTool.startPainting();
	});
	
	ptTool.mouseUpFunction = function()
	{
		if (ptTool.toolRootCanvas.alpha == 1)
			ptTool.stopPainting();
	};

	ptTool.mouseMoveFunction = function()
	{
		if (ptTool.painting)
		{
			if ((ptTool.ptCanvas.mouseX <= 0 || ptTool.ptCanvas.mouseX >= 256)
				|| (ptTool.ptCanvas.mouseY <= 0 || ptTool.ptCanvas.mouseY >= 256))
			{
				ptTool.stopPainting();
			}
			else
			{
				if (Utils.distance(ptTool.ptCanvas.mouseX, ptTool.ptCanvas.mouseY, ptTool.lastPenX, ptTool.lastPenY) > 3)
				{
					ptTool.lastPenX = ptTool.ptCanvas.mouseX;
					ptTool.lastPenY = ptTool.ptCanvas.mouseY;
					ptTool.curPenPath.add(ptTool.ptCanvas.mouseX, ptTool.ptCanvas.mouseY);
					ptTool.update();
				}
			}
		}
	};
	
	ptTool.appear = function()
	{
		if (ptTool.rootCanvas.visible)
			return;
			
		ptTool.rootCanvas.alpha = 0;
		ptTool.rootCanvas.visible = true;
		(Tween.to(ptTool.rootCanvas, {alpha:1.0}, 0.5)).play();
	};
	
	ptTool.disappear = function()
	{
		if (!ptTool.rootCanvas.visible)
			return;

		startTweenAndHookEvent(Tween.to(ptTool.rootCanvas, {alpha:0.0}, 0.5), function()
		{
			ptTool.rootCanvas.visible = false;

			ptTool.toolRootCanvas.alpha = 0;
			ptTool.toolRootCanvas.visible = false;
			ptTool.clear();
			
			ptTool.settingListPanel.alpha = 0;
			ptTool.settingListPanel.visible = false;
			
			ptTool.copyProm.visible = false;
		});
	};
	
	ptTool.changePenColor = function(index)
	{
		ptTool.penColorIndex = index;
		ptTool.colorSelection.x = index>7 ? 35 : 10;
		ptTool.colorSelection.y = 10 + (index%8)*25;
	};
	
	ptTool.changePenThickness = function(index)
	{
		ptTool.penThicknessType = index;
		ptTool.thicknessSelection.x = 10;
		ptTool.thicknessSelection.y = 212 + index*12;
	};

	ptTool.startPainting = function()
	{
		if (ptTool.penPaths.length > ptTool.curPenPathIdx+1)
			ptTool.penPaths.splice(ptTool.curPenPathIdx+1, ptTool.penPaths.length - (ptTool.curPenPathIdx+1));

		ptTool.curPenPath = createPenPath(ptTool.ptCanvas, ptTool.penColorIndex, ptTool.penThicknessType);
		ptTool.penPaths.push(ptTool.curPenPath);
		ptTool.curPenPathIdx = ptTool.penPaths.length - 1;

		ptTool.curPenPath.add(ptTool.ptCanvas.mouseX, ptTool.ptCanvas.mouseY);
		ptTool.painting = true;
		ptTool.update();
		
		if (ptTool.showDebugInfo)
		{
			ptTool.ptCanvasDebugInfo.visible = true;
			ptTool.ptCanvasDebugInfo.graphics.clear();
		}

		$.root.addEventListener('mouseMove', ptTool.mouseMoveFunction);
		$.root.addEventListener('mouseUp', ptTool.mouseUpFunction);
	};
	
	ptTool.stopPainting = function()
	{
		ptTool.painting = false;
		ptTool.update(true);
		
		if (ptTool.curPenPath.pointPaths.length == 0)
		{
			ptTool.ptCanvas.removeChild(ptTool.penPaths[ptTool.curPenPathIdx^0].shape);
			ptTool.penPaths.splice(ptTool.curPenPathIdx, 1);
			ptTool.curPenPathIdx--;
			ptTool.updateSpaceBar();
		}

		if (ptTool.showDebugInfo)
			ptTool.ptCanvasDebugInfo.visible = false;

		if (ptTool.dataLength > 1 && ptTool.dataLength < maxDataLength)
			ptTool.setCopyButtonEnable(true);
		else
			ptTool.setCopyButtonEnable(false);

		$.root.removeEventListener('mouseMove', ptTool.mouseMoveFunction);
		$.root.removeEventListener('mouseUp', ptTool.mouseUpFunction);
		
		//trace('length: ', ptTool.dataLength);
	};

	ptTool.undo = function()
	{
		if (ptTool.curPenPathIdx >= 0)
		{
			ptTool.ptCanvas.removeChild(ptTool.penPaths[ptTool.curPenPathIdx^0].shape);
			ptTool.curPenPathIdx--;
			ptTool.updateSpaceBar();
			
			if (ptTool.dataLength > 1 && ptTool.dataLength < maxDataLength)
				ptTool.setCopyButtonEnable(true);
			else
				ptTool.setCopyButtonEnable(false);
		}
	};

	ptTool.redo = function()
	{
		if (ptTool.penPaths.length > ptTool.curPenPathIdx+1)
		{
			ptTool.ptCanvas.addChild(ptTool.penPaths[ptTool.curPenPathIdx+1].shape);
			ptTool.curPenPathIdx++;
			ptTool.updateSpaceBar();
			
			if (ptTool.dataLength > 1 && ptTool.dataLength < maxDataLength)
				ptTool.setCopyButtonEnable(true);
			else
				ptTool.setCopyButtonEnable(false);
		}
	};
	
	ptTool.clear = function()
	{
		while (ptTool.ptCanvas.numChildren)
			ptTool.ptCanvas.removeChildAt(0);
		ptTool.penPaths.length = 0;
		ptTool.curPenPath = null;
		ptTool.curPenPathIdx = -1;
		
		ptTool.updateSpaceBar();
		ptTool.setCopyButtonEnable(false);
	};

	ptTool.updateSpaceBar = function()
	{
		ptTool.dataLength = 1;
		if (ptTool.curPenPathIdx >= 0)
		{
			for (var i = 0; i < ptTool.curPenPathIdx+1; ++i)
				ptTool.dataLength += 2 + ptTool.penPaths[i^0].pointPaths.length*3;
		}

		var d = 1.0 - (ptTool.dataLength/maxDataLength);
		
		var rect = ptTool.spaceBar.scrollRect || Bitmap.createRectangle(0, 0, ptTool.spaceBar.height, ptTool.spaceBar.height);
		rect.right = d * 200;
		ptTool.spaceBar.scrollRect = rect;
		ptTool.spaceText.text = '可用空间: ' + (Math.ceil(d * 100)^0) + '%';
		
		if (ptTool.dataLength >= maxDataLength)
			ptTool.spaceWarning();
	};
	
	ptTool.spaceWarning = function()
	{
		if (!ptTool.isSpaceWarning)
		{
			ptTool.isSpaceWarning = true;
			startTweenAndHookEvent(Tween.repeat(Tween.serial(
				Tween.to(ptTool.spaceWarnPanel, {alpha:1.0}, 0.15),
				Tween.to(ptTool.spaceWarnPanel, {alpha:0.0}, 0.15)), 4), function()
			{
				ptTool.isSpaceWarning = false;
			});
		}
	};
	
	ptTool.update = function()
	{
		if (ptTool.curPenPath)
			ptTool.curPenPath.update();
			
		if (ptTool.showDebugInfo)
		{
			drawPaintingPathDebugInfo(ptTool.curPenPath.pointPaths, ptTool.ptCanvasDebugInfo.graphics,
				thicknesses[this.penThicknessType^0]);
		}
		
		ptTool.updateSpaceBar();
	};

	ptTool.getData = function()
	{
		if (ptTool.curPenPathIdx < 0)
			return null;
		if (ptTool.dataLength >= maxDataLength)
		{
			ptTool.spaceWarning();
			return null;
		}
		
		var data = createByteArray();
		var pathCount = ptTool.curPenPathIdx + 1;
		data.writeByte(pathCount);

		var path, len, i, j, point, x, y;
		for (i = 0; i < pathCount; ++i)
		{
			path = ptTool.penPaths[i^0];
			data.writeByte((path.penThicknessType & 7) | ((path.penColorIndex & 15) << 3));
			
			len = path.pointPaths.length;
			data.writeByte(len);
			
			for (j = 0; j < len; ++j)
			{
				point = path.pointPaths[j^0];
				x = ((point.x + 127) * 8) & 0xfff;
				y = ((point.y + 127) * 8) & 0xfff;

				data.writeByte(x & 0xff);
				data.writeByte(((x & 0xf00) >> 8) | ((y & 0xf00) >> 4));
				data.writeByte(y & 0xff);
			}
		}
		
		data.position = 0;
		return data;
	};
	
	ptTool.renderPattern = function(data, graphics)
	{
		data.position = 0;
		var pathCount = data.readUnsignedByte();
		var byte1, byte2, byte3, penStyle, pointCount;
		var paths = [];
		var i, j, x, y;

		graphics.clear();
		for (i = 0; i < pathCount; ++i)
		{
			penStyle = data.readUnsignedByte();
			pointCount = data.readUnsignedByte();

			if (data.length - data.position < pointCount * 3)
				return false;

			paths.length = 0;
			for (j = 0; j < pointCount; ++j)
			{
				byte1 = data.readUnsignedByte();
				byte2 = data.readUnsignedByte();
				byte3 = data.readUnsignedByte();
				
				x = ((byte1 | ((byte2 & 0x0f)<<8)) / 8) - 127;
				y = ((byte3 | ((byte2 & 0xf0)<<4)) / 8) - 127;
				if (x < -127) x = -127;
				else if (x > 384) x = 384;
				if (y < -127) x = -127;
				else if (y > 384) x = 384;
				
				paths.push($.createPoint(x, y));
			}
			
			graphics.lineStyle(thicknesses[penStyle&7], colors[(penStyle&120)>>3]);
			drawPaintingPath(paths, graphics);
		}

		return true;
	};

	ptTool.onScreenResized = function(msgPanelOnly)
	{
		ptTool.msgPanel.x = (ptTool.copyBtn.getRect($.root)).x + ptTool.copyBtn.width/2 - ptTool.msgPanel.width/2;
		ptTool.msgPanel.y = $.height - ptTool.bottomButtonsCanvas.height - ptTool.msgPanel.height - 5;
		
		if (msgPanelOnly)
			true;
			
		ptTool.toolRootCanvas.x = $.width/2 - ptTool.toolRootCanvas.width/2;
		ptTool.toolRootCanvas.y = $.height/2 - ptTool.toolRootCanvas.height/2;
		
		ptTool.bottomButtonsCanvas.x = $.width/2 - ptTool.bottomButtonsCanvas.width/2;
		ptTool.bottomButtonsCanvas.y = $.height - ptTool.bottomButtonsCanvas.height;
		
		ptTool.aboutPanel.x = (ptTool.aboutBtn.getRect($.root)).x + ptTool.aboutBtn.width/2 - ptTool.aboutPanel.width/2;
		ptTool.aboutPanel.y = $.height - ptTool.bottomButtonsCanvas.height - ptTool.aboutPanel.height - 5;

		ptTool.settingListPanel.x = (ptTool.settingBtn.getRect($.root)).x + ptTool.settingBtn.width/2 - ptTool.settingListPanel.width/2;
		ptTool.settingListPanel.y = $.height - ptTool.bottomButtonsCanvas.height - ptTool.settingListPanel.height - 5;
	};
	

	ptTool.onScreenResized();
	ptTool.changePenColor(0);
	ptTool.changePenThickness(2);
	ptTool.clear();
}

/***********************************************************************/
function createVNode(x, y)
{
	var node = {};
	node.x = x;
	node.y = y;
	node.hasTheta = false;
	node.theta = 0;
	
	node.distance = function(n)
	{
		var dx = n.x - this.x;
		var dy = n.y - this.y;
		return Math.sqrt(dx*dx + dy*dy);
	};
	
	return node;
}

/***********************************************************************/
function createCubicSegment(vectorizer, index0, index1)
{
	var segment = {};
	segment.index0 = index0;
	segment.index1 = index1;

	// initialization
	{
		segment.totalLength = vectorizer.arcLengths[index1] - vectorizer.arcLengths[index0];
		
		var n1 = vectorizer.nodes[index0];
		var n2 = vectorizer.nodes[index1];
		
		// the distance from each end point the control points should be:
		var k = segment.totalLength * vectorizer.bezierFactor;
		
		segment.x1 = n1.x;
		segment.y1 = n1.y;
		segment.x2 = n2.x;
		segment.y2 = n2.y;
		
		if (n1.hasTheta == false && n2.hasTheta == false)
		{
			// straight line:
			segment.cx1 = n1.x*1/3+n2.x*2/3;
			segment.cy1 = n1.y*1/3+n2.y*2/3;
			segment.cx2 = n1.x*2/3+n2.x*1/3;
			segment.cy2 = n1.y*2/3+n2.y*1/3;
			segment.isLine = true;
		}
		else if (n1.hasTheta && n2.hasTheta)
		{
			// one curve on each side:
			segment.cx1 = n1.x+k*Math.cos(n1.theta);
			segment.cy1 = n1.y+k*Math.sin(n1.theta);
			segment.cx2 = n2.x-k*Math.cos(n2.theta);
			segment.cy2 = n2.y-k*Math.sin(n2.theta);
			segment.isLine = false;
		}
		else
		{
			// either prev or next does not have an angle
			segment.isLine = false;
			
			// so calculate the angle we would use if we wanted a straight line between index0 and index1:
			var ax0 = n2.x-n1.x;
			var ay0 = n2.y-n1.y;
			var theta = Math.atan2(ay0, ax0);

			if (n1.hasTheta == false)
			{
				segment.cx1 = n1.x+k*Math.cos(theta);
				segment.cy1 = n1.y+k*Math.sin(theta);
				segment.cx2 = n2.x-k*Math.cos(n2.theta);
				segment.cy2 = n2.y-k*Math.sin(n2.theta);
			}
			else
			{
				segment.cx1 = n1.x+k*Math.cos(n1.theta);
				segment.cy1 = n1.y+k*Math.sin(n1.theta);
				segment.cx2 = n2.x-k*Math.cos(theta);
				segment.cy2 = n2.y-k*Math.sin(theta);
			}
		}
	}

	segment.getError = function(vectorizer)
	{
		// convert from bezier control points to parametric coefficients:
		var ay = -this.y1 + 3*this.cy1 - 3*this.cy2 + this.y2;
		var by = 3*this.y1 - 6*this.cy1 + 3*this.cy2;
		var cy = -3*this.y1 + 3*this.cy1;
		var dy = this.y1;
		var ax = -this.x1 + 3*this.cx1 - 3*this.cx2 + this.x2;
		var bx = 3*this.x1 - 6*this.cx1 + 3*this.cx2;
		var cx = -3*this.x1 + 3*this.cx1;
		var dx = this.x1;

		var errorSum = 0;
		var fraction = 0;
		var arcLengths_start = vectorizer.arcLengths[this.index0^0];

		for (var i = this.index0+1; i < this.index1; i++)
		{
			fraction = (vectorizer.arcLengths[i^0] - arcLengths_start) / this.totalLength;
			var n = vectorizer.nodes[i^0];
			errorSum += Utils.distance(n.x, n.y, 
					((ax*fraction+bx)*fraction+cx)*fraction+dx,
					((ay*fraction+by)*fraction+cy)*fraction+dy);
		}
		
		return errorSum / this.totalLength;
	};

	segment.append = function(path)
	{
		path.push($.createPoint(this.cx1, this.cy1));
		path.push($.createPoint(this.cx2, this.cy2));
		path.push($.createPoint(this.x2, this.y2));
	};

	return segment;
}

/***********************************************************************/
function createVectorizer(errorTolerance, bezierFactor, color, thickness)
{
	var vectorizer = {};
	vectorizer.errorTolerance = errorTolerance || 0.2;
	vectorizer.bezierFactor = bezierFactor || 1.0/3.0;
	vectorizer.nodes = [];
	vectorizer.arcLengths = [];
	vectorizer.lastFixedNodeId = 0;
	vectorizer.fixedPoints = [];

	vectorizer.penColorIndex = color;
	vectorizer.penThicknessType = thickness;
	vectorizer.fixedBmpData = Bitmap.createBitmapData(256, 256, true, 0);
	vectorizer.tmpShape = createShape();
	$.root.removeChild(vectorizer.tmpShape);

	vectorizer.reset = function()
	{
		this.nodes.length = 0;
	};

	vectorizer.add = function(x, y)
	{
		var n = createVNode(x, y);
		if (this.nodes.length == 0)
			this.arcLengths.push(0);
		else
			this.arcLengths.push(this.arcLengths[this.arcLengths.length-1] + n.distance(this.nodes[this.nodes.length-1]));
		this.nodes.push(n);
	};

	vectorizer.getThetas = function()
	{
		var array = [];
		var len = array.length = this.nodes.length;
		for (var a = this.lastFixedNodeId; a < len; a++)
		{
			var n = this.nodes[a];
			if (n.hasTheta)
				array[a] = n.theta;
		}
		return array;
	};

	vectorizer.calculateTheta = function(index)
	{
		var node = this.nodes[index];
		var k = index-1;
		var dx = 0;
		var dy = 0;
		var significant = true;
		var nextNode, prevNode;
		var distanceSq;
		while (k>0 && significant)
		{
			prevNode = this.nodes[k];
			distanceSq = (node.x-prevNode.x)*(node.x-prevNode.x)+
				(node.y-prevNode.y)*(node.y-prevNode.y);
			if (distanceSq != 0)
			{
				dx -= (prevNode.x-node.x)/distanceSq;
				dy -= (prevNode.y-node.y)/distanceSq;
				if (distanceSq > 25)
					significant = false;
			}
			k--;
		}

		k = index+1;
		significant = true;
		var len = this.nodes.length;
		while (k<len && significant)
		{
			nextNode = this.nodes[k];
			distanceSq = (node.x-nextNode.x)*(node.x-nextNode.x)+
				(node.y-nextNode.y)*(node.y-nextNode.y);
			if (distanceSq != 0)
			{
				dx += (nextNode.x-node.x)/distanceSq;
				dy += (nextNode.y-node.y)/distanceSq;
				if (distanceSq > 25)
					significant = false;
			}
			k++;
		}

		node.theta = Math.atan2(dy, dx);
		node.hasTheta = true;
	};

	vectorizer.calculateThetas = function()
	{
		var len = this.nodes.length;
		for (var a = this.lastFixedNodeId+1; a < len-1; a++)
			this.calculateTheta(a);

		var thetas = this.getThetas();
		for (var a = this.lastFixedNodeId+1; a < len-1; a++)
		{
			var n0 = this.nodes[a-1];
			var n1 = this.nodes[a];
			var n2 = this.nodes[a+1];
			
			if (n1.hasTheta)
			{
				var dx = 100*Math.cos(thetas[a]);
				var dy = 100*Math.sin(thetas[a]);
				if(n0.hasTheta)
				{
					dx = dx+100*Math.cos(thetas[a-1]);
					dy = dy+100*Math.sin(thetas[a-1]);
				}
				if(n2.hasTheta)
				{
					dx = dx+100*Math.cos(thetas[a+1]);
					dy = dy+100*Math.sin(thetas[a+1]);
				}
				n1.theta = Math.atan2(dy,dx);
			}
		}
	};

	vectorizer.drawToBitmapDataAndReturnPath = function(bitmapData)
	{
		this.calculateThetas();
		var path = this.fixedPoints.slice();
		var arcs = [];
		var startId = this.lastFixedNodeId;
		var lastI = -1, len, i;
		var tmpPath = [];

		len = this.nodes.length;
		i = startId;
		while (i < len-1)
		{
			var n = this.nodes[i];
			if (i == startId)
			{
				var startPoint = $.createPoint(n.x, n.y);
				tmpPath.push(startPoint);
				if (i == 0)
					path.push(startPoint);
				lastI = startId;
				i++;
			}
			else
			{
				var error = 0;
				var lastArc = null;
				var arc = null;
				do
				{
					lastArc = arc;
					i++;
					arc = createCubicSegment(this, lastI, i);
					error = arc.getError(this);
				}
				while (error < this.errorTolerance && i < len-1);


				if (lastArc==null)
				{
					arc.append(path);
					arc.append(tmpPath);
					arcs.push({arc:arc, lastI:lastI});
				}
				else
				{
					i--;
					lastArc.append(path);
					lastArc.append(tmpPath);
					arcs.push({arc:lastArc, lastI:lastI});
				}
				lastI = i;
			}
		}

		if (this.nodes.length == 2) //this is a special case
		{
			var n = this.nodes[1];
			path.push($.createPoint(n.x, n.y));
			tmpPath.push($.createPoint(n.x, n.y));
		}


		if (arcs.length > 3)
		{
			this.lastFixedNodeId = arcs[1].lastI;

			if (this.fixedPoints.length == 0)
				this.fixedPoints.push($.createPoint(this.nodes[0].x, this.nodes[0].y));
			arcs[0].arc.append(this.fixedPoints);

			var n = this.nodes[arcs[0].lastI ^ 0];
			var newFixedPath = [$.createPoint(n.x, n.y)];
			arcs[0].arc.append(newFixedPath);

			this.tmpShape.graphics.clear();
			this.tmpShape.graphics.lineStyle(thicknesses[this.penThicknessType^0], colors[this.penColorIndex^0]);
			drawPaintingPath(newFixedPath, this.tmpShape.graphics);
			this.fixedBmpData.draw(this.tmpShape);
		}

		bitmapData.lock();
		{
			if (this.fixedPoints.length != 0)
				bitmapData.copyPixels(this.fixedBmpData, this.fixedBmpData.rect, $.createPoint(0, 0));
			else
				bitmapData.fillRect(bitmapData.rect, 0);

			this.tmpShape.graphics.clear();
			this.tmpShape.graphics.lineStyle(thicknesses[this.penThicknessType^0], colors[this.penColorIndex^0]);
			drawPaintingPath(tmpPath, this.tmpShape.graphics);
			bitmapData.draw(this.tmpShape);
		}
		bitmapData.unlock();

		return path;
	};
	
	return vectorizer;
}

/***********************************************************************/
function drawPaintingPath(path, graphics)
{
	function getPointOnSegment(P0, P1, ratio)
	{
		return $.createPoint((P0.x + ((P1.x-P0.x) * ratio)), (P0.y + ((P1.y-P0.y) * ratio)));
	}

	function getMiddle(P0, P1)
	{
		return $.createPoint(((P0.x+P1.x) * 0.5), ((P0.y+P1.y) * 0.5));
	}

	var commands = $.toIntVector([]);
	var data = $.toNumberVector([]);

	if (path.length > 1)
	{
		commands.push(1);
		data.push(path[0].x, path[0].y);

		var P0 = path[0], P1, P2, P3, dx, dy, PA, PB, Pc_1, Pc_2, Pc_3, Pc_4;
		var len = path.length;
		
		if (len == 2)
		{
			commands.push(2);
			data.push(path[1].x, path[1].y);
		}
		else
		{
			for (var i = 1; i < len; i+=3)
			{
				P1 = path[i];
				P2 = path[i+1];
				P3 = path[i+2];
				
				// calculates the useful base points
				PA = getPointOnSegment(P0, P1, 0.75);
				PB = getPointOnSegment(P3, P2, 0.75);

				// get 1/16 of the [P3, P0] segment
				dx = (P3.x - P0.x) * 0.0625;
				dy = (P3.y - P0.y) * 0.0625;

				// calculates control point 1
				Pc_1 = getPointOnSegment(P0, P1, 0.375);

				// calculates control point 2
				Pc_2 = getPointOnSegment(PA, PB, 0.375);
				Pc_2.x -= dx;
				Pc_2.y -= dy;

				// calculates control point 3
				Pc_3 = getPointOnSegment(PB, PA, 0.375);
				Pc_3.x += dx;
				Pc_3.y += dy;

				// calculates control point 4
				Pc_4 = getPointOnSegment(P3, P2, 0.375);

				// calculates the 3 anchor points
				Pa_1 = getMiddle(Pc_1, Pc_2);
				Pa_2 = getMiddle(PA, PB);
				Pa_3 = getMiddle(Pc_3, Pc_4);

				// draw the four quadratic subsegments
				commands.push(3, 3, 3, 3);
				data.push(Pc_1.x, Pc_1.y, Pa_1.x, Pa_1.y,
						Pc_2.x, Pc_2.y, Pa_2.x, Pa_2.y,
						Pc_3.x, Pc_3.y, Pa_3.x, Pa_3.y,
						Pc_4.x, Pc_4.y, P3.x, P3.y);

				P0 = P3;
			}
			graphics.drawPath(commands, data);
		}
	}
}

/***********************************************************************/
function drawPaintingPathDebugInfo(path, graphics, thickness)
{
	graphics.clear();
	var P0, P1, P2, P3;
	var s = 1 + thickness/2;
	var s2 = s * 2;

	if (path.length > 2)
	{
		var P0 = path[0], P1, P2, P3;
		var len = path.length;
		for (var i = 1; i < len; i+=3)
		{
			P1 = path[i];
			P2 = path[i+1];
			P3 = path[i+2];
			
			graphics.lineStyle(1, (i-1)%6==0 ? 0xFF00FF : 0x0000FF, 0.5);
			graphics.moveTo(P0.x, P0.y);
			graphics.lineTo(P1.x, P1.y);
			graphics.moveTo(P2.x, P2.y);
			graphics.lineTo(P3.x, P3.y);
			graphics.beginFill((i-1)%6==0 ? 0xFF00FF : 0x0000FF, 0.4);
			graphics.drawRect(P0.x-s, P0.y-s, s2, s2);
			graphics.drawRect(P1.x-s, P1.y-s, s2, s2);
			graphics.drawRect(P2.x-s, P2.y-s, s2, s2);
			graphics.drawRect(P3.x-s, P3.y-s, s2, s2);
			P0 = P3;
		}
	}
}


function createTransport() {

    //CRC-16-ANSI polynomial: x^16 + x^15 + x^2 + 1 (0xa001 LSBF/reversed)
    var CRC_TAB = [
    0x0000, 0xC0C1, 0xC181, 0x0140, 0xC301, 0x03C0, 0x0280, 0xC241,
    0xC601, 0x06C0, 0x0780, 0xC741, 0x0500, 0xC5C1, 0xC481, 0x0440,
    0xCC01, 0x0CC0, 0x0D80, 0xCD41, 0x0F00, 0xCFC1, 0xCE81, 0x0E40,
    0x0A00, 0xCAC1, 0xCB81, 0x0B40, 0xC901, 0x09C0, 0x0880, 0xC841,
    0xD801, 0x18C0, 0x1980, 0xD941, 0x1B00, 0xDBC1, 0xDA81, 0x1A40,
    0x1E00, 0xDEC1, 0xDF81, 0x1F40, 0xDD01, 0x1DC0, 0x1C80, 0xDC41,
    0x1400, 0xD4C1, 0xD581, 0x1540, 0xD701, 0x17C0, 0x1680, 0xD641,
    0xD201, 0x12C0, 0x1380, 0xD341, 0x1100, 0xD1C1, 0xD081, 0x1040,
    0xF001, 0x30C0, 0x3180, 0xF141, 0x3300, 0xF3C1, 0xF281, 0x3240,
    0x3600, 0xF6C1, 0xF781, 0x3740, 0xF501, 0x35C0, 0x3480, 0xF441,
    0x3C00, 0xFCC1, 0xFD81, 0x3D40, 0xFF01, 0x3FC0, 0x3E80, 0xFE41,
    0xFA01, 0x3AC0, 0x3B80, 0xFB41, 0x3900, 0xF9C1, 0xF881, 0x3840,
    0x2800, 0xE8C1, 0xE981, 0x2940, 0xEB01, 0x2BC0, 0x2A80, 0xEA41,
    0xEE01, 0x2EC0, 0x2F80, 0xEF41, 0x2D00, 0xEDC1, 0xEC81, 0x2C40,
    0xE401, 0x24C0, 0x2580, 0xE541, 0x2700, 0xE7C1, 0xE681, 0x2640,
    0x2200, 0xE2C1, 0xE381, 0x2340, 0xE101, 0x21C0, 0x2080, 0xE041,
    0xA001, 0x60C0, 0x6180, 0xA141, 0x6300, 0xA3C1, 0xA281, 0x6240,
    0x6600, 0xA6C1, 0xA781, 0x6740, 0xA501, 0x65C0, 0x6480, 0xA441,
    0x6C00, 0xACC1, 0xAD81, 0x6D40, 0xAF01, 0x6FC0, 0x6E80, 0xAE41,
    0xAA01, 0x6AC0, 0x6B80, 0xAB41, 0x6900, 0xA9C1, 0xA881, 0x6840,
    0x7800, 0xB8C1, 0xB981, 0x7940, 0xBB01, 0x7BC0, 0x7A80, 0xBA41,
    0xBE01, 0x7EC0, 0x7F80, 0xBF41, 0x7D00, 0xBDC1, 0xBC81, 0x7C40,
    0xB401, 0x74C0, 0x7580, 0xB541, 0x7700, 0xB7C1, 0xB681, 0x7640,
    0x7200, 0xB2C1, 0xB381, 0x7340, 0xB101, 0x71C0, 0x7080, 0xB041,
    0x5000, 0x90C1, 0x9181, 0x5140, 0x9301, 0x53C0, 0x5280, 0x9241,
    0x9601, 0x56C0, 0x5780, 0x9741, 0x5500, 0x95C1, 0x9481, 0x5440,
    0x9C01, 0x5CC0, 0x5D80, 0x9D41, 0x5F00, 0x9FC1, 0x9E81, 0x5E40,
    0x5A00, 0x9AC1, 0x9B81, 0x5B40, 0x9901, 0x59C0, 0x5880, 0x9841,
    0x8801, 0x48C0, 0x4980, 0x8941, 0x4B00, 0x8BC1, 0x8A81, 0x4A40,
    0x4E00, 0x8EC1, 0x8F81, 0x4F40, 0x8D01, 0x4DC0, 0x4C80, 0x8C41,
    0x4400, 0x84C1, 0x8581, 0x4540, 0x8701, 0x47C0, 0x4680, 0x8641,
    0x8201, 0x42C0, 0x4380, 0x8341, 0x4100, 0x81C1, 0x8081, 0x4040];

    function crc16(byteArray) {
        var crc = 0xFFFF;
        var len = byteArray.length;
        var i = 0;
        while (i < len) {
            //assert('crc16: byteArray[i]', byteArray[i] === byteArray[i | 0]);
            crc = CRC_TAB[crc & 0xFF ^ byteArray[i++]] ^ crc >> 8;
        }
        return crc;
    }

    /* Safe character range in XML is \t \n \r #x20-#xD7FF #xE000-#xFFFD
       #x20 \t may be trimmed; \r \n are banned. 
       There is a server-side silent truncation at 300 bytes.
       Unicode range [0x4000, 0x9fff] and [0xb000-0xcfff] have been manually verified to be safe.
       There may still be random "code:-3", inevitably.
       */
    function alpha2code(alpha) { //alpha must be in [0, 0x8000)
        //assert('alpha2code: alpha is legal', alpha >= 0 && alpha < 0x8000);
        return (alpha < 0x6000 ? 0x4000 : 0x5000) + alpha;
    }

    function code2alpha(code) { //code must be in [0x4000, 0x9fff] [0xb000-0xcfff]
        //assert('code2alpha: code is legal', code >= 0x4000 && code <= 0x9fff || code >= 0xb000 && code <= 0xcfff);
        return code - (code < 0xb000 ? 0x4000 : 0x5000);
    }

    function explode(packet) {
        return (packet.split('')).map(function (s) {
            return code2alpha(s.charCodeAt());
        });
    }

    function implode(numerals) {
        return String.fromCharCode.apply(null, numerals.map(alpha2code));
    }

    function mutate_raw(numerals, use_xor_key) {
        var new_xor_key = use_xor_key;
        if (use_xor_key === undefined) new_xor_key = Utils.rand(0, 0x8000);
        var xor_key = numerals[0] ^ new_xor_key;
        numerals[0] = new_xor_key;
        var len = numerals.length;
        for (var i = 1; i < len; ++i) {
            //assert('mutate_raw: numerals[i]', numerals[i] === numerals[i | 0]);
            numerals[i] ^= xor_key;
            //assert('mutate_raw: numerals[i] is legal', numerals[i] >= 0 && numerals[i] < 0x8000);
        }
        return numerals;
    }

    //take unpadded ByteArray, produce padded numeral Array
    function unpack15(byteArray) {
        var len = byteArray.length;
        var buf = 0, buffered = 0;
        var numerals = [];
        for (var i = 0; i < len; i++) {
            //assert('unpack15: byteArray[i]', byteArray[i] === byteArray[i | 0]);
            var byte = byteArray[i];
            if (buffered >= 7) {
                numerals.push(buf | byte >> buffered - 7); //15 - $buffered bits written; $buffered - 7 bits next
                buffered -= 7;
                buf = 0;
            } else {
                buffered += 8;
            }
            buf |= byte << 15 - buffered & 0x7fff;
        }
        if (buffered > 0) numerals.push(buf);
        return numerals;
    }

    //take numeral Array with padding bits, produce unpadded ByteArray
    //@padding must be < 16
    function pack15(numerals, padding) {
        //assert('pack15: padding < 16', padding < 16);
        //assert('libBitmap is loaded', Bitmap !== undefined);
        var bmd = Bitmap.createBitmapData(1, 1);
        var byteArray = bmd.getPixels(bmd.rect);
        byteArray.length = 0;
        var len = numerals.length;
        var buf = 0, buffered = 0;
        for (var i = 0; i < len; i++) {
            //assert('pack15: numerals[i]', numerals[i] === numerals[i | 0]);
            var numeral = numerals[i];
            byteArray.writeByte(buf | numeral >> buffered + 7);
            buffered += 7;
            if (buffered >= 8) {
                if (i === len - 1 && buffered <= padding)
                    break;
                byteArray.writeByte(numeral >> buffered - 8 & 0xff); //8 bits written; $buffered - 8 bits ntext
                buffered -= 8;
            }
            buf = numeral << 8 - buffered & 0xff;
            //assert('pack15: buffered < 8', buffered < 8);
        }
        return byteArray;
    }
    return {
        //@packet String
        //@use_xor_key uint (optional); a static key to mutate packet; 0 for unmutation; default: random
        //@return mutated packet
        mutate: function (packet, use_xor_key) {
            return patternSymbol + implode(mutate_raw(explode(packet.slice(1)), use_xor_key));
        },
        //@payload ByteArray (readonly); maximum length: 404
        //@use_xor_key uint; a static key to mutate packet, must be in [0, 0x8000)
        //@return the packet; String or null on error;
        //No compression inside; Ignores payload.position
        encapsulate: function (payload, use_xor_key) {
            var byteArray = clone(payload);
            byteArray.position = byteArray.length;
            byteArray.endian = 'littleEndian';
            byteArray.writeShort(crc16(byteArray));
            var numerals = unpack15(byteArray);
            var paddings = (numerals.length * 15 - byteArray.length * 8) & 0xf;
            var header = paddings;
            numerals.unshift(0, header);
            if (numerals.length > 219) {
                //trace('encapsulate: payload too long', payload.length);
                return null;
            }
            return patternSymbol + implode(mutate_raw(numerals, use_xor_key));
        },
        //@packet String
        //@return the payload; ByteArray or null on error
        //No decompression inside; Requires Bitmap
        decapsulate: function (packet) {
            if (packet.length < 4) {
                //'$' XOR_KEY RESERVED 
                //trace('decapsulate: no content');
                return null;
            }
            var numerals = mutate_raw(explode(packet.slice(1)), 0);
            numerals.shift();
            var header = numerals.shift();
            var paddings = header & 0xf;
            var byteArray = pack15(numerals, paddings);
            if (crc16(byteArray) !== 0) {
                //trace('decapsulate: bad checksum', crc16(byteArray));
                return null;
            }
            byteArray.length -= 2;
            return byteArray;
        }
    };
}

/***********************************************************************/
function initializeDispatcher()
{
	dispatcher = {};
	dispatcher.lastWidth = 0;
	dispatcher.lastHeight = 0;
	dispatcher.lastPlayTime = 0;
	dispatcher.lastPlayerState = '';
	dispatcher.patternQueue = [];
	dispatcher.scrollPatternYPosList = [];
	dispatcher.topPatternYPosList = [];
	dispatcher.bottomPatternYPosList = [];
	dispatcher.patternRoot = createCanvas({alpha:0.7});
	dispatcher.patternFilters = [$.createDropShadowFilter(1, 90, 0x231F20, 0.8, 9, 9, 1)];

	dispatcher.shape = createShape();
	$.root.removeChild(dispatcher.shape);
	
	dispatcher.matrix = $.createMatrix();
	dispatcher.matrix.scale(0.390625, 0.390625);

	dispatcher.enterFrame = function()
	{
		var toolRootIndex = $.root.getChildIndex(ptTool.rootCanvas);
		if (toolRootIndex != $.root.numChildren - 1)
			$.root.swapChildrenAt(toolRootIndex, $.root.numChildren - 1);
			
		if (dispatcher.lastWidth != $.width || dispatcher.lastHeight != $.height)
		{
			var len = dispatcher.patternQueue.length;
			var newWidth = $.width;
			var newHeight = $.height;
			for (var i = 0; i < len; ++i)
			{
				var pattern = dispatcher.patternQueue[i];
				if (pattern.mode == 4 || pattern.mode == 5)
				{
					pattern.x = newWidth/2 - 50;
					pattern.canvas.x = pattern.x;
					
					if (pattern.mode == 4)
						pattern.canvas.y = newHeight - (pattern.y % (newHeight-100)) - 100;
				}
				else
				{
					pattern.x = (pattern.x / dispatcher.lastWidth) * newWidth;
					pattern.canvas.x = pattern.x;
				}
			}
			
			dispatcher.lastWidth = newWidth;
			dispatcher.lastHeight = newHeight;

			ptTool.onScreenResized();
		}


		if (Math.abs(Player.time - dispatcher.lastPlayTime) > 1000)
		{
			while (dispatcher.patternRoot.numChildren)
				dispatcher.patternRoot.removeChildAt(0);

			dispatcher.patternQueue.length = 0;
			dispatcher.scrollPatternYPosList.length = 0;
			dispatcher.topPatternYPosList.length = 0;
			dispatcher.bottomPatternYPosList.length = 0;
		}
		dispatcher.lastPlayTime = Player.time;

		
		currentTime = getTimer();
		if (lastTime == 0)
			lastTime = currentTime;
		deltaTime = (currentTime - lastTime) * 0.001;

		if (Player.state == 'playing')
		{
			var len = dispatcher.patternQueue.length;
			for (var i = 0; i < len; ++i)
			{
				var pattern = dispatcher.patternQueue[i];
				if (pattern.mode == 4 || pattern.mode == 5)
				{
					pattern.life += deltaTime;
					if (pattern.life >= 3)
					{
						dispatcher.patternRoot.removeChild(pattern.canvas);
						dispatcher.patternQueue.splice(i, 1);
						i--;
						len--;
					}
				}
				else
				{
					pattern.x -= pattern.speed * deltaTime;
					pattern.canvas.x = pattern.x;

					if (pattern.x < -100)
					{
						dispatcher.patternRoot.removeChild(pattern.canvas);
						dispatcher.patternQueue.splice(i, 1);
						i--;
						len--;
					}
				}
			}
		}
		else if (dispatcher.lastPlayerState != Player.state && Player.state == 'stop')
		{
			while (dispatcher.patternRoot.numChildren)
				dispatcher.patternRoot.removeChildAt(0);

			dispatcher.patternQueue.length = 0;
			dispatcher.scrollPatternYPosList.length = 0;
			dispatcher.topPatternYPosList.length = 0;
			dispatcher.bottomPatternYPosList.length = 0;
	
			ptTool.disappear();
		}
		dispatcher.lastPlayerState = Player.state;

		lastTime = currentTime;
	};

	dispatcher.getBestNextScrollPatternYPos = function()
	{
		var screenWidth = $.width;
		var xPosInCurLine = 0, lastLineYPos = 0, patLenInCurLine = 0;
		var i, j, yPos;

		var queueLen = dispatcher.patternQueue.length;
		var yPosListLen = dispatcher.scrollPatternYPosList.length;

		for (i = 0; i < yPosListLen; ++i)
		{
			yPos = dispatcher.scrollPatternYPosList[i ^ 0];
			xPosInCurLine = -9999;
			patLenInCurLine = 0;

			for (j = 0; j < queueLen; ++j)
			{
				var pattern = dispatcher.patternQueue[j ^ 0];
				if (pattern.mode != 1 || pattern.y != yPos)
					continue;

				patLenInCurLine++;
				if (pattern.x > xPosInCurLine)
					xPosInCurLine = pattern.x;
			}

			if (patLenInCurLine)
			{
				if (screenWidth - xPosInCurLine > 130)
				{
					return yPos;
				}
			}
			else
			{
				return yPos;
			}
		}

		if (yPosListLen == 0)
		{
			dispatcher.scrollPatternYPosList.push(10);
			return 10;
		}

		lastLineYPos = dispatcher.scrollPatternYPosList[yPosListLen - 1] ^ 0;
		lastLineYPos += 110;

		dispatcher.scrollPatternYPosList.push(lastLineYPos);
		if (dispatcher.scrollPatternYPosList.length > 1)
			dispatcher.scrollPatternYPosList.sort(16);
		return lastLineYPos;
	};
	
	dispatcher.getBestNextTopPatternYPos = function()
	{
		var screenWidth = $.width;
		var i, j, yPos;

		var queueLen = dispatcher.patternQueue.length;
		var yPosListLen = dispatcher.topPatternYPosList.length;
		var hasPatInCurLine = false;

		for (i = 0; i < yPosListLen; ++i)
		{
			yPos = dispatcher.topPatternYPosList[i ^ 0];
			hasPatInCurLine = false;

			for (j = 0; j < queueLen; ++j)
			{
				var pattern = dispatcher.patternQueue[j ^ 0];
				if (pattern.mode != 5)
					continue;
				if (pattern.y == yPos)
				{
					hasPatInCurLine = true;
					break;
				}
			}
			
			if (!hasPatInCurLine)
				return yPos;
		}

		if (yPosListLen == 0)
		{
			dispatcher.topPatternYPosList.push(10);
			return 10;
		}

		var lastLineYPos = dispatcher.topPatternYPosList[yPosListLen - 1] ^ 0;
		lastLineYPos += 110;

		dispatcher.topPatternYPosList.push(lastLineYPos);
		if (dispatcher.topPatternYPosList.length > 1)
			dispatcher.topPatternYPosList.sort(16);
		return lastLineYPos;
	};

	dispatcher.getBestNextBottomPatternInvYPos = function()
	{
		var screenWidth = $.width;
		var i, j, yPos;

		var queueLen = dispatcher.patternQueue.length;
		var yPosListLen = dispatcher.bottomPatternYPosList.length;
		var hasPatInCurLine = false;

		for (i = 0; i < yPosListLen; ++i)
		{
			yPos = dispatcher.bottomPatternYPosList[i ^ 0];
			hasPatInCurLine = false;

			for (j = 0; j < queueLen; ++j)
			{
				var pattern = dispatcher.patternQueue[j ^ 0];
				if (pattern.mode != 4)
					continue;
				if (pattern.y == yPos)
				{
					hasPatInCurLine = true;
					break;
				}
			}
			
			if (!hasPatInCurLine)
			{
				return yPos;
			}
		}

		if (yPosListLen == 0)
		{
			dispatcher.bottomPatternYPosList.push(30);
			return 30;
		}

		var lastLineYPos = dispatcher.bottomPatternYPosList[yPosListLen - 1] ^ 0;
		lastLineYPos += 110;

		dispatcher.bottomPatternYPosList.push(lastLineYPos);
		if (dispatcher.bottomPatternYPosList.length > 1)
			dispatcher.bottomPatternYPosList.sort(16);
		return lastLineYPos;
	};
	
	dispatcher.added = function(e)
	{
		var comment = e.target;
		if (!comment.hasOwnProperty('data')
			|| !comment.data.hasOwnProperty('text'))
		{
			return;
		}

		var commentAlpha = (Player.time >= 0 && Player.time <= 7000) ? 0.1 : 1.0;
		if (comment.data.text.charAt(0) != patternSymbol)
		{
			comment.alpha = commentAlpha;
			if (cfgHideComment)
				comment.visible = false;
			return;
		}

		comment.visible = false;
		if (cfgHidePattern)
			return;

		var data = transport.decapsulate(comment.data.text);
		if (!data)
			return;

		dispatcher.shape.graphics.clear();
		ptTool.renderPattern(data, dispatcher.shape.graphics);

		var bitmapData = Bitmap.createBitmapData(100, 100, true, 0xFFFFFFFF);
		bitmapData.draw(dispatcher.shape, dispatcher.matrix);

		var pattern = {};
		pattern.mode = comment.data.mode;
		pattern.date = comment.data.date;

		if (pattern.mode == 5)
		{
			pattern.x = $.width/2 - 50;
			pattern.y = dispatcher.getBestNextTopPatternYPos();
			pattern.canvas = createCanvas({x:pattern.x, y:pattern.y % ($.height-100), parent:dispatcher.patternRoot, filters:dispatcher.patternFilters});
			pattern.life = 0;
		}
		else if (pattern.mode == 4)
		{
			pattern.x = $.width/2 - 50;
			pattern.y = dispatcher.getBestNextBottomPatternInvYPos();
			pattern.canvas = createCanvas({x:pattern.x, y:$.height - (pattern.y % ($.height-100)) - 100, parent:dispatcher.patternRoot, filters:dispatcher.patternFilters});
			pattern.life = 0;
		}
		else
		{
			pattern.x = $.width;
			pattern.y = dispatcher.getBestNextScrollPatternYPos();
			pattern.canvas = createCanvas({x:pattern.x, y:pattern.y % ($.height-100), parent:dispatcher.patternRoot, filters:dispatcher.patternFilters});
			pattern.speedGain = data.length / maxDataLength;
			pattern.speed = 543 / (3 + (pattern.speedGain*1.5));
		}
		
		pattern.bitmap = createBitmap({parent:pattern.canvas, bitmapData:bitmapData, alpha:commentAlpha});

		if (cfgShowCommentDate)
			pattern.text = createText(pattern.date, {parent:pattern.canvas, size:10, color:0xFFFFFF, y:100, alpha:0.8});
		else
			pattern.text = null;
		
		dispatcher.patternQueue.push(pattern);
	};
	
	dispatcher.updateCommentDateVisible = function()
	{
		var len = dispatcher.patternQueue.length;
		for (var i = 0; i < len; ++i)
		{
			var pattern = dispatcher.patternQueue[i];
			if (cfgShowCommentDate)
			{
				if (pattern.text)
					pattern.text.visible = true;
				else
					pattern.text = createText(pattern.date, {parent:pattern.canvas, size:10, color:0xFFFFFF, y:100, alpha:0.8});
			}
			else if (pattern.text)
				pattern.text.visible = false;
		}
	};

	dispatcher.register = function()
	{
		var len = $.root.numChildren;
		for (var i = 0; i < len; ++i)
		{
			var child = $.root.getChildAt(i);
			if (!child.hasOwnProperty('data')
				|| !child.data.hasOwnProperty('text'))
			{
				continue;
			}
			
			dispatcher.added({target:child});
		}
		
		$.root.addEventListener('enterFrame', dispatcher.enterFrame);
		$.root.addEventListener('added', dispatcher.added);
	};

	dispatcher.unregister = function()
	{
		$.root.removeEventListener('enterFrame', dispatcher.enterFrame);
		$.root.removeEventListener('added', dispatcher.added);
	};

	dispatcher.register();
}

function loadBitmapLibraryThen(onCompleted)
{
	var loadingBackground = createCanvas();
		loadingBackground.graphics.beginFill(0xc0c2be);
		loadingBackground.graphics.drawRect(0, 0, $.width, $.height);
		loadingBackground.graphics.endFill();
	var loadingIcon = createCanvas({parent:loadingBackground});
		loadingIcon.graphics.beginFill(0x000000);
		loadingIcon.graphics.drawPath($.toIntVector([1,2,2,2,2,3,3,3,3,2,2,2,2,2,3,3,3,3,3,3,2,2,2,1,2,2,2,2,2,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,2,3,2,1,3,3,2,2,2,2,2,2,2,2,2,3,2,2,2,2,2,2,2,2,2,2,3,3,2,2,2,2,2,2,2,2,2,3,3,3,2,3,2,3,3,2,2,3,3,3,2,2,2,2,2,2,2,1,2,2,2,2,2,2,2,2,3,2,2,2,2,2,3,3,2,3,2,1,2,2,2,2,1,2,2,2,2,2,2,2,2,3,3,3,2,2,2,3,2,2,2,3,2,2,2,1,3,3,3,2,2,2,2,3,3,3,3,3,2,2,2,2,2,3,3,1,2,2,3,3,2,2,2,2,2,2,2,2,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,2,1,3,3,2,2,2,2,2,2,2,2,2,3,3,3,3,2,2,2,2,2,2,2,3,3,1,2,2,2,2,2,2,2,1,2,3,2,2,2,3,2,2,3,2,2,2,2,3,2,2,2,2,2,2,2,2,3,3,2,2,2,2,2,3,3,3,3,2,2,2,2,2,2,2,2,2,3,1,2,2,2,2,2,2,2,2,3,2,2,2,2,3,3,2,3,3,2,1,2,2,2,2,2,2,3,2,2,2,3,3,1,2,2,2,2,2,2,2,3,2,2,2,2,2,3,3,2,1,2,2,3,2,2,2,2,2,3,2,2,2,2,2,2,2,2,2,2,2,2,2,3,2,2,2,2,2,2,3,3,2,2,2,2,2,2,2,2,1,2,2,2,2,2,1,2,2,2,2,2,1,3,3,2,2,2,2,2,2,2,2,2,2,2,3,2,1,3,2,2,2,2,2,2,3,3,2,2,2,2,2,2,2,2,2,2,2,3,2,2,2,2,1,2,2,2,2,2,2,1,3,3,2,2,2,2,3,3,3,3,2,2,1,3,3,3,2,2,3,3,3,2,2,2,2,2,2,2,2,2,2,2,3,3,2,2,3,3,3,3,3,3,3,2,3,3,3,2,2,2,1,2,2,2,2,3,3,3,2,2,2,2,2,2,2,2,2,2,2,3,2,2,2,2,2,2,2,2,2,2,2,1,2,3,3,3,2,2,2,2,2,2,2,2,2,3,2,2,2,2,2,2,2,2,2,2,3,3,2,3,2,3,2,2,2,2,2,2,3,2,2,2,2,3,3,2,2,3,3,3,2,2,2,2,2,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,2,3,2,1,2,2,2,2,2,2,2,2,2,3,2,2,2,2,2,2,2,2,3,3,2,2,2,2,2,1,3,3,3,3,3,3,3,2,3,3,3,2,2,2,2,3,3,2,2,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,3,3,2,2,1,2,2,2,2,3,2,2,2,2,2,3,2,2,2,3,2,2,2,2,2,2,3,3,3,3,3,2,2,2,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,2,2,2,2,3,3,3,1,2,2,2,2,2,2,1,2,2,2,2,2,1,2,2,2,2]),$.toNumberVector([243.85,32.15,243.8,32.2,238.4,32.2,238.35,32.15,238.35,29.55,237.3,31.2,235.65,32,234.05,32.7,232,32.7,229.65,32.7,227.85,31.85,226.1,30.9,224.95,29.35,223.95,27.7,223.2,25.8,222.75,23.7,222.65,21.6,222.75,19.55,222.9,18.5,223.2,17.55,223.8,15.55,224.95,14.1,226.1,12.6,227.85,11.7,229.55,10.8,231.85,10.8,233.7,10.75,235.4,11.6,237.05,12.35,238.05,13.9,238.05,3.45,243.85,3.45,243.85,32.15,243.85,58.45,243.8,58.5,242.05,58.5,242.05,56.7,243.85,56.7,243.85,58.45,231.05,15.7,232.1,15.3,233.4,15.15,234.65,15.3,235.7,15.7,237.2,17.2,237.7,18.15,238,19.25,238.2,20.45,238.25,21.7,238.2,22.95,238,24.2,237.7,25.35,237.2,26.35,235.7,27.85,234.65,28.25,233.4,28.4,232.15,28.25,231.1,27.85,229.55,26.3,229.05,25.3,228.7,24.15,228.5,22.95,228.4,21.75,228.45,20.5,228.65,19.3,228.75,18.7,229,18.2,229.5,17.2,229.75,16.7,230.15,16.35,231.05,15.7,217.8,11.85,219.1,12.5,220,13.7,220.8,14.8,220.85,16.7,220.85,27.55,220.85,28.9,221,30.2,221.2,31.35,221.55,32.15,221.5,32.2,215.75,32.2,215.4,31.2,215.3,30.25,213.9,31.6,212.1,32.15,210.25,32.55,208.35,32.7,206.9,32.6,205.55,32.35,204.35,31.9,203.3,31.2,202.4,30.35,201.75,29.3,201.35,28,201.25,26.5,201.2,25.6,201.4,24.85,201.55,24.15,201.85,23.6,202.55,22.55,203.45,21.7,204.5,21.1,205.7,20.7,207,20.4,208.3,20.15,210.8,19.8,212,19.65,213.05,19.45,213.95,19.2,214.55,18.8,215.1,18.3,215.05,17.45,215.05,16.5,214.75,16,213.95,15.2,213.45,14.85,212.8,14.8,211.4,14.65,209.7,14.65,208.75,15.4,207.8,16.1,207.65,17.75,201.9,17.8,201.85,17.75,202,15.75,202.9,14.4,203.75,13.05,205.15,12.25,205.8,11.85,206.6,11.6,208.2,11.15,209.95,10.85,211.65,10.8,213.25,10.85,214.85,11,216.4,11.35,217.8,11.85,210.35,23.25,211.7,23.05,213,22.8,214.2,22.55,215.05,22.05,215.05,24.1,214.95,25.4,214.75,26.2,214.4,27,213.95,27.75,213.05,28.3,211.95,28.7,210.45,28.85,209.15,28.75,208.05,28.35,207.3,27.5,207,27,207,26.25,207,25.45,207.3,24.95,208,24.1,208.45,23.75,209.05,23.55,210.35,23.25,217.85,47.25,217.5,48.9,216.1,48.9,216.45,47.25,217.85,47.25,215.1,47.25,212.75,58.45,211.45,58.45,211.4,58.4,211.65,57.4,210.5,58.35,209.05,58.65,207.65,58.4,206.65,57.7,206.2,57.25,206.05,56.65,205.8,56,205.85,55.3,205.85,54.35,206.15,53.45,206.5,52.6,207,51.8,208.45,50.6,208.85,50.35,209.35,50.25,210.35,50.1,211.1,50.2,211.85,50.45,212.2,50.6,212.5,50.9,212.9,51.45,213.7,47.25,215.1,47.25,190.9,10.8,193.35,10.8,195.15,11.7,196.9,12.6,198.1,14.15,199.25,15.7,199.85,17.75,200.25,19.8,200.4,22,200.25,24.05,199.85,26,199.25,27.95,198.1,29.45,196.95,30.9,195.25,31.8,193.5,32.7,191.25,32.7,189.3,32.7,187.65,31.95,186,31.1,185,29.6,184.95,39.45,179.2,39.45,179.2,11.35,184.65,11.35,184.65,14,185.75,12.3,187.35,11.55,188.95,10.75,190.9,10.8,188.4,15.3,189.65,15.15,190.9,15.3,191.45,15.45,191.95,15.75,192.9,16.3,193.5,17.25,194,18.25,194.35,19.4,194.55,20.6,194.6,21.8,194.55,23.05,194.35,24.25,194.05,25.4,193.55,26.4,192.95,27.25,192,27.8,191,28.25,189.7,28.4,188.45,28.25,187.4,27.8,186.5,27.2,185.85,26.4,185.35,25.4,185,24.25,184.8,23.05,184.75,21.8,184.8,20.55,185,19.35,185.3,18.2,185.8,17.2,186.4,16.3,187.3,15.75,188.4,15.3,168.9,10.8,171.2,10.8,172.65,11.45,174.15,12.05,175,13.15,175.7,14.4,176.2,15.85,176.45,17.55,176.55,19.4,176.55,32.15,176.5,32.2,170.8,32.2,170.75,32.15,170.75,20.4,170.75,17.85,169.95,16.6,169.15,15.35,167.15,15.35,164.8,15.35,163.8,16.75,162.75,18.1,162.75,21.25,162.75,32.15,162.7,32.2,157,32.2,157,3.45,162.75,3.45,162.75,14.25,162.8,14.25,163.9,12.45,165.6,11.65,167.3,10.8,168.9,10.8,185.8,47.25,183.7,57.15,189.6,57.15,189.35,58.45,181.9,58.45,181.9,58.4,184.2,47.25,185.8,47.25,201.1,51.7,200.6,52.15,200.4,52.4,200.35,52.8,198.95,52.8,199.35,51.6,200.15,50.75,200.65,50.45,201.25,50.3,202.5,50.15,203.6,50.2,204.15,50.3,204.55,50.55,205.2,51.2,205.45,52.25,205.4,53,204.55,56.45,204.45,56.75,204.5,57.05,204.6,57.4,204.85,57.5,205.05,57.5,205.25,57.4,205.3,57.45,205.1,58.45,204.65,58.6,204.25,58.65,203.7,58.65,203.4,58.35,203.1,58.05,203.15,57.55,202.15,58.35,200.45,58.65,199.5,58.5,198.7,58.15,198.15,57.4,197.95,56.95,198,56.35,197.95,55.4,198.35,54.9,198.75,54.4,199.35,54.15,199.95,53.9,200.7,53.8,203,53.55,203.6,53.35,203.95,53,204.05,52.4,203.9,51.9,203.55,51.6,203,51.4,202.5,51.35,201.75,51.45,201.35,51.5,201.1,51.7,197.95,54.5,197.75,55.45,196.85,57.1,195.45,58.2,194.55,58.55,193.5,58.65,192.05,58.4,191,57.7,190.3,56.6,190.05,55.95,190.1,55.25,190.15,54.25,190.4,53.3,190.75,52.45,191.25,51.7,191.85,50.95,192.7,50.55,193.1,50.35,193.6,50.25,194.65,50.15,196.3,50.1,197.15,51,198,51.85,198.05,53.5,197.95,54.5,200.25,55.1,201.1,54.9,202.1,54.75,203,54.65,203.65,54.4,203.45,55.4,203,56.35,202.35,57.4,200.8,57.4,199.8,57.15,199.45,56.8,199.35,56.3,199.35,55.8,199.6,55.55,199.85,55.25,200.25,55.1,195.45,51.55,196.1,52.05,196.5,52.75,196.65,53.6,196.4,54.85,195.85,56.1,194.9,57.05,193.65,57.4,192.6,57.4,192.05,56.8,191.6,56.1,191.5,55.25,191.5,54.6,191.65,53.9,192.25,52.7,192.65,52.1,193.2,51.75,193.75,51.35,194.55,51.35,195.45,51.55,233.75,50.35,232,58.45,231.65,59.45,231.15,60.7,230.2,61.2,229.2,61.6,227.95,61.75,226.75,61.6,225.75,61.15,225.05,60.35,224.75,59.85,224.75,59.2,224.75,59.15,226.1,59.15,226.3,59.85,226.75,60.25,227.4,60.45,228.1,60.5,229.35,60.2,230.15,59.5,230.6,58.45,230.9,57.4,229.9,58.25,228.45,58.5,227.1,58.3,226.55,58,226.15,57.6,225.55,56.5,225.4,55.15,225.45,54.25,225.65,53.35,226,52.5,226.5,51.75,227.05,51,227.85,50.6,228.2,50.35,228.7,50.25,229.6,50.15,230.5,50.25,231.25,50.6,231.85,51.1,232.2,51.7,232.45,50.35,233.7,50.3,233.75,50.35,236.5,56.7,236.5,58.45,236.45,58.5,234.7,58.5,234.7,56.7,236.5,56.7,240.15,58.5,238.4,58.5,238.4,56.7,240.2,56.7,240.2,58.45,240.15,58.5,228.4,51.75,228.9,51.35,229.6,51.35,230.65,51.35,231.15,51.95,231.5,52.6,231.65,53.45,231.45,54.75,230.9,55.95,230,56.9,228.75,57.3,227.85,57.1,227.25,56.65,226.9,55.95,226.8,55.15,226.95,53.95,227.15,53.25,227.5,52.7,228.4,51.75,224.35,50.65,224.9,51.15,224.95,52.25,224.85,52.95,224.7,53.85,223.7,58.45,222.35,58.45,222.3,58.4,223.55,52.45,223.5,51.9,223.15,51.65,222.75,51.35,222.15,51.35,221.1,51.65,220.2,52.3,219.65,53.05,219.3,53.95,218.35,58.45,217,58.45,217,58.4,218.65,50.35,220,50.3,220,50.35,219.85,51.45,220.3,50.8,221,50.5,221.8,50.2,222.65,50.15,223.65,50.25,224.35,50.65,217.15,50.3,217.2,50.35,215.5,58.45,214.15,58.45,214.15,58.4,215.8,50.35,217.15,50.3,210.4,51.35,211.35,51.35,211.85,51.95,212.35,52.5,212.4,53.4,212.2,54.75,211.55,56.05,210.6,57,209.25,57.4,208.2,57.4,207.7,56.85,207.25,56.25,207.25,55.3,207.2,54.6,207.45,53.95,207.6,53.25,208.05,52.65,209,51.75,210.4,51.35,150.75,11.9,151.5,12.25,152.2,12.75,153.55,13.7,154.4,15.2,155.25,16.65,155.4,18.7,155.35,18.75,149.75,18.75,149.15,15.15,145.55,15.15,144.15,15.15,143.25,15.8,142.35,16.4,141.75,17.4,141.25,18.4,140.95,19.55,140.75,20.7,140.7,21.85,140.75,23,140.95,24.15,141.25,25.25,141.7,26.25,143.2,27.8,144.2,28.25,145.4,28.4,147.45,28.35,148.5,27.25,149.6,26.1,149.9,24.2,155.45,24.15,155.5,24.2,154.9,28.35,152.25,30.55,149.6,32.7,145.45,32.7,143.1,32.7,141.15,31.95,139.2,31.15,137.85,29.75,136.45,28.3,135.7,26.4,134.9,24.4,134.95,22.05,134.9,20.85,135.1,19.75,135.6,17.6,136.35,15.5,137.7,14,139.05,12.45,141.05,11.6,143,10.75,145.55,10.8,147.4,10.9,149.1,11.25,150.75,11.9,134.55,11.4,134.55,15.2,134.5,15.25,130.35,15.25,130.35,25.5,130.35,26.2,130.5,26.7,130.6,27.15,130.85,27.4,131.05,27.65,131.55,27.75,132.75,27.9,133.65,27.85,134.5,27.7,134.55,27.75,134.55,32.15,133.75,32.3,131.15,32.4,129.85,32.35,128.65,32.2,127.5,31.95,126.55,31.5,125.65,30.95,125.1,30,124.7,28.9,124.6,27.45,124.6,15.25,121.15,15.25,121.15,11.35,124.6,11.35,124.6,5.15,130.35,5.15,130.35,11.35,134.5,11.35,134.55,11.4,114.4,11,115.95,11.35,116.65,11.55,117.35,11.85,118.65,12.5,119.55,13.7,120.35,14.8,120.4,16.7,120.4,27.55,120.4,28.9,120.55,30.2,120.75,31.35,121.1,32.15,121.05,32.2,115.3,32.2,114.95,31.2,114.85,30.25,113.5,31.6,111.65,32.15,109.8,32.55,107.9,32.7,106.45,32.6,105.1,32.35,103.9,31.9,102.85,31.2,101.95,30.35,101.3,29.3,100.9,28,100.8,26.5,100.75,25.6,100.95,24.85,101.1,24.15,101.4,23.6,102.1,22.55,102.5,22.05,103,21.7,104.05,21.1,104.6,20.85,105.25,20.7,106.55,20.4,107.85,20.15,110.4,19.8,111.55,19.65,112.6,19.45,114.1,18.8,114.65,18.3,114.6,17.45,114.3,16,113.5,15.2,112.35,14.8,110.95,14.65,109.25,14.65,108.3,15.4,107.35,16.1,107.2,17.75,101.45,17.8,101.4,17.75,101.55,15.75,102.45,14.4,103.3,13.05,104.7,12.25,105.35,11.85,106.15,11.6,107.75,11.15,109.5,10.85,111.2,10.8,112.8,10.85,114.4,11,109.9,23.25,111.25,23.05,112.55,22.8,113.75,22.55,114.6,22.05,114.6,24.1,114.5,25.4,114.3,26.2,113.95,27,112.6,28.3,111.5,28.7,110,28.85,108.7,28.75,107.6,28.35,106.85,27.5,106.55,27,106.55,26.25,106.55,25.45,106.85,24.95,107.55,24.1,108,23.75,108.6,23.55,109.9,23.25,101.1,11,101.15,16.3,101.1,16.35,100.15,16.25,99.05,16.15,97.6,16.3,96.4,16.65,95.45,17.3,94.65,18.1,94.1,19.05,93.85,19.55,93.75,20.2,93.55,21.45,93.45,22.8,93.45,32.15,93.4,32.2,87.7,32.2,87.7,11.35,93.15,11.35,93.15,15.2,93.6,14.2,94.3,13.45,94.95,12.6,95.85,12.05,96.75,11.5,97.75,11.1,98.8,10.85,99.85,10.8,101.1,11,86.2,24.2,85.6,28.35,82.95,30.55,80.3,32.7,76.15,32.7,73.8,32.7,71.85,31.95,69.9,31.15,68.55,29.75,67.15,28.3,66.4,26.4,65.6,24.4,65.65,22.05,65.6,20.85,65.8,19.75,66.3,17.6,67.05,15.5,68.4,14,69.75,12.45,71.75,11.6,73.7,10.75,76.25,10.8,78.1,10.9,79.8,11.25,81.45,11.9,82.9,12.75,84.25,13.7,85.1,15.2,85.95,16.65,86.1,18.7,86.05,18.75,80.45,18.75,79.85,15.15,76.25,15.15,74.85,15.15,73.95,15.8,73.05,16.4,72.45,17.4,71.95,18.4,71.65,19.55,71.45,20.7,71.4,21.85,71.45,23,71.65,24.15,71.95,25.25,72.4,26.25,73.05,27.1,73.9,27.8,74.9,28.25,76.1,28.4,78.15,28.35,79.2,27.25,80.3,26.1,80.6,24.2,86.15,24.15,86.2,24.2,63.95,12,63.9,12.05,57.8,12.05,57.6,10.85,57.2,9.9,56.75,9.05,56,8.6,55.2,8.15,54.25,7.9,53.25,7.75,52.15,7.7,50.6,7.85,49.85,8,49.2,8.4,48.2,9.4,47.9,10.1,47.8,10.9,47.8,11.75,48.15,12.25,49.35,13.2,50.5,13.65,52,14.1,58.55,15.85,60,16.35,61.45,17.15,62.85,18.1,63.85,19.65,64.9,21.2,64.9,23.6,64.9,25.6,64.15,27.3,63.35,28.95,61.85,30.25,60.35,31.45,58.1,32.15,52.95,32.8,50.6,32.65,48.3,32.2,46.1,31.65,44.35,30.4,42.65,29.15,41.65,27.2,40.65,25.25,40.7,22.6,46.85,22.6,47,23.95,47.4,25.05,48,25.95,48.75,26.7,49.7,27.2,50.75,27.6,51.95,27.8,53.15,27.9,55,27.75,55.9,27.55,56.8,27.2,58.15,26.15,58.6,25.35,58.75,24.35,58.7,23.2,57.95,22.5,57.15,21.8,56.05,21.3,54.75,20.85,53.35,20.45,50.25,19.65,48.65,19.2,47.1,18.65,45.65,18,44.35,17.15,43.1,16.2,42.35,14.85,41.65,13.4,41.65,11.45,41.6,9.2,42.55,7.6,43.5,5.95,45.05,4.85,45.8,4.3,46.7,3.9,47.55,3.5,48.55,3.25,50.45,2.85,52.4,2.75,54.6,2.85,56.7,3.25,58.8,3.75,60.45,4.85,62.05,6,62.95,7.75,63.9,9.5,63.95,12,20.7,24,8.5,14.55,8.5,14.45,14.65,11.35,26.9,20.8,26.85,20.85,20.7,24,35.35,35.4,0,35.4,0,0,35.4,0,35.4,35.35,35.35,35.4,6.25,29.15,6.25,6.25,29.15,6.25,29.15,29.15,6.25,29.15]),"evenOdd");
		loadingIcon.graphics.endFill();
		loadingIcon.x = $.width/2 - loadingIcon.width/2;
		loadingIcon.y = $.height/1.5 - loadingIcon.height/2;

	var lastPlayerState = Player.state;
	if (lastPlayerState == 'playing')
		Player.pause();

	var failedPermanently = false;
	var loadTimeout = timer(function()
	{
		var loadText = createText('载入超时，请刷新重试或检查网络连接。', {size:18, color:0, filters:[$.createGlowFilter(0, 0.6, 10, 10, 1, 3)]});
		loadText.x = $.width/2 - loadText.width/2;
		loadText.y = $.height/1.2 - loadText.height/2;
		failedPermanently = true;
	}, 5000);

	var startLoadTime = getTimer();
	load('libBitmap', function()
	{
		if (failedPermanently)
			return;

		clearTimeout(loadTimeout);
		var elapsed = getTimer() - startLoadTime;
		if (elapsed > 1000)
		{
			startTweenAndAutoRemoveObject(Tween.to(loadingBackground, {alpha:0}, 0.3));
			if (lastPlayerState == 'playing')
				Player.play();
			onCompleted();
		}
		else
		{
			timer(function()
			{
				startTweenAndAutoRemoveObject(Tween.to(loadingBackground, {alpha:0}, 0.3));
				if (lastPlayerState == 'playing')
					Player.play();
				onCompleted();
			}, 1000 - elapsed);
		}
	});
}

ScriptManager.clearEl();

if (!$G._get('DanmakuScratchpad'))
{
	$G._set('DanmakuScratchpad', true);

	loadBitmapLibraryThen(function()
	{
		transport = createTransport();
		initializePaintingTool();
		initializeDispatcher();

		$G._set('PaintingTool', ptTool);
	});
}
