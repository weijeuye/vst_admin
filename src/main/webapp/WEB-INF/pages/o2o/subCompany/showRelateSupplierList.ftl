<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
<link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css" />
</head>
<body>
	<div class="iframe_header"><p style="font-size:14px; border-bottom: 1px solid #e4e4e4;">关联供应商</p></div>
	<div class="iframe_content">
		<div class="p_box box_info">
			<#if type?upper_case=="WRITABLE">
				<@mis.checkPerm permCode="5120">
					<span class=" operate mt10"><a class="btn btn_cc1" id="addRelateSupplier"><font color="#fff">添加供应商</font></a></span>
				</@mis.checkPerm >
			</#if>
			<input type="hidden" id="subCompanyId" value="${subCompanyId}" />
		</div>
		<div style="font-size:14px;"><b>已关联供应商</b></div><br/>
		<!-- 关联供应商列表 -->
		<#if pageParam?? && pageParam.items?? &&  pageParam.items?size &gt; 0>
			<div class="p_box box_info">
				<table class="p_table table_center">
					<thead>
						<tr>
							<th>供应商编号</th>
							<th>供应商名称</th>
							<th>上级供应商</th>
							<th>供应商地区</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
						<#if pageParam.items?exists>
							<#list pageParam.items as supplier>
							<tr>
								<td>${supplier.supplierId!''}</td>
								<td>${supplier.supplierName!''}</td>
								<td><#if supplier.fatherSupplier??>${supplier.fatherSupplier!''}</#if></td>
								<td><#if supplier.supplierDistrict??>${supplier.supplierDistrict!''}</#if></td>
								<td class="oper">
									<@mis.checkPerm permCode="5119">
										<a href="javascript:void(0);" class="showSupp" data-type="READONLY" data-id="${supplier.supplierId}">查看信息</a>
									</@mis.checkPerm >
									<#if type?upper_case=="WRITABLE">
										<@mis.checkPerm permCode="5120">
											<a href="javascript:void(0);" class="cancelRelation" data-type="WRITABLE" data-id="${supplier.supplierId}">取消关联</a>
										</@mis.checkPerm >
									</#if>
								</td>
							</tr>
							</#list>
						</#if>
					</tbody>
				</table>
				<#if pageParam.items?exists>
				<div class="paging">${pageParam.getPagination()}</div>
				</#if>
			</div>
		<#else>
			<div class="hint mb10">
				<span class="icon icon-big icon-info"></span> 抱歉，查询暂无数据
			</div>
		</#if>
	</div>
	<!-- 关联供应商列表 -->
	<#include "/base/foot.ftl"/>
</body>
</html>

<script>
var showSupplierInfoDialog, addSupplierDialog;

//添加供应商
$("#addRelateSupplier").click(function() {
	var subCompanyId = $("#subCompanyId").val();
	var param = "?o2oSubCompanyId=" + subCompanyId;
	var url = "/vst_back/supp/supplier/findSupplierList.do" + param;
	addSupplierDialog = new xDialog(url, {}, { title : "添加供应商", iframe : true, width : 900 });
	return false;
});

//查看供应商信息
$("a.showSupp").click(function() {
	var supplierId = $(this).data("id");
	var param = "?supplierId=" + supplierId;
	var url = "/vst_admin/o2o/subCompany/showRelateSupplierInfo.do" + param;
	showSupplierInfoDialog = new xDialog(url, {}, { title : "查看供应商信息", iframe : true, width : 900 });
	return false;
	// var supplierId = $(this).attr("data");
	// showSupplierInfoDialog = new xDialog("/vst_admin/o2o/subCompany/showRelateSupplierInfo.do",{"supplierId":supplierId},{title:"查看供应商信息",width:900});
});

//取消供应商关联关系
$("a.cancelRelation").click(function() {
	var subCompanyId = $("#subCompanyId").val();
	var supplierId = $(this).data("id");
	$.confirm("是否确认取消供应商关联关系吗?", function() {
		$.ajax({
			url : "/vst_admin/o2o/subCompany/cancelRelateSupplier.do",
			type : "post",
			dataType : "JSON",
			data : {
				"subCompanyId" : subCompanyId,
				"supplierId" : supplierId
			},
			success : function(result) {
				if (result.code == "success") {
					$.alert(result.message, function() {
						window.location.reload();
					});
				} else {
					$.alert(result.message);
				}
			}
		});

	});
});

</script>

