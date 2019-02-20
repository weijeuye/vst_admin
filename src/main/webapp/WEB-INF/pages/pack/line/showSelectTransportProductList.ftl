<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
</head>
<body style="min-height:450px;">
<div class="iframe_content">
    <div class="p_box box_info">
    <form method="post" action='/vst_admin/productPack/line/showSelectProductList.do' id="searchForm">
        <input type="hidden" id="groupId" name="groupId" value="${groupId }"/>
        <input type="hidden" id="groupType" name="groupType" value="TRANSPORT"/>
        <input type="hidden" id="redirectType" name="redirectType" value="${redirectType }"/>
        <!-- 是否为多出发地标记字段-->
        <input type="hidden" id="isMuiltDparture" name="isMuiltDparture" value="${isMuiltDparture }"/>
        <!-- 交通组类型（往返程：TOBACK 单程去程：TO 单程返程：BACK）-->
        <input type="hidden" id="transportType" name="transportType" value="${transportType}"/>
        <table class="s_table">
            <tbody>
                <tr>
                    <td class="s_label">产品品类：</td>
                    <td class="w18">
                        <select name="selectCategoryId" id="selectCategoryId">
                            <option value="21" <#if selectCategoryId==21>selected=selected</#if> >其它机票</option>
                            <#if isGuoNeiBU==false><option value="23" <#if selectCategoryId==23>selected=selected</#if> >其它火车票</option></#if>
                            <option value="25" <#if selectCategoryId==25>selected=selected</#if> >其它巴士</option>
                            <option value="27" <#if selectCategoryId==27>selected=selected</#if> >其它船票</option>
                        </select>
                    </td>
                    <td class="s_label">产品名称：</td>
                    <td class="w18"><input type="text" name="productName" value="${productName}"></td>
                    <td class="s_label">产品ID：</td>
                    <td class="w18"><input type="text" name="productId" number="true" value="${productId}"></td>
                    <td class=" operate mt10"><a class="btn btn_cc1" id="search_button">查询</a> </td>
                </tr>
                <tr>
                   <td class="s_label">出发地：</td>
                   <td colspan="6">
                        <#if startDistricts?? &&  startDistricts?size &gt; 0>
                            <#list startDistricts as startDistrict>
                                <#if firstLoad?? && firstLoad == '1'>
                                    <div style="float:left; margin-right:5px;"><input type="checkbox" checked="checked" name="checkedStartDistrictIds" value="${startDistrict.districtId}" data="${startDistrict.districtName!''}"/>${startDistrict.districtName!''}</div>
                                <#else>
                                    <#if checkedStartDistrictIds?? && checkedStartDistrictIds?size &gt; 0>
                                        <div style="float:left; margin-right:5px;"><input type="checkbox" name="checkedStartDistrictIds" data="${startDistrict.districtName!''}" value="${startDistrict.districtId}"
                                        <#list checkedStartDistrictIds as checkedStartDistrictId>
                                        <#if checkedStartDistrictId == startDistrict.districtId>
                                        checked
                                        </#if>
                                        </#list>
                                        /> ${startDistrict.districtName!''}</div>
                                    <#else>
                                        <div style="float:left; margin-right:5px;"><input type="checkbox" name="checkedStartDistrictIds" data="${startDistrict.districtName!''}" value="${startDistrict.districtId}"/> ${startDistrict.districtName!''}</div>
                                    </#if>
                                </#if>
                            </#list>
                        </#if>
                    </td>
                    <td class="s_label">目的地：</td>
                    <td colspan="6">
                        <#if toDistricts?? &&  toDistricts?size &gt; 0>
                            <#list toDistricts as toDistrict>
                                <#if firstLoad?? && firstLoad == '1'>
                                    <div style="float:left; margin-right:5px;">
                                        <input checked="checked" type="checkbox" name="checkedToDistrictIds" value="${toDistrict.districtId}" />${toDistrict.districtName!''}
                                    </div>
                                <#else>
                                    <#if checkedToDistrictIds?? && checkedToDistrictIds?size &gt; 0>
                                        <div style="float:left; margin-right:5px;"><input type="checkbox" name="checkedToDistrictIds" value="${toDistrict.districtId}"
                                        <#list checkedToDistrictIds as checkedToDistrictId>
                                        <#if checkedToDistrictId == toDistrict.districtId>
                                        checked
                                        </#if>
                                        </#list>
                                        /> ${toDistrict.districtName!''}</div>
                                    <#else>
                                        <div style="float:left; margin-right:5px;"><input type="checkbox" name="checkedToDistrictIds" value="${toDistrict.districtId}"/>${toDistrict.districtName!''}</div>
                                    </#if>
                                </#if>
                            </#list>

                            <#-- 往返程缺程情况-->
                            <#if transportType == "TOBACK" && backStartDistrict?? >
                                <div style="float:left;">
                                    |  ${backStartDistrict.districtName!''} <input checked="checked" type="checkbox" name="backStartDistrictId" value="${backStartDistrict.districtId}" style="visibility: hidden;" />
                                </div>
                            </#if>
                        </#if>
                    </td>
                </tr>
                <tr id="seatname">
                    <td class="s_label">交通类型：</td>
                    <td>
                        <select name="transportType" disabled="disabled">
                            <option value="TOBACK" <#if transportType=='TOBACK'>selected=selected</#if> >往返</option>
                            <option value="TO" <#if transportType=='TO' || transportType=='BACK'>selected=selected</#if> >单程</option>
                        </select>
                    </td>
                    <td class="s_label">产品规格：</td>
                    <td>
                    	<input type="hidden" name="SeatValue" id="SeatValue" value="${SeatValue}"/>
                        <input name="Seat" id="seat1" type="checkbox" value="经济舱" />经济舱
						<input name="Seat" id="seat2" type="checkbox" value="公务舱" />公务舱
						<input name="Seat" id="seat3" type="checkbox" value="头等舱" />头等舱 
                    </td>
                </tr>
            </tbody>
        </table>
        </form>
    </div>
