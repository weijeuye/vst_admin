<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title></title>
 	<link rel="stylesheet" href="/vst_admin/css/ui-common.css" type="text/css" />
    
	<link rel="stylesheet" href="/vst_admin/css/dialog.css" type="text/css"/>
    
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/product-list-iframe.css"/>
</head>
<body>

<div class="category clearfix">
	<#if bizCategoryList??>
		<#list bizCategoryList as category>
			<a href="javascript:void(0);"  data="${category.categoryId}" class="btnlistener">${category.categoryName}</a>
		</#list>
    </#if>
</div>

<div class="template">
    <!--跟团游-->
    <div class="group-travel">
        <div class="hint">
            <div class="btn-group text-center">
                <a href="javascript:void(0);" target="_blank" id="supplierAddProduct" class="btn btnlistener">供应商打包</a>
                <a href="javascript:void(0);" target="_blank" id="addProduct" class="btn btn-primary btnlistener">自主打包</a>
            </div>
        </div>
    </div>

</div>
<div class="template1" style="display: none;">
    <!--自由行-->
    <div class="freedom">
		<div class="category clearfix">
            <#if bizFreedomList??>
				<#list bizFreedomList as category>
					<a href="javascript:void(0);"  data2="${category.categoryId}" data="18">${category.categoryName}</a>
				</#list>
		    </#if>
        </div>
    </div>
</div>
<input type="hidden" id="category" value="">

<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>

<script type="text/javascript" src="http://pic.lvmama.com/js/backstage/pandora-dialog.js"></script>
<script type="text/javascript" src="/vst_admin/js/lvmama-dialog.js"></script>

<script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/product-list-category.js"></script>
<script>
	$(".btnlistener").click(function(){
		//获取选择窗口元素复制

    	var $template = $(".template");
        var $groupTravel = $template.find(".group-travel").clone();
        //获取当前窗口上的属性类别

		var categoryId = $(this).attr("data");
		if(categoryId==""){
			alert("请先选择品类");
			return;
		}
		var categoryName = $(this).html();
		var value = $(this).attr("data");

		if(categoryId==15 || categoryId==8 || categoryId == 42){
	    	var $template = $(".template");
	        var $groupTravel = $template.find(".group-travel").clone();
			var dialogGroupTravel = backstage.dialog({
	            title: "",
	            width: 300,
	            height: 80,
	            $content: $groupTravel
	        });
	        
			var $addProduct = $groupTravel.find("#addProduct");
			var $supplierAddProduct = $groupTravel.find("#supplierAddProduct");
			
			$addProduct.on("click", function() {
				dialogGroupTravel.destroy();
				window.open("/vst_admin/prod/baseProduct/toAddProduct.do?categoryId="+value);
				parent.dialogCategory.destroy();
			});
			$supplierAddProduct.on("click", function() {
				dialogGroupTravel.destroy();
				window.open("/vst_admin/prod/baseProduct/toSupplierAddProduct.do?categoryId="+value);
				parent.dialogCategory.destroy();
			});
		//自由行
		} else if (categoryId == 18) {

	    	var $template = $(".template1");
	        var $groupTravel = $template.find(".freedom").clone();
	        $("#sourceCategory").html(categoryName+"（老）");
	        $("#sourceCategory").attr('data', categoryId);
			var dialogGroupTravel = backstage.dialog({
	            title: "",
	            width: 300,
	            height: 90,
	            $content: $groupTravel
	        });
			//覆盖click事件
			$(".freedom a").click(function(){
				var subCategoryId = $(this).attr("data2");
				if(subCategoryId=="" || "undefined" == typeof subCategoryId || subCategoryId == 18){
					window.open("/vst_admin/prod/baseProduct/toAddProduct.do?categoryId="+$(this).attr("data"));
				}else{
					window.open("/vst_admin/prod/baseProduct/toAddProduct.do?categoryId="+$(this).attr("data")+"&subCategoryId="+subCategoryId);
				}
				parent.dialogCategory.destroy();
			});
				
		} else {
			window.open("/vst_admin/prod/baseProduct/toAddProduct.do?categoryId="+$(this).attr("data"));
			parent.dialogCategory.destroy();
		}
		return;
	});
</script>

</body>
</html>
