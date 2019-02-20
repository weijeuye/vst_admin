<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
</head>
<body onload="initvisaFlag();">
<div class="iframe_header">
    <ul class="iframe_nav">
        <li><a href="#">${prodProduct.bizCategory.categoryName!''}</a> &gt;</li>
        <li><a href="#">${packageType!''}</a> &gt;</li>
        <li><a href="#">产品维护</a> &gt;</li>
        <li class="active">行程</li>
    </ul>
</div>

<div class="p_box box_info">
    <form method="post" action='/vst_admin/prod/prodLineRoute/showUpdateRoute.do' id="searchForm">
        <input type="hidden" name="productId" value="${prodProduct.productId}" id="productId" />
        <input type="hidden" name="categoryId" value="${prodProduct.bizCategory.categoryId!''}" id="categoryId" />
        <input type="hidden" name="categoryName" value="${prodProduct.bizCategory.categoryName!''}" id="categoryName" />
        <input type="hidden" name="packageType" value="${packageType!''}" id="packageType" />
        <input type="hidden" name="subCategoryId" value="${prodProduct.subCategoryId!''}" id="subCategoryId" />
        <input type="hidden" name="modelVersion" value="${modelVersion!''}" id="modelVersion" />
        <input type="hidden" name="productType" value="${prodProduct.productType!''}" id="productType" />
        <input type="hidden" name="destinationBu" value="${prodProduct.bu!''}" id="destinationBu" />
        <input type="hidden" id="saveRouteFlag" value="${saveRouteFlag}">
        <input type="hidden" name="productType" value="${prodProduct.productType!''}" />
        <input type="hidden" id="visaDocFlag" value="${visaDocFlag}"/>
        <input type="hidden" id="routeFlag" value="${routeFlag}"/>
        <input type="hidden" id="embedFlag" value="${embedFlag}"/>
        <input type="hidden" id="productType" value="${prodProduct.productType}"/>
        <input type="hidden" id="auto_pack_traffic" value="${auto_pack_traffic}">
        <input type="hidden" id="isuse_packed_route_details" value="${isuse_packed_route_details}">
        <#if embedFlag!='Y'>
        <table class="s_table">
            <tbody>
            <tr>
                <#if prodProduct.bizCategory.categoryId != '17'>
                <td class="s_label">是否有效：</td>
                <td class="w10">
                    <select name="cancleFlag" id="cancleFlag">
                        <option value="">不限</option>
                        <option value='Y' <#if cancleFlag == 'Y'>selected</#if>>有效</option>
                        <option value='N' <#if cancleFlag == 'N'>selected</#if>>无效</option>
                    </select>
                </td>
                </#if>
                <td class="operate mt10">
                    <#if prodProduct.bizCategory.categoryId != '17'>
                        <a class="btn btn_cc1" id="search_button">查询</a>
                    </#if>
                    <a class="btn btn_cc1" id="multi_addRoute">新增</a>
				<#if prodProduct.packageType != 'LVMAMA'>
                    <a class="btn btn_cc1" id="showlinedate">查看所有行程适用出发日期</a>
					<#if prodProduct.bizCategory.categoryId == '17'>
                        <a id="showInvalidedGoods" href="javascript:void(0);" style="font-size:12px;" data="1">显示无效行程</a>
					</#if>
				</#if>
                </td>
            </tr>
            </tbody>
        </table>
        </#if>
    </form>
</div>

<div class="p_box box_info">
<#if prodProduct.packageType == 'LVMAMA' && (prodProduct.bizCategory.categoryId == 15 || (prodProduct.bizCategory.categoryId == 18 && prodProduct.subCategoryId != 181&& prodProduct.subCategoryId != 184))>
    温馨提示：被引用产品行程明细发生变化，不会同步更新到引用该行程的产品