<!-- 主要内容显示区域\\ -->
    <#if pageParam??>
    <#if pageParam.items?? &&  pageParam.items?size &gt; 0>
    <div class="p_box box_info">
    <table class="p_table table_center">
                <thead>
                    <th>选择</th>
                    <th width="80px">品类</th>
                    <th>产品ID</th>
                    <th>是否参考信息</th>
                    <th>产品名称</th>
                    <th>规格</th>
                    </tr>
                </thead>
                <tbody>
                    <#list pageParam.items as productBranch> 
                    <tr>
                    <td>
                        <input type="checkbox" name="branchIds" value="${productBranch.productBranchId!''}">
                        <input type="hidden" name="productBranchIdHide" value="${productBranch.productBranchId!''}">
                        <input type="hidden" name="categoryNameHide" value="${productBranch.categoryName!''}">
                        <input type="hidden" name="productIdHide" value="${productBranch.productId!''}">
                        <input type="hidden" name="productNameHide" value="${productBranch.productName!''}">
                        <input type="hidden" name="branchNameHide" value="${productBranch.branchName!''}">
                        <input type="hidden" name="startDistrictHide" value="${productBranch.startDistrict!''}">
                        <input type="hidden" name="endDistrictHide" value="${productBranch.endDistrict!''}">
                    </td>
                    <td>${productBranch.categoryName!''}</td>
                    <td>${productBranch.productId!''}</td>
                    <td><#if productBranch.product?? && productBranch.product.referFlag??&&productBranch.product.referFlag=='Y'>是<#else>否</#if></td>
                    <td>
                        <a style="cursor:pointer" 
                            onclick="openProduct(${productBranch.productId!''},${productBranch.categoryId!''},'${productBranch.categoryName!''}')">
                            ${productBranch.productName!''}
                        </a>
                    </td>
                    <td>${productBranch.branchName!''}</td>
                    </tr>
                    </#list>
                </tbody>
            </table>
                <#if pageParam.items?exists> 
                    <div class="paging" > 
                    ${pageParam.getPagination()}
                        </div> 
                </#if>

    </div><!-- div p_box -->
    <#else>
        <div class="no_data mt20"><i class="icon-warn32"></i>暂无相关产品，重新输入相关条件查询！</div>
    </#if>
    </#if>
