<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
<style type="text/css">
#search_button{
	margin-left:5px;
}
input,select {
	width:110px;
}
</style>
</head>

<body>
<div class="iframe_header">
        <ul class="iframe_nav">
            <li>&gt;</li>
            <li class="active">新增编辑商品特殊权限</li>
        </ul>
</div>
<div style="width:50%">
    <form method="post"  id="dataForm" style="height:500px;">
    	<div style="padding-top:40px;padding-left:40px;">
	        <table class="s_table" style="height:150px;">
	            <tbody>
		            <tr align="center">
			            <td style="width:50%" align="right" >登录用户名：</td>
			            <td><input type="text" name="userName" id="userName" value="" style="width:120px"></td>
			        </tr>
		            <tr align="center" style="margin:20px auto 50px auto">
			            <td style="width:50%" align="right">开通编辑权限字段：</td>
			            <td >
			                <select name="permType" id="permType" style="width:135px">
			             		<option value="">请选择</option>
				             	<option value="SPECIAL_TICKET_TYPE">特殊门票类型</option>
				             	<option value="IS_CIRCUS">是否长隆马戏票</option>
				             	<option value="TIAN_NIU_FLAG">是否天牛计划</option>
			  			 	</select>
			            </td>
		            </tr>
		            <tr align="center">
		            	<td style="width:50%" align="right">&nbsp;</td>
		            	<td class="operate mt10"><a class="btn btn_cc1" id="save_button">添加</a></td>
		            </tr>
	            </tbody>
	        </table>
	       </div>
    </form>
</div>

</body>
</html>

<script>
    $(function () {
        //保存
        $("#save_button").bind("click", function () {
        	var userName = $("#userName").val().trim();
       		if(userName ==''){
    	 		alert("请输入登录用户名");
    	 		return;
    	 	}
    	 	var permType = $("#permType").val().trim();
        	if(permType ==''){
    	 		alert("请选择开通编辑权限字段");
    	 		return;
    	 	}
            
            $.ajax({
                url: "/vst_admin/ticket/goods/goods/saveSuppGoodsEditPerm.do?userName="+userName+"&permType="+permType,
                type: "post",
                async: false,
                dataType: 'JSON',
                success: function (result) {
                   alert(result.message);
                }
            });
        });
    });
</script>