</#if>
    <table class="p_table table_center">
        <thead>
        <tr>
            <th style="width:10%">行程名称</th>
            <th style="width:10%">行程天数</th>
            <#if embedFlag!='Y'>
            <th style="width:10%">行程特色</th>
            </#if>
            <th style="width:10%">是否有效</th>
            <th style="width:10%">录入时间</th>
            <th style="width:50%">操作</th>
        </tr>
        </thead>
        <tbody>
		<#list prodLineRouteList as prodLineRoute>
        <tr <#if prodProduct.bizCategory.categoryId == '17' && prodLineRoute.cancleFlag != 'Y' >class="invalidGoods" style="display: none;" </#if>>
            <td style="width:10%">${prodLineRoute.routeName}</td>
            <td style="width:10%">${prodLineRoute.routeNum}天${prodLineRoute.stayNum}晚</td>
            <#if embedFlag!='Y'>
            <td style="width:15%" class="feature" size="20">${prodLineRoute.routeFeature}</td>
            </#if>
            <td style="width:10%">
				<#if prodLineRoute.cancleFlag == "Y">
                    <span style="color:green" >有效</span>
				<#else>
                    <span style="color:red" >无效</span>
				</#if>
            </td>
            <td style="width:15%">${prodLineRoute.createTime?string("yyyy-MM-dd HH:mm:ss")}</td>
            <td style="width:40%">
            	<#if embedFlag!='Y'>
				<#if prodLineRoute.cancleFlag == "Y">
                    <a href="javascript:void(0);" class="cancelProd" data='N' prodLineRouteId=${prodLineRoute.lineRouteId}>设为无效</a>
				<#else>
                    <a href="javascript:void(0);" class="cancelProd" data='Y' prodLineRouteId=${prodLineRoute.lineRouteId}>设为有效</a>
				</#if>
                <a href="javascript:void(0);" class="copyBtn" prodLineRouteId=${prodLineRoute.lineRouteId} prodLineRouteName=${prodLineRoute.routeName}>复制</a>
				<#if prodProduct.productType == 'FOREIGNLINE' >
                    <a href="javascript:multiVisa(${prodLineRoute.lineRouteId})" id="multi_visa">关联签证</a>
				</#if>
				</#if>
				<#if (packageType=='自主打包' && prodProduct.bizCategory.categoryName=='自由行' && prodProduct.bu=='DESTINATION_BU' && prodProduct.subCategoryId == 181)||(prodProduct.bizCategory.categoryId == 18 && prodProduct.subCategoryId == 184)  >
                    <a href="javascript:void(0);" data=${prodLineRoute.lineRouteId!''} class="multi_updRoutes">编辑</a>
				<#else>
                    <a href="javascript:updRoutes(${prodLineRoute.lineRouteId});" id="multi_updRoute">编辑</a>
					<#if prodProduct.packageType == 'LVMAMA' && (prodProduct.bizCategory.categoryId == 15 || (prodProduct.bizCategory.categoryId == 18 && prodProduct.subCategoryId != 181))>
                        <a href="javascript:referRoute();" data=${prodLineRoute.lineRouteId!''} class="multi_referRoutes">引用</a>
					</#if>
				<#-- 跟团游，当地游，自由行（非景+酒），显示新的行程明细页面-->
					<#if prodProduct.bizCategory.categoryId == 15 || prodProduct.bizCategory.categoryId == 16 || (prodProduct.bizCategory.categoryId == 18 && prodProduct.subCategoryId != 181) || prodProduct.bizCategory.categoryId == 42>
						<#if associatedRouteFlag=="true">
                            <a href="/vst_admin/dujia/comm/route/detail/showRouteDetail.do?routeId=${assLineRoute.lineRouteId}&productId=${lineProdProduct.productId}&editFlag=${associatedRouteFlag}&categoryId=${prodProduct.bizCategory.categoryId}" target="_blank" id="routeDetail2">关联行程</a>
						<#else>	
                            <a href="/vst_admin/dujia/comm/route/detail/showRouteDetail.do?routeId=${prodLineRoute.lineRouteId}&productId=${prodProduct.productId}&categoryId=${prodProduct.bizCategory.categoryId}" target="_blank" id="routeDetail">行程明细</a>
						</#if>
					<#else>
                        <a href="/vst_admin/prod/prodLineRoute/editprodroutedetail.do?lineRouteId=${prodLineRoute.lineRouteId}&productId=${prodProduct.productId}&categoryId=${prodProduct.bizCategory.categoryId}" id="routeDetail">行程明细</a>
					</#if>

					<#if prodProduct.bizCategory.categoryId == 42>
                        <a href="/vst_admin/prod/prodLineRoute/editprodroutecost.do?lineRouteId=${prodLineRoute.lineRouteId}&productId=${prodProduct.productId}">费用说明</a>
					<#else>
						<#if associatedFeeFlag == "true">
							<#if assFeeModelVesion == "true">
                                <a href="/vst_admin/dujia/group/route/cost/editProdRouteCost.do?lineRouteId=${assFeeLineRoute.lineRouteId}&productId=${feeProdProduct.productId}&productType=${feeProdProduct.productType}&editFlag=${associatedFeeFlag}&oldProductId=${prodProduct.productId}">关联费用</a>
							<#else>
                                <a href="/vst_admin/prod/prodLineRoute/editprodroutecost.do?lineRouteId=${assFeeLineRoute.lineRouteId}&productId=${feeProdProduct.productId}&editFlag=${associatedFeeFlag}&oldProductId=${prodProduct.productId}">关联费用</a>
							</#if>
						<#else>
							<#if modelVersion=="true" || (modelVersionToNew?? && modelVersionToNew=="true")>
                                <a href="/vst_admin/dujia/group/route/cost/editProdRouteCost.do?lineRouteId=${prodLineRoute.lineRouteId}&productId=${prodProduct.productId}&productType=${prodProduct.productType}">费用说明</a>
							<#else>
                                <a href="/vst_admin/prod/prodLineRoute/editprodroutecost.do?lineRouteId=${prodLineRoute.lineRouteId}&productId=${prodProduct.productId}">费用说明</a>
							</#if>
						</#if>
					</#if>
					<#if prodProduct.bizCategory.categoryId == 15 ||prodProduct.bizCategory.categoryId == 16 || prodProduct.bizCategory.categoryId == 42>
						<#if associatedContractFlag == "true">
							<#if asscontModelVesion == "true">
                                <a href="/vst_admin/dujia/group/route/contractDetail/showAddContractDetailList.do?productId=${contractProdProduct.productId}&categoryId=${contractProdProduct.bizCategory.categoryId!''}&lineRouteId=${assContractLineRoute.lineRouteId}&editFlag=${associatedContractFlag}&oldProductId=${prodProduct.productId}">关联合同条款</a>
							<#else>
                                <a href="/vst_admin/prod/product/prodContractDetail/showAddContractDetailList.do?productId=${contractProdProduct.productId}&categoryId=${contractProdProduct.bizCategory.categoryId!''}&lineRouteId=${assContractLineRoute.lineRouteId}&editFlag=${associatedContractFlag}">关联合同条款</a>
							</#if>
						<#else>
							<#if modelVersion=="true">
                                <a href="/vst_admin/dujia/group/route/contractDetail/showAddContractDetailList.do?productId=${prodProduct.productId}&categoryId=${prodProduct.bizCategory.categoryId!''}&lineRouteId=${prodLineRoute.lineRouteId}">合同条款</a>
							<#else>
                                <a href="/vst_admin/prod/product/prodContractDetail/showAddContractDetailList.do?productId=${prodProduct.productId}&categoryId=${prodProduct.bizCategory.categoryId!''}&lineRouteId=${prodLineRoute.lineRouteId}">合同条款</a>
							</#if>
						</#if>
					</#if>
				</#if>
				<#if embedFlag!='Y'>
                <a href="javascript:void(0);"   class="showLogDialog"  param='objectId=${prodLineRoute.lineRouteId}&objectType=PROD_LINE_ROUTE&sysName=VST'>操作日志</a>
                </#if>
            </td>
        </tr>
		</#list>
        </tbody>
    </table>