<!-- //主要内容显示区域 -->

         <div class="p_box box_info clearfix mb20">
             <#if pageParam?? && pageParam.items?? &&  pageParam.items?size &gt; 0>
             <div style="float:left;"><input type="checkbox" name="all_checkbox">全选</input></div>
             </#if>
            <div style="float:left;" class="fl operate"><a class="btn btn_cc1" id="addPackage">加入打包</a></div>
        </div>

           <div id="packagedBranchsDiv" style="width:600px;display:none;">
               <div>已选择产品</div>
               <div>
               <table class="p_table table_center">
                <thead>
                    <th width="80px">产品类型</th>
                    <th>产品ID</th>
                    <th>产品名称</th>
                    <th>规格</th>
                    <th>操作</th>
                </thead>
                <tbody id="packagedBranchTbody">
                </tbody>
            </table>
            </div>
            <div style="float:left;margin-top:10px;" class="fl operate"><a class="btn btn_cc1" id="saveDetail">确定</a></div>
           </div>
</div>
<#include "/base/foot.ftl"/>
</body>
</html>
<script>
//vst_pet_util.districtSuggest("#bizDistrictName", "#bizDistrictId");
//vst_pet_util.districtSuggest("#destName", "#destReId");
$(function(){

    //渲染已加入打包的临时规格列表
    showPackagedBranchTable();

	//产品规格
	var seatValue = $("#SeatValue").val();
	if(null !=seatValue && "" !=seatValue){
		if(seatValue.indexOf("经济舱")>=0){
			$("#seat1").attr("checked",true);
		}
		if(seatValue.indexOf("公务舱")>=0){
			$("#seat2").attr("checked",true);
		}
		if(seatValue.indexOf("头等舱")>=0){
			$("#seat3").attr("checked",true);
		}
	}
	$("input[name='Seat']").bind("change",function(){
		$("#SeatValue").val("");
		$("#SeatValue").val($('#seatname input[type=checkbox]:checked').map(function(){return this.value}).get().join(','));
	});
    //查询
    $("#search_button").bind("click",function(){
        if(!$("#searchForm").validate().form()){
                return false;
            }
        $("#searchForm").submit();
    });

    //修改
    $("a.editProd").bind("click",function(){
        var productId = $(this).attr("data");
        var categoryId = $(this).attr("data1");
        var categoryName = $(this).attr("categoryName");
        window.open("/vst_admin/prod/baseProduct/toUpdateProduct.do?productId="+productId+"&categoryId="+categoryId+"&categoryName="+categoryName);
        return false;
    });

    //点击确定按钮
    $("#saveDetail").bind("click",function(){
        var strBranchs = getStrBranchs();
        var branchIds = strBranchs.strBranchIds;
        var startDistrictIds = strBranchs.strBranchStartDistrictIds;
        var isMuiltDparture = $("#isMuiltDparture").val();

        if(variableIsEmpty(branchIds)){
            $.alert("请先选择产品规格....");
            return;
        }

        if(variableIsEmpty(isMuiltDparture)){
            $.alert("无法确定是否为多出发地！");
            return;
        }

        //检验多出发地时，将要传出的参数是否有误
        if (isMuiltDparture == 'Y') {
            var branchsArr =  branchIds.split(',');
            var districtIdsArr = startDistrictIds.split(',');

            if (branchsArr.length != districtIdsArr.length) {
                $.alert("后台参数获取错误，原因：规格信息数组与出发地信息数组大小不相等！");
                return;
            }

            var hasEmptyDistrictId = false;
            $.each(districtIdsArr,function(index,districtId){
                if (districtId == '') {
                    hasEmptyDistrictId = true;
                    return false;//break循环
                }
            });
            
            if (hasEmptyDistrictId) {
                $.alert("检测到被打包规格信息内，存在规格无法找到对应的交通产品出发地信息，请检查。");
                return;
            }
        }

        //校验每个出发地至少有一个规格被打包进来（提示）
        var result = validatePackageInfo();
        var tip = result.tip;
        var notHavePackagedStartDistrictNames = result.notHavePackagedStartDistrictNames;

        if (tip) {
            $.confirm("【"+ notHavePackagedStartDistrictNames +"】出发产品缺少,确定打包么？", function(){
                sentAjax(branchIds, startDistrictIds);
            });
        } else {
            sentAjax(branchIds, startDistrictIds);
        }
    });

    //加入打包按钮点击事件
    $("#addPackage").click(function(){
        //拿到已选中的checkbox
        var checkedBoxTds = $("input[name='branchIds']:checkbox:checked").parent('td');
        if (checkedBoxTds.length == 0) {
            $.alert("请先选择要打包的规格");
            return;
        }

        var checkedBranchs = new Array();

        $.each(checkedBoxTds, function(index, checkedBoxTd) {
            var branch = {};
            branch.productBranchId = $("input[name='productBranchIdHide']", checkedBoxTd).val();
            branch.categoryName = $("input[name='categoryNameHide']", checkedBoxTd).val();
            branch.productId = $("input[name='productIdHide']", checkedBoxTd).val();
            branch.productName = $("input[name='productNameHide']", checkedBoxTd).val();
            branch.branchName = $("input[name='branchNameHide']", checkedBoxTd).val();
            branch.startDistrictId = $("input[name='startDistrictHide']", checkedBoxTd).val();
            branch.endDistrictId = $("input[name='endDistrictHide']", checkedBoxTd).val();
            checkedBranchs.push(branch);
        });

        parent.addTransientBranchs(checkedBranchs);

        //渲染已加入打包的临时规格列表
        showPackagedBranchTable();
    });

    //选择单个复选框
    $("input[name='branchIds']:checkbox").bind("click",function(){
        //判断是不是所有的checkbox item 都被选中
        var allCheckBoxs = $("input[name='branchIds']:checkbox");
        var checkedBoxs = $("input[name='branchIds']:checkbox:checked");
        if (allCheckBoxs.length == checkedBoxs.length) {
            $("input[name='all_checkbox']").attr("checked", true);
        } else {
            $("input[name='all_checkbox']").attr("checked", false);
        }
    });

    //全选按钮
    $("input[name='all_checkbox']").bind("click",function(){
        if ($(this).is(':checked')) {
            $("input[name = 'branchIds']:checkbox").attr("checked", true);
        } else {
            $("input[name = 'branchIds']:checkbox").attr("checked", false);
        }
    });

});

