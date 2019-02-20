<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>绑定预控项目</title>
<link rel="stylesheet" href="/vst_admin/css/ui-common.css"
	type="text/css" />
<link rel="stylesheet" href="/vst_admin/css/iframe.css" type="text/css" />
<link rel="stylesheet" href="/vst_admin/css/dialog.css" type="text/css" />


<link rel="stylesheet"
	href="http://pic.lvmama.com/styles/backstage/v1/common.css" />
<link rel="stylesheet"
	href="http://pic.lvmama.com/styles/backstage/v1/product-list.css" />
<link rel="stylesheet" href="/vst_admin/css/easyui.css" type="text/css" />
<link rel="stylesheet" href="/vst_admin/css/base.css" type="text/css" />
</head>
<body>

	<div class="resource-table" style="margin: 20px 10px;">

		<table class="table table-border">
			<thead>
				<tr>
					<th width="5%">操作</th>
					<th width="38%">预控名称</th>
					<th width="37%">游玩时间</th>
					<th width="20%">预控方式</th>
				</tr>
			</thead>

			<#if resPrecontrolPolicies?size &gt; 0>
			<tbody>
				<#list resPrecontrolPolicies as rs>
				<tr>
					<td><input type="radio" value="${rs.id }" data="${rs.name}"
						class="resPrecontrolPolicies" /></td>
					<td>${rs.name}</td>
					<td>${rs.tradeEffectDate?string("yyyy-MM-dd")}
						-${rs.tradeExpiryDate?string("yyyy-MM-dd")}</td>
					<td><#if rs.controlType == "amount">金额 <#else> 库存 </#if></td>
				</tr>
				</#list>
			</tbody>
			</#if>
		</table>


	</div>

	<div style="text-align: center;">
		<input type="button" value="保存" style="width: 60px;" id="btnSaveResControl" />
	</div>

	<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
	<script src="http://pic.lvmama.com/js/backstage/v1/pandora-calendar.js"></script>
	<script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
	<script
		src="http://pic.lvmama.com/js/backstage/v1/resource-add-control.js"></script>
		
	<script type="text/javascript"
		src="/vst_admin/js/goods/line_multi_route/resource_control_bind.js"></script>
</body>
</html>