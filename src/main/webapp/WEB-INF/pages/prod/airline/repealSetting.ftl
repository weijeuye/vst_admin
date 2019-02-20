 <!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="/vst_admin/css/dialog.css" type="text/css"/>
<link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css"/>
<link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/product-list.css"/>
</head>
<body>  
确认取消限制？
<a class="btn" id="search_button">确定</a>
<a class="btn btn-primary JS_btn_select"   id="new_button">取消</a>
</body>
</html>
<script>
	//确定
	$("#search_button").bind("click",function(){
		 
	});
	//取消
	$("#new_button").bind("click",function(){
		$('#new_button').dialog('close');		
	});
	
</script>