//发送打包请求(参数解释：branchIds->多个规格id字符串，startDistrictIds->规格对应的交通产品出发地id字符串)
function sentAjax(branchIds, startDistrictIds){
    var groupId = $("#groupId").val();
    var groupType = $("#groupType").val();
    var selectCategoryId = $("#selectCategoryId").val();
    var postData = "groupId=" + groupId + "&groupType=" + groupType + "&branchIds=" + branchIds+ "&selectCategoryId=" + selectCategoryId+"&startDistrictIds=" + startDistrictIds;
    var loading = top.pandora.loading("正在努力保存中...");
    $.ajax({
        url : "/vst_admin/productPack/line/addGroupDetail.do",
        type : "post",
        dataType : 'json',
        data : postData,
        success : function(result) {
            loading.close();
            if(result.code == "success"){
                var packGroupDetail = {};
                packGroupDetail.groupId = result.attributes.groupId;
                packGroupDetail.groupType = result.attributes.groupType;
                packGroupDetail.selectCategoryId = result.attributes.selectCategoryId;
                packGroupDetail.detailIds = result.attributes.detailIds;
                parent.onSavePackGroupDetail(packGroupDetail);
            }
            if(result.code == "error"){
                $.alert(result.message);
            }
        },
        error : function(result) {
            loading.close();
            $.alert(result.message);
        }
    });
}

