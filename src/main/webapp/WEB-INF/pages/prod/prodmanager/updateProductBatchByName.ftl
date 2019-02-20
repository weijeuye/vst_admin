<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
</head>
<body>
<div class="iframe_search" style="height:300px;">

<form method="post" action='/vst_admin/prod/prodmanager/updateProductBatchByName.do' id="prodConfirm">
    原产品经理：<input class="search form-control w90" type="text" id="oldProductManagerName" name="oldProductManagerName" value="${productManagerName!''}">
        <input type="hidden" id="oldProductManagerId" name="oldProductManagerId" value="${productManagerId!''}">
        &nbsp;&nbsp;&nbsp;&nbsp;
    新产品经理：<input class="search form-control w90" type="text" id="newProductManagerName" name="newProductManagerName" value="${productManagerName!''}">
        <input type="hidden" id="newProductManagerId" name="newProductManagerId" value="${productManagerId!''}">&nbsp;&nbsp;&nbsp;&nbsp;
    <a class="btn btn_cc1" id="confirm_button">确定</a>
</form>
</div>

<#include "/base/foot.ftl"/>
</body>
</html>

<script>
    vst_pet_util.superUserSuggest("#oldProductManagerName","#oldProductManagerId");
    vst_pet_util.superUserSuggest("#newProductManagerName","#newProductManagerId");

$(document).ready(function(){
    var goodsNum = '${goodsNum}';
    var productNum = '${productNum}';
    var parentdom = window.parent.document;
    if (goodsNum != '' || productNum != '') {
        if (typeof(parent.closeDialogByName) === "function") {
			parent.closeDialogByName();
		}
    }
});

//修改产品经理
$("#confirm_button").bind("click",function(){
	var oldProductManagerName = $('#oldProductManagerName').val();
	var newProductManagerName = $('#newProductManagerName').val();
	if (oldProductManagerName == '' || oldProductManagerName == undefined || newProductManagerName =='' || newProductManagerName == undefined) {
		alert("请输入有效的姓名");
		return;
	} else {
		$("#prodConfirm").submit();
	}
});

</script>
