<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
<#include "/base/findProductInputType.ftl"/>
</head>
<body>
	<div class="tiptext tip-warning cc5" style="margin-top: 30px;"><span class="tip-icon tip-icon-warning"></span>责任声明：
        <p class="pl15">1.请谨慎修改相应的产品经理</p>
        <p class="pl15">2.随意修改产品经理造成的一切后果，其责任概由修改者承担</p>
	</div>
	<div style="margin-top:50px;margin-left: 100px;">
	    <a class="btn btn_cc1" id="productId_btn">按照产品ID修改</a>
		<a class="btn btn_cc1" id="productName_btn">按照产品经理名字修改</a>
	</div>
    <!-- //工作区 -->
<#include "/base/foot.ftl"/>
<script type="text/javascript" src="/vst_admin/js/kindeditor-4.0.2/kindeditor.js"></script>
<script type="text/javascript" src="/vst_admin/js/kindeditor-4.0.2/plugins/image/image.js"></script>
<script type="text/javascript" src="/vst_admin/js/contentManage/kindEditorConf.js?v1"></script>
</body>
</html>
<script>

	$("#productId_btn").click(function(){
		updateProductManagerById = new xDialog("/vst_admin/prod/prodmanager/updateProductBatchById.do",{},{title:"根据Id修改产品经理",iframe:true,width:"1000",height:"600"});
	});

	$("#productName_btn").click(function(){
		updateProductManagerByName = new xDialog("/vst_admin/prod/prodmanager/updateProductBatchByName.do",{},{title:"根据姓名修改产品经理",iframe:true,width:"1000",height:"600"});
	});
	
	function closeDialogById() {
		updateProductManagerById.close();
	}
	
	function closeDialogByName() {
		updateProductManagerByName.close();
	}
	
</script>