//渲染已加入打包的临时规格列表
function showPackagedBranchTable(){
    var packagedBranchs = parent.getCheckBranchs();

    $("#packagedBranchTbody").empty();

    if (packagedBranchs.length == 0) {
        return;
    }

    $("#packagedBranchsDiv").show();

    $.each(packagedBranchs, function(index, value) {
        var htmlTr = '<tr><td>'+value.categoryName+'</td><td>'+value.productId+'</td><td>'+value.productName+'</td><td>'+value.branchName+'</td><td><a data="'+value.productBranchId+'">删除</a></td></tr>';
        $("#packagedBranchTbody").append(htmlTr);
    });
}

//验证打包规格时，是否存在有出发地没有对应的打包规格信息存在（返回值：result.tip->是否提示信息,result.notHavePackagedStartDistrictNames->没有被打包的出发地名称）
function validatePackageInfo() {
    //所有多出发地input框
    var allStartDistrictIdInputs = $("input[name=checkedStartDistrictIds]");

    var packagedBranchs = parent.getCheckBranchs();
    var allStartDistrictIds = '';
    var tip = false;
    var notHavePackagedStartDistrictNames = '';

    $.each(allStartDistrictIdInputs, function(index, startDistrictInput){
        var startDistrictId = $(startDistrictInput).val();
        var startDistrictName = $(startDistrictInput).attr('data');

        var exist = false;
        $.each(packagedBranchs, function(index,packageBranch){
            if (packageBranch.startDistrictId == startDistrictId) {
                exist = true;
                return false;
            }
        });

        if (!exist) {
            notHavePackagedStartDistrictNames += startDistrictName + '、';
        }
    });

    if (notHavePackagedStartDistrictNames != '') {
        tip = true;
        notHavePackagedStartDistrictNames = notHavePackagedStartDistrictNames.substring(0, notHavePackagedStartDistrictNames.length-1);
    }

    var result = {};
    result.tip = tip;
    result.notHavePackagedStartDistrictNames = notHavePackagedStartDistrictNames;

    return result;
}

//获取所有已经选中的打包规格
function getStrBranchs() {
    var strBranchIds = '';
    var strBranchStartDistrictIds = '';
    var packagedBranchs = parent.getCheckBranchs();
    var transportType = $("#transportType").val();
    $.each(packagedBranchs, function(index, value) {
        strBranchIds += value.productBranchId + ',';
        
        //如果是返程，将目的地做为打包规格的出发地
        if (transportType == 'BACK') {
            strBranchStartDistrictIds += value.endDistrictId + ',';
        } else {
            strBranchStartDistrictIds += value.startDistrictId + ',';
        }
    });

    if (typeof(strBranchIds) != 'undefined' && strBranchIds != '') {
        strBranchIds = strBranchIds.substring(0, strBranchIds.length-1);
        strBranchStartDistrictIds = strBranchStartDistrictIds.substring(0, strBranchStartDistrictIds.length-1);
    }

    var strBranchs = {};
    strBranchs.strBranchIds = strBranchIds;
    strBranchs.strBranchStartDistrictIds = strBranchStartDistrictIds;
    return strBranchs;
}

//点击删除 按钮，对某个规格进行删除
$("#packagedBranchTbody a").live("click", function(){
    var branchId = $(this).attr("data");

    if (variableIsEmpty(branchId)) {
        $.alert("删除错误，无法定位到要删除的规格");
    }

    //调用父页面方法，对父页面全局变量进行删除
    parent.deleteBranch(branchId);
    //渲染已选择的规格列表
    showPackagedBranchTable();
});

//判断一个变量是空的么？返回：true->是空，false->非空
function variableIsEmpty(vari) {
    if (typeof(vari) == 'undefined' || vari == "" || vari.length == 0) {
        return true;
    }

    return false;
}

//打开编辑产品页面
function openProduct(productId, categoryId, categoryName){
    window.open("/vst_admin/prod/baseProduct/toUpdateProduct.do?productId="+productId+"&categoryId="+categoryId+"&categoryName="+categoryName);
}

</script>
