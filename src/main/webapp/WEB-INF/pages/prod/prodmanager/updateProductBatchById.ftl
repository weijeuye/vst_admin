<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
</head>
<body>
<div class="iframe_search" style="height:300px;">
<form method="post" action='/vst_admin/prod/prodmanager/updateProductBatchById.do' id="prodConfirm">
	<div style="margin-bottom:10px;"> 
		原产品ID：<textarea id="oldProductIdStr" name="oldProductIdStr"  class="w35 ckeditor" rows="3" required="true"></textarea>
		<i class="cc1">*多个id用英文逗号隔开，如：111,222,333</i>
	</div>
   <br/>
    新产品经理：<input class="search form-control w90" type="text" id="newProductManagerName" name="newProductManagerName" value="${productManagerName!''}">
        <input type="hidden" id="newProductManagerId" name="newProductManagerId" value="${productManagerId!''}">&nbsp;&nbsp;&nbsp;&nbsp;
    <a class="btn btn_cc1" id="confirm_button">确定</a>
</form>
</div>

<#include "/base/foot.ftl"/>
</body>
</html>

<script>
    vst_pet_util.superUserSuggest("#newProductManagerName","#newProductManagerId");

$(document).ready(function(){
    var goodsNum = '${goodsNum}';
    var productNum = '${productNum}';
    var parentdom = window.parent.document;
    if (goodsNum != '' || productNum != '') {
        if (typeof(parent.closeDialogById) === "function") {
			parent.closeDialogById();
		}
    }
});

//修改产品经理
$("#confirm_button").bind("click",function(){
	var oldProductIdStr = $('#oldProductIdStr').val();
	var newProductManagerName = $('#newProductManagerName').val();
	if (oldProductIdStr == '' || oldProductIdStr == undefined || newProductManagerName == '' || newProductManagerName == undefined) {
		alert("请输入相应ID和有效的姓名");
		return;
	} else {
		var alertMsg = "ID输入不规范，请重新输入";
		var reg = new RegExp('[^0-9\\,\\\s]'); 
		if(reg.test(oldProductIdStr)){
			alert(alertMsg);
			return;
		}
		var oldProductIdArr = oldProductIdStr.split(",");
		for (var i = 0; i < oldProductIdArr.length; i++) {
			if (oldProductIdArr[i] != "") {
				if (oldProductIdArr[i].trim() == "") {
					alert(alertMsg);
					return;
				}
			} else {
				alert(alertMsg);
				return;
			}
		};
		$("#prodConfirm").submit();
	}
});

</script>

