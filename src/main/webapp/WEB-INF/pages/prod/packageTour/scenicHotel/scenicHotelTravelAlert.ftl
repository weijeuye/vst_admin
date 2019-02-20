<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<link rel="stylesheet" href="http://super.lvmama.com/vst_back/css/ui-common.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_back/css/ui-components.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_back/css/iframe.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_back/css/dialog.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_back/css/easyui.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_back/css/button.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_back/css/base.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_back/css/normalize.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_back/css/calendar.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_back/css/jquery.jsonSuggest.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_back/css/jquery.ui.autocomplete.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_back/css/jquery.ui.theme.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_back/css/contentManage/kindEditorConf.css" type="text/css">
<style type="text/css">
body > div {
	padding:0 20px 10px 20px;
}

body > h1 {
	margin : 5px 0;
	padding: 0 20px;
}
.s_mt1 {
padding: 10px 20px;
border:1px solid #cccccc;
width:740px;
display:inline-block;
float:left;
}
.s_mt1 > div {
	margin-top: 10px;
}
.s_mt1 > div > span {
	display: inline-block;
	width:100px;
	text-align:left;
}

.s_mt1 > div > input {
	width:600px;
}
.s_mt2 {
	margin-top: 95px;
}
div.container {
 overflow:hidden;
}
div.other > div {
	padding-left:20px;
	display:inline-block;
	width:100px;
}
div.other > textarea {
	width:600px;
	height:80px;
}
.category_header{
	margin-top:20px;
	width:780px;
}
.category_header > a {
	float:right;
}
.category_header > span {
	font-weight:bold;
}

div.supplement > div {
	padding-left:20px;
	display:inline-block;
	width:100px;
}
div.supplement > div >span {
	font-weight:bold;
}
div.supplement > textarea {
	width:600px;
	height:80px;
}
.s_operate {
	width: 800px;
	text-align:center;
}
</style>

</head>
<body>
<div class="iframe_header">
        <ul class="iframe_nav">
            <li><a href="#">自由行</a> &gt;</li>
            <li><a href="#">产品维护</a> &gt;</li>
            <li class="active">修改产品条款</li>
        </ul>
</div>
<h1>出行警示及说明：</h1>
<div class="category_header">
	<input type="checkbox" />
	<span>酒店信息：</span>
	<a href="#" class="btn btn_cc1" >增加一条</a>
</div>
<div class="container">
	<div class="s_mt1" >
		<div>
			<span>酒店名称：</span>
			<input type="text" class="s_1"/>
		</div>
		<div>
			<span>酒店地址：</span>
			<input type="text" class="s_1"/>
		</div>
		<div>
			<span>前台电话：</span>
			<input type="text" class="s_1"/>
		</div>
		<div>
			<span>最早到店时间：</span>
			<input type="text" class="s_1"/>
		</div>
		<div>
			<span>最晚离店时间：</span>
			<input type="text" class="s_1"/>
		</div>
	</div>
	<div class="s_mt2">
		<a href="#" class="btn btn_cc1">删除</a>
	</div>
</div>
<div class="other">
	<div>
		<input type="checkbox" />
		<span>其他：</span>
	</div>
	<textarea></textarea>
</div>

<!--ticket-->
<div class="category_header">
	<input type="checkbox" />
	<span>景点门票信息：</span>
	<a href="#" class="btn btn_cc1" >增加一条</a>
</div>
<div class="container">
	<div  class="s_mt1">
		<div>
			<span>景点名称：</span>
			<input type="text" class="s_1"/>
		</div>
		<div>
			<span>景点地址：</span>
			<input type="text" class="s_1"/>
		</div>
		<div>
			<span>入园时间：</span>
			<input type="text" class="s_1"/>
		</div>
		<div>
			<span>取票地点：</span>
			<input type="text" class="s_1"/>
		</div>
		<div>
			<span>取票时间：</span>
			<input type="text" class="s_1"/>
		</div>
		<div>
			<span>取票方式：</span>
			<input type="text" class="s_1"/>
		</div>
	</div>
	<a href="#" class="btn btn_cc1">删除</a>
</div>
<div class="other">
	<div>
		<input type="checkbox" />
		<span>其他：</span>
	</div>
	<textarea></textarea>
</div>

<!--supplements-->
<div class="supplement">
	<div>
		<input type="checkbox" />
		<span>补充：</span>
	</div>
	<textarea></textarea>
</div>

<div class="s_operate">
	<a href="#" class="btn btn_cc1">保存</a>
	<a href="#" class="btn btn_cc1">操作日志</a>
</div>
<div style="height:200px;">
<div>
</body>
</html>