</div>
<div id="showProductTargetBox"  style="display:none;padding:10px; border:1px solid #FF8801; background-color:#FFFFE0;overflow:auto;max-height:200px;">
</div>
</div>
<#include "/base/foot.ftl"/>
</body>
</html>
<script>

    //行程优化
    var saveDialog, addBranchDialog;

    $(document).ready(function(){
        $("#modelVersion",parent.document).val($("#modelVersion").val());
        var auto_pack_traffic = $('#auto_pack_traffic').val();
        var isuse_packed_route_details = $('#isuse_packed_route_details').val();
        $("#auto_pack_traffic",parent.document).val(auto_pack_traffic);
        $("#isuse_packed_route_details",parent.document).val(isuse_packed_route_details);
    });

    $("a.multi_updRoutes").bind("click",function(){
        var productId = $("#productId").val();
        var categoryId = $("#categoryId").val();
        var lineRouteId =$(this).attr("data");
        var subCategoryId =$("#subCategoryId").val();
        var modelVersion = $("#modelVersion").val();
        var productType = $("#productType").val();
        
        var embedFlag = $("#embedFlag").val();
        if("Y" == embedFlag) {
        	if(window.parent && window.parent.kickoffLineEdit) {
        		var productType = $("#productType").val();
        		window.parent.kickoffLineEdit(lineRouteId, productId, productType);
        	}
        } else {
        	saveDialog = new xDialog("/vst_admin/prod/prodLineRoute/showAddProductTrip.do",{"productId":productId,"categoryId":categoryId,"lineRouteId":lineRouteId,"subCategoryId":subCategoryId,"modelVersion":modelVersion,"productType":productType}, {title:"编辑行程规格",width:1000,zIndex:200});
        }
    });




    $(function(){
        $(".feature").each(function cutout(){
            var size = $(this).attr("size");
            var feature = $(this).html();
            if(feature != '' && feature != null && feature.length > size ) {
                $(this).html(feature.substring(0, size) + "...");
            }
        });

        $("#search_button").bind("click",function(){
            $("#searchForm").submit();
        });

        $(".cancelProd").bind("click", function() {
            var prodLineRouteId = $(this).attr("prodLineRouteId");
            var msg = $(this).attr("data") === "N" ? "设置为无效，是否确认操作？" : "确认设为有效  ？";
            var url = "/vst_admin/prod/prodLineRoute/setCancelFlag.do?lineRouteId=" + prodLineRouteId;
            $.confirm(msg, function () {
                $.get(url, function(result){
                    confirmAndRefresh(result);
                });
            });
        });

        $(".copyBtn").bind("click", function(){
            var productId = $("#productId").val();
            var prodLineRouteName = $(this).attr("prodLineRouteName");
            var prodLineRouteId = $(this).attr("prodLineRouteId");
            $.ajax({
                url : "/vst_admin/prod/prodLineRoute/valiLVMAMALineRoute.do",
                type : "post",
                dataType : 'json',
                data :  'productId='+productId,
                success : function(result) {
                    if(result.code=="success"){
                        copyRoute(prodLineRouteId, prodLineRouteName);
                    }else {
                        $.alert(result.message);
                    }
                }
            });
        });

        $("#showlinedate").bind("click", function(){
            var productId = $("#productId").val();
            window.location.href = "/vst_admin/prod/prodLineRoute/showlinedate.do?productId=" + productId;
        });


        $("#showInvalidedGoods").click(function(){

            $(".invalidGoods").toggle();
            var data = $(this).attr("data");
            if(data=="1"){
                $("#showInvalidedGoods").attr("data","0");
                $("#showInvalidedGoods").html("隐藏无效行程");
            }else {
                $("#showInvalidedGoods").attr("data","1");
                $("#showInvalidedGoods").html("显示无效行程");
            }
        });
    });

    function confirmAndRefresh(result){
        if (result.code == "success") {
            pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
                $("#searchForm").submit();
            }});
        }else {
            pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
            }});
        }

        //如果是查看模式，则取消掉点击事件
        isView();

    }

    var docSelectDialog;
    var productId = $("#productId").val();
    //新增行程
    $("#multi_addRoute").click(function(){
        var productId = $("#productId").val();
        var categoryId = $("#categoryId").val();
        var lineRouteId =$(this).attr("data");
        var subCategoryId =$("#subCategoryId").val();
        var modelVersion = $("#modelVersion").val();
        var productType = $("#productType").val();
        var destinationBu = $("#destinationBu").val();
        var categoryName = $("#categoryName").val();
        var packageType = $("#packageType").val();
        $.ajax({
            url : "/vst_admin/prod/prodLineRoute/valiLVMAMALineRoute.do",
            type : "post",
            dataType : 'json',
            data :  'productId='+productId,
            success : function(result) {
                if(result.code=="success"){
                    if(categoryName == '自由行' && packageType == '自主打包' && destinationBu=='DESTINATION_BU' && subCategoryId ==181 ){
                        docSelectDialog = new xDialog("/vst_admin/prod/prodLineRoute/showAddProductTrip.do",{"productId":productId,"categoryId":categoryId,"lineRouteId":lineRouteId,"subCategoryId":subCategoryId,"modelVersion":modelVersion,"productType":productType}, {title:"编辑行程规格",width:1000,zIndex:200});
                    }
                    else{
                        var url = "/vst_admin/prod/prodLineRoute/selectProdLineRoute.do?productId="+productId;
                        docSelectDialog = new xDialog(url,{},{title:"新增行程",iframe:true,width:"800",height:"600"});
                    }
                }else {
                    $.alert(result.message);
                }
            }
        });
    });


    function copyRoute(prodLineRouteId, prodLineRouteName) {
        var url = "/vst_admin/prod/prodLineRoute/copyProdLineRoute.do?lineRouteId=" + prodLineRouteId;
        var msg = "确定要复制" + prodLineRouteName + "该行程?";
        $.confirm(msg, function () {
            $.get(url, function(result){
                confirmAndRefresh(result);
            });
        });
    }

    //更新行程
    function updRoutes(lineRouteId){
        var productId = $("#productId").val();
        var url = "/vst_admin/prod/prodLineRoute/selectProdLineRoute.do?productId="+productId+"&lineRouteId="+lineRouteId;
        docSelectDialog = new xDialog(url,{},{title:"编辑行程",iframe:true,width:"800",height:"600"});
    }

    //关联签证材料
    function multiVisa(lineRouteId){
        var docSelectVisaDialog;
        var url = "/vst_admin/prod/prodLineRoute/selectProdVisadocRe.do?productId="+productId+"&lineRouteId="+lineRouteId;
        docSelectVisaDialog = new xDialog(url,{},{title:"关联签证材料",width:"1000",height:"800"});
    }

    function initvisaFlag(){
        var visaDocFlag = $("#visaDocFlag").val();
        $("#visaDocFlag",window.parent.document).val(visaDocFlag);

        var routeFlag = $("#routeFlag").val();
        $("#routeFlag",window.parent.document).val(routeFlag);

        var saveRouteFlag = $("#saveRouteFlag").val();
        $("#saveRouteFlag",window.parent.document).val(saveRouteFlag);
    }

    var referDialog;
    function referRoute(){
        var productId = $("#productId").val();
        var categoryId = $("#categoryId").val();
        var lineRouteId = $("a.multi_referRoutes").attr("data");
        var subCategoryId = $("#subCategoryId").val();
        var modelVersion = $("#modelVersion").val();
        var productType = $("#productType").val();
        var url = "/vst_admin/prod/prodLineRoute/showReferRouteForm.do?productId=" + productId + "&categoryId=" + categoryId + "&lineRouteId=" + lineRouteId + "&subCategoryId=" + subCategoryId + "&modelVersion=" + modelVersion + "&productType=" + productType;
        referDialog = new xDialog(url,{}, {title:"系统提示",iframe:true,width:"500",height:"500"});
    }

    function closeDialog(){
        referDialog.close();
    }
</script>