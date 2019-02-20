<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>历史数据补录</title>
<!-- <link rel="stylesheet"
	href="http://pic.lvmama.com/styles/backstage/v1/resource-add-control.css" />
<link rel="stylesheet"
	href="http://pic.lvmama.com/styles/backstage/v1/common.css" />
<link rel="stylesheet"
	href="http://pic.lvmama.com/styles/backstage/v1/pandora-calendar.css" /> -->
<!-- <link rel="stylesheet"
	href="http://pic.lvmama.com/styles/backstage/v1/sales-information-iframe.css" />
<link rel="stylesheet" href="/vst_admin/css/dialog.css" type="text/css" />
<link rel="stylesheet" href="/vst_admin/css/button.css" type="text/css" /> -->

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<#include "/base/head.ftl"/>
<link rel="stylesheet" href="/vst_admin/css/ui-common.css" type="text/css" />
<!-- <link rel="stylesheet" href="/vst_admin/css/ui-components.css" type="text/css"/> -->
<link rel="stylesheet" href="/vst_admin/css/iframe.css" type="text/css"/>
<link rel="stylesheet" href="/vst_admin/css/dialog.css" type="text/css"/>
<link rel="stylesheet" href="/vst_admin/css/easyui.css" type="text/css"/>
<link rel="stylesheet" href="/vst_admin/css/button.css" type="text/css"/>
<link rel="stylesheet" href="/vst_admin/css/base.css" type="text/css"/>
<link rel="stylesheet" href="/vst_admin/css/normalize.css" type="text/css"/>
<link rel="stylesheet" href="/vst_admin/css/calendar.css" type="text/css"/>
<link rel="stylesheet" href="/vst_admin/css/jquery.jsonSuggest.css" type="text/css"/>
<link rel="stylesheet" href="/vst_admin/css/jquery.ui.autocomplete.css" type="text/css"/>
<link rel="stylesheet" href="/vst_admin/css/jquery.ui.theme.css" type="text/css"/>
<link rel="stylesheet"  href="/vst_admin/css/contentManage/kindEditorConf.css" type="text/css"/>

<link rel="stylesheet"
	href="http://pic.lvmama.com/styles/backstage/v1/common.css" />
<link rel="stylesheet"
	href="http://pic.lvmama.com/styles/backstage/v1/pandora-calendar.css" />
<link rel="stylesheet"
	href="http://pic.lvmama.com/styles/backstage/v1/resource-add-control.css" />
</head>
<body class="resource-add-control">

	<div class="iframe_content">
		<div style="margin: 8px;">
			<ul class="nav-tabs JS_tab_main">
				<li class="active" data="bindGoods">已绑定商品补录</li>
				<@mis.checkPerm permCode="5722" ><li data = "invalidGoods">无效产品补录</li></@mis.checkPerm>
			</ul>
		</div>

		<div class="form-group" style="margin: 8px;">
			预控ID:<input type="text" name="resourceControlName"
				id="resourceControlId" /> 商品ID:<input type="text" id="goodslId" />
			补录时间:<input id="startDate" class="form-control w90 JS_play_date"
				type="text" value="">&nbsp;&nbsp; <input id="endDate"
				class="form-control w90 mr10 JS_play_date" type="text"><input
				type="button" value="添加" id="addHDARBtnId" class="btn btn-small"   style="background: #4d90fe;border: 1px solid #2979fe;color: #fff;">
		</div>

		<div class="iframe-content" id="resourceControlTableId" style="margin: 8px;">
			<table class="p_table table_center">
				<thead>
					<tr>
						<th>预控ID</th>
						<th>商品ID</th>
						<th colspan="2">补录时间</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
		</div>

		<div class="main mt10">
			<div class="btn-group text-center w600">
				<a class="btn btn-primary JS_btn_save" id="hdSubmitId">提交</a> <a
					class="btn btn-primary JS_btn_cancel" id="hdCancelId">取消</a>
			</div>
		</div>
	</div>


	<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
	<script src="http://pic.lvmama.com/js/backstage/v1/pandora-calendar.js"></script>
	<script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
	<script
		src="http://pic.lvmama.com/js/backstage/v1/resource-add-control.js"></script>
    <script type="text/javascript" src="/vst_admin/js/res/history_data_additional_recording.js"></script>
</body>
</html>